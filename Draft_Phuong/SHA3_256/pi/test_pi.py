import cocotb
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
    fail = 0
    v = []
    for k in range(8192):
        v.clear()
        for i in range(1600):
            j = randint(0,1)
            v.append(j)
        inp = bit_handle.arr_to_str(v)
        dut.a <= int.from_bytes(inp, "big")
        await Timer(2, units="ns")
        expect = int.from_bytes(pi_model(v),"big")
        try:
            if dut.out.value != expect:
                    fail = 1
                    report.write("When in = %X, out = %X, but I expect it = %X\n" %(int(dut.a.value), int(dut.out.value), expect) )
        except:
            report.write("When in = %X, I expect it = %X, but out is unidentified\n" %(int(dut.a.value), expect) )

    if fail == 0: report.write("------VERIFICATION SUCCEED------\n")
    else: report.write("------VERIFICATION FAIL------\n")
    dut._log.info("Running test...done")
    report.close()

def pi_model(a):
    a.reverse()
    m = hashes.str_to_st_arr(a,64)
    n = hashes.pi(m,64)
    out = hashes.st_arr_to_str(n,64)
    out.reverse()
    return bit_handle.arr_to_str(out)
