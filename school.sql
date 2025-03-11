CREATE DATABASE school;

USE school;

CREATE TABLE students (
    last_name VARCHAR(50),
    first_name VARCHAR(20),
    school_year INTEGER NOT NULL,
    CONSTRAINT student PRIMARY KEY (last_name, first_name)
);

CREATE TABLE courses (
    title VARCHAR(50) PRIMARY KEY,
    school_year TINYINT NOT NULL,
    duration INTEGER NOT NULL
);

CREATE TABLE enrollements (
    student_last_name VARCHAR(50),
    student_first_name VARCHAR(20),
    course_title VARCHAR(50) REFERENCES courses(title),
    final_grade REAL DEFAULT NULL,

    FOREIGN KEY (student_last_name, student_first_name) REFERENCES students(last_name, first_name)
);