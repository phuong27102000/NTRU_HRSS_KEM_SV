x,y = 1,0
for t in range(0,24):
    m = ((t+1)*(t+2))//2
    print("//t = %d. 320*y + 64*x,m = %d,%d" % (t,320*y + 64*x,m))
    print("for (z = 0; z < 64; z = z+1) begin: loop1\nassign out[%d + z] = a[%d + ( (z - %d) & 63 ) ];\nend" % (320*y + 64*x,320*y + 64*x,m))
    x,y = y,((2*x+3*y)%5)
