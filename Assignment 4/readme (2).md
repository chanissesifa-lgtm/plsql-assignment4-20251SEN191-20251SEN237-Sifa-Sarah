# Student Registration & Grading System – Oracle PL/SQL

|  |  | 
| ----- | ----- | 
| **Course** | Database Development with PL/SQL (INSY 8311) | 
| **Instructor** | Eric Maniraguha | 
| **Teaching Assistant** | Afanyu Emmanuel | 
| **Group Assignment** | IV | 

## 1. Group Members

| Full Name | Student ID | Contributions | 
| ----- | ----- | ----- | 
| Sifa Sonia Chanisse | 20251SEN191 | Schema creation, `register_student` procedure, and documentation | 
| Kabanyana Sarah | 20251SEN237 | `bulk_update_grades` procedure, `calculate_student_gpa` function, and test suites | 

## 2. Application Description

A simple system for registering students in courses and managing their grades. It is built entirely with Oracle PL/SQL stored procedures and functions, and it handles errors in every operation.

### Functional Requirements

* Register a new student.

* Update a student's score/grade in a course.

* Bulk update student grades for a semester.

* Calculate a student's GPA based on credits and grades.

* Custom error and exception handling for duplicate records and non-existent IDs.

## 3. Database Schema

### Tables

| Table | Purpose | 
| ----- | ----- | 
| `students` | Student information | 
| `courses` | Courses offered | 
| `enrollments` | Links students to courses and stores each score/grade | 

### Relationships

```
erDiagram
    STUDENTS ||--o{ ENROLLMENTS : "makes"
    COURSES ||--o{ ENROLLMENTS : "contains"

```

* `students 1 — N enrollments N — 1 courses`

### Key Constraints

* **PRIMARY KEY** on every table (`student_id`, `course_id`, `enrollment_id`).

* **FOREIGN KEY** from `enrollments` to `students` and `courses`.

* **UNIQUE** on `students.email` and on `enrollments (student_id, course_id)`.

* **CHECK**: `credits > 0` and `grade IN ('A', 'B', 'C', 'D', 'F', 'IP')`.

* **NOT NULL** on required columns.

> Full definitions: [`00_schema/01_create_tables.sql`](00_schema/01_create_tables.sql)

## 4. PL/SQL Objects

### Stored Procedures (`01_procedures/`)

| File | Description | Parameters | 
| ----- | ----- | ----- | 
| `register_student.sql` | Inserts a new student and returns the new ID | IN: `p_first_name`, `p_last_name`, `p_email` · OUT: `p_student_id` | 
| `bulk_update_grades.sql` | Updates 'IP' grades for all students in a semester | IN: `p_semester`, `p_new_grade` | 

### Stored Functions (`02_functions/`)

| File | Description | Returns | 
| ----- | ----- | ----- | 
| `calculate_student_gpa.sql` | Calculates a student's GPA | `NUMBER` | 

## 5. Requirements Coverage Map

| Concept | Where It Is Demonstrated | 
| ----- | ----- | 
| Implicit cursor – `INSERT` + `SQL%ROWCOUNT` | `register_student.sql` | 
| Explicit cursor – `OPEN` / `FETCH` / `CLOSE` | `bulk_update_grades.sql` | 
| `BULK COLLECT` | `bulk_update_grades.sql` | 
| `FORALL` + `SAVE EXCEPTIONS` | `bulk_update_grades.sql` | 
| `NO_DATA_FOUND` | `calculate_student_gpa.sql` | 
| `DUP_VAL_ON_INDEX` / Custom Exception | `register_student.sql` | 
| `RAISE_APPLICATION_ERROR` | `register_student.sql`, `calculate_student_gpa.sql` | 
| Function called from a PL/SQL block | `03_tests/test_success_cases.sql` | 

## 6. Repository Structure

```
plsql-assignment4-20251SEN191-20251SEN237/
│
├── README.md                        # Group members, application description, how to run
├── .gitignore
├── 00_schema/
│   ├── 01_create_tables.sql         # Tables, relationships, constraints
│   └── 02_insert_sample_data.sql    # Sample data
├── 01_procedures/                   # One file per stored procedure
│   ├── register_student.sql
│   └── bulk_update_grades.sql
├── 02_functions/                    # One file per stored function
│   └── calculate_student_gpa.sql
├── 03_tests/
│   ├── test_success_cases.sql       # Successful execution
│   └── test_error_cases.sql         # Exception handling
└── screenshots/                     # Output of each test case
    ├── Screenshot 2026-11-02 203131.png
    └── Screenshot 2026-11-02 202431.png

```

## 7. Prerequisites

* Oracle Database (XE or Oracle Live SQL)

* Oracle SQL Developer or SQL\*Plus

## 8. How to Run

Enable output first:

```
SET DEFINE OFF;
SET SERVEROUTPUT ON;

```

Then run the scripts in this order:

1. `00_schema/01_create_tables.sql`

2. `00_schema/02_insert_sample_data.sql`

3. Compile every file in `01_procedures/`

4. Compile every file in `02_functions/`

5. Run `03_tests/test_success_cases.sql` and `03_tests/test_error_cases.sql`

6. Compare your output with the images in `screenshots/`

## 9. Testing

### Success Cases (`03_tests/test_success_cases.sql`)

| \# | Test | Expected Result | Screenshot | 
| ----- | ----- | ----- | ----- | 
| 1 | Register student, calculate GPA & bulk update | Student inserted, GPA calculated, bulk update complete | `Screenshot 2026-11-02 203131.png` | 

### Error Cases (`03_tests/test_error_cases.sql`)

| \# | Test | Expected Exception | Screenshot | 
| ----- | ----- | ----- | ----- | 
| 1 | Duplicate email registration (`ORA-20001`) | Caught Expected Error: ORA-20001 | `Screenshot 2026-11-02 202431.png` | 
| 2 | GPA calculation for non-existent student (`ORA-20004`) | Caught Expected Error: ORA-20004 | `Screenshot 2026-11-02 202431.png` | 

## 10. Implementation & Performance Notes

`BULK COLLECT` and `FORALL` reduce the number of switches between the PL/SQL engine and the SQL engine. A row-by-row loop switches once per row, while a bulk operation handles all rows in one switch, so it is much faster on large data. `SAVE EXCEPTIONS` lets valid rows succeed and reports the rows that failed.

## 11. AI Usage Statement

AI assistance was used to help format and organize documentation, debug syntax errors during development, and verify test case script structures.

## 12. References

* Lecture 06 – PL/SQL Collections and Records

* Lecture 08 – Cursors: Implicit & Explicit

* Oracle Database PL/SQL Language Reference