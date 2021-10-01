import bit_handle as bit
from sample import ter

def ter_model(bit_str):
    b = bit.str_to_arr(bit_str)
    b.reverse()
    v = ter(b,5600,701)
    v.reverse()
    x = []
    for a_num in v:
        if a_num == -1: x += [1,1]
        elif a_num == 0: x += [0,0]
        elif a_num == 1: x += [0,1]
        else: raise("The model has some problem!")
    out = bit.arr_to_str(x)
    return int.from_bytes(out, "big")