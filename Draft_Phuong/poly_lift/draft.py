def binit_r(x):
    leng = 13
    if (x<0):
        y = x + 8
    else:
        y = x
    str = bin(y)[2:]
    while len(str) < 3:
        str = '0' + str
    while len(str) < leng:
        if x<0:
            str = '1' + str
        else:
            str = '0' + str
    while len(str) > leng:
        str = str[1:]
    return str
for i in range(-7,8):
    print(binit_r(i))
