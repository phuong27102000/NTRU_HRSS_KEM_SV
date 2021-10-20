def same(a,b):
    if len(a) != len(b): return 0,0
    out = []
    for i in range(0,len(a)):
        if a[i] != b[i]: out += [i]
    if len(out) == 0: return 1,0
    else: return 0,out
    
def show(m):
    text =''
    i = 0
    while i < len(m):
        for j in range (0,64):
            text += convert(m[i][0:4])
            text += convert(m[i][4:8])
            text += ' '
            i+=1
            if i == len(m): break
        text += "\n"
    return text

def convert(x):
    pow2 = 8
    sumx = 0
    for i in range (0,4):
        sumx += x[i]*pow2
        pow2>>=1
    switcher = {0:'0',1:'1',2:'2',3:'3',4:'4',5:'5',6:'6',7:'7',8:'8',9:'9',10:'A',11:'B',12:'C',13:'D',14:'E',15:'F'}
    return switcher.get(sumx)
    
def reconvert(m):
    out = []
    i = 0
    while i < len(m):
        x = back(m[i])
        i += 1
        if x == None: continue
        else:
            y = back(m[i])
            if y == None: out += [4*[0]+x]
            else: out += [x+y]  
        i += 1
    return out

def back(m):
    switcher = {'0':0,'1':1,'2':2,'3':3,'4':4,'5':5,'6':6,'7':7,'8':8,'9':9,'A':10,'B':11,'C':12,'D':13,'E':14,'F':15}
    sumx = switcher.get(m)
    if sumx == None: return None
    pow2 = 8
    x = []
    for i in range (0,4):
        if sumx >= pow2: 
            x.append(1)
            sumx -= pow2
        else: x.append(0)
        pow2>>=1
    return x