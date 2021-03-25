{{ config(materialized='view') }}

with amazon_shipped_cogs as 
(
    select * from {{ source('ha_amazon','amazon_sales_diagnostic_shipped_cogs') }}
),
final as
( 
    select distinct
         concat(isbn_13,'|"|~|"|',left(right(_file,10),6),'|"|~|"|"amazon"') as business_key
        ,cast(left(right(_file,10),6) as date) as ship_date
        ,isbn_13
        ,_file as record_source
        ,_fivetran_synced as dw_load_date_time 
        ,ordered_units
        ,shipped_cogs        
        ,shipped_units
        ,average_sales_price        
        ,customer_returns
        ,free_replacements
        -- ,conversion_rate
        -- ,glance_views
        -- ,lbb_price_  as lbb_price
        -- ,rep_oos
    from amazon_shipped_cogs
    where isbn_13 <> '0'
    and isbn_13 <> 'UNKNOWN'
    and isbn_13 <> 'EISBN'
    and isbn_13 <> 'ISBN-13'
    and reporting_range = 'Daily'
) 
select * 
from final

