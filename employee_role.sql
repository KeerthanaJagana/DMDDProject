SELECT * FROM ADMIN_ROLE.employee;
SET SERVEROUTPUT ON
DECLARE
  emp_id NUMBER := 126; -- replace with the employee ID you want to calculate bonus for
  bonus NUMBER;
BEGIN
  bonus := ADMIN_ROLE.employee_bonus.calc_bonus(emp_id);
  DBMS_OUTPUT.PUT_LINE('Bonus for employee ' || emp_id || ': $' || bonus);
END;
/

