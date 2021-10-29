import cocotb
from cocotb.clock import Clock
from cocotb import triggers
from cocotb.triggers import Timer

report = open('report.txt','w')

@cocotb.test()
async def test(dut):
    """Try accessing the design."""

    dut._log.info("Running test...")
    list = [0,1,3]
    fail = 0
    for i in range(3):
        for j in range(3):
            x = list[i]
            y = list[j]
            dut.x <= x
            dut.y <= y
            if (x == 3): x = 2
            if (y == 3): y = 2
            expect = (x-y) %3
            if expect == 2: expect = 3
            await Timer(1, units = "ns")
            try:
                if dut.z.value != expect:
                    fail = 1
                    report.write("%s + %s = %s - but i expect it = %s\n" %( bin(dut.x.value), bin(dut.y.value), bin(dut.z.value), bin(expect) ) )
                else:
                    report.write("It is true that: %s + %s = %s\n" %( bin(dut.x.value), bin(dut.y.value), bin(dut.z.value) ) )
            except:
                fail = 1
                report.write("When x = %s, y = %s, out is unidentified, but i expect it = %s\n" %( bin(dut.x.value), bin(dut.y.value), bin(expect) ) )
    if fail == 0: report.write("------VERIFICATION SUCCEED------\n")
    else: report.write("------VERIFICATION FAIL------\n")
    dut._log.info("Running test...done")
    report.close()
