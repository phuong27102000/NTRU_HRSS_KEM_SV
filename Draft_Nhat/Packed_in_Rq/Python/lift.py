import poly
import inverse

def HPS(m,n):
    return poly.s3(m,n)

def HRSS(m,n):
    v = poly.s3(m,n)+[0]
    phi1 = [-1,1]
    phi1 += poly.zeros_gen(n-3)
    z,check = inverse.s3(phi1,n)
    if check != 0:
        return 0
    z += [0]
    z.reverse()
    a = poly.zeros_gen(n)
    for i in range(0,3):
        z.insert(0,z.pop())
        for j in range(0,n-1):
            a[i] += z[j]*v[j]
    for i in range(3,n):
        a[i] = a[i-3] - v[i] - v[i-1] - v[i-2]
    a = poly.s3(a,n)
    b = poly.zeros_gen(n)
    b[0] = -a[0]
    b[n-1] = a[n-2]
    for i in range(1,n-1):
        b[i] = a[i-1]-a[i]
    return b
    
def HRSS_ref(m,n):
    b = poly.zeros_gen(n)
    r = poly.zeros_gen(n)
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
    b = poly.s3(b,n) + [0]
    r[0] = -b[0]
    for i in range (0,n-1):
        r[i+1] = b[i] - b[i+1]
    return r