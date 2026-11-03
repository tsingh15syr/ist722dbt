-- One row per order line (orderid + productkey), as in the modeling workbook.
with order_lines as (
    select
        d.orderid,
        d.productid,
        d.quantity,
        d.unitprice,
        d.discount,
        o.customerid,
        o.employeeid,
        to_date(o.orderdate) as orderdate
    from {{ source('northwind', 'Order_Details') }} d
    join {{ source('northwind', 'Orders') }} o on d.orderid = o.orderid
),
amounts as (
    select
        orderid,
        {{ dbt_utils.generate_surrogate_key(['customerid']) }} as customerkey,
        {{ dbt_utils.generate_surrogate_key(['employeeid']) }} as employeekey,
        to_number(to_char(orderdate, 'YYYYMMDD')) as orderdatekey,
        {{ dbt_utils.generate_surrogate_key(['productid']) }} as productkey,
        quantity,
        round(quantity * unitprice, 2)::number(18, 2) as extendedpriceamount,
        round(quantity * unitprice * discount, 2)::number(18, 2) as discountamount
    from order_lines
)
select
    orderid,
    customerkey,
    employeekey,
    orderdatekey,
    productkey,
    quantity,
    extendedpriceamount,
    discountamount,
    (extendedpriceamount - discountamount)::number(18, 2) as soldamount
from amounts
