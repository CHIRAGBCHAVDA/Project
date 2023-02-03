use [Northwind]
go

select * from Products;
go

select ProductID,ProductName,UnitPrice 
from products
where UnitPrice<20;
go

select ProductID,ProductName,UnitPrice 
from products
where UnitPrice>15 and UnitPrice<25;
go

select ProductName,UnitPrice 
from products
where UnitPrice> (select AVG(unitprice)from Products);
go

select distinct top 10 ProductName,UnitPrice 
from products order by UnitPrice desc;
go

select COUNT(productname) 
from products 
group by Discontinued;
go

select ProductName, UnitsOnOrder,UnitsInStock
from Products
where UnitsInStock < UnitsOnOrder;
go