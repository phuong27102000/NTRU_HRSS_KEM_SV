import bit_handle
map = {0: [0,0], 1: [0,1], -1: [1,1]}
v = [-1, 1, 0, 1, -1]
inp = []
for i in v:
    inp += map.get(i)
inp = int.from_bytes( bit_handle.arr_to_str(inp), "big")
# print(inp)
a = "7D9638A863B4DD4FBE5B3D7EBD3EDC9F0138370ADFF1DCC7AD1CCA9177EA30C49198EC3F5F496749D40C553D0C25AA2F73754A078E48C0927AC303E6146244F0E3599719070873DCA2AE993B34AD404D0A65722E88C2728FB4347ACA1DE2B2CB090462C5B02FBEA9302506176FC99C20C3C15D442C5B4FAE9F05511A44E0277A54F26C15247D242F1F9934A7BCD08BA93303C44FCFDF757E1842795C4F9BCD263EC7EEB9AFA56E089D68143AC3387D5C158159B1EF3D5ED3908FD9DF779A1DC4E325E8A6DC2ED97529DE4DAF116184AD498EE3BFD17194E70D82C1C8DF9797083B77D0E82F39A8E1496B951058E0773133A30F23AE521C90610839E98A83AEA506751A8E85EF8929BA4B34A2ECB98B46"
print(len(a))
