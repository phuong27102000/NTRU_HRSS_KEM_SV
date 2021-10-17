# import poly
# import inverse
# import seed_gen
# import lift
# import pack
# import unpack
# import sample
# import const
# import dpke
# import check
# import hashes
# import math_
# import math

# n = 701

# inp = seed_gen.trnr(n-1,5,4)
# out,check = inverse.s3(inp,n)
# if check == 0:
    # print(inp,out)
    # print('check:',poly.r3_mul(inp+[0],out+[0],n))

# inp = seed_gen.bnr(n-1,500)
# out = inverse.s2(inp,n)
# print(inp,out)
# print('check:',poly.r2_mul(inp+[0],out+[0],n))

# out = inverse.sq(inp,n,5,32)
# print(inp,out)
# print('check:',poly.rq_mul(inp+[0],out+[0],32,n))

# m = [12,23,34,54,23,12,54,1,34,54,65,23,0]
# out = lift.HRSS(m,13)
# print(lift.HPS(m,13))
# print(out)
# print(poly.s3(out,13))


# a = [1,2,3,4,5,6,7,8,567,-12,-24,-23,-23,43,-54,34,7,46,65,85,85,12,31,-875]
# print(len(a))
# c = pack.rq0(a,17,32,5)
# print(c)
# print('a =',unpack.rq0(c,17,32,5))
# a = [1,2,3,4,5,6,7,8,567,-12,-24,-23,-23,43,-54,34,7,46,65,85,85,12,31]
# c = pack.sq(a,17,32,5)
# print(c)
# print('a =',unpack.sq(c,17,32,5))
# c = pack.s3(a,17,6)
# print(c)
# print('a =',unpack.s3(c,17,6))
# print((1*1>1)*3)
# n = 89
# sib = 8*n - 8
# sftb = 30*(n-1)
# q = 512
# inp = seed_gen.bnr(sib,50)
# print(inp)
# print(sample.ter(inp,sib,n))
# print(sample.ter_plus(inp,sib,n))
# inp = seed_gen.bnr(sftb,500)
# print(inp)
# a = sample.fixed_type(inp,sftb,n,q)
# print(a)
# x=0
# for i in range(0,len(a)):
    # x += a[i]
# print(x)
# inp = seed_gen.bnr(sftb+sib,150)
# print(inp)
# print(sample.fg_HPS(inp,sib,sftb,n,q))
# print(sample.rm_HPS(inp,sib,sftb,n,q))
# inp = seed_gen.bnr(2*sib,100)
# print(inp)
# print(sample.fg_HRSS(inp,sib,n))
# print(sample.rm_HRSS(inp,sib,n))


# a = 31
# b = 16
# ab = b ^ a
# c = b - a
# c ^= ab & (c ^ b)
# c >>= 31
# c &= ab
# a ^= c
# b ^= c
# print(a,b)

# i = const.take("ntruhps2048509")
# print(i.meth)
# for i in range(0,32):
    # a = i%32
    # a -= (a>=(32>>1))*32
    # print(a)

# # name = 'ntruhps2048677'
# # obj = const.take(name)
# # seed = seed_gen.bnr(26000,19843)
# # f,fp,h,hq,g,fail = dpke.key_pair(seed[0:],name)
# # coin = seed_gen.bnr(26000,18475)
# # r,m = sample.rm_HPS(coin,obj.sib,obj.sftb,obj.n,obj.q)
# # c = dpke.encrypt(h,r,m,name)
# # print(c)
# # print('r-before',r)
# # print('m-before',m)
# # hq2 = hq.copy()
# # r2,m2,failed = dpke.decrypt(f,fp,hq,c,name)
# # print('r-after',r2)
# # print('m-after',m2)
# # print(f)
# # print(fp)
# # print(h)
# # print(hq)
# # print(fail)
# # print(poly.sq_mul(h,hq,obj.q,obj.n))
# # print('check:',poly.r3_mul(f+[0],fp+[0],obj.n))
# # print(g)
# # print(poly.rq_mul(f+[0],h,obj.q,obj.n))
# # print(check.same(r,r2))
# # print(check.same(m,m2))

# # # name = 'ntruhrss701'
# # # obj = const.take(name)
# # # seed = seed_gen.bnr(32000,19843)
# # # pprik,ppubk,fail = dpke.key_pair(seed,name)
# # # coin = seed_gen.bnr(32000,24555)
# # # # r,m = sample.rm_HPS(coin,obj.sib,obj.sftb,obj.n,obj.q) #use this for HPS
# # # r,m = sample.rm_HRSS(coin,obj.sib,obj.n) #use this for HRSS
# # # prm = pack.s3(r,obj.n,obj.ps3) + pack.s3(m,obj.n,obj.ps3)
# # # pciph = dpke.encrypt(ppubk,prm,name)
# # # print('r-before',r)
# # # print('m-before',m)
# # # print("ciphertext: ",pciph)
# # # prm,failed = dpke.decrypt(pprik,pciph,name)
# # # r2 = unpack.s3(prm[0:obj.ps3],obj.n,obj.ps3)
# # # m2 = unpack.s3(prm[obj.ps3:obj.dpla],obj.n,obj.ps3)
# # # print('r-after',r2)
# # # print('m-after',m2)
# # # print(failed,fail)
# # # print(check.same(r,r2))
# # # print(check.same(m,m2))

# seed = [1, 1, 0, 0, 1, 0, 1, 0, 0, 0, 0, 1, 1, 0, 1, 0, 1, 1, 0, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 0]
# print(seed)
# a = hashes.sha3_256(seed)
# print(a)
# check.show(pack.bi2by(a))

# seed = []
# message = "phuong"
# res = ''.join(format(ord(i), '08b')[::-1] for i in message)
# for i in res:
    # seed.append(int(i))
# print(seed)
# ciph = hashes.sha3_256(seed)
# print(seed)
# check.show(pack.bi2by(ciph))

# n = int('0b1101000', 2)
# print(n)
# b = n.to_bytes((n.bit_length() + 7) // 8, 'big').decode()
# print(b)

# name = 'ntruhps2048677'
# obj = const.take(name)
# print((obj.n)-1)
# out = math_.combination(obj.n-1,(obj.q>>4)-1)
# out2 = math_.combination(obj.n-(obj.q>>4),(obj.q>>4)-1)
# print(math.log2(out)+math.log2(out2))
# print(math_.combination(20,12))

# print(len('Shared key after decrypt'))

# import poly
# print(poly.int32_MINMAX(3053453200,3061048392))
# x = 2
# i = 0
# i+= x<<1
# print(i)