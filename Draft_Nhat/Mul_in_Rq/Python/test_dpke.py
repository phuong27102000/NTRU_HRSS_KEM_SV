import const
import seed_gen
import dpke
import sample
import pack
import unpack
import check

name = 'ntruhrss701'
obj = const.take(name)
seed = seed_gen.bnr(32000,19843)
pprik,ppubk,fail = dpke.key_pair(seed,name)
coin = seed_gen.bnr(32000,24555)
# r,m = sample.rm_HPS(coin,obj.sib,obj.sftb,obj.n,obj.q) #use this for HPS
r,m = sample.rm_HRSS(coin,obj.sib,obj.n) #use this for HRSS
prm = pack.s3(r,obj.n,obj.ps3) + pack.s3(m,obj.n,obj.ps3)
print(len(r))
pciph = dpke.encrypt(ppubk,prm,name)
print('r-before',r)
print('m-before',m)
print("ciphertext: ",pciph)
check.show(pciph)
prm,failed = dpke.decrypt(pprik,pciph,name)
r2 = unpack.s3(prm[0:obj.ps3],obj.n,obj.ps3)
m2 = unpack.s3(prm[obj.ps3:obj.dpla],obj.n,obj.ps3)
print('r-after',r2)
print('m-after',m2)
print(failed,fail)
print(check.same(r,r2))
print(check.same(m,m2))