
SET SERVEROUTPUT ON;

DECLARE
    v_new_id NUMBER;
    v_gpa NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== RUNNING SUCCESS TEST CASES ===');

    -- 1. Test Stored Procedure: register_student
    register_student(
        p_first_name => 'Claude',
        p_last_name  => 'Habimana',
        p_email      => 'claude.habimana@auca.ac.rw',
        p_student_id => v_new_id
    );

    -- 2. Test Stored Function: calculate_student_gpa
    v_gpa := calculate_student_gpa(1);
    DBMS_OUTPUT.PUT_LINE('Calculated GPA for Student 1: ' || v_gpa);

    -- 3. Test Bulk Processing Procedure: bulk_update_grades
    bulk_update_grades(
        p_semester  => '2026-S1',
        p_new_grade => 'B'
    );

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('=== ALL SUCCESS TESTS COMPLETED ===');
END;
/
