with orders as (
    select
        orderid,
        customerid,
        employeeid,
        to_date(orderdate) as orderdate,
        to_date(requireddate) as requireddate,
        to_date(shippeddate) as shippeddate,
        shipname, shipaddress, shipcity, shipregion,
        shippostalcode, shipcountry, freight, shipvia
    from {{ source('northwind', 'Orders') }}
),
order_details as (
    select
        orderid,
        sum(quantity) as quantityonorder,
        round(sum(quantity * unitprice * (1 - discount)), 2)::number(18, 2) as totalorderamount
    from {{ source('northwind', 'Order_Details') }}
    group by orderid
),
shippers as (
    select * from {{ source('northwind', 'Shippers') }}
)
select
    o.orderid,
    {{ dbt_utils.generate_surrogate_key(['o.customerid']) }} as customerkey,
    {{ dbt_utils.generate_surrogate_key(['o.employeeid']) }} as employeekey,
    to_number(to_char(o.orderdate, 'YYYYMMDD')) as orderdatekey,
    to_number(to_char(o.requireddate, 'YYYYMMDD')) as requireddatekey,
    to_number(to_char(o.shippeddate, 'YYYYMMDD')) as shippeddatekey,
    o.freight,
    d.quantityonorder,
    d.totalorderamount,
    datediff('day', o.orderdate, o.shippeddate) as daysfromordertoshipped,
    datediff('day', o.orderdate, o.requireddate) as daysfromordertorequired,
    datediff('day', o.requireddate, o.shippeddate) as shippedtorequireddelta,
    case
        when o.shippeddate is null or o.requireddate is null then null
        when o.shippeddate <= o.requireddate then 'Y'
        else 'N'
    end as shippedontime,
    s.companyname as shippercompanyname,
    o.shipname, o.shipaddress, o.shipcity, o.shipregion,
    o.shippostalcode, o.shipcountry, o.shipvia
from orders o
join order_details d on o.orderid = d.orderid
left join shippers s on o.shipvia = s.shipperid
