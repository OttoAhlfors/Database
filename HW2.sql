/*
a) Partition the Orders table using orderdate with the following constraints:
  1. Orders between: 20060703 00:00:00.000 and 20070205 00:00:00.000
  2. Orders between: 20070205 00:00:00.000 and 20070819 00:00:00.000
  3. Orders between: 20070819 00:00:00.000 and 20080123 00:00:00.000
  4. Orders between: 20080123 00:00:00.000 and 20080507 00:00:00.000

b) Alter the third partition and add a contraint where the freight cost is higher than 50 €
c) Alter the fourth partition and add a constraint that the shipped date should not be null
d) Create two partitions of the first partition (so a partition of partitions) using shipcountry so that:
  1. Orders shipped to USA and UK are in one
  2. Orders shipped to Germany and Finland are in another

e) How many rows are in each partition?
*/

Drop table if exists Orders, orders_1, orders_2, orders_3, orders_4, orders_USA_UK, orders_FIN_GER cascade;

CREATE TABLE if not exists Orders
(
  orderid        INT          NOT NULL,
  custid         INT          NULL,
  empid          INT          NOT NULL,
  orderdate      TIMESTAMP     NOT NULL,
  requireddate   TIMESTAMP     NOT NULL,
  shippeddate    TIMESTAMP     NULL,
  shipperid      INT          NOT NULL,
  freight        MONEY        NOT NULL
    CONSTRAINT DFT_Orders_freight DEFAULT(0),
  shipname       VARCHAR(40) NOT NULL,
  shipaddress    VARCHAR(60) NOT NULL,
  shipcity       VARCHAR(15) NOT NULL,
  shipregion     VARCHAR(15) NULL,
  shippostalcode VARCHAR(10) NULL,
  shipcountry    VARCHAR(15) NOT NULL 
) PARTITION BY RANGE (orderdate); 

-- task A, order partitions
CREATE TABLE if not exists Orders_1 PARTITION OF Orders
	FOR VALUES from ('2006-07-03 00:00:00.000') to ('2007-02-05 00:00:00.000')
	PARTITION BY LIST (shipcountry);
	
CREATE TABLE if not exists Orders_2 PARTITION OF Orders
	FOR VALUES from ('2007-02-05 00:00:00.000') to ('2007-08-19 00:00:00.000');
	
CREATE TABLE if not exists Orders_3 PARTITION OF Orders
	FOR VALUES from ('2007-08-19 00:00:00.000') to ('2008-01-23 00:00:00.000');
	
CREATE TABLE if not exists Orders_4 PARTITION OF Orders
	FOR VALUES from ('2008-01-23 00:00:00.000') to ('2008-05-07 00:00:00.000');

-- task B, first constraint 
Alter table orders_3 add constraint freight_over50 check(freight > 50::money);

-- task C, second constraint
Alter table orders_4 add constraint shipdate_notnull check(shippeddate IS NOT NULL);

-- task D, partition of partition
CREATE TABLE if not exists Orders_USA_UK PARTITION OF Orders_1
	FOR VALUES IN ('USA', 'UK');
	
CREATE TABLE if not exists Orders_FIN_GER PARTITION OF Orders_1
	FOR VALUES IN ('Finland', 'Germany');
	
	
-- Inserts come here

-- End of inserts
	
	
-- task E, count rows
-- count 70
SELECT COUNT(*) FROM Orders_1;
-- count 200
SELECT COUNT(*) FROM Orders_2;
-- count 101
SELECT COUNT(*) FROM Orders_3;
-- count 209
SELECT COUNT(*) FROM Orders_4;
-- count 38
SELECT COUNT(*) FROM Orders_USA_UK;
-- count 32
SELECT COUNT(*) FROM Orders_FIN_GER;



