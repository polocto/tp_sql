CREATE DATABASE school;

USE school;

CREATE TABLE students (
    id VARCHAR(50) PRIMARY KEY,
    last_name VARCHAR(50),
    first_name VARCHAR(20),
    school_year INTEGER NOT NULL
);

CREATE TABLE courses (
    id VARCHAR(50) PRIMARY KEY,
    title VARCHAR(50),
    school_year TINYINT NOT NULL,
    duration INTEGER NOT NULL,
    CONSTRAINT course UNIQUE (title, school_year)
);

CREATE TABLE enrollements (
    student_id VARCHAR(50) REFERENCES students(id)
    course_id VARCHAR(50) REFERENCES courses(id),
    final_grade REAL DEFAULT NULL
);