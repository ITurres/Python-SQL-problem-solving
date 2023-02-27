import sys
import csv
from cs50 import SQL

while True:
    if len(sys.argv) != 2:
        sys.exit("Usage: python prophecy.py* CSV-file*")
    else:
        break

roster2_db = SQL("sqlite:///roster2.db")
students_csv = open(sys.argv[1])
students_csv_reader = csv.DictReader(students_csv)


houses = []


def store_house_and_head(house, head, houses):
    found = False
    for houses_house in houses:
        if houses_house["house"] == house:
            found = True
    if not found:
        houses.append({"house": house, "head": head})


for students_data in students_csv_reader:
    store_house_and_head(students_data["house"], students_data["head"], houses)
    roster2_db.execute(
        "INSERT INTO students (id, student_name) VALUES (?, ?)",
        students_data["id"],
        students_data["student_name"],
    )

for data in houses:
    roster2_db.execute(
        "INSERT INTO houses (house, head) VALUES (?, ?)", data["house"], data["head"]
    )
