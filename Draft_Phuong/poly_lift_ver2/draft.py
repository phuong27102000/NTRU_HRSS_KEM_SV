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
list = [ [0,0], [0,1], [1,1] ]
temp = []
for i in range(701):
    temp += list[i%3]
for i in range(1402):
    print(temp[i],end="")
print("\n")
