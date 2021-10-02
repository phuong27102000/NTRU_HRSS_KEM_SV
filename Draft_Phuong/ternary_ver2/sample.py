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
        v += [a[i]&3]
    out = poly.s3(v,n)
    return out