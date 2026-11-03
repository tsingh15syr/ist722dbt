with products as (
    select * from {{ source('northwind', 'Products') }}
),
categories as (
    select * from {{ source('northwind', 'Categories') }}
)
select
    {{ dbt_utils.generate_surrogate_key(['p.productid']) }} as productkey,
    p.productid,
    p.productname,
    {{ dbt_utils.generate_surrogate_key(['p.supplierid']) }} as supplierkey,
    c.categoryname,
    c.description as categorydescription
from products p
left join categories c on p.categoryid = c.categoryid
