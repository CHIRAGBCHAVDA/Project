--1. write a SQL query to find the salesperson and customer who reside in the same city.
--Return Salesman, cust_name and city

SELECT salesman.name AS "Salesman",
customer.cust_name, customer.city 
FROM salesman,customer 
WHERE salesman.city=customer.city;
go

--2. write a SQL query to find those orders where the order amount exists between 500
--and 2000. Return ord_no, purch_amt, cust_name, city

SELECT O.ord_no [Order No], O.purch_amt [Purchase Amount],C.cust_name [Customer Name], C.City
from orders O, customer C
where (O.purch_amt between 500 and 2000) and (O.customer_id=C.customer_id);
go

--3. write a SQL query to find the salesperson(s) and the customer(s) he represents.
--Return Customer Name, city, Salesman, commission

Select C.cust_name, C.city, S.name Salesman, S.commission
from customer C, salesman S
where C.salesman_id=S.salesman_id;
go

--4. write a SQL query to find salespeople who received commissions of more than 12
--percent from the company. Return Customer Name, customer city, Salesman,
--commission.

Select C.cust_name, C.city, S.name Salesman, S.commission
from customer C, salesman S
where C.salesman_id=S.salesman_id and S.commission>0.12;
go

--5. write a SQL query to locate those salespeople who do not live in the same city where
--their customers live and have received a commission of more than 12% from the
--company. Return Customer Name, customer city, Salesman, salesman city,
--commission

Select C.cust_name, C.city, S.name Salesman, S.commission
from customer C, salesman S
where (C.salesman_id=S.salesman_id) and (S.commission>0.12) and (C.city != S.city);
go

--6. write a SQL query to find the details of an order. Return ord_no, ord_date,
--purch_amt, Customer Name, grade, Salesman, commission

Select O.ord_no,O.ord_date,O.purch_amt,C.cust_name,C.grade,S.name as Salesman, S.commission
from orders O
Inner join customer C On O.customer_id = C.customer_id
Inner join salesman S on C.salesman_id = S.salesman_id
go

--7. Write a SQL statement to join the tables salesman, customer and orders so that the
--same column of each table appears once and only the relational rows are returned.

--Select * from orders 
--join customer join salesman

--8. write a SQL query to display the customer name, customer city, grade, salesman,
--salesman city. The results should be sorted by ascending customer_id.

Select C.cust_name,C.city [Customer City],C.grade,S.name Salesman,S.city [Salesman City]
from customer C
join salesman S on C.salesman_id = S.salesman_id
order by C.customer_id asc;
go

--9. write a SQL query to find those customers with a grade less than 300. Return
--cust_name, customer city, grade, Salesman, salesmancity. The result should be
--ordered by ascending customer_id.

Select C.cust_name,C.city [Customer City],C.grade,S.name Salesman,S.city [Salesman City]
from customer C
join salesman S on C.salesman_id = S.salesman_id
where C.grade<300
order by C.customer_id asc;
go

--10. Write a SQL statement to make a report with customer name, city, order number,
--order date, and order amount in ascending order according to the order date to
--determine whether any of the existing customers have placed an order or not

Select C.cust_name,C.city,O.ord_date,O.purch_amt
from customer C
Join orders O on C.customer_id = O.customer_id
Order by O.purch_amt asc;
go

--11. Write a SQL statement to generate a report with customer name, city, order number,
--order date, order amount, salesperson name, and commission to determine if any of
--the existing customers have not placed orders or if they have placed orders through
--their salesman or by themselves

Select C.cust_name,C.city,O.ord_date,O.purch_amt, S.name Salesman, S.commission
from customer C
Join orders O on C.customer_id = O.customer_id
join salesman S on C.salesman_id = S.salesman_id;
go

--12. Write a SQL statement to generate a list in ascending order of salespersons who
--work either for one or more customers or have not yet joined any of the customers

Select Distinct name as Salesman from salesman
left join customer on salesman.salesman_id = customer.salesman_id;
go

--13. write a SQL query to list all salespersons along with customer name, city, grade,
--order number, date, and amount.

Select S.name as Salesman,C.cust_name, C.city, C.grade, 
O.ord_no, O.ord_date, O.purch_amt
from salesman S
inner join customer C on S.salesman_id = C.salesman_id
inner join orders O on C.customer_id= O.customer_id;
go

--14. Write a SQL statement to make a list for the salesmen who either work for one or
--more customers or yet to join any of the customers. The customer may have placed,
--either one or more orders on or above order amount 2000 and must have a grade, or
--he may not have placed any order to the associated supplier.

Select Distinct name as Salesman from salesman
left join customer on salesman.salesman_id = customer.salesman_id
left join orders on orders.customer_id=customer.customer_id
where orders.purch_amt>=2000
and customer.grade is not null;
go

--15. Write a SQL statement to generate a list of all the salesmen who either work for one
--or more customers or have yet to join any of them. The customer may have placed
--one or more orders at or above order amount 2000, and must have a grade, or he
--may not have placed any orders to the associated supplier.

Select Distinct name as Salesman from salesman
left join customer on salesman.salesman_id = customer.salesman_id
left join orders on orders.customer_id=customer.customer_id
where orders.purch_amt>=2000
and customer.grade is not null;
go


--16. Write a SQL statement to generate a report with the customer name, city, order no.
--order date, purchase amount for only those customers on the list who must have a
--grade and placed one or more orders or which order(s) have been placed by the
--customer who neither is on the list nor has a grade.

SELECT C.cust_name,C.city, O.ord_no,
O.ord_date,O.purch_amt AS "Order Amount" 
FROM customer C 
FULL OUTER JOIN orders O
ON C.customer_id=O.customer_id 
WHERE C.grade IS NOT NULL;
go

--17. Write a SQL query to combine each row of the salesman table with each row of the
--customer table

Select * from salesman 
cross join customer; 
go

--18. Write a SQL statement to create a Cartesian product between salesperson and
--customer, i.e. each salesperson will appear for all customers and vice versa for that
--salesperson who belongs to that city

Select * from salesman S
cross join customer
where S.city is not null;
go

--19. Write a SQL statement to create a Cartesian product between salesperson and
--customer, i.e. each salesperson will appear for every customer and vice versa for
--those salesmen who belong to a city and customers who require a grade

Select * from salesman S
cross join customer C
where S.city is not null and C.grade is not null;
go

--20. Write a SQL statement to make a Cartesian product between salesman and
--customer i.e. each salesman will appear for all customers and vice versa for those
--salesmen who must belong to a city which is not the same as his customer and the
--customers should have their own grade

Select * from salesman S
cross join customer C
where S.city is not null and C.grade is not null and S.city != C.city;
go