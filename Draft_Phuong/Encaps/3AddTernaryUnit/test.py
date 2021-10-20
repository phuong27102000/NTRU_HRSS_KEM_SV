import cocotb
from cocotb.clock import Clock
from cocotb import triggers
from cocotb.triggers import Timer
from random import randint
import bit_handle

report = open('report.txt','w')

@cocotb.test()
async def test(dut):
    """Try accessing the design."""

    dut._log.info("Running test...")
    cocotb.fork(Clock(dut.clk, 1, units="ns").start())
    fail = 0
    v = []
    for times in range(10):
        v.clear()
        dut.ovr_rst <= 0
        await triggers.RisingEdge(dut.clk)
        dut.ovr_rst <= 1
        await Timer(1.1, units="ns")
        dut.ovr_rst <= 0
        await triggers.RisingEdge(dut.clk)
        for i in range(1500):
            rannum = randint(0,65535)
            dut.bits <= rannum
            if i < 340:
                byte1 = ( rannum // 256 ) % 3
                byte2 = ( rannum & 255 ) % 3
                if byte1 == 2:
                    byte1 = -1
                if byte2 == 2:
                    byte2 = -1
                v.append(byte2)
                v.append(byte1)
            await Timer(1, units="ns")
            if dut.hash_rst1 == 1:
                expect, inp = check_model(v)
                try:
                    if dut.prm.value != expect:
                        fail = 1
                        report.write("When i = %d, \n + in = %X, \n + out = %X, \n + but i expect it = %X\n" %(i, inp, int(dut.prm.value), expect ) )
                except:
                    fail = 1
                    report.write("When i = %d, \n + in = %X, \n + out is unidentified, \n + but i expect it = %X\n" %(i, inp, expect ) )
    if fail == 0: report.write("------VERIFICATION SUCCEED------\n")
    else: report.write("------VERIFICATION FAIL------\n")
    dut._log.info("Running test...done")
    report.close()

def check_model(a):
    v = a.copy()
    ps3 = 1088//8
    b = 1088*[0]
    for i in range(0,ps3):
        pow3 = 1
        c = 0
        for j in range(0,5):
            if 5*i+j<len(v):
                if v[5*i+j] < 0: v[5*i+j] += 3
                c += v[5*i+j]*pow3
                pow3 *= 3
        k = list(bin(c)[2:])
        k.reverse()
        for j in range(0,8):
            if j < len(k):
                b[8*i+j] = int(k[j])
            else:
                b[8*i+j] = 0
    b.reverse()
    v.reverse()
    map = {0: [0,0], 1: [0,1], 2: [1,1]}
    inp = []
    for i in v:
        inp += map.get(i)
    out = int.from_bytes( bit_handle.arr_to_str(b), "big" )
    inp = int.from_bytes( bit_handle.arr_to_str(inp), "big" )
    return out, inp
