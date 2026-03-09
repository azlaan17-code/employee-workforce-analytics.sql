/* =========================
   PRODUCTS TABLE
   ========================= */

CREATE TABLE Products (
Order_date date,
Sales int );

INSERT INTO Products(Order_date,Sales)
VALUES
('2021-01-01',20),
('2021-01-02',32),
('2021-02-08',45),
('2021-02-04',31),
('2021-03-21',33),
('2021-03-06',19),
('2021-04-07',21),
('2021-04-22',10);

SELECT extract(year from order_date) AS YE_AR,
TO_Char(ORDER_DATE,'MON') AS MON_TH,
SUM(sales) AS S_AL
FROM products
GROUP BY YE_AR, MON_TH
ORDER BY S_AL DESC;


/* =========================
   APPLICATIONS TABLE
   ========================= */

CREATE TABLE Applications (
candidate_id int,
skills varchar);

INSERT INTO Applications(candidate_id,skills)
VALUES
(101, 'Power BI'),
(101, 'Python'),
(101, 'SQL'),
(102, 'Tableau'),
(102, 'SQL'),
(108, 'Python'),
(108, 'SQL'),
(108, 'Power BI'),
(104, 'Python'),
(104, 'Excel');

SELECT candidate_id, count(skills)
FROM APPLICATIONS
WHERE SKILLS IN('Python','SQL','Power BI')
GROUP BY candidate_id
HAVING count(skills) = 3;


/* =========================
   EMPLOYEE TABLE
   ========================= */

CREATE TABLE Employee (
EmpID int NOT NULL,
EmpName Varchar,
Gender Char,
Salary int,
City Char(20) );

INSERT INTO Employee
VALUES
(1, 'Arjun', 'M', 75000, 'Pune'),
(2, 'Ekadanta', 'M', 125000, 'Bangalore'),
(3, 'Lalita', 'F', 150000 , 'Mathura'),
(4, 'Madhav', 'M', 250000 , 'Delhi'),
(5, 'Visakha', 'F', 120000 , 'Mathura');


/* =========================
   EMPLOYEE DETAIL TABLE
   ========================= */

CREATE TABLE EmployeeDetail (
EmpID int NOT NULL,
Project Varchar,
EmpPosition Char(20),
DOJ date );

INSERT INTO EmployeeDetail
VALUES
(1, 'P1', 'Executive', '2019-01-26'),
(2, 'P2', 'Executive', '2020-05-04'),
(3, 'P1', 'Lead', '2021-10-21'),
(4, 'P3', 'Manager', '2019-11-29'),
(5, 'P2', 'Manager', '2020-08-01');


/* =========================
   CITIES WITH MULTIPLE EMPLOYEES
   ========================= */

SELECT count(empname), city
FROM employee
GROUP BY city
HAVING count(empname) > 1;


/* =========================
   EMPLOYEES LIVING IN SAME CITY
   ========================= */

SELECT e1.empname, e1.city
FROM employee AS e1
JOIN employee AS e2
ON e1.city = e2.city
WHERE e1.empname != e2.empname;


/* =========================
   EMPLOYEES FROM CITIES WITH MULTIPLE EMPLOYEES
   ========================= */

SELECT empname, city
FROM employee
WHERE city IN
(
SELECT city
FROM employee
GROUP BY city
HAVING count(empname) > 1
);


/* =========================
   JOIN EMPLOYEE AND PROJECT
   ========================= */

SELECT empname, project, employee.empid
FROM employee
JOIN employeedetail
ON employee.empid = employeedetail.empid;


/* =========================
   EMPLOYEES WORKING ON SAME PROJECT
   ========================= */

SELECT e1.empname, e2.empname, d1.project
FROM employee e1
JOIN employeedetail d1 ON e1.empid = d1.empid
JOIN employeedetail d2 ON d1.project = d2.project
JOIN employee e2 ON d2.empid = e2.empid
WHERE e1.empid < e2.empid;


/* =========================
   EMPLOYEES JOINED EACH YEAR
   ========================= */

SELECT extract(year from doj), count(*)
FROM employeedetail
GROUP BY extract(year from doj);


/* =========================
   PATTERN MATCHING
   ========================= */

SELECT empname FROM employee WHERE empname LIKE 'A%';

SELECT empname FROM employee WHERE empname LIKE '_a%';

SELECT empname FROM employee WHERE empname LIKE '%y_';

SELECT empname FROM employee WHERE empname LIKE '%___l';

SELECT empname FROM employee WHERE empname LIKE 'V%a';


/* =========================
   NAMES STARTING WITH VOWEL
   ========================= */

SELECT DISTINCT EmpName
FROM Employee
WHERE LOWER(EmpName) SIMILAR TO '[aeiou]%';


/* =========================
   SALARY CATEGORY
   ========================= */

SELECT empname, salary,
CASE
WHEN salary < 100000 THEN 'low'
WHEN salary >= 100000 AND salary <= 200000 THEN 'medium'
WHEN salary > 200000 THEN 'high'
END AS salarystatus
FROM employee;


/* =========================
   EVEN ROWS
   ========================= */

SELECT *
FROM
(
SELECT *,
row_number() over(order by empid) as row_number
FROM employee
) AS emp
WHERE row_number %2 = 0;


/* =========================
   ODD ROWS
   ========================= */

SELECT *
FROM
(
SELECT *,
row_number() over(order by empid) as row_number
FROM employee
) AS emp
WHERE row_number % 2 = 1;


/* =========================
   HIGHEST SALARY
   ========================= */

SELECT empname, max(salary)
FROM employee
GROUP BY empname
ORDER BY max(salary) desc
LIMIT 1;


/* =========================
   NTH HIGHEST SALARY
   ========================= */

SELECT DISTINCT(salary)
FROM employee
ORDER BY salary desc
LIMIT 1 OFFSET N-1;


/* =========================
   SECOND HIGHEST SALARY USING WINDOW FUNCTION
   ========================= */

SELECT *
FROM
(
SELECT empname,salary,
dense_rank() over(order by salary desc) as rnk
FROM employee
) AS emp
WHERE rnk = 2;


/* =========================
   FIRST HALF OF EMPLOYEES
   ========================= */

SELECT *
FROM employee
WHERE empid <=
(
SELECT count(empid)/2
FROM employee
);


/* =========================
   CUMULATIVE SALARY
   ========================= */

SELECT empname, salary,
SUM(salary) OVER (ORDER BY salary) AS cum_Salary
FROM employee;


/* =========================
   SAME PROJECT (SELF JOIN APPROACH)
   ========================= */

SELECT empname, project
FROM employee
JOIN
(
SELECT e1.empid,e1.project
FROM employeedetail AS e1
JOIN employeedetail AS e2
ON e1.project = e2.project
WHERE e1.empid != e2.empid
) AS x
ON employee.empid = x.empid;


/* =========================
   EMPLOYEES GROUPED BY PROJECT
   ========================= */

SELECT empname, project
FROM employee
JOIN employeedetail
ON employeedetail.empid = employee.empid
GROUP BY empname,project
ORDER BY project;


/* =========================
   EMPLOYEES FROM CITIES WITH MULTIPLE EMPLOYEES
   ========================= */

SELECT empname, city
FROM employee
WHERE city IN
(
SELECT city
FROM employee
GROUP BY city
HAVING count(empname) > 1
);