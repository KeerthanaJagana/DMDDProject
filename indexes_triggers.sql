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


--------