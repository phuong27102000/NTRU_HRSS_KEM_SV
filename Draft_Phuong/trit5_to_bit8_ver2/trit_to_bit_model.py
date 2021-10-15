def trit_to_bit_model(v):
    b = 8*[0]
    pow3 = 1
    c = 0
    for j in range(0,5):
        if j<len(v):
            if v[j] < 0: v[j] += 3
            c += v[j]*pow3
            pow3 *= 3
    k = list(bin(c)[2:])
    k.reverse()
    for j in range(0,8):
        if j < len(k):
            b[j] = int(k[j])
        else:
            b[j] = 0
    b.reverse()
    return b