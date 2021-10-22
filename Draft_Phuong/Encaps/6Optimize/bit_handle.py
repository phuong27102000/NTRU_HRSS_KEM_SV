def str_to_arr(bit_str):
    byte_arr = bytearray(bit_str)
    bit_arr = []
    for by in byte_arr:
        temp = []
        threshold = 128
        for i in range(8):
            if by < threshold:
                temp += [0]
            else:
                temp += [1]
                by -= threshold
            threshold >>= 1
        bit_arr += temp
    return bit_arr

def arr_to_str(bit_arr):
    while (len(bit_arr) & 7) != 0:
        bit_arr.insert(0,0)
    pow2 = 128
    temp = 0
    byte_arr = []
    for bi in bit_arr:
        if bi:
            temp += pow2
        if pow2 == 1: #reset
            byte_arr += [temp]
            pow2 = 128
            temp = 0
        else:
            pow2 >>= 1
    bit_str = bytes(byte_arr)
    return bit_str
