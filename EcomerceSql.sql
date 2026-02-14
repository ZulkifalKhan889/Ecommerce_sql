#ist step is to import the data but before that create the database for it

create database ecommerce;

use ecommerce;
#create a table first for the data
create table  Sales(
Product_ID varchar(10),
Product_Name varchar(50),
Category varchar(50),

#now the decimal takes two argument 10 is total value like 5678.34 has 6 values and 2 represent values after the comma

Price decimal(10,2),
Discount int,
Tax_rate int,
#stock level means how many units of that specicfic product wa savaliable at that time when a product sold
#it is subtracted from all the products that was bought the left over are called stock 
Stock_level int,
Supplier_ID varchar(10),

#Customer Age Group: The age group of customers who frequently purchase this product (e.g., Teens, Adults, Seniors).
#for now put it as varchar coz it contains hypen

customer_age_group varchar(10),
Customer_location text,
Customer_gender varchar(10),
Shipping_cost decimal(10,2),
Shipping_method varchar(30),

Return_rate decimal(10.2),

#seasonlity means is the product seasonal or not so it contains yes and no
Seasonality varchar(10),

#contains popularity from 0 to 100
Popularity_index int
);



select * from Sales;

#load the file now 

#make the table and then import the excel file to this table 
#it was approx 1000000 rows so we stopped the importing at mid 

select * from Sales;




################################  BASIC SQL #############################

#the revnue or other thing calculated with discount 



#lets check how many rows are loaded there into the sql

select count(*)  as total_rows from Sales;

#Now checking whether our Productid is really unique


#how to check duplicates in a column in mysql
select Product_name , count(*) as count_duplicates
from Sales
group by Product_name
having count(*) > 1
order by count_duplicates desc;

#finding the total revenue 

select sum(Price) from Sales;


#lets display it in Million 

select concat('$', round(sum(Price)/1000000,2) , ' M') as Revenue from sales;


select * from sales;

select round(Price-(Discount/100),2) from sales;
#this is the price after discount 

#now find the totl revenue #Total revenue after discount

select round(sum(Price-(Discount/100))) as Total_revenue from sales;

#find the most expensive product 

select Product_Name, Price from sales
order by Price desc
limit 1;

#another query which is called subquery

select Product_Name , Price
from sales
where Price = (select max(Price) from sales);

#expensive product after discount 

select Product_Name , round(Price-(Discount/100),2) as Price from sales
order by Price desc
limit 1;

#another way to find the most expensive product before Discount
select Product_Name, round(Price-(Discount/100),2) as price from sales
where round(Price-(Discount/100),2)  = (select round(max(Price-(Discount/100)),2) from sales);

select round(max(Price-(Discount/100)),2) from sales;



#find the total_discount company has given in this whole dataset

select concat('$', round(sum(Discount)/1000000,2), ' M') as Total_discount from sales;

#find all the shipping costs 

select sum(Shipping_cost) as Total_shipping_cost 
from sales;

#display all the unique product name in the dataset

select distinct Product_Name from sales

order by Product_Name asc;

#let say how many times each product appears in the datset so we can easily in businees terms 
#that how much each product sold
#so cookbooks item sold the most

select Product_Name, count(*) as product_sold from Sales
group by Product_Name
order by product_sold desc ;



SELECT 
    COUNT(DISTINCT Product_Name) AS total_unique_product
FROM
    sales;

#lets find the revenue of each product  as you can put $ or M to the prod revenue can be done as above concat

select Product_Name ,sum(Price) as total_revenue_per_prod
from sales 
group by Product_Name
order by total_revenue_per_prod;

#now if we look at the cust loc then it contains two pieces info city and country 
#lets split it  now in excel there is a built in function like split but here 
#in mysql we use substring index it takes the column you are splitting the delimiter you want to split on
#and the left one 1 you want to take out or the right one -1 you want to take out can be clear below
select * from sales;


select trim(substring_index(Customer_location, ',', 1)) as city from sales;

#now the thing is that we have some rows that only contain the country name like singapore 
#so what to do with it we run the following 

select case 
when Customer_location like '%,%'
then trim(substring_index(Customer_location, ',', 1))
else Null
end as city 
from sales;


#we dont need to do above as this already takes the city even if it is a single value like singapore
select trim(substring_index(Customer_location, ',', -1))
as country from sales;
#update the tale with city and country 

alter table sales add column City varchar(100);
alter table sales add column Country varchar(100);

update sales
set city = case 
when Customer_location like '%,%'
then trim(substring_index(Customer_location, ',', 1))
else Null
end;

set sql_safe_updates = 0;
select * from sales;

update sales 
set Country = trim(substring_index(Customer_location, ',', -1));


#now i want to do update the columns name like cust_city and cust_country becuase just city and country does not make sense

alter table Sales
rename column City to Cust_City;
alter table sales
rename column Country to Cust_Country;

#we have some null in the city column where country is singapoe the thing is that the singapoe capital is singapore
#so replcae the null with singapore as it is city and country both becuase earlier we just split it in country column only

update sales
set Cust_city = 'Singapore'
where Cust_city  is null;



select * from sales;

#now deleter the customer location column because it is of no use

alter table sales
drop column Customer_location;

#lets bring the city and country after the cust_gender

alter table sales
modify column Cust_city varchar(100) after Customer_gender;

alter table sales 
modify column Cust_country varchar(100) after Cust_city;

#find sales per city

#the null represents singapore which is a country and that is in country column
select Cust_city, concat('$',round(sum(Price)/1000000,2), ' M') as revenue from sales 
group by Cust_city 
order by revenue desc;


#so from the below wuery we have the usa country first in buy list
select Cust_country , sum(Price) from sales
group by Cust_country 
order by sum(Price) desc;

#now what if we want to find out only the india total sales
#just put the filter there usign WHERE

select Cust_country , sum(Price) from sales
where Cust_country = 'India'
group by Cust_country;

#find the country that has got the most Discount

select Cust_country , sum(Discount) as Total_discount from sales
group by Cust_country
order by Total_discount desc
limit 1;

#find which category has been sold the most

select Category , sum(Price) as category_revenue from sales
group by Category 
order by category_revenue desc;


#the tax rate column is inform of percentage like 15 mean 15% tax on the product so 
#and it is diff like in one place the tax rate is different than at another row
#even the tax rate is not same in the same city for a same product as given

select Product_Name, Tax_rate, Cust_city from sales
where product_name = 'Camera' and Cust_city = 'Mumbai';

#find the top 5 most popular product by popularty index

select Product_Name , max(Popularity_index) popularity
from sales
group by Product_Name 
order by popularity desc
limit 5;

#lets find out who are the most customer male or female or Non_binary

select Customer_gender, sum(Price) Total_price from sales
group by Customer_gender 
order by Total_price desc
limit 1 ;


#now find the shipping method where its used the most 
#which shipping method is used the most

select Shipping_method , sum(Price) as total_sales from sales
group by Shipping_method 
order by total_sales desc
limit 1;

#the return rate is also in percentage 
#The percentage of orders for this product that are returned by customers.

#lets find out top 5  product which has returned most by the customer that would be the weak prod

select Product_Name, max(Return_rate) as return_rate from sales
group by Product_Name
order by return_rate  desc
limit 5;


################################# MASTER QUERIES ################################

#INSIGHTS NO 1	

#Finding which age group and genders contribut most to total revenue so that the comapny target it through ads and revenue in fututre 

select customer_age_group , Customer_gender , sum(Price-(Discount/100)) as Revenue from sales
group by customer_age_group, Customer_gender
order by Revenue desc;

#so based on the above insights the company majority customers are female adults from 25 to  44 age they can be targeted through
#ads discounts etc	

#while also the teens female age 25-34 are low revenue company is required to find out why becuase of wrong product, less dicount etc


#### INSIGHTS NO 2#### 

#we took avg mean on avg how often this product returned as we are grouping by product so if
#i group by the product like cookbooks then i need to avg the return rate of all he cookbooks as they will be grouped by 
#so thats why we took group by 

select Product_Name, Category, count(Product_Name) as total_sold, round(avg(Return_rate),2) as return_rate from sales
group by Product_Name, Category
order by total_sold desc;

#now the return rate we find with total_sold mean they are selling the most still there return rate is high mean somethign is wronf 
#with the product maybe reviews are ntoonot good maybe marketing is not good so the company cna focus on it


###### INSIGHTS NO 3 ######
#lets find out the understock item overstock and fit Products like if a product is sold more than it is now in our
#stock then it means it is understock we need it more 
#if a product is sold like 300 but in stock it is 1000 then it means this is overstock like it is more than we need so it 
#means we have spent more money on it or it would cost more storage 

select * from sales;
select Product_Name, Category, Popularity_index, max(Stock_level) as stock_level,
case when Popularity_index > 80 and max(Stock_level)<100 then 'High demand product'
when Popularity_index < 40 and max(Stock_level) > 500 then 'Low demand, Overstocked'
else 'Balanced Product'
end as 'Product_demand_status'
from sales
group by Product_Name, Category, Popularity_index
order by Popularity_index desc;

#so based on the above query all the company products are good when no risk of overstocked ot understocked



########## INSIGHTS NO 4 ################
 
#lets find out the product which has high popularity and also has a good high discount it would mean that the product is popular coz of
#the discount but if the discount is low and the the product is still popular then it shows that the product is strong


#no basically we use avg discount becuase if we have product t-shirt then at one row the discount is 10 at notherrow the disount is
#12 so thats why we use avg for same product we done similarly for p_index 

SELECT 
    Product_Name,
    Category,
    ROUND(AVG(Popularity_index), 2),
    ROUND(AVG(Discount), 2) AS discount,
    CASE
        WHEN
            AVG(Popularity_index) > 50
                AND AVG(Discount) > 10
        THEN
            'Discount_driven_product'
        WHEN
            AVG(Popularity_index) > 50
                AND AVG(Discount) < 5
        THEN
            'Strong Product'
        WHEN
            AVG(Popularity_index) < 50
                AND AVG(Discount) > 10
        THEN
            'Weak Product'
        ELSE 'Avg Product'
    END AS 'Discount_impact'
FROM
    sales
GROUP BY Product_Name , Category
ORDER BY discount DESC;









###################### INSIGHTS NO 6 ########################

#lets find out which country contribute most to the revenue and also has highest return rate

select Cust_country,  sum(Price) as Total_Revenue, avg(Return_rate)
from sales
group by Cust_country 
order by Total_Revenue desc, avg(Return_rate) desc;

#usa contributes more to the total revenue
#now find out the most popular product in usa

select Product_name, sum(Price) as revenue
from sales

where Cust_country = 'USA' 
group by Product_name
order by  revenue
limit 1;


######################## INSIGHTS NO 7 ###################
#dont include this in portfolio because we just calculate the profit for our practice as the profit for this dataset cant be calculated
#because we dont have the column COST 

#the tax-rate does not affect our profit as it is taken form customer and passed it on to the govt so there
#fore no use of tax_rate like  +- in profit formula


select * from sales;
#LETS calculate the another column which contains only the profit from the product and then display the top 10 most profitable product

set sql_safe_updates = 0;
alter table sales add column Profit decimal(10,2);
update sales 
set Profit = round(Price*(1-Discount/100)  - Shipping_cost,2);

alter table sales  drop column Profit;

alter table sales
modify column Profit decimal(10,2) after Price;

select Product_Name, sum(Profit) as Profit from sales
group by Product_Name 
order by Profit desc;


#run again the following to drop it from the dataste

alter table sales drop column Profit;

select * from sales;

##################### Insights no 8 ###################
#imp topic

#AVERAGE ORDER values

#it is the avergae amount of money the cust spends each time they place an order from your website or store 
#totalRevenue/NoOfOrders

#basically what we do is we try to increase the aov its better to work on old customer to spend 70 than 50 than to acquired new customer
#like if the aov is 50 then we can advertise or work to convince the ezisting customer to spend 70 than to acquired new customer

#like if highAov and high number of orders then mean more custmoer we have and a good market
#if highAOV and lowNumerordes then mean the custoomer are high spenders they spend more when enter to store or website
#lowAov and high orders then not that good spending 
#LowAOV lowNumberOrders then maret is dead less customer and also less spending 

#lets find out AOV for our dataset
#but we will find it based on the country alter

select Cust_country , Count(distinct order_ID) as No_Of_Orders,
sum(Price * (1-Discount/100)) as revenue,
revenue/count(distinct order_id) as average_order_value 
from sales
group by Cust_country
#you can place a a filter also here  by using Having
order by average_order_value desc;


#the problem with this query is that we dont have order id so we cant calculate the Average Order value


#Customer segmentation and behavoiur

##################### INSIGHTS NO 9 ####################alter
# find the city vs product popularity
#group by first the product eg jacket then city like tokyo whenever the product is jacket now when both are
#group by we left with the rating in tokyo for that product so we take the avg not the max because there may be a row where 
#somene would rate it 100 thereore we use avg

select Product_Name, Cust_city , 
round(avg(Popularity_index),2) as avg_popularity from sales
group by Product_Name, Cust_city 
order by avg_popularity desc;




############ INSGHTS NO 10 ##############
#which customer spend the most but also return a lot help the company that the revenue from these i greate but return rate
#can hurt the profit
#we are finding the most prefered product for that age but also with most return rate so filter it out also
   
   
select Product_Name,  customer_age_group, sum(Price) as Total_spent, round(avg(return_rate),2) as Avg_return
from sales
group by Product_Name, customer_age_group
having Total_spent > 1300000 and Avg_return > 10
order by Total_spent desc;

########## Insights No 11 ###################
