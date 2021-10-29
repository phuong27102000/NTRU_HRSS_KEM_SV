import cocotb
from cocotb.clock import Clock
import cocotb.triggers as triggers
from cocotb.triggers import Timer
from random import randint
import poly
import bit_handle

report = open('report.txt','w')

@cocotb.test()
async def test(dut):
    """Try accessing the design."""

    dut._log.info("Running test...")
    cocotb.fork(Clock(dut.clk, 1, units="ns").start())
    dut.rst <= 0
    await Timer(0.2, units = "ns")
    dut.rst <= 1
    await Timer(1, units = "ns")
    dut.rst <= 0
    m = []
    map = {0: [0,0], 1:[0,1], 2:[1,1]}
    dut.en <= 1
    for i in range(350):
        m.append(randint(0,2))
        m.append(randint(0,2))
        num = map.get( m[2*i+1] ) + map.get( m[2*i] )
        dut.m_in <= int.from_bytes(bit_handle.arr_to_str(num), "big")
        await Timer(1, units = "ns")
    m.append(0)
    dut.m_in <= 0
    await Timer(1, units = "ns")
    dut.en <= 0
    await Timer(10, units = "ns")
    expect, m0_str = hrss(m)
    try:
        if dut.m1.value != expect:
            fail = 1
            report.write(" + m1 = %X \n + but i expect it = %X\n" %( int(dut.m1.value), expect ) )
        else:
            report.write("It is true that: + m1 = %X\n" %( int(dut.m1.value) ) )
    except:
        fail = 1
        report.write("Out is unidentified, but i expect it = %X\n" %( expect ) )

    m0 = binit(dut.m0.value, 9113)
    try:
        if m0 != m0_str:
            fail = 1
            report.write(" + m0 = %s \n + but i expect it = %s\n" %( m0, m0_str ) )
        else:
            report.write("It is true that: + m0 = %s\n" %( m0 ) )
    except:
        fail = 1
        report.write("Out is unidentified, but i expect it = %s\n" %( m0_str ) )

    dut._log.info("Running test...done")

def hrss(m):
    print(m)
    n = 701
    b = poly.zeros_gen(n)
    t = 3 - (n%3)
    b[0] = m[0] * (2-t) + m[1] * 0 + m[2] * t
    b[1] = m[1] * (2-t) + m[2] * 0
    b[2] = m[2] * (2-t)

    zj = 0
    for i in range (3,n):
        b[0] += m[i] * (zj + 2*t)
        b[1] += m[i] * (zj + t)
        b[2] += m[i] * zj
        zj = (zj + t) % 3
    b[1] += m[0] * (zj + t)
    b[2] += m[0] * zj
    b[2] += m[1] * (zj + t)
    for i in range (3,n):
        b[i] = b[i-3] + 2*(m[i] + m[i-1] + m[i-2])
    for i in range (0,n):
        b[i] = b[i] % 3
    b.reverse()
    map = {0: [0,0], 1:[0,1], 2:[1,1]}
    bb = []
    for i in range(n):
        bb += map.get(b[i])
    out = int.from_bytes(bit_handle.arr_to_str(bb), "big")
    r = poly.zeros_gen(n)
    b.reverse()
    b = poly.s3(b,n) + [0]
    r[0] = -b[0]
    for i in range (0,n-1):
        r[i+1] = b[i] - b[i+1]
    str = ''
    for i in range(n):
        str = binit_r(r[i]) + str
    return out, str

def binit(x,leng):
    str = bin(x)[2:]
    while len(str) < leng:
        str = '0' + str
    while len(str) > leng:
        str = str[1:]
    return str

def binit_r(x):
    leng = 13
    if (x<0):
        y = x + 8
    else:
        y = x
    str = bin(y)[2:]
    while len(str) < 3:
        str = '0' + str
    while len(str) < leng:
        if x<0:
            str = '1' + str
        else:
            str = '0' + str
    while len(str) > leng:
        str = str[1:]
    return str
