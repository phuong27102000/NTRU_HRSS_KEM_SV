a=5
b = format(a & 0x1fff, '13b')
i=0
b1=''
while i<len(b):
    if b[i]==' ':
        b1=b1+'0'
    else:
        b1=b1+b[i]
    i=i+1

print(b1)