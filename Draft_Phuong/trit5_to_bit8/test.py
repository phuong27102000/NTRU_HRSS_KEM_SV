import cocotb
from cocotb.clock import Clock
import cocotb.triggers as triggers
from cocotb.triggers import Timer
from trit_to_bit_model import trit_to_bit_model
import bit_handle

report = open('report.txt','w')

@cocotb.test()
async def test_mod3(dut):
    """Try accessing the design."""
    
    cocotb.fork(Clock(dut.clk, 1, units="ns").start())
    dut._log.info("Running test...")
    fail = 0
    trits = [[0,0], [0,1], [1,1]]
    dut.rst <= 0
    await triggers.RisingEdge(dut.clk)
    for i1 in trits:
        for i2 in trits:
            for i3 in trits:
                for i4 in trits:
                    for i5 in trits:
                        i = i1 + i2 + i3 + i4 + i5
                        inp = bit_handle.arr_to_str(i)
                        dut.rst <= 1
                        dut.a <= int.from_bytes(inp, "big")
                        await Timer(0.5, units = "ns")
                        dut.rst <= 0
                        await Timer(4, units = "ns")
                        
                        v = []
                        for j in [i5,i4,i3,i2,i1]:
                            if j == [0,1]: v.append(1) 
                            elif j == [0,0]: v.append(0) 
                            elif j == [1,1]: v.append(-1)
                            else: raise("Error in transform to the integer trit of", j);
                        b = trit_to_bit_model(v)
                        expect = int.from_bytes(bit_handle.arr_to_str(b), "big")
                        try:
                            if dut.out.value != expect:
                                fail = 1
                                report.write("When in = %s, out = %d, but I expect it = %d\n" %(bin(dut.a.value),int(dut.out.value),expect))
                        except:
                            fail = 1
                            report.write("When in = %s, I expect it = %d\n" %(bin(dut.a.value),expect))
        
    if fail == 0: report.write("------VERIFICATION SUCCEED------")
    else: report.write("------VERIFICATION FAIL------")
    dut._log.info("Running test...done")
    report.close()
