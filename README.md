# SQL-Workforce-Analytics-Project-Employee-and-Project-Insights

### Overview
This project focuses on analyzing workforce data using SQL to derive actionable insights about employee distribution, project collaboration, hiring trends, and salary segmentation. The dataset simulates a simplified HR analytics environment containing employee demographic data, salary information, project assignments, and joining dates.

The goal of this project is to demonstrate how SQL can be used to answer real-world workforce analytics questions that support HR planning, organizational decision-making, and team collaboration analysis.

### The project includes:

1. Data schema design and table creation.
2. Exploratory Data Analysis (EDA).
3. Workforce analytics using SQL queries.
4. Solving key HR business problems through SQL queries.

---

## Key Features

- **Database Schema:** A structured relational database consisting of two tables: `employee` and `employeedetail`.
- **Workforce Analytics:** Queries designed to analyze employee distribution, project collaboration, and hiring patterns.
- **Business Problem Analysis:** Tackles real-world HR analytics scenarios such as salary segmentation and workforce distribution.
- **Advanced Querying:** Includes window functions, subqueries, ranking functions, and aggregate analysis.

---

## Database Schema

The project uses two main tables:

### 1. **employee**
Contains employee demographic and salary information.

- `empid`: Unique identifier for each employee.
- `empname`: Employee name.
- `gender`: Gender of the employee.
- `salary`: Employee salary.
- `city`: City where the employee is located.

### 2. **employeedetail**
Stores project assignments and employment information.

- `empid`: References the employee table.
- `project`: Project assigned to the employee.
- `empposition`: Employee position.
- `doj`: Date when the employee joined the organization.

---

## SQL Queries and Analysis

This project contains SQL queries structured around Exploratory Data Analysis (EDA) and Business Problem Solving. The queries help analyze employee distribution, project collaboration patterns, salary segmentation, and hiring trends.

---

## Exploratory Data Analysis

```sql
SELECT * FROM employee;

SELECT * FROM employeedetail;

SELECT COUNT(*) AS total_employees FROM employee;

SELECT DISTINCT city FROM employee;

SELECT DISTINCT project FROM employeedetail;
```


## Business Problem Queries

1. **Identify cities that have more than one employee.**
```
SELECT 
    COUNT(empname), city
FROM employee
GROUP BY city
HAVING COUNT(empname) > 1;
```
2. **List employees working in cities with multiple employees.**
```
SELECT 
    empname, city
FROM employee
WHERE city IN (
    SELECT city
    FROM employee
    GROUP BY city
    HAVING COUNT(empname) > 1
);
```
3. **Identify employees living in the same city.**
```
SELECT 
    e1.empname, 
    e1.city
FROM employee AS e1
JOIN employee AS e2
ON e1.city = e2.city
WHERE e1.empname != e2.empname;
```
4. **Identify employees working on the same project.**
```
SELECT 
    e1.empname, 
    e2.empname, 
    d1.project
FROM employee e1
JOIN employeedetail d1 
ON e1.empid = d1.empid
JOIN employeedetail d2 
ON d1.project = d2.project
JOIN employee e2 
ON d2.empid = e2.empid
WHERE e1.empid < e2.empid;
```
5. **Analyze employee hiring trends by year.**
```
SELECT 
    EXTRACT(YEAR FROM doj) AS join_year,
    COUNT(*) AS employees_joined
FROM employeedetail
GROUP BY join_year
ORDER BY join_year;
```
6. **Categorize employees into salary bands (Low, Medium, High).**
```
SELECT 
    empname,
    salary,
    CASE
        WHEN salary < 100000 THEN 'Low'
        WHEN salary >= 100000 AND salary <= 200000 THEN 'Medium'
        WHEN salary > 200000 THEN 'High'
    END AS salary_band
FROM employee;
```
7. **Find the second highest salary in the organization.**
```
SELECT *
FROM (
    SELECT 
        empname,
        salary,
        DENSE_RANK() OVER (ORDER BY salary DESC) AS rnk
    FROM employee
) AS emp
WHERE rnk = 2;
```
8. **Retrieve even row records from the employee table.**
```
SELECT *
FROM (
    SELECT *,
           ROW_NUMBER() OVER (ORDER BY empid) AS row_number
    FROM employee
) AS emp
WHERE row_number % 2 = 0;
```
9. **Retrieve odd row records from the employee table.**
```
SELECT *
FROM (
    SELECT *,
           ROW_NUMBER() OVER (ORDER BY empid) AS row_number
    FROM employee
) AS emp
WHERE row_number % 2 = 1;
```
10. **Calculate cumulative salary distribution across employees.**
```
SELECT 
    empname,
    salary,
    SUM(salary) OVER (ORDER BY salary) AS cumulative_salary
FROM employee;
```
11. **Filter employee names using pattern matching.**
```
SELECT empname FROM employee WHERE empname LIKE 'A%';
SELECT empname FROM employee WHERE empname LIKE '_a%';
SELECT empname FROM employee WHERE empname LIKE '%y_';
SELECT empname FROM employee WHERE empname LIKE '%___l';
SELECT empname FROM employee WHERE empname LIKE 'V%a';
```
12. **Identify the highest salary in the organization.**
```
SELECT 
    empname,
    MAX(salary)
FROM employee
GROUP BY empname
ORDER BY MAX(salary) DESC
LIMIT 1;
```
13. **Find the Nth highest salary in the organization.**
```
SELECT DISTINCT salary
FROM employee
ORDER BY salary DESC
LIMIT 1 OFFSET N-1;
```
14. **Split employees into two halves for workload distribution.**
```
SELECT *
FROM employee
WHERE empid <= (
    SELECT COUNT(empid)/2
    FROM employee
);
```

---

## Technologies Used
- **Database:** PostgreSQL
- **SQL Concepts:**
    - **Window Functions:** `DENSE_RANK()`, `ROW_NUMBER()`, and `SUM() OVER()`
    - **Subqueries and Joins:** Mastery of **Self-Joins** and **Inner Joins**
    - **Aggregate Functions:** Advanced data grouping using `GROUP BY` and `HAVING`
    - **Pattern Matching:** Advanced string filtering using `LIKE` and Wildcards



---

## Key Learnings
- **Business Problem Solving with SQL:** Applying SQL to solve real-world business questions related to employee distribution, collaboration, and salary analysis.
- **Advanced Relational Logic:** Successfully implemented **Self-Joins** to uncover hidden organizational links, such as employees sharing projects or residential locations.
- **Data Insights:** Extracting actionable insights from large datasets to drive decisions in workforce management and regional planning.
- **Analytical Ranking:** Utilized Window Functions to handle competitive salary rankings and data partitioning.



---

## Business Impact
- **Optimized Resource Allocation:** Identified project overlaps, allowing management to visualize team synergy and reallocate talent where needed.
- **Data-Driven Compensation:** Established automated salary tiers, providing HR with a structured framework for market-parity checks and retention strategies.
- **Strategic Regional Planning:** Mapped regional talent density to help leadership decide where to establish satellite offices or corporate transit hubs.

---
