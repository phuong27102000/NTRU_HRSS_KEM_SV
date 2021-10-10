import bit_handle as bh
def xor(b,a):
    y = a.copy()
    x = b.copy()
    for i in b:
        try:
            y.index(i)
            x.remove(i)
            y.remove(i)
        except:
            continue
    try:
        return x + y
    except:
        return x

reg = []
stage = 168
itg = []
for i in range(8):
    reg.append([i])
for i in range(stage):
    print("At stage %d, it is a concatenation of xor: " % i, reg)
    itg.clear()
    for k in reg:
        try:
            k.index(0)
            itg += [1]
        except:
            itg += [0]
    itg.reverse()
    n = int.from_bytes(bh.arr_to_str(itg),"big")
    print("\nwhich is: ",n)
    print("___________________________________________________________")
    a = reg.pop()
    reg.insert(0,a)
    reg[4] = xor(reg[4],a)
    reg[5] = xor(reg[5],a)
    reg[6] = xor(reg[6],a)
print("At stage %d, it is a concatenation of xor: " % stage, reg)
