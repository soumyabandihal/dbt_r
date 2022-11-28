with stg_customers as (
select
id as customer_id, first_name, last_name
from lab_one.customers
),
stg_orders as (
select
id as order_id,user_id as customer_id, order_date, status
from lab_one.orders
),
stg_payments as (
select id as payment_id, order_id, payment_method, amount / 100 as amount
from lab_one.Payments
),
customer_orders as (
select customer_id, min(order_date) as first_order,
max(order_date) as most_recent_order,count(order_id) as number_of_orders
from stg_orders
group by customer_id
),
customer_payments as (
select stg_orders.customer_id, sum(amount) as total_amount
from stg_payments
left join stg_orders on stg_payments.order_id = Stg_orders.order_id
group by stg_orders.customer_id
),
final as (
select
stg_customers.customer_id,
stg_customers.first_name,
stg_customers.last_name,
customer_orders.first_order,
customer_orders.most_recent_order,
customer_orders.number_of_orders,
customer_payments.total_amount as customer_lifetime_value
from stg_customers
left join customer_orders
on stg_customers.customer_id = customer_orders.customer_id
left join customer_payments
on stg_customers.customer_id = customer_payments.customer_id
)
select * from final