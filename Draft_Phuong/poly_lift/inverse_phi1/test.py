import cocotb
from cocotb.clock import Clock
import cocotb.triggers as triggers
from cocotb.triggers import Timer
from random import randint

@cocotb.test()
async def test(dut):
    """Try accessing the design."""

    dut._log.info("Running test...")
    cocotb.fork(Clock(dut.clk, 1, units="ns").start())
    dut.rst <= 0
    await Timer(0.2, units = "ns")
    list = [0,1,3,4,5,7,12,13,15]
    for j in range(9):
        dut.rst <= 1
        dut.init <= list[j]
        await Timer(1, units = "ns")
        dut.rst <= 0
        for i in range(5):
            dut.spe_case <= randint(1,2)
            await Timer(1, units = "ns")
            dut.spe_case <= 0
            await Timer(4, units = "ns")
    dut._log.info("Running test...done")
