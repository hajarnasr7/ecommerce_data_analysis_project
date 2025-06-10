-- sales
-- Average revenue per order
SELECT ROUND(SUM(price)/count(oi.order_id),2) as Average_revenue_per_order
FROM order_items as oi
INNER JOIN orders as o 
on o.order_id = oi.order_id
WHERE order_status !=  'canceled' or order_status !=  'unavailable'

select sum(price) 
from order_items

-- Average revenue per order for the year
SELECT extract(year from order_delivered_customer_date) as order_year ,extract(month from order_delivered_customer_date) as order_month,ROUND(SUM(price)/count(oi.order_id),2) as Average_revenue_per_order
FROM order_items as oi
INNER JOIN orders as o 
on o.order_id = oi.order_id
GROUP BY  order_year,order_month
ORDER BY order_year asc

-- Ranking of products by profitability
SELECT product_category_name_english, SUM(price) as Revenue
FROM order_items as oi
INNER JOIN products as p
on oi.product_id = p.product_id
INNER JOIN public.product_category_name_translation as pc
on p.product_category_name = pc.product_category_name
GROUP BY product_category_name_english
ORDER BY Revenue desc

-- Revenue over time
SELECT customer_state, SUM(price) as Revenue
FROM order_items as oi
INNER JOIN orders as o
on oi.order_id = o.order_id
INNER JOIN customers as c
on o.customer_id = c.customer_id
GROUP BY customer_state
ORDER BY Revenue desc

-- Orders  
-- Average delivery time for products
select NULLIF(SUM(DATE_PART('day', order_delivered_customer_date - order_purchase_timestamp)),0)/ count(order_id) AS avg_days
FROM public.orders

-- Percentage of orders delivered on time
SELECT 
    (COUNT(CASE 
            WHEN order_delivered_customer_date <= order_estimated_delivery_date 
            THEN 1 END) * 100.0) / COUNT(order_id) AS on_time_delivery_percentage
FROM orders
where order_status = 'canceled'

-- Percentage of orders delivered on time for those who rated 1
SELECT 
    (COUNT(CASE 
            WHEN o.order_delivered_customer_date <= o.order_estimated_delivery_date 
            THEN 1 END) * 100.0) 
    / COUNT(o.order_id) AS on_time_delivery_percentage
FROM orders o
JOIN order_reviews r ON o.order_id = r.order_id
WHERE r.review_score = 1
AND o.order_delivered_customer_date IS NOT NULL;

-- Percentage of orders delivered on time
SELECT (sum(CASE WHEN (order_delivered_customer_date  > order_estimated_delivery_date ) THEN 1 END) * 1.0)/ count(order_id) * 100
FROM orders

SELECT COUNT(order_id) 
FROM orders 
WHERE order_delivered_customer_date > order_estimated_delivery_date;

-- Order status
SELECT order_status,count(order_id) as count_orders
FROM orders
group by order_status
order by count_orders desc

-- Payments
SELECT *
FROM public.order_payments
	
-- Percentage of customers using installment payments
WITH customers_with_installments AS (
    SELECT DISTINCT o.customer_id
    FROM public.order_payments AS op
    INNER JOIN public.orders AS o
    ON op.order_id = o.order_id
    WHERE op.payment_installments > 1
)

SELECT 
    (COUNT(*) * 100.0) / (SELECT COUNT(DISTINCT customer_id) FROM public.orders) AS installment_ratio
FROM customers_with_installments;

-- Payment method analysis
SELECT payment_type,COUNT(DISTINCT o.customer_id) as customar_count
FROM public.order_payments AS op
INNER JOIN public.orders AS o
ON op.order_id = o.order_id
GROUP BY payment_type
ORDER BY customar_count desc
	
-- Sellers  
-- Top sellers based on the number of orders	
SELECT oi.seller_id,seller_state, count(order_id) as orders_count
FROM public.order_items as oi
inner join public.sellers as s
on oi.seller_id = s.seller_id
GROUP BY oi.seller_id,seller_state
ORDER BY orders_count desc
LIMIT 5
	
-- Ratings  
-- Revenue based on review score
select review_score, sum(price) as price_sum
from public.order_reviews as o_r
inner join public.order_items as oi
on o_r.order_id = oi.order_id
group by review_score

select review_score, count(DISTINCT o.customer_id) as customar_count,count(o.order_id) as orders_count
from public.order_reviews as o_r
inner join public.order_items as oi
on o_r.order_id = oi.order_id
inner join public.orders as o
on o.order_id = oi.order_id
WHERE order_status !=  'canceled' or order_status !=  'unavailable'
group by review_score

-- - Number of orders vs. review score
select review_score,order_status, count(DISTINCT o.customer_id) as customar_count,count(o.order_id) as orders_count
from public.order_reviews as o_r
inner join public.order_items as oi
on o_r.order_id = oi.order_id
inner join public.orders as o
on o.order_id = oi.order_id
WHERE order_status !=  'canceled' or order_status !=  'unavailable'
group by review_score,order_status

-- Customers who rated 1: Most purchased or canceled products
select product_category_name_english,count (review_score)
from public.order_reviews as o_r
inner join public.order_items as oi
on o_r.order_id = oi.order_id
inner join public.orders as o
on o.order_id = oi.order_id
inner join public.products as p
on oi.product_id = p.product_id
inner join public.product_category_name_translation as pc
on pc.product_category_name = p.product_category_name
WHERE order_status = 'canceled'
review_score = 1
group by product_category_name_english
order by count (review_score) desc

-- Payment methods used by customers who rated 1
SELECT op.payment_type, COUNT(*) AS total_payments
FROM order_reviews r
JOIN orders o ON r.order_id = o.order_id
JOIN order_payments op ON o.order_id = op.order_id
WHERE r.review_score = 1
GROUP BY op.payment_type
ORDER BY total_payments DESC;

-- Number of products purchased by customers who rated 1
SELECT r.review_score, count(oi.product_id) AS avg_products_per_order
FROM order_reviews r
JOIN orders o ON r.order_id = o.order_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY r.review_score
ORDER BY avg_products_per_order DESC;


-- Sellers with the lowest sales and their status
SELECT oi.seller_id,seller_state, count(order_id) as orders_count
FROM public.order_items as oi
inner join public.sellers as s
on oi.seller_id = s.seller_id
GROUP BY oi.seller_id,seller_state
ORDER BY orders_count asc
LIMIT 5
-- mg,rj,sp,go,rs
	
-- State with the lowest sales
SELECT customer_state,SUM(price)
FROM order_items as oi
INNER JOIN orders as o 
on o.order_id = oi.order_id
inner join public.customers as c
on c.customer_id = o.customer_id
group by customer_state
order by SUM(price) 
-- rr,ap,ac,am,ro

-- Does the state with the lowest sales have a high order cancellation rate?
SELECT customer_state,SUM(price)
FROM order_items as oi
INNER JOIN orders as o 
on o.order_id = oi.order_id
inner join public.customers as c
on c.customer_id = o.customer_id
where order_status = 'canceled'
group by customer_state
order by SUM(price) asc
-- ms,rr,ro,pa,mt
-- - No, only "RO" has low sales and a high cancellation rate.
	

select count(*)
from customers
-- 99441
select count(*)
from public.leads_qualified
-- 8000
select count(*)
from public.leads_closed
-- 380
-- 4% of the people nominated for the marketing campaign successfully completed a deal with us.