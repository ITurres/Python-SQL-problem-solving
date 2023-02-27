import sys
import csv
from cs50 import SQL

while True:
    if len(sys.argv) != 2:
        sys.exit("Usage: python prophecy.py* CSV-file*")
    else:
        break

roster3_db = SQL("sqlite:///roster3.db")
students_csv = open(sys.argv[1])
students_csv_reader = csv.DictReader(students_csv)


houses = []
house_assignments = []


def store_house_and_head(house, head, houses):
    found = False
    for houses_house in houses:
        if houses_house["house"] == house:
            found = True
    if not found:
        houses.append({"house": house, "head": head})


def store_house_assignments(name, house, house_assignments):
    house_assignments.append({"student_name": name, "house": house})


for students_data in students_csv_reader:
    store_house_and_head(students_data["house"], students_data["head"], houses)
    store_house_assignments(
        students_data["student_name"], students_data["house"], house_assignments
    )
    roster3_db.execute(
        "INSERT INTO students (id, student_name) VALUES (?, ?)",
        students_data["id"],
        students_data["student_name"],
    )

for assingment in house_assignments:
    roster3_db.execute(
        "INSERT INTO house_assignments (student_name, house) VALUES (?, ?)",
        assingment["student_name"],
        assingment["house"],
    )

for data in houses:
    roster3_db.execute(
        "INSERT INTO houses (house, head) VALUES (?, ?)", data["house"], data["head"]
    )
