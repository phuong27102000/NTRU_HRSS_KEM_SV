import cocotb
from cocotb.clock import Clock
from cocotb import triggers
from cocotb.triggers import Timer
from random import randint
import bit_handle
from hashes import sha3_256

report = open('report.txt','w')

@cocotb.test()
async def test(dut):
    """Try accessing the design."""

    dut._log.info("Running test...")
    cocotb.fork(Clock(dut.clk, 1, units="ns").start())

# Set up variable
    sum = 0
    str_even = ""
    str_odd = ""
    fail = 0
    v = []
    for times in range(1):
    # Reset some port
        onetime = 0
        v.clear()
        dut.ovr_rst1 <= 0
        await Timer(0.2, units="ns")
        dut.ovr_rst1 <= 1
        await Timer(0.9, units="ns")
        dut.ovr_rst1 <= 0
        await Timer(0.3, units="ns")
        for i in range(1250):
        # Keep sending data in our chip
            rannum = randint(0,65535)
            dut.bits <= rannum
            even = randint(0,8191)
            odd = randint(0,8191)
            dut.h <= 8192*odd + even
            if i < 350:
                # Prepare for checking h_mem
                str_even = binit(even,13) + str_even
                str_odd = binit(odd,13) + str_odd
                sum += odd + even
                h_expect = 8192 - (sum & 8191)
            if i < 700:
                # Prepare for checking hash_value
                byte1 = ( rannum // 256 ) % 3
                byte2 = ( rannum & 255 ) % 3
                if byte1 == 2:
                    byte1 = -1
                if byte2 == 2:
                    byte2 = -1
                v.append(byte2)
                v.append(byte1)
            await Timer(1, units="ns")
        await Timer(2, units="ns")
        onetime = 1
        expect1, inp1, expect2, inp2 = check_model(v)
        try:
            if dut.k.value != expect2:
                fail = 1
                report.write("When i = %d, \n + in = %X, \n + out = %X, \n + but i expect it = %X\n" %(i, inp2, int(dut.k.value), expect2 ) )
                report.write("You could test our reference hashed values by enter these on https://emn178.github.io/online-tools/sha3_256.html: \n + in = %X, \n + the expectation is = %X\n" %(inp1, expect1 ) )
            else:
                report.write("It is true that: \n + When i = %d, \n + in = %X, \n + out = %X, \n + and i expect it = %X\n" %(i, inp2, int(dut.k.value), expect2 ) )
                report.write("You could test our reference hashed values by enter these on https://emn178.github.io/online-tools/sha3_256.html: \n + in = %X, \n + the expectation is = %X\n" %(inp1, expect1 ) )
        except:
            fail = 1
            report.write("When i = %d, \n + in = %X, \n + out is unidentified, \n + but i expect it = %X\n" %(i, inp2, expect2 ) )
            report.write("You could test our reference hashed values by enter these on https://emn178.github.io/online-tools/sha3_256.html: \n + in = %X, \n + the expectation is = %X\n" %(inp1, expect1 ) )
        try:
            str = str_odd + binit(h_expect,13) + str_even
            h = binit(dut.h_mem.value, 9113)
            if h != str:
                fail = 1
                report.write("Out = b%s \n but I expect it = b%s\n" %(h,str))
                if len(h) != len(str):
                    fail = 1
                    report.write("Length of out is %d \n but I expect it is %d\n" %( len(h),len(str) ) )
                for leng in range(len(h)):
                    if h[leng] != str[leng]:
                        report.write("Different at %d\n" %leng)
        except:
            fail = 1
            report.write("I expect it = b%s\n but out is unindentified\n" %str)
    if fail == 0: report.write("------VERIFICATION SUCCEED------\n")
    else: report.write("------VERIFICATION FAIL------\n")
    dut._log.info("Running test...done")
    report.close()

def check_model(a):
    v = a.copy()
    ps3 = 1400//5
    b = (8*ps3)*[0]
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
    key = sha3_256(b)
    key.reverse()
    out1 = int.from_bytes( bit_handle.arr_to_str(key)[::-1] , "big" )
    out2 = int.from_bytes( bit_handle.arr_to_str(key) , "big" )
    # v.reverse()
    # map = {0: [0,0], 1: [0,1], 2: [1,1]}
    # inp = []
    # for i in v:
    #     inp += map.get(i)
    # inp = int.from_bytes( bit_handle.arr_to_str(inp), "big" )
    b.reverse()
    inp1 = int.from_bytes( bit_handle.arr_to_str(b)[::-1], "big" )
    inp2 = int.from_bytes( bit_handle.arr_to_str(b) , "big" )
    return out1, inp1, out2, inp2

def binit(x,leng):
    str = bin(x)[2:]
    while len(str) < leng:
        str = '0' + str
    if len(str) > leng:
        str = str[1:]
    return str
