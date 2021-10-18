import bit_handle
map = {0: [0,0], 1: [0,1], -1: [1,1]}
v = [-1, 1, 0, 1, -1]
inp = []
for i in v:
    inp += map.get(i)
inp = int.from_bytes( bit_handle.arr_to_str(inp), "big")
print(inp)
