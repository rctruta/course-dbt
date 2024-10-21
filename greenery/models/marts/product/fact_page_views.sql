with

events as (
    select * from {{ ref('stg_postgres__events')}}    
),

order_itmes as (
    select * from {{ ref('stg_postgres__order_items')}}    
),

session_timing_agg as (
    select * from {{ ref('int_session_timings')}}
)

select 
    e.session_id,
    e.user_id,
    coalesce(e.product_id, oi.product_id) as product_id,
    session_started_at,
    session_ended_at,
    sum(case when event_type = 'add_to_cart' then 1 else 0 end) as add_to_cart_ctn,
    sum(case when event_type = 'checkout' then 1 else 0 end) as checkout_ctn,
    sum(case when event_type = 'page_view' then 1 else 0 end) as page_view_ctn,
    sum(case when event_type = 'package_shipped' then 1 else 0 end) as package_shipped_ctn,
    datediff('minute', session_started_at, session_ended_at) as session_length_minutes
from
    events e
    left join order_itmes oi on e.order_id = oi.order_id
    left join session_timing_agg sta on e.session_id = sta.session_id
group by 1, 2, 3, 4, 5
