import cocotb
from cocotb.clock import Clock
import cocotb.triggers as triggers
from cocotb.triggers import Timer

report = open('report.txt','w')

@cocotb.test()
async def test_mod3(dut):
    """Try accessing the design."""

    dut._log.info("Running test...")
    fail = 0
    for i in range(255):
        dut.a <= i
        await Timer(1, units="ns")
        expect = i+1
        if dut.out.value != expect:
            fail = 1
            report.write("When in = %d, out = %d, but I expect it = %d\n" %(int(dut.a.value),int(dut.out.value),expect))
    if fail == 0: report.write("------VERIFICATION SUCCEED------\n")
    else: report.write("------VERIFICATION FAIL------\n")
    dut._log.info("Running test...done")
    report.close()
