# TODO
import sys
import csv
import cs50

if len(sys.argv) != 2:
    print("ERROR")
    exit(1)

db = cs50.SQL("sqlite:///students.db")
count = 0
with open(sys.argv[1]) as csvfile:
    reader = csv.DictReader(csvfile)
    for row in reader:
        # print(row['name'])
        name = row['name'].split(" ")

        # print(len(name))
        if len(name) == 2:
            name.insert(1, "NULL")
        # print(name)
        count += 1
        db.execute("INSERT INTO students (id, first, middle, last, house, birth) VALUES(?, ?, ?, ?, ?, ?)",
                   count, name[0], name[1], name[2], row["house"], row["birth"])
