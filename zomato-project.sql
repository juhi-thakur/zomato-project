create database zomato;
use zomato;
drop table if exists goldusers_signup;
CREATE TABLE goldusers_signup(userid integer,gold_signup_date date); 
INSERT INTO goldusers_signup(userid,gold_signup_date) VALUES (1,"2017-09-22"), (3,"2017-04-21");
drop table if exists users; 
CREATE TABLE users(userid integer,signup_date date);
INSERT INTO users(userid,signup_date) VALUES (1,'2014-09-02'),(2,'2015-01-15'),(3,'2014-04-11');
drop table if exists sales;
CREATE TABLE sales(userid integer,created_date date,product_id integer); 
INSERT INTO sales(userid,created_date,product_id) VALUES (1,'2017-04-19',2),(3,'2019-12-18',1),(2,'2020-07-20',3),(1,'2019-10-23',2),(1,'2018-03-19',3),(3,'2016-12-20',2),
(1,'2016-11-09',1),(1,'2016-05-20',3),(2,'2017-09-24',1),(1,'2017-03-11',2),(1,'2016-03-11',1),(3,'2016-11-10',1),(3,'2017-12-07',2),(3,'2016-12-15',2),(2,'2017-11-08',2),
(2,'2018-09-10',3);
drop table if exists product;
CREATE TABLE product(product_id integer,product_name text,price integer);
INSERT INTO product(product_id,product_name,price) VALUES (1,'p1',980), (2,'p2',870),(3,'p3',330);

/* what is the total amount each customer spent on zomato? */
select s.userid , s.product_id, p.price from sales s join product p on s.product_id = p.product_id;
select s.userid , s.product_id , p.price from sales s join product p using (product_id);

select s.userid , sum(p.price) as total_amount from sales s join product p using (product_id) group by s.userid;

/* how many days has each customer visited zomato? */
select userid , count(distinct created_date) as total_days from sales group by userid;

/* what was the first product purchased by each customer */
select s.userid , s.created_date, p.product_name from sales s join product p using (product_id) where s.created_date = (select min(created_date) from sales where userid = s.userid ) order by userid;


/* what is the most purchased item on the menu and how many times was it purchased by all customers; */
select  p.product_name , count(s.product_id) as purchase_count from sales s join product p using (product_id) group by p.product_name order by purchase_count desc limit 1;

/* which item was the most popular for each customer?*/
select s.userid , p.product_name, count(s.product_id) as product_count from sales s join product p using (product_id) group by s.userid , p.product_name 
having count(s.product_id) = (select max(product_count) from (select count(*) as product_count from sales s1 where s1.userid = s.userid group by s1.product_id ) as subquery )
order by s.userid;

/* which item was purchased by the customer after they became a member? */
select s.userid , p.product_name , s.created_date from sales s join users u using (userid) join product p on p.product_id = s.product_id where s.created_date > u.signup_date;

select s.userid , s.created_date , s.product_id , g.gold_signup_date from sales s join goldusers_signup g using (userid) where created_date >= gold_signup_date order by created_date limit 2;
	