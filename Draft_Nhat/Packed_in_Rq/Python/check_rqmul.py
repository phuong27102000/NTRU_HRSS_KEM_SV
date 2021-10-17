import poly
import sample
import pack
a=[-1,0,1,0,1]
b=[-1,2,-1]
q=8192
n=3

k=pack.rq0(b,n,q,13)
print(k)
print(len(b))

k= [[0, 1, 1, 0, 0, 0, 1, 1], [1, 0, 1, 1, 0, 0, 1, 1], [1, 0, 1, 1, 0, 1, 1, 0]]
print(sample.arr_to_str_integer_packver(k))