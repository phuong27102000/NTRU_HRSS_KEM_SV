def shake_256(m,d):
# m is bit string
# d is length of output
    out = sponge(m+[1,1,1,1],256)
    return out
    
def sha3_256(m):
# m is bit string
# 256 is length of output
    out = sponge(m+[0,1],256)
    return out

def sponge(n_cap,d):
#b = 1600, nr = 24, r = 1600-512 = 1088
    b,nr,r = 1600,24,1088
    p = n_cap + pad(r,len(n_cap))
    n = len(p)//r
    s = b*[0]
    x = 0
    for i in range (0,n):
        temp = s.copy()
        for j in range (0,r):
            temp[j] = s[j] ^ p[x]
            x += 1
        s = keccak_p(temp)
    z = s[0:r].copy()
    while len(z)<d:
        s = keccak_p(s)
        z += s[0:r].copy()
    return z[0:d]
    
def pad(x,m):
    j = (-m-2)%x
    p = [1]+j*[0]+[1]
    return p
    
def keccak_p(s):
#b (len of s) = 1600, nr = 24, w = 64, l = 6
    w,l,nr = 64,6,24
    a = str_to_st_arr(s,w)
    begin = 12+2*l-nr
    end = 12+2*l
    for i in range (begin,end):
        a = rnd(a,i,w)
    out = st_arr_to_str(a,w)
    return out

def str_to_st_arr(s,w):
    state = arr_3d_gen(5,5,w)
    j = 0
    for y in range (0,5):
        for x in range (0,5):
            for z in range(0,w):
                state[x][y][z] = s[j]
                j+=1
    return state    

def st_arr_to_str(a,w):
    s = []
    for y in range (0,5):
        for x in range (0,5):
            for z in range(0,w):
                s += [a[x][y][z]]
    return s 

def rnd(a,ir,w):
    tht = theta(a,w)
    rh = rho(tht,w)
    p = pi(rh,w)
    ch = chi(p,w)
    iot = iota(ch,ir,w)
    return iot

def theta(a,w):
    c = arr_2d_gen(5,w)
    d = arr_2d_gen(5,w)
    out = arr_3d_gen(5,5,w)
    for x in range (0,5):
        for z in range (0,w):
            c[x][z] = a[x][0][z] ^ a[x][1][z] ^ a[x][2][z] ^ a[x][3][z] ^ a[x][4][z]
    for x in range (0,5):
        for z in range (0,w):
            m = (x-1)%5
            n = (x+1)%5
            p = (z-1)%w
            d[x][z] = c[m][z] ^ c[n][p]
    for x in range (0,5):
        for y in range (0,5):
            for z in range(0,w):
                out[x][y][z] = a[x][y][z] ^ d[x][z]
    return out

def rho(a,w):
    out = arr_3d_gen(5,5,w)
    for z in range (0,w):
        out[0][0][z] = a[0][0][z]
    x,y = 1,0
    for t in range(0,24):
        for z in range (0,w):
            m = (z - ((t+1)*(t+2))//2)%w
            out[x][y][z] = a[x][y][m]
        x,y = y,((2*x+3*y)%5)
    return out

def pi(a,w):
    out = arr_3d_gen(5,5,w)
    for x in range (0,5):
        for y in range (0,5):
            for z in range(0,w):
                m = (x+3*y)%5
                out[x][y][z] = a[m][x][z]
    return out

def chi(a,w):
    out = arr_3d_gen(5,5,w)
    for x in range (0,5):
        for y in range (0,5):
            for z in range(0,w):
                m = (x+1)%5
                n = (x+2)%5
                out[x][y][z] = a[x][y][z] ^ ( (~a[m][y][z]) & a[n][y][z] )
    return out

def rc(t):
    t1 = t%255
    if t1==0: return 1
    r = [1,0,0,0,0,0,0,0]
    for i in range (0,t1):
        r.insert(0,0)
        r[0] ^= r[8]
        r[4] ^= r[8]
        r[5] ^= r[8]
        r[6] ^= r[8]
        r.pop()
    return r[0]

def iota(a,ir,w):
    out = a.copy()
    rc_arr = w*[0]
    j = 0
    pow2j = 1
    while pow2j <= w:
        rc_arr[pow2j-1] = rc(j+7*ir)
        j += 1
        pow2j <<= 1
    for z in range (0,w):
        out[0][0][z] ^= rc_arr[z]
    return out   

def arr_2d_gen(x,y):
    plane = []
    for a in range (0,x):
        lane = []
        for b in range(0,y):
            lane += [0]
        plane += [lane]
    return plane

def arr_3d_gen(x,y,z):
    state = []
    for a in range (0,x):
        sheet = []
        for b in range (0,y):
            lane = []
            for c in range(0,z):
                lane += [0]
            sheet += [lane]
        state += [sheet]
    return state
