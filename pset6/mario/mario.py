from cs50 import get_int

num = get_int("Height: ")
while (num > 8 or num < 1):
    num = get_int("Height: ")

n = num - (num - 1)
m = num - n

for i in range(num):

    # for j in range(m):
    #     print(" ", end = "")

    # for k in range(n):
    #     print("#", end = "")
    # # print()

    # for l in range(1):
    #     print("  ", end = "")
    for o in range(n):
        print("#", end = "")
    print()

    n+=1
    m-=1




