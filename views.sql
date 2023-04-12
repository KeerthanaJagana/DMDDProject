--Index
Select * from EMPLOYEE Where emp_name LIKE 'Bob%';
CREATE INDEX EmployeeNameIndex ON EMPLOYEE(emp_name);

select * from show_movies where show_name like 'The%';
CREATE INDEX ShowNameIndex ON SHOW_movies(show_name);

INSERT INTO FOOD VALUES ('444', 'Others',2, 1, 111);
INSERT INTO PAYMENT (PID, TKT_COST, ROOM_COST, FOOD_cost_PER_PERSON, PAY_MODE, RID, UNIQUE_ID, TICKET_ID, FID) VALUES (11, 20, 100, 90, 'cash', 111, 11, 1, 444);

--trigger
CREATE OR REPLACE TRIGGER employeedelete
  AFTER DELETE ON ADMIN_TABLE
  FOR EACH ROW
BEGIN
  DELETE FROM EMPLOYEE WHERE ADMIN_ID = :old.ADMIN_ID;
END;
/
DELETE FROM EMPLOYEE WHERE ADMIN_id=2;

select * from EMPLOYEE;

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

-----for package----
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



--Execution of stored procedure
EXEC TOTAL_CASH_PAYMENT('cash');

--Execution of package
BEGIN 
   pkg_TOTAL_CASH_PAYMENT.TOTAL_CASH_PAYMENT('cash'); 
END;

--report1 to get the list of pay_mode wise total payments
SELECT pay_mode, SUM(tkt_cost) AS "Total Payments"
FROM PAYMENT
GROUP BY pay_mode
ORDER BY pay_mode;

--report2 to get the list of total tickets based on game type





---trigger1
CREATE OR REPLACE TRIGGER trg_employee_insert
BEFORE INSERT ON Employee
FOR EACH ROW
BEGIN
    IF :NEW.salary < 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Salary cannot be negative.');
    END IF;
END;
/
select * from employee;
insert into employee values (56,'vhd','dbcs',to_date('2023-08-01', 'YYYY-MM-DD'),-600,44,2);

--trigger2
CREATE OR REPLACE TRIGGER trg_room_reservation_update
BEFORE INSERT OR UPDATE ON Room_Reservation
FOR EACH ROW
BEGIN
    IF :NEW.room_type IS NULL THEN
        :NEW.room_type := 'Standard';
    END IF;
END;
/

insert into room_reservation values (666,2,'garden view',to_date('2023-08-01', 'YYYY-MM-DD'),NULL,5);
select * from room_reservation;
delete from room_reservation where rid=666;


--trigger3

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


--------
--report-1: Report of all the employees and their salaries:
SET SERVEROUTPUT ON;
CREATE OR REPLACE PROCEDURE generate_employee_salary_report IS
BEGIN
  FOR emp IN (SELECT e.emp_id, e.emp_name, e.job_title, e.hire_date, e.salary, l.email
              FROM employee e
              JOIN login l ON e.unique_id = l.unique_id)
  LOOP
    DBMS_OUTPUT.PUT_LINE('Employee ID: ' || emp.emp_id);
    DBMS_OUTPUT.PUT_LINE('Employee Name: ' || emp.emp_name);
    DBMS_OUTPUT.PUT_LINE('Job Title: ' || emp.job_title);
    DBMS_OUTPUT.PUT_LINE('Hire Date: ' || TO_CHAR(emp.hire_date, 'DD-MON-YYYY'));
    DBMS_OUTPUT.PUT_LINE('Salary: $' || emp.salary);
    DBMS_OUTPUT.PUT_LINE('Email: ' || emp.email);
    DBMS_OUTPUT.PUT_LINE('------------------------');
  END LOOP;
END;
/
--executing report1
BEGIN
  generate_employee_salary_report;
END;
/
-----------
--Report-2 : Generate a report of all the admins with their contact information
SET SERVEROUTPUT ON;
CREATE OR REPLACE PROCEDURE generate_admin_contact_report IS
BEGIN
FOR admin IN (SELECT a.admin_id, a.first_name, a.last_name, a.phone, a.designation, l.email
FROM admin_table a
JOIN login l ON a.admin_id = l.admin_id)
LOOP
DBMS_OUTPUT.PUT_LINE('Admin ID: ' || admin.admin_id);
DBMS_OUTPUT.PUT_LINE('Name: ' || admin.first_name || ' ' || admin.last_name);
DBMS_OUTPUT.PUT_LINE('Designation: ' || admin.designation);
DBMS_OUTPUT.PUT_LINE('Phone: ' || admin.phone);
DBMS_OUTPUT.PUT_LINE('Email: ' || admin.email);
DBMS_OUTPUT.PUT_LINE('------------------------');
END LOOP;
END;
/

-- To execute the procedure:
EXECUTE generate_admin_contact_report;

---Report3--report of all the movies showing, with their showtimes and ticket availability:
SET SERVEROUTPUT ON;
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

-- To execute the procedure:
EXECUTE generate_movie_schedule_report;

---Report4 :a report of all the shops in the park with their items and prices:
SET SERVEROUTPUT ON;
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

-- To execute the procedure:
EXECUTE generate_shop_inventory_report;

---Report5: 
SET SERVEROUTPUT ON;
CREATE OR REPLACE PROCEDURE generate_food_order_report IS
BEGIN
  FOR order IN (SELECT f.fid, f.food_cuisine, f.no_of_ppl, t.date_res, r.rid, r.no_of_rooms, r.room_view, r.room_type
                FROM food f
                JOIN ticket t ON f.ticket_id = t.ticket_id
                JOIN room_reservation r ON f.rid = r.rid)
  LOOP
    DBMS_OUTPUT.PUT_LINE('Food Order ID: ' || order.fid);
    DBMS_OUTPUT.PUT_LINE('Food Cuisine: ' || order.food_cuisine);
    DBMS_OUTPUT.PUT_LINE('No. of People: ' || order.no_of_ppl);
    DBMS_OUTPUT.PUT_LINE('Date Reserved: ' || TO_CHAR(order.date_res, 'DD-MON-YYYY'));
    DBMS_OUTPUT.PUT_LINE('Room Reservation ID: ' || order.rid);
    DBMS_OUTPUT.PUT_LINE('No. of Rooms Reserved: ' || order.no_of_rooms);
    DBMS_OUTPUT.PUT_LINE('Room View: ' || order.room_view);
    DBMS_OUTPUT.PUT_LINE('Room Type: ' || order.room_type);
    DBMS_OUTPUT.PUT_LINE('------------------------');
  END LOOP;
END;
/

SET SERVEROUTPUT ON;
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
execute generate_login_report;



------
set serveroutput on;
CREATE OR REPLACE PACKAGE pkg_CALCULATE_BONUS AS 
   PROCEDURE CALCULATE_BONUS(D_HIRE_DATE IN DATE, N_SALARY IN NUMBER); 
END pkg_CALCULATE_BONUS;

CREATE OR REPLACE PACKAGE BODY pkg_CALCULATE_BONUS AS 
   PROCEDURE CALCULATE_BONUS(D_HIRE_DATE IN DATE, N_SALARY IN NUMBER)
   IS
      O_BONUS NUMBER(10,2) := 0;
      D_CURRENT_DATE DATE := SYSDATE;
      
   BEGIN
      IF D_HIRE_DATE > ADD_MONTHS(D_CURRENT_DATE, -12) THEN
         O_BONUS := N_SALARY * 0.05;
      ELSIF D_HIRE_DATE > ADD_MONTHS(D_CURRENT_DATE, -36) THEN
         O_BONUS := N_SALARY * 0.1;
      ELSE
         O_BONUS := N_SALARY * 0.15;
      END IF;
      
      DBMS_OUTPUT.PUT_LINE('Employee bonus: $' || O_BONUS);
   EXCEPTION
      WHEN OTHERS THEN
         dbms_output.put_line( SQLERRM );  
   END;
END pkg_CALCULATE_BONUS;
/

BEGIN
   pkg_CALCULATE_BONUS.CALCULATE_BONUS('01-JAN-2022', 5000);
END;
