import random
#---------------------------------CREATE RANDOM BINARY POLYNOMIAL
def bnr(N,d):
    out=[]
    for k in range(0,N):
        out += [0]
    k = d
    leftovers = [i for i in range(0,N)]
    while k>0:
        j = random.choice(leftovers)
        out[j] = 1
        k -= 1
        leftovers.remove(j)
    return out 
    
#---------------------------------CREATE RANDOM TRINARY POLYNOMIAL
def trnr(N,d_pos,d_neg):
    out=[]
    for k in range(0,N):
        out += [0]
    k = d_pos
    leftovers = [i for i in range(0,N)]
    while k>0:
        j = random.choice(leftovers)
        out[j] = 1
        k -= 1
        leftovers.remove(j)
    k = d_neg
    while k>0:
        j = random.choice(leftovers)
        out[j] = -1
        k -= 1
        leftovers.remove(j)
    return out                  
