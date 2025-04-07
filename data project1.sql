-- source: https://www.youtube.com/watch?v=ChIQjGBI3AM
-- Data cleaning
SELECT * FROM `spiritual-grove-451916-k6.p1.p` 

SELECT count(*) FROM `spiritual-grove-451916-k6.p1.p` 

select * from `spiritual-grove-451916-k6.p1.p` 
where transactions_id is null
or sale_date is null
or sale_time is null
or gender is null
or quantiy is null
or total_sale is null
or price_per_unit is null
or cogs is null

DELETE FROM `spiritual-grove-451916-k6.p1.p` 
where gender is null
or quantiy is null
or total_sale is null
or price_per_unit is null
or cogs is null

SELECT count(*) as total_sale FROM `spiritual-grove-451916-k6.p1.p` 

-- number of unique customer
SELECT count(distinct customer_id) as total_sale FROM `spiritual-grove-451916-k6.p1.p` 

-- data analysis
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
SELECT * FROM `spiritual-grove-451916-k6.p1.p` 
where sale_date = '2022-11-05'


-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
SELECT * FROM `spiritual-grove-451916-k6.p1.p` 
where category = 'Clothing' and  FORMAT_DATE('%Y-%m', sale_date) = '2022-11' and quantiy>=4


-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT category, sum(total_sale) as total_sale, count(*) as total_order FROM `spiritual-grove-451916-k6.p1.p` 
group by category

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

SELECT round(avg(age),2) FROM `spiritual-grove-451916-k6.p1.p` 
where category = 'Beauty' 

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT * FROM `spiritual-grove-451916-k6.p1.p` 
where total_sale>1000

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

SELECT gender, category, count(*) as transactions FROM `spiritual-grove-451916-k6.p1.p` 
group by gender, category
order by 1

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
WITH monthly_avg AS (
  SELECT 
    EXTRACT(YEAR FROM sale_date) AS year,
    EXTRACT(MONTH FROM sale_date) AS month,
    AVG(total_sale) AS avg_sale
  FROM `spiritual-grove-451916-k6.p1.p`
  GROUP BY year, month
)

SELECT 
  year,
  month,
  avg_sale
FROM (
  SELECT 
    *,
    RANK() OVER(PARTITION BY year ORDER BY avg_sale DESC) AS rank
  FROM monthly_avg
)
WHERE rank = 1


-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 

SELECT customer_id, sum(total_sale) FROM `spiritual-grove-451916-k6.p1.p` 
group by 1
order by 2 desc
limit 5


-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

SELECT category, count(distinct customer_id), sum(total_sale) FROM `spiritual-grove-451916-k6.p1.p` 
group by category

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
with hourly 
as (
SELECT *, 
  CASE
    WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'morning'
    WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'afternoon'
    ELSE 'evening'
  END AS shift
FROM `spiritual-grove-451916-k6.p1.p`
)
select shift, count(*) as total_order
from hourly
group by shift
