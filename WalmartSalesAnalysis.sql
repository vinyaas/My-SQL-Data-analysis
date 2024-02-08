-- ----------------------------------------Walmart Sales Data Analysis------------------------------------------------------
-- -------------------------------https://www.kaggle.com/c/walmart-recruiting-store-sales-forecasting------------------------
/* 
	The major aim of thie project is to gain insight into the sales data of Walmart and 
    to understand the different factorsthat affect sales of the different branches.
    
    -------------------------------------------Analysis List------------------------------------------------
1. Product Analysis
	Conduct analysis on the data to understand the different product lines, the products lines performing best and the product lines that need to be improved.

2. Sales Analysis
	This analysis aims to answer the question of the sales trends of product. The result of this can help use measure the effectiveness of each sales strategy the business applies and what modificatoins are needed to gain more sales.

3. Customer Analysis
	This analysis aims to uncover the different customers segments, purchase trends and the profitability of each customer segment.
*/
-- --------------------------------------------DATA WRANGLING---------------------------------------------

CREATE DATABASE IF NOT EXISTS salesdatawalmart ;

-- Create table
CREATE TABLE IF NOT EXISTS sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    tax_pct FLOAT(6) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT(11),
    gross_income DECIMAL(12, 4),
    rating FLOAT(2)
);

-- -------------------------------------------------FEATURE ENGINEERING --------------------------------------------------------
/* 1. Add a new column named time_of_day to give insight of sales in the Morning, Afternoon and Evening.
      This will help answer the question on which part of the day most sales are made.
*/

SELECT
	time,
	(CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END) AS time_of_day
FROM sales;

-- Creating time_of_day column

ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);

-- Inserting the data to the new column

UPDATE sales SET time_of_day = (
	CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END
);

/* 2. Add a new column named day_name that contains the extracted days of the week on which the given transaction took place (Mon, Tue, Wed, Thur, Fri). 
This will help answer the question on which week of the day each branch is busiest. 
*/

SELECT date , dayname(date) as day_name from sales;

-- creating day_name column 
ALTER TABLE SALES ADD COLUMN day_name varchar(20);

-- Inserting the new data to the column  
UPDATE SALES SET day_name = (dayname(date));

/* Add a new column named month_name that contains the extracted months of the year on which the given transaction took place (Jan, Feb, Mar).
 Help determine which month of the year has the most sales and profit
*/

SELECT date , monthname(date) as month_name from sales;

-- Creating a new column month_name
ALTER TABLE sales ADD COLUMN month_name VARCHAR(20);

-- Inserting the data to the month_name 
UPDATE sales SET month_name = ( monthname(date));

-- ---------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------- EXPLORATORY DATA ANALYSIS ------------------------------------
-- ---------------- --------------------------------------GENERIC QUESTIONS --------------------------------------------

-- how many unique cities does the data have ? 
select distinct(city) from sales ;

-- how many branches do we have ?
select distinct(branch) from sales;

-- which city has which branch ?
select distinct(city) , branch from sales;

-- how many branches does each city have ?
select city , count(branch) as num_of_branches from sales
group by city;

-- ------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------- product questions ------------------------------------------------

-- How many unique product lines does the data have?
select distinct(product_line) from sales;

-- What is the most common payment method?
select payment , count(payment) as payment_method from sales
group by payment
order by payment_method desc;

-- What is the most selling product line?
select product_line , count(product_line)  from sales 
group by product_line 
order by count(product_line) desc;

-- What is the total revenue by month?
select month_name , sum(unit_price) as revenue from sales 
group by month_name
order by revenue desc;

-- What month had the largest COGS?
select month_name , sum(cogs) as cogs from sales 
group by month_name
order by cogs desc
limit 1 ;

-- What product line had the largest revenue?
select product_line , sum(unit_price) as revenue from sales 
group by product_line 
order by revenue desc
limit 1 ;

-- What is the city with the largest revenue?
select city , sum(unit_price) as revenue from sales
group by city 
order by revenue desc 
limit 1 ;

-- What product line had the largest VAT?
select product_line , avg(tax_pct) as vat from sales 
group by product_line
order by vat desc  ;

-- Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales
select avg(quantity) from sales;

select product_line , (
	CASE 
		WHEN avg(quantity) > 5.5 then "GOOD"
        ELSE "BAD"
        END
) AS Remark
from sales
group by product_line ;

-- Which branch sold more products than average product sold?
select branch , sum(quantity) from sales 
group by branch
having sum(quantity) > ( select avg(quantity) from sales);

-- What is the most common product line by gender?
select product_line , gender , count(gender) as total from sales 
group by gender , product_line
order by count(gender) desc ;

-- What is the average rating of each product line?
select product_line , round(avg(rating),2) from sales 
group by product_line ;

-- --------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------- SALES  ANALYSIS ---------------------------------------------------

-- Number of sales made in each time of the day per weekday
SELECT day_name , time_of_day , count(*) from sales 
group by time_of_day  , day_name;

-- Which of the customer types brings the most revenue?
select customer_type , sum(total)  as total_revenue from sales
group by customer_type
order by total_revenue desc;

-- Which city has the largest tax percent/ VAT (Value Added Tax)?
select city  , avg(tax_pct) from sales
group by city;

-- Which customer type pays the most in VAT?
select customer_type  , avg(tax_pct) from sales 
group by customer_type;

-- What is the gender distribution per branch?
select branch , gender , count(gender) from sales
group by branch , gender
order by branch;

-- Which time of the day do customers give most ratings?
select time_of_day , count(*) as total_ratings from sales
group by time_of_day;

---------------------------------------------------------------------------------------------------------------------------------------------------------

