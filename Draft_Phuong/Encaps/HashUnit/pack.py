import poly

def bi2by(bits):
    out = []
    temp = []
    while len(bits)&7 != 0:
        bits += [0]
    k = len(bits)
    i = 8
    while i<=k:
        temp.clear()
        for j in range(1,9):
            temp += [bits[i-j]]
        out += [temp.copy()]
        i+=8
    return out
    
def rq0(a,n,q,logq):
# a must be congurent to 0 modulo (q,x-1)
    check = 0
    for i in range (0,len(a)):
        check += a[i]
    if check%q != 0: return 0
    v = poly.rq(a,n,q)
    b = poly.zeros_gen((n-1)*logq)
    for i in range(0,n-1):
        if v[i] < 0: v[i] += q
        k = list(bin(v[i])[2:])
        k.reverse()
        for j in range(0,logq):
            if j < len(k):
                b[logq*i+j] = int(k[j])
            else:
                b[logq*i+j] = 0
    out = bi2by(b)
    return out
    
def sq(a,n,q,logq):
    v = poly.sq(a,n,q)
    b = poly.zeros_gen((n-1)*logq)
    for i in range(0,n-1):
        if v[i] < 0: v[i] += q
        k = list(bin(v[i])[2:])
        k.reverse()
        for j in range(0,logq):
            if j < len(k):
                b[logq*i+j] = int(k[j])
            else:
                b[logq*i+j] = 0
    out = bi2by(b)
    return out

def s3(a,n,ps3):
    v = poly.s3(a,n)
    b = poly.zeros_gen(8*ps3)
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
    out = bi2by(b)
    return out