--report-1: Report of all the employees and their salaries:
set serveroutput on;
CREATE OR REPLACE PROCEDURE generate_employee_salary_report IS
BEGIN
  FOR emp IN (SELECT e.emp_id, e.emp_name, e.job_title, e.hire_date, e.salary
              FROM employee e
              JOIN admin_table a ON e.admin_id = a.admin_id)
  LOOP
    DBMS_OUTPUT.PUT_LINE('Employee ID: ' || emp.emp_id);
    DBMS_OUTPUT.PUT_LINE('Employee Name: ' || emp.emp_name);
    DBMS_OUTPUT.PUT_LINE('Job Title: ' || emp.job_title);
    DBMS_OUTPUT.PUT_LINE('Hire Date: ' || TO_CHAR(emp.hire_date, 'DD-MON-YYYY'));
    DBMS_OUTPUT.PUT_LINE('Salary: $' || emp.salary);
    
    DBMS_OUTPUT.PUT_LINE('------------------------');
  END LOOP;
END;
/
--executing report1
EXECUTE generate_employee_salary_report;
