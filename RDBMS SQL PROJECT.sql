create database mprdbms;





use mprdbms;

--  SQL II - Mini Project 

 
-- Composite data of a business organisation, confined to ‘sales and delivery’ domain is given for the period of last decade. From the given data retrieve solutions for the given scenario. 
 
# 1.	Join all the tables and create a new table called combined_table. 
-- (market_fact, cust_dimen, orders_dimen, prod_dimen, shipping_dimen) 

 
 
 
  create table combined_table as 
 select ord_id from 
 (select m.ord_id from market_fact m left  join  cust_dimen c on c.cust_id=m.cust_id left   join orders_dimen o on o.ord_id = m.ord_id left join
 prod_dimen p on p.prod_id= m.prod_id left join shipping_dimen s on s.ship_id = m.ship_id  union 
  select m.ord_id from market_fact m right  join  cust_dimen c on c.cust_id=m.cust_id right   join orders_dimen o on o.ord_id = m.ord_id right join
 prod_dimen p on p.prod_id= m.prod_id right join shipping_dimen s on s.ship_id = m.ship_id)combined_table;
 
 
#2.	Find the top 3 customers who have the maximum number of orders 
 
 

-- window function 
 select * from cust_dimen where cust_id in 
 (select cust_id from 
 (select cust_id, order_quantity, dense_rank()over(order by order_quantity desc) c from market_fact   )t1 where  c=1 or c=2 or c=3  );
 

#3.	Create a new column DaysTakenForDelivery that contains the date difference of Order_Date and Ship_Date. 



 select datediff(str_to_date(s.ship_date,'%d-%m-%Y'),str_to_date(o.order_date,'%d-%m-%Y') ) DaysTakenForDelivery
 from shipping_dimen s join orders_dimen o on o.order_id = s.order_id  order by DaysTakenForDelivery desc ;
-- Note the date in text form so date is converted into date format using str_date .



#4.	Find the customer whose order took the maximum time to get delivered.
drop table df;
create table df as 
 (select (datediff(str_to_date(s.ship_date,'%d-%m-%Y'),str_to_date(o.order_date,'%d-%m-%Y') )) DaysTakenForDelivery
 from shipping_dimen s join orders_dimen o on o.order_id = s.order_id join market_fact m on m.ord_id = o.ord_id  join cust_dimen c on c.cust_id = m.cust_id )
;
select count(cust_id) from  cust_dimen where customer_name = (select customer_name from df where DaysTakenForDelivery = (select max(DaysTakenForDelivery) from df));

 

 
#5.	Retrieve total sales made by each product from the data (use Windows function)

 
  select distinct sum(sales)over(partition by prod_id) total_sales  , prod_id from market_fact;
  
  
#6.	Retrieve total profit made from each product from the data (use windows function) 


  select distinct sum(profit)over(partition by prod_id) total_profit  , prod_id from market_fact;
  
  
  
  
#7.	Count the total number of unique customers in January and how many of them came back every month over the entire year in 2011 
 
 
 select  count(cust_id) from cust_dimen where cust_id in (select cust_id from market_fact where
 ord_id in (select ord_id from orders_dimen where month(str_to_date(order_date,'%d-%m-%Y'))= 1         )) ;
 
  select  count(cust_id) from cust_dimen where cust_id in (select cust_id from market_fact where
 ord_id in (select ord_id from orders_dimen where month(str_to_date(order_date,'%d-%m-%Y'))= 1 and year(str_to_date(order_date,'%d-%m-%Y'))=2011 
 and month(str_to_date(order_date,'%d-%m-%Y')) =2  and month(str_to_date(order_date,'%d-%m-%Y')) =3
 and month(str_to_date(order_date,'%d-%m-%Y')) =4
 and month(str_to_date(order_date,'%d-%m-%Y')) =5
 and month(str_to_date(order_date,'%d-%m-%Y')) =6
 and month(str_to_date(order_date,'%d-%m-%Y')) =7
 and month(str_to_date(order_date,'%d-%m-%Y')) =8
 and month(str_to_date(order_date,'%d-%m-%Y')) =9 and month(str_to_date(order_date,'%d-%m-%Y')) =10
  and month(str_to_date(order_date,'%d-%m-%Y')) =11
 and month(str_to_date(order_date,'%d-%m-%Y')) =12 
 
 
 ) 
 
 
 
 
 ) ;
 
 
#8.	Retrieve month-by-month customer retention rate since the start of the business.(using views) 



#Tips:  
#1: Create a view where each user’s visits are logged by month, allowing for
# the possibility that these will have occurred over multiple # years since whenever business started operations 
# 2: Identify the time lapse between each visit. 
# So, for each person and for each month, we see when the next visit is. # 3: Calculate the time gaps between visits 
# 4: categorise the customer with time gap 1 as retained, >1 as irregular and 
#NULL as churned 
# 5: calculate the retention month wise 
  select * from market_fact;
 select * from cust_dimen;
select * from orders_dimen;
 select * from prod_dimen;
 select * from shipping_dimen;

