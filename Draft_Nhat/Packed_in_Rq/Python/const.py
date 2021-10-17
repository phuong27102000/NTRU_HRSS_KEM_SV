class take(object):
#sftb:  sample_fixed_type_bits
#sib:   sample_iid_bits
#skb:   sample_key_bits   
#spb:   sample_plaintext_bits
#ps3:   packed_s3_bytes
#prq:   packed_rq0_bytes
#psq:   packed_sq_bytes
#dpub:  dpke_public_key_bytes
#dpri:  dpke_private_key_bytes
#dpla:  dpke_plaintext_bytes
#dcip:  dpke_ciphertext_bytes
#kpub:  kem_public_key_bytes
#kpri:  kem_private_key_bytes
#kcip:  kem_ciphertext_bytes
#ksb:   key_seed_bits
    def __init__(self,name):
        if name == 'ntruhps2048509':
            self.meth = 'hps'
            self.n = 509
            self.q = 2048
            self.logq = 11
            self.sftb = 15240
            self.sib = 4064
            self.skb = 19304
            self.spb = 19304
            self.ps3 = 102
            self.prq = 699
            self.psq = 699
            self.dpub = 699
            self.dpri = 903
            self.dpla = 204
            self.dcip = 699
            self.kpub = 699
            self.kpri = 935
            self.kcip = 699
            self.ksb = 19560
        elif name == 'ntruhps2048677':
            self.meth = 'hps'
            self.n = 677
            self.q = 2048
            self.logq = 11
            self.sftb = 20280
            self.sib = 5408
            self.skb = 25688
            self.spb = 25688
            self.ps3 = 136
            self.prq = 930
            self.psq = 930
            self.dpub = 930
            self.dpri = 1202
            self.dpla = 272
            self.dcip = 930
            self.kpub = 930     
            self.kpri = 1234    
            self.kcip = 930     
            self.ksb = 25944    
        elif name == 'ntruhps4096821':
            self.meth = 'hps'
            self.n = 821
            self.q = 4096
            self.logq = 12
            self.sftb = 24630
            self.sib = 6560
            self.skb = 31160
            self.spb = 31160
            self.ps3 = 164
            self.prq = 1230
            self.psq = 1230
            self.dpub = 1230
            self.dpri = 1558
            self.dpla = 328
            self.dcip = 1230
            self.kpub = 1230
            self.kpri = 1590
            self.kcip = 1230
            self.ksb = 31416
        elif name == 'ntruhrss701':
            self.meth = 'hrss'
            self.n = 701
            self.q = 8192
            self.logq = 13
            self.sib = 5600
            self.skb = 11200
            self.spb = 11200
            self.ps3 = 140
            self.prq = 1138
            self.psq = 1138
            self.dpub = 1138
            self.dpri = 1418
            self.dpla = 280
            self.dcip = 1138
            self.kpub = 1138
            self.kpri = 1450
            self.kcip = 1138
            self.ksb = 11456
        self.ksha = 256
        self.prfb = 256
        
