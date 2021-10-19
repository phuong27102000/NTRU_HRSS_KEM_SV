import cocotb
import cocotb.triggers as triggers
from cocotb.triggers import Timer
from random import randint

report = open('report.txt','w')

@cocotb.test()
async def test(dut):
    """Try accessing the design."""

    dut._log.info("Running test...")
    fail = 0
    for i in range(256):
        x1 = randint(0,8191)
        x2 = randint(0,8191)
        dut.x1 <= x1
        dut.x2 <= x2
        expect = ( (x1+x2) & 8191 )
        await Timer(1, units="ns")
        try:
            check = expect ^ dut.out.value
        except:
            check = 8191
        dut.check_holder <= check
        await Timer(1, units="ns")
        try:
            if dut.out.value != expect:
                fail = 1
                report.write("When x1 = %d, x2 = %d, out = %d, but I expect it = %d\n" %(int(dut.x1.value),int(dut.x2.value),int(dut.out.value),expect))
        except:
            fail = 1
            report.write("When x1 = %d, x2 = %d, I expect it = %d, but out is unindentified\n" %(int(dut.x1.value),int(dut.x2.value),expect))
    if fail == 0: report.write("------VERIFICATION SUCCEED------\n")
    else: report.write("------VERIFICATION FAIL------\n")
    dut._log.info("Running test...done")
    report.close()
