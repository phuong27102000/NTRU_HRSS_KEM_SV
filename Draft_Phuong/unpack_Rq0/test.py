import cocotb
from cocotb.clock import Clock
import cocotb.triggers as triggers
from cocotb.triggers import Timer
from random import randint

report = open('report.txt','w')

@cocotb.test()
async def test_mod3(dut):
    """Try accessing the design."""

    dut._log.info("Running test...")
    cocotb.fork(Clock(dut.clk, 1, units="ns").start())
    fail = 0
    dut.rst <= 1
    await Timer(1.3, units="ns")
    dut.rst <= 0
    sum = 0
    for i in range(701):
        x = randint(0,8191)
        dut.x <= x
        sum += x
        sum &= 8191
        await Timer(0.7, units="ns")
        expect = 8192 - sum
        dut.check_holder <= expect
        await Timer(0.3, units="ns")
        try:
            if dut.out.value != expect:
                fail = 1
                report.write("When x = %d, out = %d, but I expect it = %d\n" %(int(dut.x.value),int(dut.out.value),expect))
        except:
            fail = 1
            report.write("When x = %d, I expect it = %d\n but out is unindentified" %(int(dut.x.value),expect))
    if fail == 0: report.write("------VERIFICATION SUCCEED------\n")
    else: report.write("------VERIFICATION FAIL------\n")
    dut._log.info("Running test...done")
    report.close()
