select
    f.orderid,
    f.customerkey, c.customerid, c.companyname as customercompanyname,
    c.contactname, c.contacttitle, c.customeraddress, c.customercity,
    c.customerregion, c.customerpostalcode, c.customercountry,
    c.customerphone, c.customerfax,
    f.employeekey, e.employeeid, e.employeenamelastfirst, e.employeenamefirstlast,
    e.employeetitle, e.supervisornamelastfirst, e.supervisornamefirstlast,
    f.orderdatekey, d.date as orderdate, d.year as orderyear,
    d.month as ordermonth, d.quarter as orderquarter,
    f.requireddatekey, f.shippeddatekey,
    f.freight, f.quantityonorder, f.totalorderamount,
    f.daysfromordertoshipped, f.daysfromordertorequired,
    f.shippedtorequireddelta, f.shippedontime,
    f.shippercompanyname, f.shipname, f.shipaddress, f.shipcity,
    f.shipregion, f.shippostalcode, f.shipcountry, f.shipvia
from {{ ref('fact_order_fulfillment') }} f
left join {{ ref('dim_customer') }} c on f.customerkey = c.customerkey
left join {{ ref('dim_employee') }} e on f.employeekey = e.employeekey
left join {{ ref('dim_date') }} d on f.orderdatekey = d.datekey
