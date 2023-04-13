--Index
Select * from EMPLOYEE Where emp_name LIKE 'Bob%';
CREATE INDEX EmployeeNameIndex ON EMPLOYEE(emp_name);

select * from show_movies where show_name like 'The%';
CREATE INDEX ShowNameIndex ON SHOW_movies(show_name);


---trigger1  cant insert negative or empty salary 
CREATE OR REPLACE TRIGGER trg_employee_insert
BEFORE INSERT ON Employee
FOR EACH ROW
BEGIN
    IF :NEW.salary < 0 or :new.salary is null THEN
        RAISE_APPLICATION_ERROR(-20001, 'Salary cannot be empty or negative.');
    END IF;
END;
/
select * from employee;
insert into employee values (56,'vhd','dbcs',to_date('2023-08-01', 'YYYY-MM-DD'),-600,2);
insert into employee values (57,'vhd','dbcs',to_date('2023-08-01', 'YYYY-MM-DD'),null,2);

--trigger2 if room type is null it assigns it as standard
CREATE OR REPLACE TRIGGER trg_room_reservation_update
BEFORE INSERT OR UPDATE ON Room_Reservation
FOR EACH ROW
BEGIN
    IF :NEW.room_type IS NULL THEN
        :NEW.room_type := 'Standard';
    END IF;
END;
/

insert into room_reservation values (9899,2,'garden view',to_date('2023-08-01', 'YYYY-MM-DD'),NULL,5);
select * from room_reservation;



--trigger3  checks if the email is in the correct format

CREATE OR REPLACE TRIGGER login_email_validation_trigger
BEFORE INSERT OR UPDATE ON Login
FOR EACH ROW
DECLARE
    email_valid BOOLEAN;
BEGIN
    -- Check if email is valid using regular expression
    email_valid := REGEXP_LIKE(:NEW.email, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$');
    IF NOT email_valid THEN
        RAISE_APPLICATION_ERROR(-20001, 'Invalid email format');
    END IF;
END;
/

select * from payment;
insert into login (email) values ('.com@');

--trigger 4
CREATE OR REPLACE TRIGGER trg_customer_info
BEFORE INSERT OR UPDATE ON login
FOR EACH ROW
BEGIN
    IF :NEW.first_name IS NULL or length(:NEW.first_name)=0 THEN
       RAISE_APPLICATION_ERROR(-20001, 'First Name cant be null');
    
    ELSIF :NEW.last_name IS NULL or length(:NEW.last_name)=0 THEN
       RAISE_APPLICATION_ERROR(-20001, 'Last Name cant be null');
    
    ELSIF :NEW.phone IS NULL or length(:NEW.phone)=0 THEN
       RAISE_APPLICATION_ERROR(-20001, 'Phone cant be null');
    
    ELSIF :NEW.address IS NULL or length(:NEW.address)=0 THEN
       RAISE_APPLICATION_ERROR(-20001, 'Address cant be null');
    
    ELSIF :NEW.email IS NULL or length(:NEW.email)=0 THEN
       RAISE_APPLICATION_ERROR(-20001, 'Email cant be null');
       
    ELSIF :NEW.password IS NULL or length(:NEW.password)=0 THEN
       RAISE_APPLICATION_ERROR(-20001, 'Password cant be null');
    END IF;
END;
/ 

insert into login(unique_id,first_name,last_name) values(1234,'asd','') ;
select * from login;
--------

-----FUNCTION-----
CREATE OR REPLACE FUNCTION fn_TOTAL_CASH_PAYMENT(S_PAY_MODE IN VARCHAR2) 
RETURN number
IS
O_TOTAL DECIMAL(10,2):=0;
BEGIN
  SELECT SUM(tkt_cost)
  INTO O_TOTAL
  FROM PAYMENT
  WHERE pay_mode = S_PAY_MODE;
  
  RETURN O_TOTAL;
EXCEPTION
   WHEN OTHERS THEN
      dbms_output.put_line( SQLERRM );  
END;
/
SELECT fn_TOTAL_CASH_PAYMENT('cash') FROM DUAL;

--Function 3
-- Function to calculate total number of tickets sold
CREATE OR REPLACE FUNCTION total_tickets_sold RETURN NUMBER
AS
v_total_tickets NUMBER;
BEGIN
SELECT SUM(total_tickets) INTO v_total_tickets FROM Ticket;
RETURN v_total_tickets;
END;
/
select total_tickets_sold() from dual;
 
 
-----package 1
--procedure--
CREATE OR REPLACE PROCEDURE TOTAL_CASH_PAYMENT(S_PAY_MODE IN VARCHAR2)
IS
O_TOTAL DECIMAL(10,2):=0;
BEGIN
  SELECT SUM(tkt_cost)
  INTO O_TOTAL
  FROM PAYMENT
  WHERE pay_mode = S_PAY_MODE;
  
  DBMS_OUTPUT.PUT_LINE(' Total cash payment for tickets ' || O_TOTAL);
EXCEPTION
   WHEN OTHERS THEN
      dbms_output.put_line( SQLERRM );  
END;
/
--Package to contain above procedure
CREATE OR REPLACE PACKAGE pkg_TOTAL_CASH_PAYMENT AS 
   PROCEDURE TOTAL_CASH_PAYMENT(S_PAY_MODE IN VARCHAR2); 
END pkg_TOTAL_CASH_PAYMENT;
/

CREATE OR REPLACE PACKAGE BODY pkg_TOTAL_CASH_PAYMENT AS 
	PROCEDURE TOTAL_CASH_PAYMENT(S_PAY_MODE IN VARCHAR2)
	IS
	O_TOTAL DECIMAL(10,2):=0;
	BEGIN
	  SELECT SUM(tkt_cost)
	  INTO O_TOTAL
	  FROM PAYMENT
	  WHERE pay_mode = S_PAY_MODE;
	  
	  DBMS_OUTPUT.PUT_LINE(' Total cash payment for tickets: ' || O_TOTAL);
	EXCEPTION
	   WHEN OTHERS THEN
	      dbms_output.put_line( SQLERRM );  
	END;
END pkg_TOTAL_CASH_PAYMENT;
/

--Execution of stored procedure
EXEC TOTAL_CASH_PAYMENT('cash');

--Execution of package
BEGIN 
   pkg_TOTAL_CASH_PAYMENT.TOTAL_CASH_PAYMENT('cash'); 
END;
/


SELECT pay_mode, SUM(tkt_cost) AS "Total Payments"
FROM PAYMENT
GROUP BY pay_mode
ORDER BY pay_mode;


--package 2
-- Package to manage login functionality
CREATE OR REPLACE PACKAGE login_pkg AS
-- Function to authenticate user
FUNCTION authenticate_user(p_email VARCHAR2, p_password VARCHAR2) RETURN NUMBER;

-- Function to update user's password
PROCEDURE update_password(p_unique_id NUMBER, p_new_password VARCHAR2);
END;
/

CREATE OR REPLACE PACKAGE BODY login_pkg AS
FUNCTION authenticate_user(p_email VARCHAR2, p_password VARCHAR2) RETURN NUMBER
AS
v_unique_id NUMBER;
BEGIN
SELECT Unique_ID INTO v_unique_id FROM Login WHERE Email = p_email AND password = p_password;
RETURN v_unique_id;
EXCEPTION
WHEN NO_DATA_FOUND THEN
RETURN NULL;
END;
PROCEDURE update_password(p_unique_id NUMBER, p_new_password VARCHAR2)
AS
BEGIN
UPDATE Login SET password = p_new_password WHERE unique_id = p_unique_id;
END;
END;
/

BEGIN 
   login_pkg.update_password(11,'Johnpassword123'); 
END;
/

select * from login;

--package 3
set serveroutput on
CREATE OR REPLACE PACKAGE employee_bonus AS
  FUNCTION calc_bonus (emp_id IN NUMBER) RETURN NUMBER;
END employee_bonus;
/

CREATE OR REPLACE PACKAGE BODY employee_bonus AS
  FUNCTION calc_bonus (emp_id IN NUMBER) RETURN NUMBER IS
    hire_date DATE;
    years_worked NUMBER;
    bonus NUMBER;
    emp_salary number;
  BEGIN
    SELECT hire_date, salary INTO hire_date, emp_salary FROM employee WHERE emp_id = calc_bonus.emp_id;
    years_worked := MONTHS_BETWEEN(SYSDATE, hire_date) / 12;
    IF years_worked > 1 THEN
      bonus := emp_salary * 2;
    ELSE
      bonus := 0;
    END IF;
    RETURN bonus;
  END calc_bonus;
END employee_bonus;
/


DECLARE
  emp_id NUMBER := 123; -- replace with the employee ID you want to calculate bonus for
  bonus NUMBER;
BEGIN
  bonus := employee_bonus.calc_bonus(emp_id);
  DBMS_OUTPUT.PUT_LINE('Bonus for employee ' || emp_id || ': $' || bonus);
END;
/



---
select * from employee;



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

-----------
--Report-2 : Generate a report of all the admins with their contact information
set serveroutput on;
CREATE OR REPLACE PROCEDURE generate_login_report IS
  
BEGIN
  for info in(SELECT l.Unique_ID, l.First_name, l.Last_name, l.Phone, l.Address, l.Email,t.TOTAL_TICKETS
  FROM Login l join ticket t on l.unique_id=t.unique_id )
  
  LOOP
  DBMS_OUTPUT.PUT_LINE('Login Report');
  DBMS_OUTPUT.PUT_LINE('ID: ' || INFO.unique_id);
  DBMS_OUTPUT.PUT_LINE('First Name: ' || INFO.first_name);
  DBMS_OUTPUT.PUT_LINE('Last Name: ' ||INFO.last_name);
  DBMS_OUTPUT.PUT_LINE('Phone Number: ' || INFO.phone);
  DBMS_OUTPUT.PUT_LINE('Address: ' || INFO.address);
  DBMS_OUTPUT.PUT_LINE('Email: ' || INFO.email);
  DBMS_OUTPUT.PUT_LINE('TOATL_TICKETS: ' || INFO.total_TICKETS);
  DBMS_OUTPUT.PUT_LINE('------------------------');
  END LOOP;
END;
/
--executing report2
execute generate_login_report;


---Report3--report of all the movies showing, with their showtimes and ticket availability:
set serveroutput on;
CREATE OR REPLACE PROCEDURE generate_movie_schedule_report IS
BEGIN
FOR movie IN (SELECT s.show_name, s.genre, s.movie_description, s.show_time, t.total_tickets, COUNT(r.rid) AS reserved_tickets
        FROM show_movies s
        JOIN ticket t ON s.ticket_id = t.ticket_id
        LEFT JOIN room_reservation r ON t.ticket_id = r.ticket_id
        GROUP BY s.show_name, s.genre, s.movie_description, s.show_time, t.total_tickets)
LOOP
 DBMS_OUTPUT.PUT_LINE('Movie Name: ' || movie.show_name);
 DBMS_OUTPUT.PUT_LINE('Genre: ' || movie.genre);
DBMS_OUTPUT.PUT_LINE('Description: ' || movie.movie_description);
DBMS_OUTPUT.PUT_LINE('Showtime: ' || movie.show_time);
DBMS_OUTPUT.PUT_LINE('Total Tickets Available: ' || movie.total_tickets);
DBMS_OUTPUT.PUT_LINE('Tickets Reserved: ' || movie.reserved_tickets);
DBMS_OUTPUT.PUT_LINE('------------------------');
END LOOP;
END;
/

--executing report3
EXECUTE generate_movie_schedule_report;

---Report4 :a report of all the shops in the park with their items and prices:
set serveroutput on;
CREATE OR REPLACE PROCEDURE generate_shop_inventory_report IS
BEGIN
FOR shop IN (SELECT s.shop_id, s.item_name, s.item_price
FROM shop s)
LOOP
DBMS_OUTPUT.PUT_LINE('Shop ID: ' || shop.shop_id);
DBMS_OUTPUT.PUT_LINE('Item Name: ' || shop.item_name);
DBMS_OUTPUT.PUT_LINE('Price: $' || shop.item_price);
DBMS_OUTPUT.PUT_LINE('------------------------');
END LOOP;
END;
/

--executing report4
EXECUTE generate_shop_inventory_report;

---Report5: 
SET SERVEROUTPUT ON;
CREATE OR REPLACE PROCEDURE generate_food_order_report IS
BEGIN
  FOR o IN (SELECT f.fid, f.food_cuisine, f.no_of_ppl, t.date_res, r.rid, r.no_of_rooms, r.room_view, r.room_type
                FROM food f
                JOIN ticket t ON f.ticket_id = t.ticket_id
                JOIN room_reservation r ON f.rid = r.rid)
  LOOP
    DBMS_OUTPUT.PUT_LINE('Food Order ID: ' || o.fid);
    DBMS_OUTPUT.PUT_LINE('Food Cuisine: ' || o.food_cuisine);
    DBMS_OUTPUT.PUT_LINE('No. of People: ' || o.no_of_ppl);
    DBMS_OUTPUT.PUT_LINE('Date Reserved: ' || TO_CHAR(o.date_res, 'DD-MON-YYYY'));
    DBMS_OUTPUT.PUT_LINE('Room Reservation ID: ' || o.rid);
    DBMS_OUTPUT.PUT_LINE('No. of Rooms Reserved: ' || o.no_of_rooms);
    DBMS_OUTPUT.PUT_LINE('Room View: ' || o.room_view);
    DBMS_OUTPUT.PUT_LINE('Room Type: ' || o.room_type);
    DBMS_OUTPUT.PUT_LINE('------------------------');
  END LOOP;
END;
/
--executing report5
execute generate_food_order_report;
