set serveroutput on;


CREATE TABLE Login (
uniqueId NUMBER(10),
  	first_name VARCHAR(20) ,
  	last_name VARCHAR(20) ,
  	phone NUMBER(10) ,
  	address VARCHAR(20) ,
  	email VARCHAR(20) ,
  	password VARCHAR(20) NOT NULL,
  	PRIMARY KEY (uniqueid)
);


CREATE TABLE Ticket (
  	ticket_id NUMBER(10),
  	game_type NUMBER(10),
  	no_of_adult NUMBER(10),
  	no_of_child NUMBER(10),
  	total_tickets NUMBER(10),
   date_res DATE,
  	unique_id NUMBER(10),
  	PRIMARY KEY (ticket_id),
  	FOREIGN KEY (unique_id) REFERENCES Login(uniqueId)	
);

Create table customer_ticket_details(
cusTicket_id number(10),
first_name VARCHAR(20),
last_name VARCHAR(20),
age_category number(10),
gender VARCHAR(20),
PRIMARY KEY (cusTicket_id),
ticket_id NUMBER(10),
FOREIGN KEY (ticket_id) REFERENCES TICKET(ticket_id)
);

CREATE TABLE Room_Reservation (
  	rid NUMBER(10),
  	no_of_rooms NUMBER(20) ,
  	room_view VARCHAR(20) ,
  	date_res DATE ,
  	room_type VARCHAR(20),
  	food VARCHAR(20),
  	custkt_id NUMBER(10),
  	PRIMARY KEY (rid),
	FOREIGN KEY (custkt_id) REFERENCES customer_ticket_details(cusTicket_id)
	
);

CREATE TABLE PAYMENT(
Pid NUMBER(10),
tot_tkt_cost_adult Number(10),
tot_tkt_cost_child Number(10),
room_cost number(10),
pay_mode varchar(20),
card_details number(20),
rid number(10),
PRIMARY KEY (Pid),
FOREIGN KEY (rid) REFERENCES room_reservation(rid),
unique_id NUMBER(10),
FOREIGN KEY (unique_id) REFERENCES Login(uniqueId),
ticket_id NUMBER(10),
FOREIGN KEY (ticket_id) REFERENCES TICKET(ticket_id)
);

/*Insert values into Login*/
INSERT INTO Login (uniqueId, first_name, last_name, phone, address, email, password)
VALUES (1234567890, 'John', 'Doe', 1234567890, '123 Main St', 'johndoe@example.com', 'password123');

INSERT INTO Login (uniqueId, first_name, last_name, phone, address, email, password)
VALUES (101, 'pop', 'Doe', 1237867890, 'chilcot', 'popdoe@example.com', 'pop78');

INSERT INTO Login (uniqueId, first_name, last_name, phone, address, email, password)
VALUES (102, 'susan', 'Doe', 1234567890, 'Boylston', 'susandoe@example.com', 'susan123');

INSERT INTO Login (uniqueId, first_name, last_name, phone, address, email, password)
VALUES (103, 'wan', 'Doe', 1234567890, 'Fenway', 'wandoe@example.com', 'wan123');

INSERT INTO Login (uniqueId, first_name, last_name, phone, address, email, password)
VALUES (104, 'ron', 'Doe', 1234567890, 'Boston', 'rondoe@example.com', 'ron123');

INSERT INTO Login (uniqueId, first_name, last_name, phone, address, email, password)
VALUES (105, 'tom', 'Doe', 1234567890, '123 Main St', 'tomdoe@example.com', 'tom123');


/*Insert values into Ticket*/
INSERT INTO Ticket (ticket_id, game_type, no_of_adult, no_of_child, total_tickets, date_res, unique_id)
VALUES (1, 123, 2, 1, 3, TO_Date('2023-09-01','yyyy-mm-dd'), 101);

INSERT INTO Ticket (ticket_id, game_type, no_of_adult, no_of_child, total_tickets, date_res, unique_id)
VALUES (2, 123, 1, 2, 3, TO_Date('2023-07-05','yyyy-mm-dd'), 102);

INSERT INTO Ticket (ticket_id, game_type, no_of_adult, no_of_child, total_tickets, date_res, unique_id)
VALUES (3, 124, 4, 1, 5, TO_Date('2023-05-05','yyyy-mm-dd'), 103);

INSERT INTO Ticket (ticket_id, game_type, no_of_adult, no_of_child, total_tickets, date_res, unique_id)
VALUES (4, 123, 1, 1, 2, TO_Date('2023-04-01','yyyy-mm-dd'), 104);

INSERT INTO Ticket (ticket_id, game_type, no_of_adult, no_of_child, total_tickets, date_res, unique_id)
VALUES (5, 123, 2, 1, 3, TO_Date('2023-09-01','yyyy-mm-dd'), 105);


/*Insert values into CustomerTicketDetails*/
INSERT INTO customer_ticket_details (cusTicket_id, first_name, last_name, age_category, gender, ticket_id)
VALUES (11, 'pop', 'Doe', 23, 'Male', 1);

INSERT INTO customer_ticket_details (cusTicket_id, first_name, last_name, age_category, gender, ticket_id)
VALUES (22, 'susan', 'Doe', 9, 'Male', 2);

INSERT INTO customer_ticket_details (cusTicket_id, first_name, last_name, age_category, gender, ticket_id)
VALUES (33, 'wan', 'Doe', 8, 'Male', 3);

INSERT INTO customer_ticket_details (cusTicket_id, first_name, last_name, age_category, gender, ticket_id)
VALUES (44, 'ron', 'Doe', 29, 'Male', 4);

INSERT INTO customer_ticket_details (cusTicket_id, first_name, last_name, age_category, gender, ticket_id)
VALUES (55, 'tom', 'Doe', 30, 'Male', 5);


/*Insert values into Room_Reservation*/
INSERT INTO Room_Reservation (rid, no_of_rooms, room_view, date_res, room_type, food, custkt_id)
VALUES (111, 2, 'Ocean View', TO_Date('2023-04-01','yyyy-mm-dd'), 'Deluxe', 'Breakfast', 11);

INSERT INTO Room_Reservation (rid, no_of_rooms, room_view, date_res, room_type, food, custkt_id)
VALUES (222, 3, 'Garden View', TO_Date('2023-05-01','yyyy-mm-dd'), 'Standard', 'Lunch Dinner', 22);

INSERT INTO Room_Reservation (rid, no_of_rooms, room_view, date_res, room_type, food, custkt_id)
VALUES (333, 1, 'Front view', TO_Date('2023-08-01','yyyy-mm-dd'), 'Deluxe', 'Breakfast Lunch', 33);

INSERT INTO Room_Reservation (rid, no_of_rooms, room_view, date_res, room_type, food, custkt_id)
VALUES (444, 4, 'Ocean View', TO_Date('2023-05-01','yyyy-mm-dd'), 'Super Deluxe', 'Breakfast', 44);

INSERT INTO Room_Reservation (rid, no_of_rooms, room_view, date_res, room_type, food, custkt_id)
VALUES (555, 3, 'Garden View', TO_Date('2023-06-01','yyyy-mm-dd'), 'Standard', 'Dinner', 55);


/*Insert values into Payment*/
INSERT INTO PAYMENT (Pid,tot_tkt_cost_adult, tot_tkt_cost_child, room_cost, pay_mode, card_details, rid, unique_id, ticket_id)
VALUES (1011,100, 50, 200, 'credit card', 1234567890123456, 111, 101, 1);

INSERT INTO PAYMENT (Pid,tot_tkt_cost_adult, tot_tkt_cost_child, room_cost, pay_mode, card_details, rid, unique_id, ticket_id)
VALUES (1022,100, 50, 100, 'upi', 567, 222, 102, 2);

INSERT INTO PAYMENT (Pid,tot_tkt_cost_adult, tot_tkt_cost_child, room_cost, pay_mode, card_details, rid, unique_id, ticket_id)
VALUES (1033,100, 50, 150, 'credit card', 1345678876543, 333, 103, 3);

INSERT INTO PAYMENT (Pid,tot_tkt_cost_adult, tot_tkt_cost_child, room_cost, pay_mode, card_details, rid, unique_id, ticket_id)
VALUES (1044,100, 50, 250, 'online', 1234567890123456, 444, 104, 4);

INSERT INTO PAYMENT (Pid,tot_tkt_cost_adult, tot_tkt_cost_child, room_cost, pay_mode, card_details, rid, unique_id, ticket_id)
VALUES (1055,100, 50, 100, 'credit card', 3456787654, 555, 105, 5);




/*view1- SHOW CUSTOMER DETAILS*/
create view  CustomerDetailsT as select first_name,last_name,address,email,phone ,total_tickets from login join ticket on login.uniqueId=ticket.unique_id;

/*view2- SHOW TICKET DETAILS AND RESERVED DATE*/
create view tiktDetails as select game_type,no_of_adult,no_of_child,date_res Date_Of_Reservation from ticket;

/*view3- SHOW ROOM RESERVATION */
create view ROOMRES AS SELECT ROOM_VIEW,NO_OF_ROOMS,DATE_RES,ROOM_TYPE,FOOD,ROOM_COST FROM ROOM_RESERVATION R JOIN PAYMENT P ON R.RID=P.RID;

/*view4- total amount */
create view total as select l.first_name,l.last_name,t.no_of_adult*p.tot_tkt_cost_adult as TotalAdultTicketPrice,
t.no_of_child*p.tot_tkt_cost_child as TotalChildTicketPrice,
r.no_of_rooms*p.room_cost as RoomTotal 
from Login l join ticket t on l.uniqueId=t.unique_id 
join customer_ticket_details ct on t.ticket_id=ct.ticket_id
join Room_Reservation r on ct.cusTicket_id=r.custkt_id
join payment p on r.rid=p.rid;




select * from CustomerDetailsT;

select * from tiktDetails;

select * from roomres;

select * from total;



