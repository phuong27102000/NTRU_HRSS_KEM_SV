import tkinter

import sample
import inverse
import const
import poly
import pack
import unpack
import lift

def key_pair(seed,name):
#length of seed = skb
    obj = const.take(name)
    if obj.meth == 'hps':
        f,g = sample.fg_HPS(seed[0:obj.skb],obj.sib,obj.sftb,obj.n,obj.q)
    if obj.meth == 'hrss':
        f,g = sample.fg_HRSS(seed[0:obj.skb],obj.sib,obj.n)
    fp,fail = inverse.s3(f,obj.n)
    h,hq = public_key(f,g,obj.n,obj.q,obj.logq)
    ppubk = pack.rq0(h,obj.n,obj.q,obj.logq)
    pprik = pack.s3(f,obj.n,obj.ps3) + pack.s3(fp,obj.n,obj.ps3) + pack.sq(hq,obj.n,obj.q,obj.logq)
    return pprik,ppubk,fail
    
def public_key(f,g,n,q,logq):
    g_cap = []
    for i in range (0,n):
        g_cap += [3*g[i]]
    v0 = poly.sq_mul(g_cap,f,q,n)
    v1 = inverse.sq(v0,n,logq,q)
    h = poly.rq_mul(poly.rq_mul(v1+[0],g_cap,q,n),g_cap,q,n)
    hq = poly.rq_mul(poly.rq_mul(v1+[0],f+[0],q,n),f+[0],q,n)
    return h,hq
    
def encrypt(ppubk,prm,name):
#length of packed r and m must be ps3 
    obj = const.take(name)
    r = unpack.s3(prm[0:obj.ps3],obj.n,obj.ps3)
    m0 = unpack.s3(prm[obj.ps3:2*obj.ps3],obj.n,obj.ps3)
    if obj.meth == 'hps':
        m1 = lift.HPS(m0,obj.n)
        m1 += [0]
    if obj.meth == 'hrss':
        m1 = lift.HRSS(m0,obj.n)
    h = unpack.rq0(ppubk,obj.n,obj.q,obj.logq)
    c = poly.rq_mul(r+[0],h,obj.q,obj.n)
    h1= sample.arr_to_str_integer(h)
    r1= sample.arr_to_str_ternary(r)
    c1=sample.arr_to_str_integer(c)
    m2=sample.arr_to_str_integer(m1)
    print('h1 ',h1)
    print('r1 ',r1)
    print('c1 ',c1)
    print('m2 ',m2)

    for i in range (0,obj.n):
        c[i] += m1[i]
    c = poly.rq(c,obj.n,obj.q)
    c2=sample.arr_to_str_integer(c)
    print('c2 ',c2)
    pciph = pack.rq0(c,obj.n,obj.q,obj.logq)
    out=sample.arr_to_str_integer_packver(pciph)
    print('out ',out)
    line=["c1",str(c1),"m2",str(m2),"c2",str(c2),"out",str(out)]
    with open('readme.txt', 'w') as f:
        for l in line:
            f.write(l)
            f.write('\n')
            f.write('\n')

    return pciph
    
def decrypt(pprik,pciph,name):
    obj = const.take(name)
    c = unpack.rq0(pciph,obj.n,obj.q,obj.logq)
    f = unpack.s3(pprik[0:obj.ps3],obj.n,obj.ps3)
    fp = unpack.s3(pprik[obj.ps3:obj.dpla],obj.n,obj.ps3)
    hq = unpack.sq(pprik[2*obj.ps3:2*obj.ps3+obj.dpri],obj.n,obj.q,obj.logq)
    v1 = poly.rq_mul(c,f+[0],obj.q,obj.n)
    m0 = poly.r3_mul(v1,fp+[0],obj.n)
    m0 = poly.s3(m0,obj.n)
    if obj.meth == 'hps':
        m1 = lift.HPS(m0,obj.n)
        m1 += [0]
    if obj.meth == 'hrss':
        m1 = lift.HRSS(m0,obj.n)
    for i in range (0,obj.n):
        c[i] -= m1[i]
    r = poly.sq_mul(c,hq,obj.q,obj.n)
    prm = pack.s3(r,obj.n,obj.ps3) + pack.s3(m0,obj.n,obj.ps3)
    # rtemp = poly.s3(r,obj.n)
    # mtemp = poly.s3(m0,obj.n)
#check r m and return fail
    if 1: fail = 0
    else: fail = 1
    return prm,fail