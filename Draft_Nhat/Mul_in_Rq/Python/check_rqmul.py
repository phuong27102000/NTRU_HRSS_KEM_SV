import poly
import sample

a=[-1,0,1]
b=[1,2,-1]
q=8192
n=3
out=poly.rq_mul(a,b,q,n)
print(out)
print(sample.arr_to_str_integer(b))
print(sample.arr_to_str_ternary(a))
