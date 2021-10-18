import cocotb
from cocotb.clock import Clock
import cocotb.triggers as triggers
from cocotb.triggers import Timer
from random import randint
import hashes
import bit_handle

report = open('report.txt','w')

@cocotb.test()
async def test(dut):
    """Try accessing the design."""

    dut._log.info("Running test...")
    cocotb.fork(Clock(dut.clk, 1, units="ns").start())
    fail = 0
    v = []
    for i in range(10):
        v.clear()
        for i in range(1600):
            j = randint(0,1)
            v.append(j)
        inp = int.from_bytes(bit_handle.arr_to_str(v),"big")
        dut.s <= inp
        dut.rst2 <= 1
        await triggers.FallingEdge(dut.clk)
        dut.rst1 <= 1
        await triggers.RisingEdge(dut.clk)
        dut.rst2 <= 0
        await triggers.FallingEdge(dut.clk)
        dut.rst1 <= 0
        await triggers.RisingEdge(dut.clk)
        dut._log.info("Reset done...")
        expect = int.from_bytes(keccak_p_model(v),"big")
        dut._log.info("Calculate expectation done...")
        await Timer(23, units = "ns")
        dut._log.info("Finish an iteration...")
        try:
            if dut.out.value != expect:
                fail = 1
                report.write("When in = %X, out = %X, but I expect it = %X\n" %( inp, int(dut.out.value), expect) )
        except:
            fail = 1
            report.write("When in = %X, I expect it = %X, but out is unidentified\n" %( inp, expect) )
            await Timer(1, units="ns")
    if fail == 0: report.write("------VERIFICATION SUCCEED------\n")
    else: report.write("------VERIFICATION FAIL------\n")
    dut._log.info("Running test...done")
    report.close()

def keccak_p_model(s):
    s.reverse()
    out = hashes.keccak_p(s)
    out.reverse()
    return bit_handle.arr_to_str(out)
