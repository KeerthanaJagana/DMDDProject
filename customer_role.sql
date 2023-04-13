--PROCEDURE 
SET SERVEROUTPUT ON
BEGIN 
   ADMIN_ROLE.login_pkg.update_password(11,'Johnpassword123'); 
END;
/


SELECT * FROM ADMIN_ROLE.LOGIN;

