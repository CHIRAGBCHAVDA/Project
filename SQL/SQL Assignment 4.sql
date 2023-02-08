--1. Create a stored procedure in the Northwind database that will calculate the average value of Freight for a specified customer.Then, a business rule will be 
--added that will be triggered before every Update and Insert command in the Orders controller,and will use the stored procedure to verify that 
--the Freight does not exceed the average freight. If it does, a message will be displayed and the command will be cancelled.

create or alter proc spCalcAvgFreightByCustomer
@CustomerId varchar(5),
@AvgFreightOrders money output
as
begin
	select @AvgFreightOrders=AVG(Orders.Freight)
					  from Orders 
					  where Orders.CustomerID = @CustomerId;
	return @AvgFreightOrders;
end
go


create or alter trigger tr_insteadOfInsert_orders
on Orders
instead of insert
as
begin
	declare @AvgFreight money, @CustomerId nvarchar(5), @insertedFreight money 
	
	select @CustomerId = CustomerId
	from Customers 
	where CustomerID in (select CustomerID from inserted);

	if(@CustomerId is null)
	begin
		Raiserror('Invalid customer id',16,1)
		return		
	end

	select @insertedFreight = Freight
	from inserted;

	exec dbo.spCalcAvgFreightByCustomer @CustomerId,@AvgFreightOrders=@AvgFreight output; 

	if(@AvgFreight < @insertedFreight)
	begin
		Raiserror('Freight amount excluded',16,1)
		return
	end

	Print 'tr_insteadOfInsert_orders'
	insert into Orders( CustomerID, EmployeeID, OrderDate, RequiredDate, ShipVia, Freight, ShipName, ShipAddress, ShipCity,ShipPostalCode, ShipCountry)
    select  CustomerID, EmployeeID, OrderDate, RequiredDate, ShipVia, Freight, ShipName, ShipAddress, ShipCity,ShipPostalCode, ShipCountry
	from inserted;

end
go

create or alter trigger tr_insteadOfUpdate_orders
on Orders
instead of update
as
begin
	declare @AvgFreight money, @CustomerId nvarchar(5), @insertedFreight money,@deletdFreight money, @OrderId int 
	
	select @CustomerId = CustomerId
	from Customers 
	where CustomerID in (select CustomerID from inserted);

	select @OrderId = OrderId
	from Orders 
	where OrderID in (select OrderID from inserted);

	if(@CustomerId is null or @OrderId is null )
	begin
		Raiserror('Invalid customer or order id',16,1)
		return		
	end

	select @insertedFreight = Freight
	from inserted;
	select @deletdFreight = Freight
	from deleted;
	
	exec dbo.spCalcAvgFreightByCustomer @CustomerId,@AvgFreightOrders=@AvgFreight output; 

	Print 'Deleted Freight ' +  CAST(@deletdFreight as varchar) + ' \n Inserted Freight : ' + CAST(@insertedFreight as varchar) + ' \n Updated : ' + CAST(@AvgFreight as varchar);
	
	if((@insertedFreight <> @deletdFreight) and (@AvgFreight < @insertedFreight))
	begin
		Raiserror('Freight amount excluded',16,1)
		return		
	end

	Print 'tr_insteadOfUpdate_orders'
	
	update Orders
	set Freight = @insertedFreight
	where OrderID = @OrderId;

end
go


insert into Orders ( CustomerID, EmployeeID, OrderDate, RequiredDate, ShipVia, Freight, ShipName, ShipAddress, ShipCity,ShipPostalCode, ShipCountry)
values('VINET',5,'1998-05-12 00:00:00.000','1998-05-24 00:00:00.000',2,168,'Rattlesnake Canyon Grocery','2817 Milton Dr.','Albuquerque',87110, 'USA')
go

Update Orders 
set Freight = 10 
where OrderID = 10248
go


Select * from Orders
--2. write a SQL query to Create Stored procedure in the Northwind database to retrieve
--Employee Sales by Country

Create proc [Employee sales by country]
@BeginingDate Datetime, @EndingDate Datetime AS
Select E.Country, E.LastName, E.FirstName, O.ShippedDate, O.OrderID, OS.Subtotal as [Sale Amount]
from Employees E
Inner Join (Orders O Inner Join "Order Subtotals" OS on O.OrderID=OS.OrderID)
on E.EmployeeID = O.EmployeeID
Where O.ShippedDate between @BeginingDate and @EndingDate

Execute [Employee Sales by Country] '1996-07-08','1996-07-15';

--3. write a SQL query to Create Stored procedure in the Northwind database to retrieve
--Sales by Year

Create proc [Sales by Year]
@BeginingDate Datetime, @EndingDate Datetime AS
Select O.ShippedDate, O.OrderID, OS.Subtotal AS [Sale Amount], DATENAME(yy,O.ShippedDate) AS Year
from Orders O inner join "Order Subtotals" OS on O.OrderID = OS.OrderID
where O.ShippedDate between @BeginingDate and @EndingDate

Execute [Sales by Year] '1996-07-08','1996-07-15';

--4. write a SQL query to Create Stored procedure in the Northwind database to retrieve
--Sales By Category

Create PROCEDURE [SalesByCategory]
    @CategoryName nvarchar(15), @OrdYear nvarchar(4) = '1998'
AS
IF @OrdYear != '1996' AND @OrdYear != '1997' AND @OrdYear != '1998' 
BEGIN
	SELECT @OrdYear = '1998'
END

SELECT ProductName,
	TotalPurchase=ROUND(SUM(CONVERT(decimal(14,2), OD.Quantity * (1-OD.Discount) * OD.UnitPrice)), 0)
FROM [Order Details] OD, Orders O, Products P, Categories C
WHERE OD.OrderID = O.OrderID 
	AND OD.ProductID = P.ProductID 
	AND P.CategoryID = C.CategoryID
	AND C.CategoryName = @CategoryName
	AND SUBSTRING(CONVERT(nvarchar(22), O.OrderDate, 111), 1, 4) = @OrdYear
GROUP BY ProductName
ORDER BY ProductName

Exec SalesByCategory 'Beverages','1996'

--5. write a SQL query to Create Stored procedure in the Northwind database to retrieve
--Ten Most Expensive Products

Create Proc [Ten Most Expensive Products]
AS
SET ROWCOUNT 10
Select P.ProductName AS [Top 10 Expensive Products],P.UnitPrice
from Products P
Order by P.UnitPrice DESC

Exec [Ten Most Expensive Products]

--6. write a SQL query to Create Stored procedure in the Northwind database to insert
--Customer Order Details

Create proc [Customer Orders Detail Insert] 
@OrderID INT,
@ProductId int,
@UnitPrice Money,
@Quantity smallint,
@Discount Real
AS
	insert into [Order Details] (OrderID,ProductID,UnitPrice,Quantity,Discount)
	values (
				@OrderID,
				@ProductId,
				ROUND(@UnitPrice, 2),
				@Quantity,
				@Discount
			)

GO
EXEC [Customer Orders Detail Insert] 10248,48,12.75,8,1


--7. write a SQL query to Create Stored procedure in the Northwind database to update
--Customer Order Details

ALTER PROC [Customer Orders Detail Update]
@OrderID INT,
@ProductID INT,
@UnitPrice MONEY,
@Quantity SMALLINT,
@Discount REAL
AS

Update [Order Details]
SET
UnitPrice=ROUND(@UnitPrice, 2),
Quantity=@Quantity,
Discount=@Discount
WHERE OrderID=@OrderID AND ProductId =@ProductID

GO

EXEC [Customer Orders Detail Insert] 10248,49,12.75,10,1



Select * from [Order Details] OD where OD.OrderID=10248 and OD.ProductID=48
Select * from Orders
select * from Products
