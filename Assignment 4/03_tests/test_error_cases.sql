
SET SERVEROUTPUT ON;

DECLARE
    v_dummy_id NUMBER;
    v_gpa NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE(' RUNNING ERROR EXCEPTION TEST CASES ');

    -- 1. Test Duplicate Registration Error (Unique Constraint Violation)
    BEGIN
        register_student(
            p_first_name => 'Duplicate',
            p_last_name  => 'User',
            p_email      => 'alice.uwase@auca.ac.rw', -- Already exists
            p_student_id => v_dummy_id
        );
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Caught Expected Error: ' || SQLERRM);
    END;

    -- 2. Test NO_DATA_FOUND Error in Function
    BEGIN
        v_gpa := calculate_student_gpa(99999); -- Non-existent student ID
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Caught Expected Error: ' || SQLERRM);
    END;

    DBMS_OUTPUT.PUT_LINE('=== ALL ERROR TESTS COMPLETED ===');
END;
/
