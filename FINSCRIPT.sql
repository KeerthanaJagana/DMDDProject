show user;
set serveroutput on;
CREATE OR REPLACE PROCEDURE drop_tables IS
  FLAG NUMBER := 0;
  current_user VARCHAR2(40);
  WRONG_user EXCEPTION;
BEGIN
  SELECT user INTO current_user FROM dual;

  IF (current_user <> 'ADMIN_ROLE') THEN
    RAISE WRONG_user;
  END IF;

  SELECT COUNT(*) INTO FLAG FROM ALL_TABLES WHERE TABLE_NAME = 'Admin_table' AND TABLESPACE_NAME = 'DATA';
  IF FLAG = 0 THEN
    EXECUTE IMMEDIATE 'DROP TABLE Admin_Table CASCADE CONSTRAINTS';
  END IF;

  SELECT COUNT(*) INTO FLAG FROM ALL_TABLES WHERE TABLE_NAME = 'Login' AND TABLESPACE_NAME = 'DATA';
  IF FLAG = 0 THEN
    EXECUTE IMMEDIATE 'DROP TABLE Login CASCADE CONSTRAINTS';
  END IF;

  SELECT COUNT(*) INTO FLAG FROM ALL_TABLES WHERE TABLE_NAME = 'Employee' AND TABLESPACE_NAME = 'DATA';
  IF FLAG = 0 THEN
    EXECUTE IMMEDIATE 'DROP TABLE Employee CASCADE CONSTRAINTS';
  END IF;

  SELECT COUNT(*) INTO FLAG FROM ALL_TABLES WHERE TABLE_NAME = 'Shop' AND TABLESPACE_NAME = 'DATA';
  IF FLAG = 0 THEN
    EXECUTE IMMEDIATE 'DROP TABLE Shop CASCADE CONSTRAINTS';
  END IF;

  SELECT COUNT(*) INTO FLAG FROM ALL_TABLES WHERE TABLE_NAME = 'Ticket' AND TABLESPACE_NAME = 'DATA';
  IF FLAG = 0 THEN
    EXECUTE IMMEDIATE 'DROP TABLE Ticket CASCADE CONSTRAINTS';
  END IF;

  SELECT COUNT(*) INTO FLAG FROM ALL_TABLES WHERE TABLE_NAME = 'Show_Movies' AND TABLESPACE_NAME = 'DATA';
  IF FLAG = 0 THEN
    EXECUTE IMMEDIATE 'DROP TABLE Show_Movies CASCADE CONSTRAINTS';
  END IF;

  SELECT COUNT(*) INTO FLAG FROM ALL_TABLES WHERE TABLE_NAME = 'Room_Reservation' AND TABLESPACE_NAME = 'DATA';
  IF FLAG = 0 THEN
    EXECUTE IMMEDIATE 'DROP TABLE Room_Reservation CASCADE CONSTRAINTS';
  END IF;

  SELECT COUNT(*) INTO FLAG FROM ALL_TABLES WHERE TABLE_NAME = 'Food' AND TABLESPACE_NAME = 'DATA';
  IF FLAG = 0 THEN
    EXECUTE IMMEDIATE 'DROP TABLE Food CASCADE CONSTRAINTS';
  END IF;

  SELECT COUNT(*) INTO FLAG FROM ALL_TABLES WHERE TABLE_NAME = 'Payment' AND TABLESPACE_NAME = 'DATA';
  IF FLAG = 0 THEN
    EXECUTE IMMEDIATE 'DROP TABLE Payment CASCADE CONSTRAINTS';
  END IF;

  COMMIT;

EXCEPTION
  WHEN WRONG_user THEN
    DBMS_OUTPUT.PUT_LINE('YOU CANNOT PERFORM THIS ACTION DROP TABLES, PLEASE CONTACT ADMIN');
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE(SQLERRM);
    ROLLBACK;
END;
/

-- executing drop tables procedure
EXECUTE DROP_TABLES;




-- Create table procedure
CREATE OR REPLACE PROCEDURE CREATETABLES IS
    FLAG NUMBER := 0;
    CURRENT_USER VARCHAR2(40);
    WRONG_user EXCEPTION;
    
BEGIN
    SELECT USER INTO CURRENT_USER FROM DUAL;
    IF (CURRENT_USER <> 'ADMIN_ROLE') THEN
        RAISE WRONG_user;
    END IF;
    SELECT COUNT(*) INTO FLAG FROM ALL_TABLES WHERE TABLE_NAME = 'Admin_Table' AND TABLESPACE_NAME = 'DATA';

    IF FLAG = 0 THEN 
        EXECUTE IMMEDIATE '
        CREATE TABLE Admin_Table(
        Admin_id NUMBER(10) PRIMARY KEY,
        first_name VARCHAR2(20),
        last_name VARCHAR2(20),
        phone NUMBER(10),
        designation VARCHAR2(20),
        park_access VARCHAR2(30)
        )';
    END IF;


-- create table Login

    
    SELECT COUNT(*) INTO FLAG FROM ALL_TABLES WHERE TABLE_NAME = 'Login' AND TABLESPACE_NAME = 'DATA';

    IF FLAG = 0 THEN 
        EXECUTE IMMEDIATE '
        CREATE TABLE Login(
        Unique_ID NUMBER(10) PRIMARY KEY,
        First_name VARCHAR2(20) NOT NULL,
        Last_name VARCHAR2(20) NOT NULL,
        Phone NUMBER(10),
        Address VARCHAR2(50),
        Email VARCHAR2(100) CONSTRAINT valid_email CHECK (REGEXP_LIKE(email, ''^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'')), 
        password VARCHAR2(50) NOT NULL,
        admin_id NUMBER(10),
        CONSTRAINT FK_AdminID FOREIGN KEY(admin_id)
            REFERENCES Admin_Table(Admin_id)
        )';
    END IF;





-- create table Employee

 SELECT COUNT(*) INTO FLAG FROM ALL_TABLES WHERE TABLE_NAME = 'Employee' AND TABLESPACE_NAME = 'DATA';


    IF FLAG = 0 THEN 
    EXECUTE IMMEDIATE '
CREATE TABLE Employee (
  	Emp_id NUMBER(10),
    emp_name VARCHAR(20),
    job_title VARCHAR(20),
  	hire_date DATE ,
  	salary NUMBER(10),
   
  	PRIMARY KEY (Emp_id),
admin_id number(10) ,

  CONSTRAINT FK_AID FOREIGN KEY (admin_id) REFERENCES Admin_table(admin_id)		
)';
END IF;




-- create table shop

 SELECT COUNT(*) INTO FLAG FROM ALL_TABLES WHERE TABLE_NAME = 'Shop' AND TABLESPACE_NAME = 'DATA';


    IF FLAG = 0 THEN 
    EXECUTE IMMEDIATE '
CREATE TABLE Shop (
  	Shop_id NUMBER(10),
    item_name VARCHAR(20),
  	item_price NUMBER(10),
    unique_id NUMBER(10),
  	PRIMARY KEY (shop_id),
	FOREIGN KEY (unique_id) REFERENCES Login(unique_id)	
)';
END IF;


--create table Ticket
SELECT COUNT(*) INTO FLAG FROM ALL_TABLES WHERE TABLE_NAME = 'Ticket' AND TABLESPACE_NAME = 'DATA';
 IF FLAG = 0 THEN 
    EXECUTE IMMEDIATE '
CREATE TABLE Ticket (
  	ticket_id NUMBER(10),
  	game_type VARCHAR(20),
  	total_tickets NUMBER(10),
    date_res DATE,
  	unique_id NUMBER(10),
  	PRIMARY KEY (ticket_id),
  	CONSTRAINT FK_UNIQUEID FOREIGN KEY (unique_id) REFERENCES Login(unique_id)	
)';
END IF;


-- create table Show Movies
 SELECT COUNT(*) INTO FLAG FROM ALL_TABLES WHERE TABLE_NAME = 'Show_Movies' AND TABLESPACE_NAME = 'DATA';

    IF FLAG = 0 THEN 
    EXECUTE IMMEDIATE '
CREATE TABLE Show_Movies (
  	show_id NUMBER(10),
  	show_name VARCHAR(40),
  	genre VARCHAR(20),
  	movie_description VARCHAR(100),
    show_time VARCHAR(20),
    ticket_id NUMBER(10),
  	PRIMARY KEY (show_id),
    FOREIGN KEY (ticket_id) REFERENCES Ticket(ticket_id)	
)';
END IF;


-- create table Room reservation

SELECT COUNT(*) INTO FLAG FROM ALL_TABLES WHERE TABLE_NAME = 'Room_Reservation' AND TABLESPACE_NAME = 'DATA';

    IF FLAG = 0 THEN 
    EXECUTE IMMEDIATE '
CREATE TABLE Room_Reservation (
  	rid NUMBER(10),
  	no_of_rooms NUMBER(20) ,
  	room_view VARCHAR(20) ,
  	date_res DATE ,
  	room_type VARCHAR(20),
  	ticket_id NUMBER(10),
  	PRIMARY KEY (rid),
	FOREIGN KEY (ticket_id) REFERENCES Ticket(ticket_id)	
)';
END IF;


-- create table Food

 SELECT COUNT(*) INTO FLAG FROM ALL_TABLES WHERE TABLE_NAME = 'Food' AND TABLESPACE_NAME = 'DATA';


    IF FLAG = 0 THEN 
    EXECUTE IMMEDIATE '
CREATE TABLE Food (
  	fid NUMBER(10),
  	food_cuisine VARCHAR(20) ,
  	no_of_ppl NUMBER(10) ,
  	ticket_id NUMBER(10),
    rid NUMBER(10),
  	PRIMARY KEY (fid),
	FOREIGN KEY (ticket_id) REFERENCES Ticket(ticket_id),
    FOREIGN KEY (rid) REFERENCES Room_Reservation(rid)		
)';
END IF;

-- create table Payment

 SELECT COUNT(*) INTO FLAG FROM ALL_TABLES WHERE TABLE_NAME = 'Payment' AND TABLESPACE_NAME = 'DATA';


    IF FLAG = 0 THEN 
    EXECUTE IMMEDIATE '
CREATE TABLE PAYMENT(
Pid NUMBER(10),
tkt_cost Number(10),
room_cost number(10),
food_cost_per_person number(10),
pay_mode varchar(20),
card_details number(20),
rid number(10),
PRIMARY KEY (Pid),
FOREIGN KEY (rid) REFERENCES Room_Reservation(rid),
unique_id NUMBER(10),
FOREIGN KEY (unique_id) REFERENCES Login(unique_id),
ticket_id NUMBER(10),
FOREIGN KEY (ticket_id) REFERENCES TICKET(ticket_id),
fid number(10),
FOREIGN KEY (fid) REFERENCES FOOD(FID)
)';
END IF;

    COMMIT;

EXCEPTION
WHEN WRONG_user THEN
        DBMS_OUTPUT.PUT_LINE('YOU CANNOT PERFORM THIS ACTION FOR CREATE TABLES. PLEASE CONTACT ADMIN');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
    ROLLBACK;


END;
/

drop sequence PAYMENT_SEQUENCE_NUM;
-- executing create tables procedure
EXECUTE CREATETABLES;

INSERT INTO Admin_table (admin_id, first_name, last_name, phone, designation, park_access) 
VALUES (1, 'John', 'Doe', 1234567890, 'Manager', 'Full Access');
INSERT INTO Admin_table (admin_id, first_name, last_name, phone, designation, park_access) 
VALUES (2, 'Jane', 'Smith', 2345678901, 'Supervisor', 'Limited Access');
INSERT INTO Admin_table (admin_id, first_name, last_name, phone, designation, park_access) 
VALUES (3, 'Bob', 'Johnson', 3456789012, 'Manager', 'Full Access');
INSERT INTO Admin_table (admin_id, first_name, last_name, phone,designation, park_access) 
VALUES (4, 'Alice', 'Jones', 4567890123, 'Supervisor', 'Limited Access');
INSERT INTO Admin_table (admin_id, first_name, last_name, phone, designation, park_access) 
VALUES (5, 'Mike', 'Brown', 5678901234, 'Manager', 'Full Access');

INSERT INTO Admin_table (admin_id, first_name, last_name, phone, designation, park_access) 
VALUES (6, 'Sarah', 'Williams', 4567890123, 'Assistant Manager', 'Restricted Access');
INSERT INTO Admin_table (admin_id, first_name, last_name, phone, designation, park_access) 
VALUES (7, 'Mark', 'Davis', 5678901234, 'Security Officer', 'Restricted Access');
INSERT INTO Admin_table (admin_id, first_name, last_name, phone, designation, park_access) 
VALUES (8,  'Jessica', 'Lopez', 4567890123, 'I T Specialist', 'Full Access');



select * from Admin_table;


INSERT INTO Login (unique_id, first_name, last_name, phone, address, email, password,admin_id)
VALUES (11, 'Mike', 'Doe', 1234567890, '123 Main St', 'johndoe@example.com', 'passwordJohn123',1);

INSERT INTO Login (unique_id, first_name, last_name, phone, address, email, password,admin_id)
VALUES (22, 'Smith', 'Kol', 123459890, '456 Main St', 'smith@example.com', 'passwordkol123',2);

INSERT INTO Login (unique_id, first_name, last_name, phone, address, email, password,admin_id)
VALUES (33, 'Loki', 'Das', 1234567890, '99 Main St', 'loki@example.com', 'passwordloki123',1);

INSERT INTO Login (unique_id, first_name, last_name, phone, address, email, password,admin_id)
VALUES (44, 'Jojo', 'Rad', 987658990, '13 Main St', 'Jojo@example.com', 'passwordjojo123',3);

INSERT INTO Login (unique_id, first_name, last_name, phone, address, email, password,admin_id)
VALUES (55, 'Paul', 'Brown', 234656090, '15 Main St', 'Paul@example.com', 'passwordpaul123',1);


INSERT INTO Login (unique_id, first_name, last_name, phone, address, email, password,admin_id)
VALUES (66, 'Paul', 'Smith', 234656090, '15ACC Main St', 'PaulSmi@example.com', 'passwordpaulsm123',3);
INSERT INTO Login (unique_id, first_name, last_name, phone, address, email, password,admin_id)
VALUES (77, 'Paul', 'Davis', 76590, '69 Main St', 'PaulDav@example.com', 'passwordpauldavis123',2);
INSERT INTO Login (unique_id, first_name, last_name, phone, address, email, password,admin_id)
VALUES (88, 'Paul', 'Williams', 23876090, '55 Main St', 'PaulWil@example.com', 'passwordpaulwil123',3);
INSERT INTO Login (unique_id, first_name, last_name, phone, address, email, password,admin_id)
VALUES (99, 'Alice', 'Brown', 12366090, '95 Main St', 'AaliceBr@example.com', 'passwordalice123',1);



select * from login;


INSERT INTO Employee (Emp_id, emp_name, job_title, hire_date, salary, admin_id)
VALUES (123, 'John Smith', 'Manager', TO_Date('2022-06-01','yyyy-mm-dd'), 80000, 1);

INSERT INTO Employee (Emp_id, emp_name, job_title, hire_date, salary, admin_id)
VALUES (124, 'Jane Doe', 'Engineer', TO_Date('2020-05-04','yyyy-mm-dd'), 65000, 2);

INSERT INTO Employee (Emp_id, emp_name, job_title, hire_date, salary, admin_id)
VALUES (125, 'Bob Johnson', 'Technician', TO_Date('2022-08-07','yyyy-mm-dd'), 40000, 2);

INSERT INTO Employee (Emp_id, emp_name, job_title, hire_date, salary, admin_id)
VALUES (126, 'Alice Brown', 'Analyst', TO_Date('2021-03-01','yyyy-mm-dd'), 55000,1);

INSERT INTO Employee (Emp_id, emp_name, job_title, hire_date, salary,  admin_id)
VALUES (127, 'Tom Wilson', 'Assisstant Manager', TO_Date('2020-06-01','yyyy-mm-dd'), 30000, 1);

INSERT INTO Employee (Emp_id, emp_name, job_title, hire_date, salary, admin_id)
VALUES (128, 'Tim Johnson', 'IT Assistant', TO_Date('2019-08-01','yyyy-mm-dd'), 50000, 8);
INSERT INTO Employee (Emp_id, emp_name, job_title, hire_date, salary,  admin_id)
VALUES (129, 'Tom Brown', 'Assisstant Manager', TO_Date('2020-06-01','yyyy-mm-dd'), 35000, 4);
INSERT INTO Employee (Emp_id, emp_name, job_title, hire_date, salary, admin_id)
VALUES (130, 'Thomas Alison', 'Associate', TO_Date('2023-01-01','yyyy-mm-dd'), 29000, 3);
INSERT INTO Employee (Emp_id, emp_name, job_title, hire_date, salary,  admin_id)
VALUES (131, 'Bob Wilson', 'Associate', TO_Date('2022-06-01','yyyy-mm-dd'), 25000,  3);


select * from employee;


INSERT INTO Ticket (ticket_id, game_type, total_tickets, date_res, unique_id)
VALUES (1, 'dryrides', 4, TO_Date('2023-06-01','yyyy-mm-dd'), 11);
INSERT INTO Ticket (ticket_id, game_type, total_tickets, date_res, unique_id)
VALUES (2, 'both', 7, TO_Date('2023-05-03','yyyy-mm-dd'), 22);

INSERT INTO Ticket (ticket_id, game_type, total_tickets, date_res, unique_id)
VALUES (3, 'waterrides', 4, TO_Date('2023-05-08','yyyy-mm-dd'), 33);

INSERT INTO Ticket (ticket_id, game_type, total_tickets, date_res, unique_id)
VALUES (4, 'dryrides', 8,TO_Date('2023-08-01','yyyy-mm-dd'), 44);

INSERT INTO Ticket (ticket_id, game_type, total_tickets, date_res, unique_id)
VALUES (5, 'waterrides', 3,TO_Date('2023-06-03','yyyy-mm-dd'), 55);


INSERT INTO Ticket (ticket_id, game_type, total_tickets, date_res, unique_id)
VALUES (6, 'dryrides', 7,TO_Date('2023-06-03','yyyy-mm-dd'), 66);
INSERT INTO Ticket (ticket_id, game_type, total_tickets, date_res, unique_id)
VALUES (7, 'both', 3,TO_Date('2023-06-03','yyyy-mm-dd'), 77);
INSERT INTO Ticket (ticket_id, game_type, total_tickets, date_res, unique_id)
VALUES (8, 'waterrides', 2,TO_Date('2023-06-03','yyyy-mm-dd'), 88);
INSERT INTO Ticket (ticket_id, game_type, total_tickets, date_res, unique_id)
VALUES (9, 'dryrides', 10,TO_Date('2023-06-03','yyyy-mm-dd'), 99);



select * from ticket;

INSERT INTO Room_Reservation (rid, no_of_rooms, room_view, date_res, room_type, ticket_id) 
VALUES(111, 2, 'ocean view', TO_DATE('2023-06-01', 'YYYY-MM-DD'), 'standard', 1);

INSERT INTO Room_Reservation (rid, no_of_rooms, room_view, date_res, room_type, ticket_id) 
VALUES(222, 4, 'city view', TO_DATE('2023-05-02', 'YYYY-MM-DD'), 'deluxe', 2);

INSERT INTO Room_Reservation (rid, no_of_rooms, room_view, date_res, room_type, ticket_id) 
VALUES(333, 3, 'mountain view', TO_DATE('2023-05-08', 'YYYY-MM-DD'), 'suite', 3);

INSERT INTO Room_Reservation (rid, no_of_rooms, room_view, date_res, room_type, ticket_id) 
VALUES(444, 5, 'garden view', TO_DATE('2023-08-01', 'YYYY-MM-DD'), 'standard', 4);

INSERT INTO Room_Reservation (rid, no_of_rooms, room_view, date_res, room_type, ticket_id) 
VALUES(555, 2, 'city view', TO_DATE('2023-06-02', 'YYYY-MM-DD'), 'deluxe', 5);


INSERT INTO Room_Reservation (rid, no_of_rooms, room_view, date_res, room_type, ticket_id) 
VALUES(666, 4, 'city view', TO_DATE('2023-06-02', 'YYYY-MM-DD'), 'deluxe', 6);
INSERT INTO Room_Reservation (rid, no_of_rooms, room_view, date_res, room_type, ticket_id) 
VALUES(777, 3, 'mountain view', TO_DATE('2023-08-02', 'YYYY-MM-DD'), 'deluxe', 7);
INSERT INTO Room_Reservation (rid, no_of_rooms, room_view, date_res, room_type, ticket_id) 
VALUES(888, 2, 'ocean view', TO_DATE('2023-10-02', 'YYYY-MM-DD'), 'standard', 8);
INSERT INTO Room_Reservation (rid, no_of_rooms, room_view, date_res, room_type, ticket_id) 
VALUES(999, 2, 'garden view', TO_DATE('2023-09-02', 'YYYY-MM-DD'), 'suite', 9);

select  * from room_reservation;

INSERT INTO Show_Movies (show_id, show_name, genre, movie_description, show_time, ticket_id)
VALUES (121, 'The Godfather', 'Crime', 'A powerful Italian-American mafia family', 'morning show', 1);

INSERT INTO Show_Movies (show_id, show_name, genre, movie_description, show_time, ticket_id)
VALUES (131, 'The Shawshank', 'Drama', 'A story of a banker imprisoned for a crime he did not commit', 'matinee show', 2);

INSERT INTO Show_Movies (show_id, show_name, genre, movie_description, show_time, ticket_id)
VALUES (141, 'The Dark Knight', 'Action', 'Batman must stop a criminal mastermind who terrorizes Gotham', 'morning show', 3);

INSERT INTO Show_Movies (show_id, show_name, genre, movie_description, show_time, ticket_id)
VALUES (151, 'Inception', 'Sci-Fi', 'A thief who steals corporate secrets through dream-sharing technology','afternoon show',4);

INSERT INTO Show_Movies (show_id, show_name, genre, movie_description, show_time, ticket_id)
VALUES (161, 'Forrest Gump', 'Drama', 'A man with a low IQ who achieves great success in life', 'matinee show',5);


INSERT INTO Show_Movies (show_id, show_name, genre, movie_description, show_time, ticket_id)
VALUES (171, 'Bridesmaids', 'Comedy', 'Annies life is a mess.', 'matinee show',6);
INSERT INTO Show_Movies (show_id, show_name, genre, movie_description, show_time, ticket_id)
VALUES (181, 'Die Hard', 'Action', 'John McClane, officer of the NYPD', 'afternoon show',7);
INSERT INTO Show_Movies (show_id, show_name, genre, movie_description, show_time, ticket_id)
VALUES (191, 'The Notebook', 'Romance', 'A poor yet passionate young man falls in love with a rich young woman', 'morning show',8);
INSERT INTO Show_Movies (show_id, show_name, genre, movie_description, show_time, ticket_id)
VALUES (1001, 'The Conjuring', 'Horror', 'Paranormal investigators Ed and Lorraine Warren work to help a family', 'matinee show',9);



INSERT INTO Food (fid, food_cuisine, no_of_ppl, ticket_id, rid) VALUES (999, 'Italian', 4, 1, 111);

INSERT INTO Food (fid, food_cuisine, no_of_ppl, ticket_id, rid) VALUES (888, 'Chinese', 7, 2, 222);

INSERT INTO Food (fid, food_cuisine, no_of_ppl, ticket_id, rid) VALUES (777, 'Indian', 4, 3, 333);

INSERT INTO Food (fid, food_cuisine, no_of_ppl, ticket_id, rid) VALUES (666, 'Mexican', 8, 4, 444);

INSERT INTO Food (fid, food_cuisine, no_of_ppl, ticket_id, rid) VALUES (555, 'Japanese', 3, 5, 555);


INSERT INTO Food (fid, food_cuisine, no_of_ppl, ticket_id, rid) VALUES (444, 'Italian', 7, 6, 666);
INSERT INTO Food (fid, food_cuisine, no_of_ppl, ticket_id, rid) VALUES (333, 'Indian', 3, 7, 777);
INSERT INTO Food (fid, food_cuisine, no_of_ppl, ticket_id, rid) VALUES (222, 'Thai', 2, 8, 888);
INSERT INTO Food (fid, food_cuisine, no_of_ppl, ticket_id, rid) VALUES (111, 'Japanese', 10, 5, 999);


select * from food;

INSERT INTO Shop (Shop_id, item_name, item_price, unique_id)
VALUES (133, 'fridge_magnet', 5, 11);
INSERT INTO Shop (Shop_id, item_name, item_price, unique_id)
VALUES (134, 'Popcorn', 3, 11);
INSERT INTO Shop (Shop_id, item_name, item_price, unique_id)
VALUES (135, 'fridge_magnet', 5, 22);
INSERT INTO Shop (Shop_id, item_name, item_price, unique_id)
VALUES (136, 'Popcorn', 3, 33);
INSERT INTO Shop (Shop_id, item_name, item_price, unique_id)
VALUES (137, 'photos', 7, 33);
INSERT INTO Shop (Shop_id, item_name, item_price, unique_id)
VALUES (138, 'photos',7, 44);
INSERT INTO Shop (Shop_id, item_name, item_price, unique_id)
VALUES (139, 'fridge_magnet', 5, 55);
INSERT INTO Shop (Shop_id, item_name, item_price, unique_id)
VALUES (140, 'fridge_magnet', 5, 44);

INSERT INTO Shop (Shop_id, item_name, item_price, unique_id)
VALUES (141,  'Popcorn', 3, 66);
INSERT INTO Shop (Shop_id, item_name, item_price, unique_id)
VALUES (142, 'photos', 7, 77);
INSERT INTO Shop (Shop_id, item_name, item_price, unique_id)
VALUES (143, 'fridge_magnet', 5, 66);
INSERT INTO Shop (Shop_id, item_name, item_price, unique_id)
VALUES (144, 'Popcorn', 3, 88);
INSERT INTO Shop (Shop_id, item_name, item_price, unique_id)
VALUES (145, 'fridge_magnet', 5, 88);
INSERT INTO Shop (Shop_id, item_name, item_price, unique_id)
VALUES (146, 'photos', 7, 99);


select * from shop;

CREATE SEQUENCE PAYMENT_SEQUENCE_NUM START WITH 11 INCREMENT BY 1 MAXVALUE 99999 MINVALUE 11 NOCYCLE CACHE 20;

INSERT INTO PAYMENT(Pid, tkt_cost, room_cost, food_cost_per_person, pay_mode, card_details, rid, unique_id, ticket_id, fid)
VALUES(PAYMENT_SEQUENCE_NUM.NEXTVAL, 10, 250, 50, 'credit card', 1234567890123456, 111, 11, 1, 999);

INSERT INTO PAYMENT(Pid, tkt_cost, room_cost, food_cost_per_person, pay_mode, card_details, rid, unique_id, ticket_id, fid)
VALUES(PAYMENT_SEQUENCE_NUM.NEXTVAL, 20, 200, 35, 'debit card', 9876543210987654, 222, 22, 2, 888);

INSERT INTO PAYMENT(Pid, tkt_cost, room_cost, food_cost_per_person,  pay_mode, card_details, rid, unique_id, ticket_id, fid)
VALUES(PAYMENT_SEQUENCE_NUM.NEXTVAL, 15, 275, 100, 'cash', null, 333, 33, 3, 777);

INSERT INTO PAYMENT(Pid, tkt_cost, room_cost, food_cost_per_person, pay_mode, card_details, rid, unique_id, ticket_id, fid)
VALUES(PAYMENT_SEQUENCE_NUM.NEXTVAL, 10, 150, 25, 'credit card', 1111222233334444, 444, 44, 4, 666);

INSERT INTO PAYMENT(Pid, tkt_cost, room_cost, food_cost_per_person, pay_mode, card_details, rid, unique_id, ticket_id, fid)
VALUES(PAYMENT_SEQUENCE_NUM.NEXTVAL, 30, 200, 90, 'debit card', 5555666677778888, 555, 55, 5, 555);


INSERT INTO PAYMENT(Pid, tkt_cost, room_cost, food_cost_per_person, pay_mode, card_details, rid, unique_id, ticket_id, fid)
VALUES(PAYMENT_SEQUENCE_NUM.NEXTVAL, 30, 200, 90, 'cash', 5555666677778888, 666, 66, 6, 444);
INSERT INTO PAYMENT(Pid, tkt_cost, room_cost, food_cost_per_person, pay_mode, card_details, rid, unique_id, ticket_id, fid)
VALUES(PAYMENT_SEQUENCE_NUM.NEXTVAL, 30, 200, 90, 'credit card', 5555666677778888, 777, 77, 7, 333);
INSERT INTO PAYMENT(Pid, tkt_cost, room_cost, food_cost_per_person, pay_mode, card_details, rid, unique_id, ticket_id, fid)
VALUES(PAYMENT_SEQUENCE_NUM.NEXTVAL, 30, 200, 90, 'debit card', 111122234467, 888, 88, 8, 222);
INSERT INTO PAYMENT(Pid, tkt_cost, room_cost, food_cost_per_person, pay_mode, card_details, rid, unique_id, ticket_id, fid)
VALUES(PAYMENT_SEQUENCE_NUM.NEXTVAL, 30, 200, 90, 'cash', 87654323288, 999, 99, 9, 111);


select * from payment;

--procedure to drop views
create or replace PROCEDURE DROP_VIEWS IS
FLAG NUMBER := 0;
CURRENT_USER VARCHAR(40);
WRONG_user EXCEPTION;
BEGIN
    SELECT USER INTO CURRENT_USER FROM DUAL;
    IF (CURRENT_USER <> 'ADMIN_ROLE') THEN
        RAISE WRONG_user;
    END IF;
    SELECT COUNT(*) INTO FLAG FROM ALL_VIEWS WHERE VIEW_NAME = 'CustomerDetails';   
    IF FLAG >= 0 THEN                
    EXECUTE IMMEDIATE 'DROP view CustomerDetails CASCADE CONSTRAINTS';         
    END IF;
  
   SELECT COUNT(*) INTO FLAG FROM ALL_VIEWS WHERE VIEW_NAME = 'empDetail';   
   IF FLAG >= 0 THEN                
   EXECUTE IMMEDIATE 'DROP view empDetail CASCADE CONSTRAINTS';         
   END IF;
   
   SELECT COUNT(*) INTO FLAG FROM ALL_VIEWS WHERE VIEW_NAME = 'showMovies';   
  IF FLAG >= 0 THEN                
  EXECUTE IMMEDIATE 'DROP view showMovies CASCADE CONSTRAINTS';         
   END IF;
   
   SELECT COUNT(*) INTO FLAG FROM ALL_VIEWS WHERE VIEW_NAME = 'roomreservation';   
  IF FLAG >= 0 THEN                
  EXECUTE IMMEDIATE 'DROP view roomreservation CASCADE CONSTRAINTS';         
   END IF;
   
   SELECT COUNT(*) INTO FLAG FROM ALL_VIEWS WHERE VIEW_NAME = 'shopitems';   
  IF FLAG >= 0 THEN                
  EXECUTE IMMEDIATE 'DROP view shopitems CASCADE CONSTRAINTS';         
   END IF;
   
   SELECT COUNT(*) INTO FLAG FROM ALL_VIEWS WHERE VIEW_NAME = 'total';   
   IF FLAG >= 0 THEN                
   EXECUTE IMMEDIATE 'DROP view total CASCADE CONSTRAINTS';         
   END IF;
   
   
COMMIT;
    
EXCEPTION
    WHEN WRONG_user THEN
        DBMS_OUTPUT.PUT_LINE('YOU CANNOT PERFORM THIS ACTION INSERT VALUES, PLEASE CONTACT ADMIN');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
    ROLLBACK;
END;
/
-- executing drop views procedure
EXECUTE DROP_VIEWS;

--procedure to create views

/*CREATE OR REPLACE PROCEDURE CREATEVIEWS IS
    FLAG NUMBER := 1;
    CURRENT_USER VARCHAR(15);
    WRONG_user EXCEPTION;
    
BEGIN
    SELECT USER INTO CURRENT_USER FROM DUAL;
    IF (CURRENT_USER <> 'ADMIN_ROLE') THEN
        RAISE WRONG_user;
    END IF;
    SELECT COUNT(*) INTO FLAG FROM ALL_VIEWS WHERE VIEW_NAME = 'CustomerDetails';
    IF FLAG = 0 THEN 
    EXECUTE IMMEDIATE 'create view  CustomerDetailss as select first_name,last_name,address,email,phone ,game_type,total_tickets,date_res 
from login join ticket on login.unique_Id=ticket.unique_id;';
    END IF;
    
-- A view to show emp details
    SELECT COUNT(*) INTO FLAG FROM ALL_VIEWS WHERE VIEW_NAME = 'empDetail';
    IF FLAG = 0 THEN 
    EXECUTE IMMEDIATE '
create view empDetail as select a.first_name employer_fname,a.designation employer_designation ,e.emp_name employee_name,e.job_title,salary,round(MONTHS_BETWEEN(sysdate,hire_date)) as months_since_hired
FROM admin_table a join employee e on a.admin_id=e.admin_id;';
    END IF;
    
    -- A view to show movie details
    SELECT COUNT(*) INTO FLAG FROM ALL_VIEWS WHERE VIEW_NAME = 'showMovies';
    IF FLAG = 0 THEN 
    EXECUTE IMMEDIATE '
create view showMovies as select t.ticket_id,s.show_id,s.show_name,s.genre,s.movie_description,s.show_time
from ticket t join show_movies s on t.ticket_id=s.ticket_id;';
    END IF;
    
    -- A view to show room reservation
    SELECT COUNT(*) INTO FLAG FROM ALL_VIEWS WHERE VIEW_NAME = 'roomreservation';
    IF FLAG = 0 THEN 
    EXECUTE IMMEDIATE '
create view roomreservation AS SELECT ROOM_VIEW,ROOM_COST cost_per_room,NO_OF_ROOMS,DATE_RES,ROOM_TYPE
FROM ROOM_RESERVATION R JOIN PAYMENT P ON R.RID=P.RID;';
    END IF;
    
    -- A view to show shopped items
    SELECT COUNT(*) INTO FLAG FROM ALL_VIEWS WHERE VIEW_NAME = 'shopitems';
    IF FLAG = 0 THEN 
    EXECUTE IMMEDIATE '
create view shopitems AS SELECT l.first_name,s.item_name,s.item_price
from login l join shop s on l.unique_id=s.unique_id order by l.first_name;';
    END IF;
    
    -- A view to show total
    SELECT COUNT(*) INTO FLAG FROM ALL_VIEWS WHERE VIEW_NAME = 'total';
    IF FLAG = 0 THEN 
    EXECUTE IMMEDIATE '
create view total as select l.first_name,t.game_type,t.total_tickets*p.tkt_cost as ticket_cost,
r.no_of_rooms*p.room_cost as tot_room_cost,
f.no_of_ppl*p.food_cost_per_person as tot_food_cost,
((t.total_tickets*p.tkt_cost)+(r.no_of_rooms*p.room_cost)+(f.no_of_ppl*p.food_cost_per_person)) as Total_Amount
from login l join ticket t on l.unique_Id=t.unique_id
join room_reservation r on t.ticket_id=r.ticket_id
join food f on r.rid=f.rid
join payment p on f.fid=p.fid;';
    END IF;

COMMIT;
EXCEPTION
WHEN WRONG_user THEN
        DBMS_OUTPUT.PUT_LINE('YOU CANNOT PERFORM THIS ACTION. PLEASE CONTACT ADMIN');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
    ROLLBACK;
    
END;
/ 
*/

create view  CustomerDetails as select first_name,last_name,address,email,phone ,game_type,total_tickets,date_res 
from login join ticket on login.unique_Id=ticket.unique_id;

create view empDetail as select a.first_name employer_fname,a.designation employer_designation ,e.emp_name employee_name,e.job_title,salary,round(MONTHS_BETWEEN(sysdate,hire_date)) as months_since_hired
FROM admin_table a join employee e on a.admin_id=e.admin_id;

create view showMovies as select t.ticket_id,s.show_id,s.show_name,s.genre,s.movie_description,s.show_time
from ticket t join show_movies s on t.ticket_id=s.ticket_id;

create view roomreservation AS SELECT ROOM_VIEW,ROOM_COST cost_per_room,NO_OF_ROOMS,DATE_RES,ROOM_TYPE
FROM ROOM_RESERVATION R JOIN PAYMENT P ON R.RID=P.RID;

create view shopitems AS SELECT l.first_name,s.item_name,s.item_price
from login l join shop s on l.unique_id=s.unique_id order by l.first_name;

create view total as select l.first_name,t.game_type,t.total_tickets*p.tkt_cost as ticket_cost,
r.no_of_rooms*p.room_cost as tot_room_cost,
f.no_of_ppl*p.food_cost_per_person as tot_food_cost,
((t.total_tickets*p.tkt_cost)+(r.no_of_rooms*p.room_cost)+(f.no_of_ppl*p.food_cost_per_person)) as Total_Amount
from login l join ticket t on l.unique_Id=t.unique_id
join room_reservation r on t.ticket_id=r.ticket_id
join food f on r.rid=f.rid
join payment p on f.fid=p.fid;


select * from CustomerDetails;
select * from empDetail;
select * from roomreservation;
select * from showmovies;
select * from shopitems;
select * from total;
--procedure to create views

/*CREATE OR REPLACE PROCEDURE CREATEVIEWS IS
    FLAG NUMBER := 1;
    CURRENT_USER VARCHAR(15);
    WRONG_user EXCEPTION;
    
BEGIN
    SELECT USER INTO CURRENT_USER FROM DUAL;
    IF (CURRENT_USER <> 'RAGA_PRJCT_FINAL3') THEN
        RAISE WRONG_user;
    END IF;
    SELECT COUNT(*) INTO FLAG FROM ALL_VIEWS WHERE VIEW_NAME = 'CustomerDetails';
    IF FLAG = 0 THEN 
    EXECUTE IMMEDIATE 'create view  CustomerDetailss as select first_name,last_name,address,email,phone ,game_type,total_tickets,date_res 
from login join ticket on login.unique_Id=ticket.unique_id;';
    END IF;
    
-- A view to show emp details
    SELECT COUNT(*) INTO FLAG FROM ALL_VIEWS WHERE VIEW_NAME = 'empDetail';
    IF FLAG = 0 THEN 
    EXECUTE IMMEDIATE '
create view empDetail as select a.first_name employer_fname,a.designation employer_designation ,e.emp_name employee_name,e.job_title,salary,round(MONTHS_BETWEEN(sysdate,hire_date)) as months_since_hired
FROM admin_table a join employee e on a.admin_id=e.admin_id;';
    END IF;
    
    -- A view to show movie details
    SELECT COUNT(*) INTO FLAG FROM ALL_VIEWS WHERE VIEW_NAME = 'showMovies';
    IF FLAG = 0 THEN 
    EXECUTE IMMEDIATE '
create view showMovies as select t.ticket_id,s.show_id,s.show_name,s.genre,s.movie_description,s.show_time
from ticket t join show_movies s on t.ticket_id=s.ticket_id;';
    END IF;
    
    -- A view to show room reservation
    SELECT COUNT(*) INTO FLAG FROM ALL_VIEWS WHERE VIEW_NAME = 'roomreservation';
    IF FLAG = 0 THEN 
    EXECUTE IMMEDIATE '
create view roomreservation AS SELECT ROOM_VIEW,ROOM_COST cost_per_room,NO_OF_ROOMS,DATE_RES,ROOM_TYPE
FROM ROOM_RESERVATION R JOIN PAYMENT P ON R.RID=P.RID;';
    END IF;
    
    -- A view to show shopped items
    SELECT COUNT(*) INTO FLAG FROM ALL_VIEWS WHERE VIEW_NAME = 'shopitems';
    IF FLAG = 0 THEN 
    EXECUTE IMMEDIATE '
create view shopitems AS SELECT l.first_name,s.item_name,s.item_price
from login l join shop s on l.unique_id=s.unique_id order by l.first_name;';
    END IF;
    
    -- A view to show total
    SELECT COUNT(*) INTO FLAG FROM ALL_VIEWS WHERE VIEW_NAME = 'total';
    IF FLAG = 0 THEN 
    EXECUTE IMMEDIATE '
create view total as select l.first_name,t.game_type,t.total_tickets*p.tkt_cost as ticket_cost,
r.no_of_rooms*p.room_cost as tot_room_cost,
f.no_of_ppl*p.food_cost_per_person as tot_food_cost,
((t.total_tickets*p.tkt_cost)+(r.no_of_rooms*p.room_cost)+(f.no_of_ppl*p.food_cost_per_person)) as Total_Amount
from login l join ticket t on l.unique_Id=t.unique_id
join room_reservation r on t.ticket_id=r.ticket_id
join food f on r.rid=f.rid
join payment p on f.fid=p.fid;';
    END IF;

COMMIT;
EXCEPTION
WHEN WRONG_user THEN
        DBMS_OUTPUT.PUT_LINE('YOU CANNOT PERFORM THIS ACTION. PLEASE CONTACT ADMIN');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
    ROLLBACK;
    
END;
/ 
*/
