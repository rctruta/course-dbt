# Week 1 project questions and answers

## Q1: How many users do we have?

### Answer: 130

```
select count(*) 
from dev_db.dbt_ramonacstorontoedu.stg_postgres__users;
```

## Q2: On average, how many orders do we receive per hour?
### Answer: 7.5

```
select count(*) * 1.0 / count(distinct date_trunc('hour', created_at)) as avg_hourly_orders
from dev_db.dbt_ramonacstorontoedu.stg_postgres__orders;
```

## Q3: On average, how long does an order take from being placed to being delivered?
### Answer: 93.4 hrs, or approximately 4 days

```
select avg(datediff('hours', created_at, delivered_at)) as time_to_delivery_hrs, 
       avg(datediff('days', created_at, delivered_at)) as time_to_delivery_days
from dev_db.dbt_ramonacstorontoedu.stg_postgres__orders
where delivered_at is not null;
```

## Q4: How many users have only made one purchase? Two purchases? Three+ purchases?
### Answer:
| order_ctn  | user_ctn  |
|------------|-----------|
| 3+ orders | 71 |
| 2 orders | 28 |
| 1 order | 25 |

```
with user_count_orders as (
    select 
        user_id,
        count(order_id) as ctn_orders
    from 
        dev_db.dbt_ramonacstorontoedu.stg_postgres__orders
    group by 
        user_id
)
select 
    case 
        when ctn_orders = 1 then '1 order'
        when ctn_orders = 2 then '2 orders'
        else '3+ orders'
    end as order_ctn,
    count(user_id) as user_ctn
from 
    user_count_orders
group by 
    order_ctn
order by 
    order_ctn desc;
```
Note: you should consider a purchase to be a single order. In other words, if a user places one order for 3 products, they are considered to have made 1 purchase.

## Q5: On average, how many unique sessions do we have per hour?
### Answer:
```
```
