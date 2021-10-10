import cocotb
from cocotb.clock import Clock
import cocotb.triggers as triggers
from cocotb.triggers import Timer
import hashes
import bit_handle as bh

report = open('report.txt','w')

@cocotb.test()
async def test(dut):
    """Try accessing the design."""

    dut._log.info("Running test...")
    cocotb.fork(Clock(dut.en, 2, units="ns").start())
    fail = 0
    dut.rst <= 1
    await triggers.RisingEdge(dut.en)
    await Timer(1, units="ns")
    dut.rst <= 0
    m = 0
    v = []
    for i in range(16384):
        v.clear()
        for j in range(7):
            a = rc_model(m)
            m += 1
            v.insert(0,a)
        expect = int.from_bytes(bh.arr_to_str(v),"big")
        try:
            if dut.out.value != expect:
                    fail = 1
                    report.write("When in = %X, out = %X, but I expect it = %X\n" %(i, int(dut.out.value), expect) )
        except:
            report.write("When in = %X, I expect it = %X, but out is unidentified\n" %(i, expect) )
        await triggers.RisingEdge(dut.en)
        await Timer(1, units="ns")
    if fail == 0: report.write("------VERIFICATION SUCCEED------\n")
    else: report.write("------VERIFICATION FAIL------\n")
    dut._log.info("Running test...done")
    report.close()

def rc_model(a):
    n = hashes.rc(a)
    return n
