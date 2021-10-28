import poly

def by2bi(byte,l):
    out = []
    for i in range(0,len(byte)):
        temp = byte[i].copy()
        temp.reverse()
        out += temp
    while len(out)<l:
        out += [0]
    while len(out)>l:
        out.pop()
    return out
    
def rq0(m,n,q,logq):
    b = by2bi(m,(n-1)*logq)
    v = poly.zeros_gen(n)
    for i in range(0,n-1):
        c = 0
        pow2 = 1
        for j in range (0,logq):
            c += pow2*b[i*logq+j]
            pow2 *= 2
        v[i] += c
        v[n-1] -= c
    out = poly.rq(v,n,q)
    return out

def sq(m,n,q,logq):
    b = by2bi(m,(n-1)*logq)
    v = poly.zeros_gen(n)
    for i in range(0,n-1):
        c = 0
        pow2 = 1
        for j in range (0,logq):
            c += pow2*b[i*logq+j]
            pow2 *= 2
        v[i] += c
    out = poly.sq(v,n,q)
    return out
    
def s3(m,n,ps3):
    b = by2bi(m,8*ps3)
    v = poly.zeros_gen(5*ps3)
    for i in range(0,ps3):
        d = 0
        pow2 = 1
        for j in range (0,8):
            d += pow2*b[8*i+j]
            pow2 *= 2
        pow3 = 3
        for j in range (0,5):
            v[5*i+j] = d%(pow3)
            d //= 3
            pow3 *= 3
    out = poly.s3(v,n)
    return out