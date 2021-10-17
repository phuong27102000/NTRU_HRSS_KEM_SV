import dpke
import pack
import unpack
import hashes
import const
import sample

def key_pair(seed,name):
#length of seed = ksb
    obj = const.take(name)
    pdprik,ppubk,fail = dpke.key_pair(seed[0:obj.skb],name)
    pprik = pdprik + pack.bi2by(seed[obj.skb:obj.ksb])
    return pprik,ppubk,fail
    
def encaps(coins,ppubk,name):
    obj = const.take(name)
    if obj.meth == 'hps':
        r,m = sample.rm_HPS(coins,obj.sib,obj.sftb,obj.n,obj.q)       
    if obj.meth == 'hrss':
        r,m = sample.rm_HRSS(coins,obj.sib,obj.n)
    prm = pack.s3(r,obj.n,obj.ps3) + pack.s3(m,obj.n,obj.ps3)
    prm_bi = unpack.by2bi(prm,8*obj.dpla)
    shak = hashes.sha3_256(prm_bi)
    pciph = dpke.encrypt(ppubk,prm,name)
    return prm,pciph,shak

def decaps(pprik,pciph,name):
    obj = const.take(name)
    prm,fail = dpke.decrypt(pprik[0:obj.dpri],pciph,name)
    prm_bi = unpack.by2bi(prm,8*obj.dpla)
    shak = hashes.sha3_256(prm_bi)
    random = unpack.by2bi(pprik[obj.dpri:obj.kpri],obj.prfb) + unpack.by2bi(pciph,8*obj.kcip)
    rank = hashes.sha3_256(random)
    if fail == 0: return shak,fail
    else: return rank,fail