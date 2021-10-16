import poly

def s2(x,n):
#len(x) = n-1
    k = list(bin(n-2)[2:])
    k.reverse()
    y = poly.s2(x,n) + [0]
    mem = [y.copy()] 
    for i in range(len(k)-1,-1,-1):
        if k[i] == '1':
            pow2j = 1
            for j in range (0,i):
                z = poly.r2_sqr(y,n,pow2j)
                y = poly.r2_mul(z,y,n)
                if (k[j+1] == '1')and(j!=i-1): mem += [y.copy()]
                pow2j *= 2
        break
    for j in range(i-1,-1,-1):
        if k[j] == '1':
            pow2j = pow(2,j)
            z = poly.r2_sqr(y,n,pow2j)
            y = poly.r2_mul(z,mem.pop(),n)
    z = poly.r2_sqr(y,n,1)
    if z[n-1] == 1:
        for i in range(0,n-1): z[i] = 1-z[i]
    z.pop()
    return z

def s3(a,n):
    delta = 1
    v = poly.zeros_gen(n)
    r = poly.zeros_gen(n)
    r.pop()
    r.insert(0,1)
    f = poly.ones_gen(n)
    g = a.copy()
    g += [0]
    for i in range(0,2*n-3):
        v.pop()
        v.insert(0,0)
        c = f[0]*g[0]
        if (delta>0)and(g[0]!=0):
            delta = -delta
            f,g = g,f
            v,r = r,v
        delta += 1
        for j in range (0,n):
            g[j] = (g[j] - c*f[j])%3
            r[j] = (r[j] - c*v[j])%3
        g.pop(0)
        g+=[0]
    out = v[n-4:n].copy()
    out += v[0:n-4].copy()
    for i in range (0,n):
        out[i] *= f[0]
    out = poly.s3(out,n)
#delta = 0 is invertible
    return out,delta

def sq(a,n,logq,q):
    v = s2(a,n) + [0]
    t = 1
    while t<logq:
        r = poly.rq_mul(a+[0],v,q,n)
        r[0] = (2-r[0])%q
        for i in range (1,n):
            r[i] = q - r[i]
        v = poly.rq_mul(v,r,q,n)
        t *= 2
    v = poly.sq(v,n,q)
    return v

def r2(x,n):
#len(x) = n-1
    k = list(bin(n-2)[2:])
    k.reverse()
    y = poly.r2(x,n)
    x = 0
    for i in range(0,n):
        x ^= y[i]
    # y += [0]
    mem = [y.copy()] 
    for i in range(len(k)-1,-1,-1):
        if k[i] == '1':
            pow2j = 1
            for j in range (0,i):
                z = poly.r2_sqr(y,n,pow2j)
                y = poly.r2_mul(z,y,n)
                if (k[j+1] == '1')and(j!=i-1): mem += [y.copy()]
                pow2j *= 2
        break
    for j in range(i-1,-1,-1):
        if k[j] == '1':
            pow2j = pow(2,j)
            z = poly.r2_sqr(y,n,pow2j)
            y = poly.r2_mul(z,mem.pop(),n)
    z = poly.r2_sqr(y,n,1)
    # if z[n-1] == 1:
        # for i in range(0,n-1): z[i] = 1-z[i]
    # z.pop()
    return z

def rq(a,n,logq,q):
    v = r2(a,n)
    t = 1
    while t<logq:
        r = poly.rq_mul(a+[0],v,q,n)
        r[0] = (2-r[0])%q
        for i in range (1,n):
            r[i] = q - r[i]
        v = poly.rq_mul(v,r,q,n)
        t *= 2
    v = poly.rq(v,n,q)
    return v

