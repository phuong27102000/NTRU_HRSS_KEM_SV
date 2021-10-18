import cocotb
from cocotb.clock import Clock
import cocotb.triggers as triggers
from cocotb.triggers import Timer

report = open('report.txt','w')

@cocotb.test()
async def test(dut):
    """Try accessing the design."""

    dut._log.info("Running test...")
    cocotb.fork(Clock(dut.ex_clk, 1, units="ns").start())
    dut.ovr_rst1 <= 0
    for i in range(2):
	    await triggers.RisingEdge(dut.ex_clk)
	    dut.ovr_rst1 <= 1
	    await Timer(1.1, units="ns")
	    dut.ovr_rst1 <= 0
	    await Timer(2000, units="ns")
    dut._log.info("Running test...done")
    report.close()
