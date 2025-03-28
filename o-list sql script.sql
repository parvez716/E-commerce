create database O_list;

use o_list;

create table master_table(
			order_id varchar(50),
			customer_id varchar(50),
			order_purchase_timestamp datetime,
			order_delivered_customer_date DATETIME,
			olist_customers_dataset.customer_city varchar(50),
			olist_order_items_dataset.product_id varchar(50),
			olist_order_items_dataset.seller_id varchar(50),
			olist_order_items_dataset.price decimal(10,2),
			olist_order_items_dataset.freight_value decimal(10,2),
			olist_order_payments_dataset.payment_type decimal(10,2),
			olist_order_payments_dataset.payment_value decimal(10,2),
			olist_order_reviews_dataset.review_score int,
			olist_products_dataset.product_category_name varchar(50),
			olist_sellers_dataset.seller_zip_code_prefix int,
			olist_sellers_dataset.seller_city varchar(50),
			product_category_name_translation.Column2 varchar(50),
			weekday_weekend varchar(50),
			shipping days int,
			day int,					-- olist dataset. shayad iske wajhe se nai banra table
			Day name varchar(50),
			month varchar(50),
			year int,
			QTR varchar(10)
            );


CREATE TABLE if not exists master_table (
    order_id VARCHAR(50),
    customer_id VARCHAR(50),
    order_purchase_timestamp DATE,
    order_delivered_customer_date DATE,
    customer_city VARCHAR(50),
    product_id VARCHAR(50),
    seller_id VARCHAR(50),
    price DECIMAL(10,2), 
    freight_value DECIMAL(10,2),
    payment_type VARCHAR(50),
    payment_value DECIMAL(10,2),
    review_score INT,
    product_category_name VARCHAR(50),
    seller_zip_code_prefix INT,
    seller_city VARCHAR(50),
    product_category_name_translation VARCHAR(50),
    weekday_weekend VARCHAR(50),
    shipping_days INT,
    day INT,
    day_name VARCHAR(50),
    month VARCHAR(50),
    year INT,
    QTR VARCHAR(10)
);
drop table master_table;

SET SQL_SAFE_UPDATES  = 0;
UPDATE master_table
SET  order_delivered_customer_date = STR_TO_DATE( order_delivered_customer_date, '%yyyy/%mm/%dd');



-- loading data into the table 

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\ooooo.csv'
INTO TABLE master_table
FIELDS TERMINATED BY ','  -- If your CSV is comma-separated
ENCLOSED BY '"'            -- If your values are enclosed in double quotes
LINES TERMINATED BY '\n'   -- For line breaks
IGNORE 1 LINES; 


select * from master_table;


-- 1) weekend vs weekday 
SELECT
    weekday_weekend,
    total_payment,
    (total_payment / SUM(total_payment) OVER ()) * 100 AS percentage
FROM (
    SELECT
      weekday_weekend ,
	  SUM(payment_value) AS total_payment
    FROM
        master_table
    GROUP BY
        weekday_weekend
) AS payment_by_weekday_weekend;


/*SELECT
    day_type,
    total_payment,
    (total_payment / SUM(total_payment) OVER ()) * 100 AS percentage
FROM (
    SELECT
        CASE
            WHEN DAYOFWEEK(order_purchase_timestamp) IN (1, 7) THEN 'Weekend'
            ELSE 'Weekday'
        END AS day_type,
        SUM(payment_value) AS total_payment
    FROM
        master_table
    GROUP BY
        day_type
) AS payment_by_day_type; 
*/    
-- 2) Number of Orders with review score 5 and payment type as credit card.
    
 select count(order_id),
		review_score,
        payment_type
from master_table
where review_score = 5 and
	  payment_type = 'credit_card';


-- 3)Average number of days taken for order_delivered_customer_date for pet_shop

select avg(shipping_days),
	   product_category_name
from master_table
where product_category_name='pet_shop';

-- 4)Average price and payment values from customers of sao paulo city

select avg(price),
	   avg(payment_value),
       customer_city
from master_table
where customer_city ='sao paulo';

-- 5) Relationship between shipping days (order_delivered_customer_date - order_purchase_timestamp) Vs review scores.

select review_score,
	   round(avg(shipping_days),0 )as delivery_day
from master_table
group by review_score
order by review_score;
    
    
-/*select 
			order_id, 
			review_score, 
			shipping_days,
			CASE 
				WHEN review_score >= 4 AND shipping_days <= 12 THEN 5
				WHEN review_score >= 3 AND shipping_days <= 13 THEN 4
				WHEN review_score >= 2 AND shipping_days <= 15 THEN 3
				WHEN review_score <= 2 OR shipping_days > 19 THEN 1
				ELSE 2
			END AS scale_rating
		FROM 
			master_table;    
    */
    

    