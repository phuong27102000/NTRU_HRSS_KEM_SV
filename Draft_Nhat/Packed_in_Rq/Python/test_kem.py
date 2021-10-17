import const 
import kem
import seed_gen
import check
import pack
import unpack
import sys

name = sys.argv[1]
obj = const.take(name)

inp = open(sys.argv[2],'r')
text = inp.read()

seed_ref = "" 
coins_ref = ""

print("Loading...")
i = 0
while i < len(text):
    if text[i:i+4] == "Seed":
        i+=6
        while text[i] != '_':
            seed_ref += text[i]
            i+=1
    if text[i:i+5] == "Coins":
        i+=7
        while text[i] != '_':
            coins_ref += text[i]
            i+=1
        break    
    i+=1
# seed = seed_gen.bnr(obj.ksb,10000)
# coins = seed_gen.bnr(obj.skb,10000)
seed = unpack.by2bi(check.reconvert(seed_ref),obj.ksb)
coins = unpack.by2bi(check.reconvert(coins_ref),obj.skb)

pprik,ppubk,fail1 = kem.key_pair(seed,name)
prm,pciph,key_enc = kem.encaps(coins,ppubk,name)
key_dec,fail2 = kem.decaps(pprik,pciph,name)

if fail1|fail2:
    print("Fail")
else:
    file = open(sys.argv[3],'w')
    file.write("-------------------------------")
    file.write(name)
    file.write("-------------------------------\n")
    file.write("Seed:\n")
    file.write(check.show(pack.bi2by(seed)))
    file.write("______________________________________________________________________________________________________________________________________________________________________________________________\n")
    file.write("\nCoins:\n")
    file.write(check.show(pack.bi2by(coins)))
    file.write("______________________________________________________________________________________________________________________________________________________________________________________________\n")
    file.write("\nrm:\n")
    file.write(check.show(prm))
    file.write("______________________________________________________________________________________________________________________________________________________________________________________________\n")
    file.write("\nPublic key:\n")
    file.write(check.show(ppubk))
    file.write("______________________________________________________________________________________________________________________________________________________________________________________________\n")
    file.write("\nSecret key:\n")
    file.write(check.show(pprik))
    file.write("______________________________________________________________________________________________________________________________________________________________________________________________\n")
    file.write("\nCiphertext:\n")
    file.write(check.show(pciph))
    file.write("______________________________________________________________________________________________________________________________________________________________________________________________\n")
    file.write("\nShared key after encrypt:\n")
    file.write(check.show(pack.bi2by(key_enc)))
    file.write("______________________________________________________________________________________________________________________________________________________________________________________________\n")
    file.write("\nShared key after decrypt:\n")
    file.write(check.show(pack.bi2by(key_dec)))
inp.close()
file.close()
print("Done!!!")
