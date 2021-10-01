def zeros_gen(n):
    out = [0]*n
    return out
    
def ones_gen(n):
    out = [1]*n
    return out

def r2_sqr(y,n,times):
#n is prime, len(y) = n, y is binary poly
    z = y.copy()
    for i in range(0,times):
        temp = z.copy()
        for j in range(0,n):
            k = (2*j)%n
            z[k] = temp[j]
    return z

def r2_add(a,b,n):
#len(a) = len(b)
    out = []
    for i in range(0,n):
        out += [a[i]^b[i]]
    return out
    
def r2_mul(a,b,n):
#len(a) = len(b)
    out = zeros_gen(n)
    temp = a.copy()
    for i in range(0,n):
        if b[i] == 1:
            out = r2_add(out,temp,n)
        temp.insert(0,temp.pop())
    return out 
    
def r2_mul_2nd(a,b,n):
#len(a) = len(b)
    out=[]
    for k in range(0,n):
        out += [0]
        j = k
        for i in range(0,n):
            if j==-1: j = n-1 
            out[k] += a[i]*b[j]
            out[k] &= 1
            j = j-1
    return out
        
def r3_mul(a,b,n):
#len(a) = len(b)
    out=[]
    for k in range(0,n):
        out += [0]
        j = k
        for i in range(0,n):
            if j==-1: j = n-1 
            out[k] += a[i]*b[j]
            out[k] = out[k]%3
            out[k] -= (out[k]>>1)*3
            j = j-1
    return out

def rq_mul(a,b,q,n):
#len(a) = len(b)
    out=[]
    for k in range(0,n):
        out += [0]
        j = k
        for i in range(0,n):
            if j==-1: j = n-1 
            out[k] += a[i]*b[j]
            out[k] %= q
            out[k] -= (out[k]>=(q>>1))*q
            j = j-1
    return out

def sq_mul(a,b,q,n):
    c = a.copy()
    d = b.copy()
    out = rq_mul(c+[0],d+[0],q,n)
    out = sq(out,n,q)
    return out

def s2(m,n):
    out = m.copy()
    k = len(out)
    while k>n:
        out[k-1-n] += out.pop()
        k-=1
    while k<n-1:
        out += [0]
        k+=1
    if k==n:
        for i in range(0,n-1):
            out[i] -= out[n-1]
        out.pop()
    for i in range(0,n-1):
        out[i] &= 1
    return out

def s3(m,n):
    out = m.copy()
    k = len(out)
    while k>n:
        out[k-1-n] += out.pop()
        k-=1
    while k<n-1:
        out += [0]
        k+=1
    if k==n:
        for i in range(0,n-1):
            out[i] -= out[n-1]
        out.pop()
    for i in range(0,n-1):
        out[i] %= 3
        out[i] -= (out[i]>>1)*3
    return out

def sq(m,n,q):
    out = m.copy()
    k = len(out)
    while k>n:
        out[k-1-n] += out.pop()
        k-=1
    while k<n-1:
        out += [0]
        k+=1
    if k==n:
        for i in range(0,n-1):
            out[i] -= out[n-1]
        out.pop()
    for i in range(0,n-1):
        out[i] %= q
        out[i] -= (out[i]>=(q>>1))*q
    return out

def r2(m,n):
    out = m.copy()
    k = len(out)
    while k>n:
        out[k-1-n] += out.pop()
        k-=1
    while k<n:
        out += [0]
        k+=1
    for i in range(0,n):
        out[i] &= 1
    return out
    
def rq(m,n,q):
    out = m.copy()
    k = len(out)
    while k>n:
        out[k-1-n] += out.pop()
        k-=1
    while k<n-1:
        out += [0]
        k+=1
    for i in range(0,n):
        out[i] %= q
        out[i] -= (out[i]>=(q>>1))*q
    return out
    
def check_mod_phi1(a,q):
    suma = 0
    for i in range(0,len(a)):
        suma += a[i]
    if suma%q == 0: return 1
    else: return 0

def int32_MINMAX(a,b):
    a31 = a>>31
    b31 = b>>31
    if a31^b31:
        if a31:
            return a,b
        else: return b,a
    else:
        if a > b: return b,a
        else: return a,b
            
def sort_int32(x,leng):
#constant time sort signed 32-bit integer
    top = 1
    while top < leng:
        top<<=1
    top>>=1
    
    p = top
    while p>=1:
        i = 0
        while (i + (p<<1)) <= leng: 
            for j in range (i,i+p):
                x[j], x[j+p] = int32_MINMAX(x[j], x[j+p])
            i += p<<1
        for j in range(i,leng-p):
            x[j], x[j+p] = int32_MINMAX(x[j], x[j+p])
            
        i,j,q = 0,0,top
        while q > p:
            goto_done = 0
            if j != i:
                while 1:
                    if j == leng - q:
                        goto_done = 1
                        break
                    r = q
                    while r > p:
                        x[j+p], x[j+r] = int32_MINMAX(x[j+p], x[j+r])
                        r >>= 1
                    j += 1
                    if j == i+p: 
                        i += p<<1
                        break
            if goto_done == 0:
                while i + p <= leng - q:
                    for j in range(i,i+p):
                        r = q
                        while r > p:
                            x[j+p], x[j+r] = int32_MINMAX(x[j+p], x[j+r])
                            r >>= 1
                    i += p<<1
                # now i + p > leng - q
                j = i
                while j < leng - q:
                    r = q
                    while r > p:
                        x[j+p], x[j+r] = int32_MINMAX(x[j+p], x[j+r])
                        r >>= 1
                    j += 1
            #done:
            q >>= 1
        p >>= 1
    return 1  