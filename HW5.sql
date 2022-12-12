/*
a) Create the following roles: user, manager, owner. Grant all privileges to owner, read privileges to user, and insert privileges to manager.
b) Create a new role: trainee. Grant privileges only to columns orderdate and shippeddate to trainee and set the role valid until 30.5.2022.
c) Create a function get_shipping_info(varchar) that returns a table. The table should have the following columns shipname, shipaddress, shipcity, shipcountry. 
   The function should return orders where the shipname matches the given string.
d) Extend the function in c) so that it accepts three parameters: get_shipping_info(varchar, timestamp, money). 
   The function should return orders where the shipname matches the given string, orderdate is equal or earlier than the given timestamp and finally, freight cost is +-10€ from the given money.
*/

-- task A, create three roles and grant desired privileges
CREATE ROLE manager;
CREATE ROLE me_user;
CREATE ROLE me_owner;

GRANT ALL PRIVILEGES ON Orders TO me_owner;
GRANT SELECT ON Orders TO me_user;
GRANT insert ON Orders TO manager;

-- task B, trainee role, valid until 30.5.2022
CREATE ROLE trainee VALID UNTIL '2022-05-30';

GRANT ALL(orderdate, shippeddate) ON Orders TO trainee;

-- task C, function to get info by shipname
CREATE FUNCTION get_shipping_info(name varchar) RETURNS TABLE(shipname varchar, shipaddress varchar, shipcity varchar, shipcountry varchar)
LANGUAGE SQL
AS $$
	SELECT shipname, shipaddress, shipcity, shipcountry FROM Orders WHERE shipname = name
$$;

-- task C -- funtion call
SELECT * FROM get_shipping_info('Ship to 85-B');

-- task D not done
								
								