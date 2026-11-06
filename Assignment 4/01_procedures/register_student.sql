
CREATE OR REPLACE PROCEDURE register_student (
    p_first_name  IN students.first_name%TYPE,
    p_last_name   IN students.last_name%TYPE,
    p_email       IN students.email%TYPE,
    p_student_id  OUT students.student_id%TYPE
) AS
    e_duplicate_email EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_duplicate_email, -00001);
BEGIN
    -- Implicit Cursor operation with INSERT
    INSERT INTO students (first_name, last_name, email, enrollment_date)
    VALUES (p_first_name, p_last_name, p_email, SYSDATE)
    RETURNING student_id INTO p_student_id;

    IF SQL%FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Success: Student registered with ID ' || p_student_id || '. Rows affected: ' || SQL%ROWCOUNT);
    END IF;

EXCEPTION
    WHEN e_duplicate_email THEN
        RAISE_APPLICATION_ERROR(-20001, 'Registration Error: Email address already exists in the system.');
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20002, 'Unexpected error during student registration: ' || SQLERRM);
END register_student;
/