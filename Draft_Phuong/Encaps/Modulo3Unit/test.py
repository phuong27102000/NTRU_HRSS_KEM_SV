import cocotb
from cocotb.clock import Clock
from cocotb import triggers
from cocotb.triggers import Timer
from random import randint

report = open('report.txt','w')

@cocotb.test()
async def test(dut):
    """Try accessing the design."""

    dut._log.info("Running test...")
    cocotb.fork(Clock(dut.clk, 1, units="ns").start())
    dut.ovr_rst <= 0
    await triggers.RisingEdge(dut.clk)
    dut.ovr_rst <= 1
    await Timer(1.1, units="ns")
    dut.ovr_rst <= 0
    await triggers.RisingEdge(dut.clk)
    fail = 0
    for i in range(701):
        rannum = randint(0,65535)
        dut.bits <= rannum
        byte1 = ( rannum // 256 ) % 3
        byte2 = ( rannum & 255 ) % 3
        if byte1 == 2:
            byte1 = 3
        if byte2 == 2:
            byte2 = 3
        expect = ( byte1<<2 ) + byte2
        await Timer(1, units="ns")
        try:
            if dut.mod3.value != expect:
                fail = 1
                report.write("When in = %X, out = %s, but i expect it = %s\n" %(rannum,bin(int(dut.mod3.value)),bin(expect)))
        except:
            fail = 1
            report.write("When in = %X, out is unidentified, but i expect it = %s\n" %(rannum,bin(expect)))
    if fail == 0: report.write("------VERIFICATION SUCCEED------\n")
    else: report.write("------VERIFICATION FAIL------\n")
    dut._log.info("Running test...done")
    report.close()
