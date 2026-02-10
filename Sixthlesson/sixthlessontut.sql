CREATE DATABASE sixthlessontut;
GO

USE sixthlessontut;


DROP TABLE IF EXISTS dbo.example;
IF OBJECT_ID('dbo.exampletb', 'U') IS NULL
    CREATE TABLE dbo.exampletb
    (
        id INT,
        name VARCHAR(50),
        typed VARCHAR(20)
    );
GO  




INSERT INTO dbo.exampletb (id, name, typed)
VALUES
(1, 'P', NULL),
(1, NULL, 'Q'),
(2, 'A', NULL),
(2, NULL, 'B');
GO  


SELECT * FROM dbo.exampletb;


SELECT id, 
STRING_AGG(name, ','),
STRING_AGG(typed, ',')

FROM dbo.exampletb
GROUP BY id;




IF OBJECT_ID('dbo.salestb', 'U') IS NULL
    CREATE TABLE dbo.salestb
    (
        busentityid INT,
        salesyear INT,
        currentquota DECIMAL(20,4)

    )
GO



INSERT INTO dbo.salestb (busentityid, salesyear, currentquota)
VALUES

(1, 2020, 100000.0000),
(1, 2021, 120000.0000),
(1, 2022, 150000.0000),
(1, 2023, 180000.0000),


(2, 2020,  80000.0000),
(2, 2021,  90000.0000),
(2, 2022, 110000.0000),
(2, 2023, 130000.0000),


(3, 2021,  50000.0000),
(3, 2022,  70000.0000),
(3, 2023,  90000.0000);
GO

SELECT * FROM dbo.salestb;



SELECT *,
LAG(currentquota, 1, 0) OVER (ORDER BY salesyear ASC) AS Previous_Quota,
LEAD(currentquota, 1, 0) OVER (ORDER BY salesyear ASC) AS Leading_Quota
FROM dbo.salestb;



SELECT *,
ISNULL(LAG(currentquota) OVER (ORDER BY salesyear ASC), 0) AS Previous_Quota,
ISNULL(LEAD(currentquota) OVER (ORDER BY salesyear ASC), 0) AS Leading_Quota
FROM dbo.salestb;


IF OBJECT_ID('dbo.employees', 'U') IS NULL
    CREATE TABLE dbo.Employees(
        EmployeeID INT,
        Name VARCHAR(50),
        Department VARCHAR(50),
        Salary DECIMAL(10,2),
        HireDate DATE
    );
    GO



INSERT INTO dbo.Employees VALUES
(1, 'Alice',   'IT',    70000, '2020-01-15'),
(2, 'Bob',     'IT',    80000, '2019-03-10'),
(3, 'Charlie', 'IT',    80000, '2021-07-01'),
(4, 'David',   'HR',    50000, '2018-06-20'),
(5, 'Eve',     'HR',    60000, '2020-09-12'),
(6, 'Frank',   'HR',    60000, '2022-01-05'),
(7, 'Grace',   'Sales', 55000, '2019-11-30'),
(8, 'Heidi',   'Sales', 65000, '2021-04-18'),
(9, 'Ivan',    'Sales', 75000, '2023-02-01');
GO



SELECT *, 

LAG(Salary, 1, 0) OVER (PARTITION BY Department ORDER BY HireDate) AS Salary_Prev_Emp

FROM dbo.Employees
ORDER BY Department, HireDate;


-- FIRST VALUE AND LAST VALUE


SELECT *, 
FIRST_VALUE(Name) 
OVER (PARTITION BY Department ORDER BY HireDate) AS First_Emp,
FIRST_VALUE(Name) 
-- THIS IS EQUAL TO THIS
OVER (PARTITION BY Department ORDER BY HireDate DESC) AS Last_Emp
FROM dbo.Employees;

-- THIS IS EQUAL TO THIS

SELECT *,
    FIRST_VALUE(Name) OVER (
        PARTITION BY Department
        ORDER BY HireDate
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS First_Emp,

    LAST_VALUE(Name) OVER (
        PARTITION BY Department
        ORDER BY HireDate
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS Last_Emp
FROM dbo.Employees;




--- JOINS -------



-- 1. INNER JOIN
-- 2. OUTER JOIN: 
    -- RIGHT OUTER JOIN
    -- LEFT OUTER JOIN
    -- FULL OUTER JOIN
-- 3.CROSS JOIN
-- (SELF-JOIN)


-- EXAMPLE


IF OBJECT_ID('dbo.department', 'U') IS NULL
    CREATE TABLE dbo.department(

        id INT IDENTITY(1,1) PRIMARY KEY,
        name VARCHAR(50),
        description VARCHAR(MAX)

    );
GO




IF OBJECT_ID('dbo.employee', 'U') IS NULL
    CREATE TABLE dbo.employee(

        id INT IDENTITY(1,1) PRIMARY KEY,
        name VARCHAR(50),
        salary DECIMAL(10,2),
        dept_id INT,
        CONSTRAINT fk_department
        FOREIGN KEY (dept_id)  REFERENCES dbo.department(id)

    );
GO


INSERT INTO dbo.department (name, description)
VALUES
    ('HR', 'Handles recruitment, employee relations, and policies'),
    ('IT', 'Responsible for infrastructure, software, and security'),
    ('Finance', 'Manages budgeting, payroll, and financial planning');

INSERT INTO dbo.department (name, description)
VALUES
    ('Marketing', 'Advertising and market research'),
    ('Legal', 'Contracts and compliance');



INSERT INTO dbo.employee (name, salary, dept_id)
VALUES
    ('Alice', 55000.00, 1),   
    ('Bob',   72000.00, 2),   
    ('Carol', 68000.00, 2),   
    ('Dave',  80000.00, 3);   


INSERT INTO dbo.employee (name, salary, dept_id)
VALUES
    ('Eve',   50000.00, NULL),
    ('Frank', 62000.00, NULL);

INSERT INTO dbo.employee (name, salary, dept_id)
VALUES
    ('Grace', 75000.00, 2),   -- IT
    ('Heidi', 58000.00, 1);   -- HR





-- 1. INNER JOIN

-- “Show rows that exist on both sides of the relationship.”

-- If an employee has no department, they disappear

SELECT
    e.id AS EmpID,
    e.name AS EmpName,
    e.salary AS EmpSalary,
    d.name AS DepName,
    d.description AS DepDescription
FROM dbo.employee e
INNER JOIN dbo.department d
    ON e.dept_id = d.id;

-- Result logic
-- Only employees with valid departments appear.

-- Think of it as the intersection of two circles.




-- 2. LEFT OUTER JOIN

-- “Show all employees, even if they don’t belong to a department.”


SELECT
    e.id AS EmpID,
    e.name AS EmpName,
    e.salary AS EmpSalary,
    d.name AS DepName,
    d.description AS DepDescription
FROM dbo.employee e
LEFT JOIN dbo.department d
    ON e.dept_id = d.id;

-- Result logic

-- Every employee appears

-- Department columns become NULL if no match exists

-- Employees are the “main character” here.





-- 3. RIGHT OUTER JOIN

-- “Show all departments, even if they have no employees.”


SELECT
    e.id AS EmpID,
    e.name AS EmpName,
    e.salary AS EmpSalary,
    d.name AS DepName,
    d.description AS DepDescription
FROM dbo.employee e
RIGHT JOIN dbo.department d
    ON e.dept_id = d.id;


-- Result logic

-- Every department appears

-- Employee columns become NULL if no employee belongs to it

-- Same result as swapping tables and using LEFT JOIN. Many developers avoid RIGHT JOIN for readability.



-- 4. FULL OUTER JOIN

-- “Show everything, matched or not.”


SELECT
    e.id AS EmpID,
    e.name AS EmpName,
    e.salary AS EmpSalary,
    d.name AS DepName,
    d.description AS DepDescription
FROM dbo.employee e
FULL OUTER JOIN dbo.department d
    ON e.dept_id = d.id;



-- Result logic

-- Employees without departments → shown

-- Departments without employees → shown

-- Matching rows → merged

-- This is the union of LEFT and RIGHT joins.



-- 5. CROSS JOIN

-- “Combine every employee with every department.”

-- No relationship. No ON clause. Pure Cartesian chaos.

SELECT
    e.name AS EmpName,
    d.name AS DepName
FROM dbo.employee e
CROSS JOIN dbo.department d;


-- If you have:

-- 4 employees

-- 3 departments

-- You get 12 rows.



-- 6. SELF JOIN

-- “A table joins to itself.”

-- Your schema doesn’t naturally need one, but here’s a meaningful example.

-- Let’s pretend employees in the same department are “colleagues”.


SELECT
    e1.name AS Employee,
    e2.name AS Colleague,
    d.name AS Department
FROM dbo.employee e1
INNER JOIN dbo.employee e2
    ON e1.dept_id = e2.dept_id
   AND e1.id <> e2.id
INNER JOIN dbo.department d
    ON e1.dept_id = d.id;


-- Result logic

-- Pairs employees who work in the same department

-- Excludes pairing an employee with themselves

-- Same table, different roles. Aliases make this possible.


-- The big picture (lock this in)

-- • INNER → only matches
-- • LEFT → keep left table
-- • RIGHT → keep right table
-- • FULL → keep everything
-- • CROSS → all combinations
-- • SELF → same table, different roles


-- 1. How to know which table is LEFT and which is RIGHT

-- This part is wonderfully boring.

-- LEFT and RIGHT have nothing to do with foreign keys, importance, or logic.
-- They are purely about writing order.

-- Look at this query:

-- FROM dbo.employee e
-- LEFT JOIN dbo.department d
--     ON e.dept_id = d.id


-- The rule is mechanical:

-- The table before the word JOIN is the LEFT table

-- The table after the word JOIN is the RIGHT table

-- So here:

-- LEFT table → employee

-- RIGHT table → department

-- That’s it. No hidden meaning. SQL is literal-minded to the point of comedy.


-- 5. What a FOREIGN KEY actually does

-- Your foreign key:

-- employee.dept_id → department.id


-- Means:

-- “Every non-NULL value in employee.dept_id must already exist in department.id.”

-- That’s it.

-- It enforces data correctness, not query behavior.

-- It prevents nonsense like:

-- ('John', 60000, 999)  -- department 999 does not exist


-- SQL Server refuses this at INSERT/UPDATE time.