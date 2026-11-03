-- Denormalized sales OBT. Keep the fact order-line grain and left join dimensions.
select
    f.orderid,
    f.customerkey,
    c.customerid,
    c.companyname as customercompanyname,
    c.contactname as customercontactname,
    c.customercity, c.customerregion, c.customercountry,
    f.employeekey,
    e.employeeid,
    e.employeenamefirstlast,
    e.employeetitle,
    f.orderdatekey,
    d.date as orderdate,
    d.year as orderyear,
    d.month as ordermonth,
    d.quarter as orderquarter,
    d.monthname as ordermonthname,
    f.productkey,
    p.productid,
    p.productname,
    p.categoryname,
    p.categorydescription,
    p.supplierkey,
    s.supplierid,
    s.companyname as suppliercompanyname,
    f.quantity,
    f.extendedpriceamount,
    f.discountamount,
    f.soldamount
from {{ ref('fact_sales') }} f
left join {{ ref('dim_customer') }} c on f.customerkey = c.customerkey
left join {{ ref('dim_employee') }} e on f.employeekey = e.employeekey
left join {{ ref('dim_date') }} d on f.orderdatekey = d.datekey
left join {{ ref('dim_product') }} p on f.productkey = p.productkey
left join {{ ref('dim_supplier') }} s on p.supplierkey = s.supplierkey
