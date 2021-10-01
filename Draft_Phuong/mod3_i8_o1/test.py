import cocotb
from cocotb.clock import Clock
import cocotb.triggers as triggers
from cocotb.triggers import Timer

report = open('report.txt','w')

@cocotb.test()
async def test_mod3(dut):
    """Try accessing the design."""

    dut._log.info("Running test...")
    cocotb.fork(Clock(dut.clk, 1, units="ns").start())
    fail = 0
    for i in range(255):
        dut.rst <= 1
        dut.in_sig <= i
        await triggers.FallingEdge(dut.clk)
        dut.rst <= 0
        await triggers.RisingEdge(dut.clk)
        await Timer(5, units="ns")
        expect = i%3
        if expect == 2: expect = 3
        if dut.out_sig.value != expect:
            fail = 1
            report.write("When in = %d, out = %d, but i expect it = %d\n" %(int(dut.in_sig.value),int(dut.out_sig.value),expect))
    if fail == 0: report.write("------VERIFICATION SUCCEED------")
    else: report.write("------VERIFICATION FAIL------")
    dut._log.info("Running test...done")
    report.close()
