import hashes
import pack
import check

seed = []
message = "phuong nguyen ha nhat"
res = ''.join(format(ord(i), '08b')[::-1] for i in message)
for i in res:
    seed.append(int(i))
print(seed)
ciph = hashes.sha3_256(seed)
print(ciph)
check.show(pack.bi2by(ciph))