
CREATE OR REPLACE FUNCTION calculate_student_gpa (
    p_student_id IN students.student_id%TYPE
) RETURN NUMBER IS
    TYPE t_grade_map IS TABLE OF NUMBER INDEX BY VARCHAR2(2);
    l_grade_weights t_grade_map;

    l_total_points NUMBER := 0;
    l_total_credits NUMBER := 0;
    l_gpa NUMBER(3,2);
    l_student_exists NUMBER;

    CURSOR c_grades(cp_student_id NUMBER) IS
        SELECT c.credits, e.grade
        FROM enrollments e
        JOIN courses c ON e.course_id = c.course_id
        WHERE e.student_id = cp_student_id AND e.grade <> 'IP';

BEGIN
    SELECT COUNT(*) INTO l_student_exists FROM students WHERE student_id = p_student_id;
    IF l_student_exists = 0 THEN
        RAISE NO_DATA_FOUND;
    END IF;

    l_grade_weights('A') := 4.0;
    l_grade_weights('B') := 3.0;
    l_grade_weights('C') := 2.0;
    l_grade_weights('D') := 1.0;
    l_grade_weights('F') := 0.0;

    FOR r_grade IN c_grades(p_student_id) LOOP
        IF l_grade_weights.EXISTS(r_grade.grade) THEN
            l_total_points := l_total_points + (l_grade_weights(r_grade.grade) * r_grade.credits);
            l_total_credits := l_total_credits + r_grade.credits;
        END IF;
    END LOOP;

    IF l_total_credits = 0 THEN
        RETURN 0.0;
    END IF;

    l_gpa := l_total_points / l_total_credits;
    RETURN ROUND(l_gpa, 2);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20004, 'Student ID ' || p_student_id || ' does not exist.');
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20005, 'Error calculating GPA: ' || SQLERRM);
END calculate_student_gpa;
/
