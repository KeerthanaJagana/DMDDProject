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
-- Function to calculate total number of tickets sold
CREATE OR REPLACE FUNCTION total_tickets_sold RETURN NUMBER
AS
v_total_tickets NUMBER;
BEGIN
SELECT SUM(total_tickets) INTO v_total_tickets FROM Ticket;
RETURN v_total_tickets;
END;


