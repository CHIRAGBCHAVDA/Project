use [AssignmentThree]
go

Create table Employee (
emp_id int primary key,
dept_id int not null,
mngr_id int,
emp_name varchar(50),
salary decimal(5,2)
)
go
alter table Employee alter column salary decimal(7,2);
alter table employee ADD CONSTRAINT FK_deptartment_dept_id FOREIGN KEY (dept_id)
      REFERENCES department(dept_id);

insert into Employee
values
(68319,1001,null,'KAYLING',  6000),
(66928,3001,68319,'BLAZE', 	2750.00),
(67832,1001,68319,'CLARE', 	2550.00),
(65646,2001,68319,'JONAS', 	2957.00),
(64989,3001,66928,'ADELYN',  1700.00),
(65271,3001,66928,'WADE', 	1350.00),
(66564,3001,66928,'MADDEN', 	1350.00),
(68454,3001,66928,'TUCKER', 	1600.00),
(68736,2001,67858,'ADNRES', 	1200.00),
(69000,3001,66928,'JULIUS', 	1050.00),
(69324,1001,67832,'MARKER', 	1400.00),
(67858,2001,65646,'SCARLET', 3100.00),
(69062,2001,65646,'FRANK', 	3100.00),
(63679,2001,69062,'SANDRINE',900.00)

select * from Employee order by salary;

CREATE TABLE Department(
	dept_id int primary key,
	dept_name varchar(50)
)
go

Insert into Department
values
(1001,'FINANCE'),	
(2001,'AUDIT'),	
(3001,'MARKETING'),	
(4001,'PRODUCTION')
go

select * from Department;


--1. write a SQL query to find Employees who have the biggest salary in their Department


--SELECT DISTINCT e.DEPT_ID,e.EMP_NAME,MAX(e.salary) MAX_SALARY
--FROM employee e
--WHERE e.DEPT_ID
--IN (SELECT e.DEPT_ID
--FROM employee e3 WHERE e.SALARY IN(SELECT MAX(SALARY) FROM EMPLOYEE E2 wHERE e2.DEPT_ID = E.DEPT_ID  GROUP BY DEPT_ID)
--)GROUP BY e.dept_id,e.EMP_NAME ORDER BY E.DEPT_ID;
--for null data run below
--SELECT d.dept_id,emp_name,salary 
--FROM employee e
--RIGHT JOIN department d
--ON e.dept_id = d.dept_id
--where d.dept_id+''+salary 
--IN(SELECT d.dept_id+''+max(salary)
--FROM employee e
--RIGHT JOIN department d
--ON e.dept_id = d.dept_id
--GROUP BY d.dept_id) or salary IS NULL

Ans : 
SELECT D.dept_name, E.emp_name, E.salary
FROM Department D
LEFT JOIN (SELECT dept_id, MAX(salary) MaxSalary FROM Employee GROUP BY dept_id) MS 
ON D.dept_id = MS.dept_id
LEFT JOIN Employee E
ON D.dept_id = E.dept_id
WHERE E.salary = MS.MaxSalary or E.salary IS NULL



--2. write a SQL query to find Departments that have less than 3 people in it
select D.dept_name,count(emp_id) [no of employees]
from Employee E
left join Department D on E.dept_id=D.dept_id
group by D.dept_name
having count(*)<3;
go

--3. write a SQL query to find All Department along with the number of people there
select D.dept_name,count(emp_id) [no of employees]
from Employee E
left join Department D on E.dept_id=D.dept_id
group by D.dept_name;
go

--4. write a SQL query to find All Department along with the total salary there
select D.dept_name,sum(salary) [Total salary]
from Employee E
left join Department D on E.dept_id=D.dept_id
group by D.dept_name;
go
