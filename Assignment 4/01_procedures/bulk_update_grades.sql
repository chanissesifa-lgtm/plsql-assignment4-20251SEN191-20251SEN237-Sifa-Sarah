
CREATE OR REPLACE PROCEDURE bulk_update_grades (
    p_semester IN VARCHAR2,
    p_new_grade IN VARCHAR2
) AS
    TYPE t_enrollment_ids IS TABLE OF enrollments.enrollment_id%TYPE;
    l_enrollment_ids t_enrollment_ids;

    CURSOR c_ip_enrollments IS
        SELECT enrollment_id 
        FROM enrollments 
        WHERE semester = p_semester AND grade = 'IP';

BEGIN
    OPEN c_ip_enrollments;
    LOOP
        FETCH c_ip_enrollments BULK COLLECT INTO l_enrollment_ids LIMIT 100;
        EXIT WHEN l_enrollment_ids.COUNT = 0;

        FORALL i IN 1..l_enrollment_ids.COUNT SAVE EXCEPTIONS
            UPDATE enrollments
            SET grade = p_new_grade
            WHERE enrollment_id = l_enrollment_ids(i);
            
    END LOOP;
    CLOSE c_ip_enrollments;

    DBMS_OUTPUT.PUT_LINE('Bulk grade update completed successfully for semester: ' || p_semester);

EXCEPTION
    WHEN OTHERS THEN
        IF SQL%BULK_EXCEPTIONS.COUNT > 0 THEN
            FOR i IN 1..SQL%BULK_EXCEPTIONS.COUNT LOOP
                DBMS_OUTPUT.PUT_LINE('Error index: ' || SQL%BULK_EXCEPTIONS(i).ERROR_INDEX);
            END LOOP;
        END IF;
        RAISE_APPLICATION_ERROR(-20003, 'Bulk update failed: ' || SQLERRM);
END bulk_update_grades;
/