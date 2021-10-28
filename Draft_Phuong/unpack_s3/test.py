import cocotb
from cocotb.clock import Clock
from cocotb import triggers
from cocotb.triggers import Timer
from random import randint
import bit_handle

report = open('report.txt','w')

@cocotb.test()
async def test(dut):
    """Try accessing the design."""

    dut._log.info("Running test...")
    cocotb.fork(Clock(dut.clk, 1, units="ns").start())
    fail = 0
    storage = []
    dut.rst <= 0
    await Timer(0.3, units="ns")
    for i in range(140):
        rannum = randint(0,242)
        dut.a <= rannum
        expect = check_model(rannum)
        dut.count <= 5
        dut.rst <= 1
        await Timer(1, units="ns")
        dut.rst <= 0
        dut.count <= 0
        await Timer(1, units="ns")
        dut.count <= 1
        await Timer(1, units="ns")
        dut.count <= 2
        await Timer(1, units="ns")
        dut.count <= 3
        await Timer(1, units="ns")
        dut.count <= 4
        await Timer(1, units="ns")
        dut.check_holder <= expect
        try:
            if dut.out.value != expect:
                fail = 1
                report.write("When i = %d, \n + in = %d, \n + out = %X, \n + but i expect it = %X\n" %(i, rannum, int(dut.out.value), expect ) )
        except:
            fail = 1
            report.write("When i = %d, \n + in = %d, \n + out is unidentified, \n + but i expect it = %X\n" %(i, rannum, expect ) )
    if fail == 0: report.write("------VERIFICATION SUCCEED------\n")
    else: report.write("------VERIFICATION FAIL------\n")
    dut._log.info("Running test...done")
    report.close()

def check_model(rannum):
    map = {0: [0,0], 1:[1,0], 2:[1,1]}
    m = []
    for j in range(5):
        m += map.get(rannum%3)
        rannum //= 3
    m.reverse()
    out = int.from_bytes( bit_handle.arr_to_str(m), "big" )
    return out
