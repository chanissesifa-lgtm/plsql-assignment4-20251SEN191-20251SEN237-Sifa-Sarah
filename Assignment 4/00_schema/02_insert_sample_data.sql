
-- Insert Sample Students
INSERT INTO students (first_name, last_name, email, enrollment_date) 
VALUES ('Alice', 'Uwase', 'alice.uwase@auca.ac.rw', TO_DATE('2025-09-01', 'YYYY-MM-DD'));

INSERT INTO students (first_name, last_name, email, enrollment_date) 
VALUES ('Eric', 'Mugisha', 'eric.mugisha@auca.ac.rw', TO_DATE('2025-09-01', 'YYYY-MM-DD'));

INSERT INTO students (first_name, last_name, email, enrollment_date) 
VALUES ('Diane', 'Uwimana', 'diane.uwimana@auca.ac.rw', TO_DATE('2026-01-15', 'YYYY-MM-DD'));

-- Insert Sample Courses
INSERT INTO courses (course_name, credits) VALUES ('Database Systems II (PL/SQL)', 4);
INSERT INTO courses (course_name, credits) VALUES ('Data Structures & Algorithms', 3);
INSERT INTO courses (course_name, credits) VALUES ('Operating Systems', 4);

-- Insert Sample Enrollments
INSERT INTO enrollments (student_id, course_id, semester, grade) VALUES (1, 1, '2026-S1', 'IP');
INSERT INTO enrollments (student_id, course_id, semester, grade) VALUES (1, 2, '2026-S1', 'B');
INSERT INTO enrollments (student_id, course_id, semester, grade) VALUES (2, 1, '2026-S1', 'IP');
INSERT INTO enrollments (student_id, course_id, semester, grade) VALUES (3, 3, '2026-S1', 'A');

COMMIT;
