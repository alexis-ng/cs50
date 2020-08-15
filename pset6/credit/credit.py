from cs50 import get_int
from cs50 import get_string

credit = get_string("Number: ")
num = len(credit)
total = 0

for i in range(num):
    if(num % 2 == 0):
        if(i % 2 == 0):
            product = int(credit[i]) * 2
            # print(f"Credit: {credit[i]}")
            # print(f"Product: {product}")
            if(product > 9):
                new = list(str(product))
                for j in range(len(new)):
                    total += int(new[j])
            #   total+=new
            if(product < 10):
                total += product
            # print(f"Total: {total}")
            # print()
    else:
        if(i % 2 == 1):
            product = int(credit[i]) * 2
            # print(f"Credit: {credit[i]}")
            # print(f"Product: {product}")
            if(product > 9):
                new = list(str(product))
                for j in range(len(new)):
                    total += int(new[j])
            #   total+=new
            if(product < 10):
                total += product
            # print(f"Total: {total}")
            # print()

for j in range(num):
    if(num % 2 == 0):
        if(j % 2 == 1):
            odd = int(credit[j])
            total += odd
            # print(f"Odd: {odd}")
            # print(f"Total: {total}")
            # print()
    else:
        if(j % 2 == 0):
            even = int(credit[j])
            total += even
            # print(f"Odd: {odd}")
            # print(f"Total: {total}")
            # print()


if(total % 10 == 0):
    # print(credit[:2])
    if(int(credit[0]) == 4):
        print("VISA")
    if(int(credit[:2]) >= 51 and int(credit[:2]) <= 55):
        print("MASTERCARD")
    if(int(credit[:2]) == 34 or int(credit[:2]) == 37):
        print("AMEX")
else:
    print("INVALID")
