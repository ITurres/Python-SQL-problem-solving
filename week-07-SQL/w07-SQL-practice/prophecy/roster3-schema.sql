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
    id INTEGER NOT NULL,
    student_name TEXT,
    house TEXT,
    PRIMARY KEY(id)
);