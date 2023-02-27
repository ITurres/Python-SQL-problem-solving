CREATE TABLE students (
    id INTEGER NOT NULL,
    student_name TEXT,
    PRIMARY KEY(id)
);

CREATE TABLE houses (
    id INTEGER NOT NULL,
    house TEXT,
    head TEXT,
    PRIMARY KEY(id)
);

CREATE TABLE house_assignments (
    student_id INTEGER NOT NULL,
    house_id INTEGER NOT NULL,
    FOREIGN KEY(student_id) REFERENCES students(id),
    FOREIGN KEY(house_id) REFERENCES houses(id),
    PRIMARY KEY(student_id, house_id)
);
