/* ================================================================
SQL Workforce Analytics Project – Employee and Project Insights
Business Analysis Using SQL
================================================================ */


/* ================================================================
DATABASE SETUP
This dataset simulates a simplified HR analytics environment.
================================================================ */

CREATE TABLE Employee (
EmpID int NOT NULL,
EmpName Varchar,
Gender Char,
Salary int,
City Char(20)
);

INSERT INTO Employee
VALUES
(1, 'Arjun', 'M', 75000, 'Pune'),
(2, 'Ekadanta', 'M', 125000, 'Bangalore'),
(3, 'Lalita', 'F', 150000 , 'Mathura'),
(4, 'Madhav', 'M', 250000 , 'Delhi'),
(5, 'Visakha', 'F', 120000 , 'Mathura');


CREATE TABLE EmployeeDetail (
EmpID int NOT NULL,
Project Varchar,
EmpPosition Char(20),
DOJ date
);

INSERT INTO EmployeeDetail
VALUES
(1, 'P1', 'Executive', '2019-01-26'),
(2, 'P2', 'Executive', '2020-05-04'),
(3, 'P1', 'Lead', '2021-10-21'),
(4, 'P3', 'Manager', '2019-11-29'),
(5, 'P2', 'Manager', '2020-08-01');



/* ================================================================
EXPLORATORY DATA ANALYSIS
Understand employee distribution and project assignments
================================================================ */

SELECT * FROM Employee;

SELECT * FROM EmployeeDetail;

SELECT COUNT(*) AS total_employees FROM Employee;

SELECT DISTINCT city FROM Employee;

SELECT DISTINCT project FROM EmployeeDetail;



/* ================================================================
BUSINESS PROBLEM 1
Which cities have more than one employee?
Understanding workforce concentration helps HR plan resource
allocation across locations.
================================================================ */

SELECT count(empname), city
FROM employee
GROUP BY city
HAVING count(empname) > 1;



/* ================================================================
BUSINESS PROBLEM 2
List employees from cities that have multiple employees.
This identifies workforce clusters in key locations.
================================================================ */

SELECT empname, city
FROM employee
WHERE city IN
(
SELECT city
FROM employee
GROUP BY city
HAVING count(empname) > 1
);



/* ================================================================
BUSINESS PROBLEM 3
Identify employees living in the same city.
This helps understand regional collaboration opportunities.
================================================================ */

SELECT e1.empname, e1.city
FROM employee AS e1
JOIN employee AS e2
ON e1.city = e2.city
WHERE e1.empname != e2.empname;



/* ================================================================
BUSINESS PROBLEM 4
Which employees are working together on the same project?
This helps identify team collaboration patterns.
================================================================ */

SELECT e1.empname, e2.empname, d1.project
FROM employee e1
JOIN employeedetail d1 ON e1.empid = d1.empid
JOIN employeedetail d2 ON d1.project = d2.project
JOIN employee e2 ON d2.empid = e2.empid
WHERE e1.empid < e2.empid;



/* ================================================================
BUSINESS PROBLEM 5
Analyze hiring trends by year.
Helps HR understand recruitment patterns over time.
================================================================ */

SELECT extract(year from doj), count(*)
FROM employeedetail
GROUP BY extract(year from doj);



/* ================================================================
BUSINESS PROBLEM 6
Segment employees into salary bands.
Helps HR analyze compensation distribution.
================================================================ */

SELECT empname, salary,
CASE
WHEN salary < 100000 THEN 'low'
WHEN salary >= 100000 AND salary <= 200000 THEN 'medium'
WHEN salary > 200000 THEN 'high'
END AS salarystatus
FROM employee;



/* ================================================================
BUSINESS PROBLEM 7
Identify the second highest salary in the organization.
Useful for benchmarking compensation beyond top earners.
================================================================ */

SELECT *
FROM
(
SELECT empname,salary,
dense_rank() over(order by salary desc) as rnk
FROM employee
) AS emp
WHERE rnk = 2;



/* ================================================================
BUSINESS PROBLEM 8
Retrieve alternate employee records.
Useful for sampling datasets.
================================================================ */

SELECT *
FROM
(
SELECT *,
row_number() over(order by empid) as row_number
FROM employee
) AS emp
WHERE row_number %2 = 0;



/* ================================================================
BUSINESS PROBLEM 9
Retrieve alternate records starting with the first row.
================================================================ */

SELECT *
FROM
(
SELECT *,
row_number() over(order by empid) as row_number
FROM employee
) AS emp
WHERE row_number % 2 = 1;



/* ================================================================
BUSINESS PROBLEM 10
Calculate cumulative salary distribution.
Useful for payroll forecasting and financial analysis.
================================================================ */

SELECT empname, salary,
SUM(salary) OVER (ORDER BY salary) AS cum_Salary
FROM employee;



/* ================================================================
BUSINESS PROBLEM 11
Filter employees using pattern matching.
Useful for HR search and validation queries.
================================================================ */

SELECT empname FROM employee WHERE empname LIKE 'A%';

SELECT empname FROM employee WHERE empname LIKE '_a%';

SELECT empname FROM employee WHERE empname LIKE '%y_';

SELECT empname FROM employee WHERE empname LIKE '%___l';

SELECT empname FROM employee WHERE empname LIKE 'V%a';



/* ================================================================
BUSINESS PROBLEM 12
Identify the highest salary in the organization.
================================================================ */

SELECT empname, max(salary)
FROM employee
GROUP BY empname
ORDER BY max(salary) desc
LIMIT 1;



/* ================================================================
BUSINESS PROBLEM 13
Find the Nth highest salary.
Useful for compensation benchmarking.
================================================================ */

SELECT DISTINCT(salary)
FROM employee
ORDER BY salary desc
LIMIT 1 OFFSET N-1;



/* ================================================================
BUSINESS PROBLEM 14
Split employees into two halves.
Useful for workload distribution or batch processing.
================================================================ */

SELECT *
FROM employee
WHERE empid <=
(
SELECT count(empid)/2
FROM employee
);



/* ================================================================
KEY LEARNINGS AND BUSINESS IMPACT
================================================================

This project demonstrates how SQL can be used to analyze workforce
data and extract insights that support organizational decision-making.

Key capabilities demonstrated:

• Workforce distribution analysis across cities
• Project collaboration insights between employees
• Hiring trend analysis using date functions
• Salary segmentation for compensation analysis
• Ranking techniques to identify top earners
• Window functions for advanced analytical queries
• Pattern matching for HR data filtering

These SQL techniques are widely used in real-world analytics
for HR reporting, workforce planning, and business intelligence.
*/
