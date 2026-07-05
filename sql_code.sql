select * from Customer limit 20;

select gender, sum(purchase_amount) as revenue
from Customer
group by gender;

select customer_id , purchase_amount
from Customer
where discount_applied='Yes' and purchase_amount >=(select avg(purchase_amount)from Customer);

select item_purchased , round(avg(review_rating::numeric),2) as "average product rating"
from Customer
group by item_purchased
order by avg(review_rating) desc
limit 5;

select shipping_type,round(avg(purchase_amount),2)
from Customer
where shipping_type in('Standard','Express')
group by shipping_type;

select subscription_status,count(customer_id) as total_customers ,
round(avg(purchase_amount),2) as avg_spend ,
round(sum(purchase_amount),2) as total_revenue
from Customer
group by subscription_status
order by total_revenue , avg_spend desc;

select item_purchased , round(100 * sum(case when discount_applied = 'Yes' then 1 else 0 end)/count(*),2) as discount_rate
from Customer
group by item_purchased 
order by discount_rate desc
limit 5;

with customer_type as (
select customer_id , previous_purchases,
case 
     when previous_purchases = 1 then 'New'
	 when previous_purchases between 2 and 10 then 'Returning'
	 else 'loyal'
	 end as customer_segment
from Customer
)
select customer_segment,count(*) as "number of customers"
from customer_type
group by customer_segment;

with item_counts as (
select category,item_purchased,count(customer_id) as total_orders,
row_number() over(partition by category order by count(customer_id)desc) as item_rank
from Customer
group by category,item_purchased 
)
select item_rank , category , item_purchased , total_orders
from item_counts
where item_rank<=3;

select subscription_status,
count(customer_id) as repeat_buyers
from Customer
where previous_purchases>5
group by subscription_status;

select age_group,sum(purchase_amount) as total_revenue
from Customer
group by age_group
order by total_revenue desc;

