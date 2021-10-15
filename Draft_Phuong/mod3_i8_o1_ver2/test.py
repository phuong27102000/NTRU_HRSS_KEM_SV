import cocotb
from cocotb.clock import Clock
from cocotb.triggers import Timer

report = open('report.txt','w')

@cocotb.test()
async def test(dut):
    """Try accessing the design."""

    dut._log.info("Running test...")
    fail = 0
    for i in range(255):
        dut.in_sig <= i
        await Timer(2, units="ns")
        expect = i%3
        if expect == 2: expect = 3
        try:
            if dut.out_sig.value != expect:
                fail = 1
                report.write("When in = %d, out = %d, but i expect it = %d\n" %(int(dut.in_sig.value),int(dut.out_sig.value),expect))
        except:
            fail = 1
            report.write("When in = %d, out is unidentified, but i expect it = %d\n" %(int(dut.in_sig.value),expect))
    if fail == 0: report.write("------VERIFICATION SUCCEED------\n")
    else: report.write("------VERIFICATION FAIL------\n")
    dut._log.info("Running test...done")
    report.close()
