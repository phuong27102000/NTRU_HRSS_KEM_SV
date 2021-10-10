import cocotb
from cocotb.clock import Clock
import cocotb.triggers as triggers
from cocotb.triggers import Timer
from random import randint
import hashes
import bit_handle

report = open('report.txt','w')

@cocotb.test()
async def test(dut):
    """Try accessing the design."""

    dut._log.info("Running test...")
    cocotb.fork(Clock(dut.en, 2, units="ns").start())
    fail = 0
    v = []
    for i in range(3):
        v.clear()
        dut.rst <= 1
        await triggers.RisingEdge(dut.en)
        await Timer(1, units="ns")
        dut.rst <= 0
        for i in range(1600):
            j = randint(0,1)
            v.append(j)
        inp = int.from_bytes(bit_handle.arr_to_str(v),"big")
        dut.a <= inp
        v.reverse()
        for m in range(0,24):
            expect = int.from_bytes(iota_model(v, m),"big")
            await triggers.RisingEdge(dut.en)
            try:
                if dut.b.value != expect:
                    fail = 1
                    report.write("When in = %X and ir = %X, out = %X, but I expect it = %X\n" %( inp, m, int(dut.b.value), expect) )
            except:
                fail = 1
                report.write("When in = %X and ir = %X, I expect it = %X, but out is unidentified\n" %( inp, m, expect) )
            await Timer(1, units="ns")
    if fail == 0: report.write("------VERIFICATION SUCCEED------\n")
    else: report.write("------VERIFICATION FAIL------\n")
    dut._log.info("Running test...done")
    report.close()

def iota_model(a, ir):
    m = hashes.str_to_st_arr(a,64)
    n = hashes.iota(m, ir, 64)
    out = hashes.st_arr_to_str(n,64)
    out.reverse()
    return bit_handle.arr_to_str(out)
