# TODO
import sys
import cs50

if len(sys.argv) != 2:
    print("ERROR")
    exit(1)

db = cs50.SQL("sqlite:///students.db")
home = (sys.argv[1]).capitalize()

# selects students from database
test = db.execute("SELECT first, middle, last, birth from students WHERE house = ? ORDER BY last, first", home)
# prints student info
for row in test:
    print(row["first"], end=" ")
    if row["middle"] != "NULL":
        print(row["middle"], end=" ")
    print(row["last"], end=", ")
    print(f"born {row['birth']}")