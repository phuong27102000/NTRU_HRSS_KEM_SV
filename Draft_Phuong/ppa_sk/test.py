import cocotb
import cocotb.triggers as triggers
from cocotb.triggers import Timer

report = open('report.txt','w')

@cocotb.test()
async def test_mod3(dut):
    """Try accessing the design."""

    dut._log.info("Running test...")
    fail = 0
    for i in range(256):
        for j in range(256):
            dut.x1 <= i
            dut.x2 <= j
            await Timer(2, units="ns")
            expect = ((i+j) & 255)
            if dut.out.value != expect:
                fail = 1
                report.write("When x1 = %d, x2 = %d, out = %d, but I expect it = %d\n" %(int(dut.x1.value),int(dut.x2.value),int(dut.out.value),expect))
    if fail == 0: report.write("------VERIFICATION SUCCEED------")
    else: report.write("------VERIFICATION FAIL------")
    dut._log.info("Running test...done")
    report.close()
