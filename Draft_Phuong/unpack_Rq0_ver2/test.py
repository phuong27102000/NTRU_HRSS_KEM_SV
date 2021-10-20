import cocotb
from cocotb.clock import Clock
import cocotb.triggers as triggers
from cocotb.triggers import Timer
from random import randint

report = open('report.txt','w')

@cocotb.test()
async def test_mod3(dut):
    """Try accessing the design."""

    dut._log.info("Running test...")
    cocotb.fork(Clock(dut.clk, 1, units="ns").start())
    fail = 0
    dut.rst <= 1
    dut.last_n <= 1
    dut.done_n <= 1
    await Timer(1, units="ns")
    sum1, sum2 = 0, 0
    str_even = ""
    str_odd = ""
    expect_next = 0
    await Timer(0.2, units="ns")
    for i in range(350):
        even = randint(0,8191)
        odd = randint(0,8191)
        dut.even <= even
        dut.odd <= odd
        str_even = binit(even,13) + str_even
        str_odd = binit(odd,13) + str_odd
        sum1 += even
        sum1 &= 8191
        sum2 += odd
        sum2 &= 8191
        expect = expect_next
        expect_next = 8192 - ( (sum1 + sum2) & 8191 )
        dut.check_holder <= expect
        await Timer(0.1, units="ns")
        if (i == 0):
            dut.rst <= 0
        try:
            if dut.out.value != expect:
                fail = 1
                report.write("Out = %d, but I expect it = %d\n" %(int(dut.out.value),expect))
        except:
            fail = 1
            report.write("I expect it = %d\n but out is unindentified" %expect)
        await Timer(0.9, units="ns")
    dut.last_n <= 0
    str_even = binit(expect_next,13) + str_even
    await Timer(1, units="ns")
    dut.check_holder <= expect_next
    dut.done_n <= 0
    await Timer(1.8, units="ns")
    str = str_odd + str_even
    h = binit(dut.h_mem.value, 9113)
    try:
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
        report.write("I expect it = b%s\n but out is unindentified" %str)
    if fail == 0: report.write("------VERIFICATION SUCCEED------\n")
    else: report.write("------VERIFICATION FAIL------\n")
    dut._log.info("Running test...done")
    report.close()

def binit(x,leng):
    str = bin(x)[2:]
    while len(str) < leng:
        str = '0' + str
    if len(str) > leng:
        str = str[1:]
    return str
