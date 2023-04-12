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