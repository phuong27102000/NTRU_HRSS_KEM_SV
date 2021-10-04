import cocotb
from cocotb.clock import Clock
import cocotb.triggers as triggers
from cocotb.triggers import Timer
from pack_s3_model import pack_s3_model
import bit_handle
from random import randint

report = open('report.txt','w')

@cocotb.test()
async def test_mod3(dut):
    """Try accessing the design."""
    
    cocotb.fork(Clock(dut.clk, 1, units="ns").start())
    dut._log.info("Running test...")
    fail = 0
    trits = {0: [0,0],1: [0,0],-1: [1,1]}
    dut.rst <= 0
    v, trit_arr = [], []
    for m in range (256):
        v.clear()
        trit_arr.clear()
        for i in range(700):
            j = randint(-1,1)
            v.append(j)
            trit_arr += trits.get(j)
        trit_arr.reverse()     
        inp = bit_handle.arr_to_str(trit_arr)
        dut.rst <= 1    
        dut.a <= int.from_bytes(inp, "big")
        await triggers.RisingEdge(dut.clk)
        await Timer(1, units = "ns")
        dut.rst <= 0
        b = pack_s3_model(v)
        expect = int.from_bytes(bit_handle.arr_to_str(b), "big")
        await Timer(1, units = "us")
        try:
            if dut.out.value != expect:
                fail = 1
                report.write("When in = %X, out = %X, but I expect it = %X\n" %(int(dut.a.value), int(dut.out.value), expect))
        except:
            fail = 1
            report.write("When in = %X, I expect it = %X\n" %(int(dut.a.value),expect))
        
    if fail == 0: report.write("------VERIFICATION SUCCEED------")
    else: report.write("------VERIFICATION FAIL------")
    dut._log.info("Running test...done")
    report.close()
