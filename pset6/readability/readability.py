from cs50 import get_string
# import math

text = get_string("Text: ")

letter = 0
word = 1
sent = 0

for i in range(len(text)):
    # checks for letters
    if(text[i].isalpha()):
        letter += 1

    # checks for words
    if(text[i] == " "):
        word += 1

    # checks for sentences
    if(text[i] == "." or text[i] == "!" or text[i] == "?"):
        sent += 1

L = (letter * 100) / word
S = (sent * 100) / word


# determines grade level
index = .0588 * L - 0.296 * S - 15.8
# print(index)

if index < 1:
    print("Before Grade 1")

if index >= 1 and index <= 16:
    print(f"Grade {round(index)}")

if index > 16:
    print("Grade 16+")