Create Table brands(		
brand_id	Int	Primary Key,
brand_name	Varchar(20)	Not Null);

Select * From brands;

Copy brands (brand_id, brand_name)
from 'D:\Chrome Donwloads\Data Analyst Projects\SQL Project\Bike Store Relational Database\brands.csv'
Delimiter ','
csv header;

Create Table categories(		
category_id	Int	Primary key,
category_name	varchar(50)	Not Null);

Select * From categories;

Copy categories (category_id, category_name)
from 'D:\Chrome Donwloads\Data Analyst Projects\SQL Project\Bike Store Relational Database\categories.csv'
Delimiter ','
csv header;

Create Table customers(		
customer_id	int	primary key,
first_name	varchar(50)	Not Null,
last_name	varchar(50)	Not Null,
phone	varchar(100),	
email	varchar(100)	Not Null,
street	varchar(100)	Not Null,
city	varchar(100)	Not Null,
state	varchar(100)	Not Null,
zip_code	int);

Select * from customers;

Copy customers(customer_id ,first_name,last_name,phone,email,street,city, state, zip_code)
from 'D:\Chrome Donwloads\Data Analyst Projects\SQL Project\Bike Store Relational Database\customers.csv'
Delimiter ','
csv header;

Create Table order_items(		
order_id	int,
item_id	int,	
product_id	int,	
quantity	int,	
list_price	decimal,
discount	decimal,
primary key (order_id, item_id));

Select * from order_items;

Copy order_items(order_id,item_id,product_id,quantity,list_price,discount)
from 'D:\Chrome Donwloads\Data Analyst Projects\SQL Project\Bike Store Relational Database\order_items.csv'
Delimiter ','
csv header;

create table orders(		
order_id	int	primary key,
customer_id	int,	
order_status	int,	
order_date	date,	
required_date	date,	
shipped_date	date,	
store_id	int,	
staff_id	int);

Select * from orders;

copy orders (order_id,customer_id,order_status,order_date,required_date,shipped_date,store_id,staff_id)
from 'D:\Chrome Donwloads\Data Analyst Projects\SQL Project\Bike Store Relational Database\orders.csv'
delimiter ','
csv header
NULL 'NULL';

create table products(		
product_id	int	primary key,
product_name	varchar(100),	
brand_id	int,	
category_id	int,	
model_year	int,	
list_price	decimal);

Select * from products;

Copy products (product_id,product_name,brand_id,category_id,model_year,list_price)
from 'D:\Chrome Donwloads\Data Analyst Projects\SQL Project\Bike Store Relational Database\products.csv'
delimiter','
csv header;

create table staffs(		
staff_id	int	primary key,
first_name	varchar(100),	
last_name	varchar(100),	
email	varchar(100),	
phone	varchar(100),
active	int,	
store_id	int,	
manager_id	int);	

select * from staffs;


COPY staffs (staff_id, first_name, last_name, email, phone, active, store_id, manager_id)
FROM 'D:\Chrome Donwloads\Data Analyst Projects\SQL Project\Bike Store Relational Database\staffs.csv'
DELIMITER ','
CSV HEADER;


create table stocks(	
store_id	int,
product_id	int,
quantity	int,
primary key (store_id,product_id));	

select * from stocks;

copy stocks(store_id,product_id,quantity)
from 'D:\Chrome Donwloads\Data Analyst Projects\SQL Project\Bike Store Relational Database\stocks.csv'
delimiter','
csv header;

create table stores(		
store_id	int	primary key,
store_name	varchar(100),	
phone	varchar(100),	
email	varchar(100),	
street	varchar(100),	
city	varchar(100),	
state	varchar(100),	
zip_code	int);	

select * from stores;

copy stores(store_id,store_name,phone,email,street,city,state,zip_code)
from 'D:\Chrome Donwloads\Data Analyst Projects\SQL Project\Bike Store Relational Database\stores.csv'
delimiter','
csv header;
	
Select * From brands;
Select * From categories;
Select * from customers;
Select * from order_items;
Select * from orders;
Select * from products;
select * from staffs;
select * from stocks;
select * from stores;

/* Which products generate the highest and lowest total sales revenue?
 → Group by product or category, order by total sales. */

Select * from order_items;
Select * from orders;
Select * from products;

SELECT 
    OI.product_id,
    P.product_name,
    SUM(OI.quantity) AS total_quantity_sold, 
    SUM(OI.quantity * OI.list_price) AS total_revenue
FROM order_items OI
JOIN orders O ON OI.order_id = O.order_id
JOIN products P ON OI.product_id = P.product_id
GROUP BY OI.product_id, P.product_name
ORDER BY total_revenue DESC; --use when show highiest revenue
ORDER BY total_revenue ASC;  --use when show lowest revenue


/* What are the top 5 selling product categories in terms of quantity and revenue?
 → Use aggregation + ranking (window functions or LIMIT). */

Select * from orders;
Select * from order_items;
Select * from products;
Select * From categories;

Select C.category_id, C.category_name,
	SUM(OI.quantity) As Total_quantity_sold,
	Sum(OI.quantity * OI.list_price) As Total_revenue
From order_items OI
Join orders O on O.order_id = OI.order_id
Join products P on OI.product_id = P.product_id
Join categories C on P.category_id = C.category_id
Group by C.category_id, C.category_name
Order by Total_revenue Desc
Limit 5;


/* Which customers are the top buyers in terms of total purchase value?
 → Join customers and sales data, group by customer, use SUM and RANK.*/

Select * from customers;
Select * from order_items;
Select * from orders;

Select C.customer_id, C.first_name,
	Sum(OI.list_price*OI.quantity) as Total_purchase
From order_items OI
Join orders O  on O.order_id = OI.order_id
Join customers C on O.customer_id = C.customer_id
Group by C.customer_id,C.first_name
Order by Total_purchase Desc;
	
/*Which stores are underperforming based on total revenue or average order value?
 → Group by store, calculate total and average order values.*/

Select * from order_items;
Select * from orders;
select * from stores;

Select S.store_id, S.store_name,
	Sum(OI.list_price * OI.quantity) as Total_Revenue,
	Avg(OI.list_price * OI.quantity) as Avg_Order_Value
From order_items OI
Join Orders O on O.order_id = OI.order_id
Join stores S on S.store_id = O.store_id
group by S.store_id, S.store_name
HAVING 
    SUM(OI.list_price * OI.quantity) < 100000 -- threshold for total revenue (can be adjusted)
    OR AVG(OI.list_price * OI.quantity) < 1800  -- threshold for average order value (can be adjusted)
Order by Total_Revenue Desc;

/*How do different customer demographics (e.g., state, city,) affect purchase behavior?
 → Group by customer location, analyze average and total sales.*/

Select * from customers;
Select * from order_items;
Select * from orders;

Select C.State, C.city,
	Sum(OI.list_price * OI.quantity) as Total_Revenue,
	Avg(OI.list_price * OI.quantity) as Avg_Order_Value
From order_items OI
Join Orders O on O.order_id = OI.order_id
Join customers C on C.customer_id = O.customer_id
group by C.State, C.city
order by Total_Revenue Desc;

/*What are the monthly sales trends over the past year?
 → Use date functions and grouping by MONTH.*/

Select * from order_items;
Select * from orders;

Select 
	DATE_TRUNC('month',	O.order_date) as month,
	Sum(OI.list_price * OI.quantity) as Total_Revenue
From order_items OI
Join Orders O on O.order_id = OI.order_id
group by month
order by month;

/*Which staff members are generating the most sales?
 → Join staff and sales tables, group and rank.*/

Select * from order_items;
Select * from orders;
select * from staffs;

Select S.store_id, S.staff_id, S.first_name,S.last_name,
    COUNT(DISTINCT O.order_id) AS Orders_Handled,
    SUM(OI.list_price * OI.quantity) AS Total_Revenue_Staff,
    RANK() OVER (ORDER BY SUM(OI.list_price * OI.quantity) DESC) AS Sales_Rank
from order_items OI
Join Orders O on O.order_id = OI.order_id
Join Staffs S on O.staff_id = S.staff_id
group by S.store_id, S.staff_id, S.first_name,S.last_name
order by Total_Revenue_Staff Desc;

/*What is the average order value by store and by product category?
 → Join tables, group by store and category.*/


Select * From categories;
Select * from order_items;
Select * from orders;
Select * from products;
select * from stores;


Select S.store_id,S.store_name,C.category_name,
	Avg(OI.quantity * OI.list_price) as Avg_order_value
from order_items OI
join orders O on O.order_id = OI.order_id
join products P on OI.product_id = P.product_id
join categories C on C.category_id = P.category_id
Join stores S on S.store_id = O.store_id
group by S.store_id,S.store_name,C.category_name
order by Avg_order_value Desc;

/*Are there any seasonal trends in product sales (e.g., certain categories doing better in certain months)?
 → Use date filtering, group by month and category.*/

Select * From categories;
Select * from order_items;
Select * from orders;
Select * from products;


SELECT 
	to_Char(date_trunc('month',O.order_date), 'Mon YYYY') as Month_year,
	C.category_id, C.category_name,
	SUM(OI.list_price * OI.quantity) AS Total_monthly_revenue
from order_items OI
Join orders O on O.order_id = OI.order_id
Join products P on OI.product_id = P.product_id
Join categories C on P.category_id = C.category_id
Group by Month_year, C.category_id, C.category_name
Order by Total_monthly_revenue Desc;	

/*What is the repeat customer rate, and who are the most loyal customers?
 → Count distinct invoices per customer, identify those with multiple purchases.*/

Select * from customers;
Select * from order_items;
Select * from orders;

Select 
	C.Customer_id, C.first_name, C.last_name,
	COUNT(DISTINCT O.order_id) AS total_orders,
	sum (OI.quantity*OI.list_price) as total_purchase
from order_items OI
join orders O on O.order_id = OI.order_id
Join customers C on C.customer_id = O.customer_id
group by C.Customer_id, C.first_name, C.last_name
HAVING COUNT(DISTINCT O.order_id) > 1
order by total_purchase Desc;

SELECT 
    ROUND(
        COUNT(DISTINCT CASE WHEN order_count > 1 THEN customer_id END)::DECIMAL 
        / COUNT(DISTINCT customer_id), 2
    ) AS repeat_customer_rate
FROM 

(SELECT C.customer_id,
    COUNT(DISTINCT O.order_id) AS order_count
    FROM customers C
    JOIN orders O ON O.customer_id = C.customer_id
    GROUP BY C.customer_id
) AS customer_orders;