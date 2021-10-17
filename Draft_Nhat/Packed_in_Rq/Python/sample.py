import poly

def fg_HPS(b,sib,sftb,n,q):
#len(b) must = sib + sftb
    f = ter(b[0:sib],sib,n)
    g = fixed_type(b[sib:sftb+sib],sftb,n,q)
    g+=[0]
    return f,g

def fg_HRSS(b,sib,n):
#len(b) must = 2*sib
    f = ter_plus(b[0:sib],sib,n)
    g0 = ter_plus(b[sib:2*sib],sib,n)
    g = []
    g += [-g0[0]]
    for i in range(1,n-1):
        g += [g0[i-1]-g0[i]]
    g += [g0[n-2]]
    return f,g

def rm_HPS(b,sib,sftb,n,q):
#len(b) must = sib + sftb
    r = ter(b[0:sib],sib,n)
    m = fixed_type(b[sib:sftb+sib],sftb,n,q)
    return r,m

def rm_HRSS(b,sib,n):
#len(b) must = 2*sib
    r = ter(b[0:sib],sib,n)
    m = ter(b[sib:2*sib],sib,n)
    return r,m

def ter(b,sib,n):
#len(b) must = sib
    v = poly.zeros_gen(n-1)
    for i in range (0,n-1):
        pow2 = 1
        for j in range (0,8):
            v[i] += pow2*b[8*i+j]
            pow2 *= 2
    out = poly.s3(v,n)
    return out
    
def ter_plus(b,sib,n):
#len(b) must = sib
    v = ter(b,sib,n)
    t = 0
    for i in range (0,n-2):
        t += v[i]*v[i+1]
    if t < 0:
        for i in range (0,n-1,2):
            v[i] = -v[i]
    out = poly.s3(v,n)
    return out

def fixed_type(b,sftb,n,q):
#len(b) must = sftb
    a = poly.zeros_gen(n-1)
    for i in range(0,n-1):
        for j in range (0,30):
            a[i] += b[30*i+j]<<(2+j)
    i = 0
    while i < ((q>>4) -1):
        a[i] |= 1
        i += 1
    while i < ((q>>3) -2):
        a[i] |= 2
        i += 1
    poly.sort_int32(a,n-1)
# #delete from here
    # f = "test_case.txt"
    # file = open(f,'a+')
    # file.write("Fixed type:\n")
    # for i in range(0,n-1):
        # file.write("%X "%a[i])
        # if (i & 63) == 63: file.write("\n")
    # file.write("\n______________________________________________________________________________________________________________________________________________________________________________________________\n\n");
    # file.close()
# #to here
    v = []
    for i in range(0,n-1):
        v += [a[i]%4]
    out = poly.s3(v,n)
    return out
def str_to_arr(bit_str):
    byte_arr = bytearray(bit_str)
    bit_arr = []
    for by in byte_arr:
        temp = []
        threshold = 128
        for i in range(8):
            if by < threshold:
                temp += [0]
            else:
                temp += [1]
                by -= threshold
            threshold >>= 1
        bit_arr += temp
    return bit_arr

def arr_to_str(bit_arr):
    while (len(bit_arr) & 7) != 0:
        bit_arr.insert(0,0)
    pow2 = 128
    temp = 0
    byte_arr = []
    for bi in bit_arr:
        if bi:
            temp += pow2
        if pow2 == 1: #reset
            byte_arr += [temp]
            pow2 = 128
            temp = 0
        else:
            pow2 >>= 1
    bit_str = bytes(byte_arr)
    return bit_str

print(arr_to_str([0,1,1,1,1,0]))
def arr_to_str_ternary(bit_arr):
    str=''
    i=len(bit_arr)-1
    while i>=0:
        b = format(bit_arr[i] & 0x3, '2b')
        m = 0
        b1 = ''
        while m < len(b):
            if b[m] == ' ':
                b1 = b1 + '0'
            else:
                b1 = b1 + b[m]
            m = m + 1
        str=str+b1
        i=i-1
    str=int(str,2)
    return str
def arr_to_str_integer(bit_arr):
    str=''
    i=len(bit_arr)-1
    while i>=0:
        b = format(bit_arr[i] & 0x1fff, '13b')
        m = 0
        b1 = ''
        while m < len(b):
            if b[m] == ' ':
                b1 = b1 + '0'
            else:
                b1 = b1 + b[m]
            m = m + 1
        str=str+b1
        i=i-1
    str=int(str,2)
    return str
def arr_to_str_integer_packver(bit_arr):
    str1=''
    i=len(bit_arr)-1;
    while i>=0:
        j=len(bit_arr[i])-1
        while j>=0:
            str1=str1+str(bit_arr[i][j])
            j=j-1
        i=i-1
    str1=int(str1,2)
    return str1
