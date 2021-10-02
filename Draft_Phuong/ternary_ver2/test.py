import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge
from cocotb.triggers import Timer
from secrets import token_bytes as prg
from ter_model import ter_model

report = open('report.txt','w')

@cocotb.test()
async def test_ternary(dut):
    """Try accessing the design."""

    dut._log.info("Running test...")
    cocotb.fork(Clock(dut.clk, 1, units="ns").start())
    fail = 0
    for i in range(10):
        dut.rst <= 1
        bit_str = prg(700)
        dut.bit_str <= int.from_bytes(bit_str, "big")   
        await RisingEdge(dut.clk)
        await Timer(1, units="ns")
        dut.rst <= 0
        await Timer(1500, units="ns")
        expect = ter_model(bit_str)
        try:
            if dut.out.value != expect:
                fail = 1
                report.write( "When bit_str = %X, v = %s, but i expect it = %s\n" %( dut.bit_str.value, bin( int(dut.out.value) ), bin(expect) ) )
        except:
            report.write( "When bit_str = %X, v = ...xxx, but i expect it = %s\n" %( dut.bit_str.value, bin(expect) ) )
    if fail == 0: report.write("------VERIFICATION SUCCEED------")
    else: report.write("------VERIFICATION FAIL------")
    dut._log.info("Running test...done")
    report.close()
