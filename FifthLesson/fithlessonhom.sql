

CREATE DATABASE fifthlesson;
GO

USE fifthlesson;


DROP TABLE IF EXISTS Employees;
GO



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


SELECT * FROM dbo.Employees;



-- TASK 1

SELECT *, ROW_NUMBER() OVER(ORDER BY Salary DESC) AS Salary_Rank 
FROM dbo.Employees;


SELECT
    EmployeeID,
    Name,
    Salary,
    ROW_NUMBER() OVER (ORDER BY Salary DESC) AS  Salary_Rank 
FROM Employees;


-- TASK 2
SELECT
    EmployeeID,
    Name,
    Salary,
    RANK() OVER (ORDER BY Salary DESC) AS  Salary_Rank 
FROM Employees;


-- NOT TO SEE ANY GAPS, WE HAVE TO USE DENSE_RANK() INSTEAD


SELECT
    EmployeeID,
    Name,
    Salary,
    DENSE_RANK() OVER (ORDER BY Salary DESC) AS  Salary_Rank 
FROM dbo.Employees;




-- TASK 3
SELECT * 
FROM
(SELECT *, 
    DENSE_RANK()
    OVER (PARTITION BY Department ORDER BY Salary DESC)
    AS  dp_rank 
FROM dbo.Employees) AS sub_table
WHERE dp_rank <= 2;



-- TASK 4


SELECT * 
FROM
(SELECT *, 
    RANK()
    OVER (PARTITION BY Department ORDER BY Salary ASC)
    AS  dp_rank 
FROM dbo.Employees) AS sub_table
WHERE dp_rank = 1;



-- TASK 5
SELECT *,
    SUM(Salary) OVER (
        PARTITION BY Department
        ORDER BY HireDate
    ) AS running_total
FROM dbo.Employees;


-- TASK 6

SELECT *, 
    SUM(Salary)
    OVER (PARTITION by Department)
    AS  salary_sum 
FROM dbo.Employees;


-- TASK 7

SELECT *, 
    AVG(Salary)
    OVER (PARTITION by Department)
    AS  average_salary
FROM dbo.Employees;


-- TASK 8

SELECT *, 
    Salary - AVG(Salary)
    OVER (PARTITION by Department)
    AS  average_salary_diff
FROM dbo.Employees;


-- TASK 9


SELECT *, 
 CAST(
        AVG(Salary) OVER (
            ORDER BY EmployeeID
            ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING)
        AS DECIMAL(10,2)
 ) AS moving_salary
FROM dbo.Employees;


-- TASK 10


SELECT *,
SUM(Salary) 
OVER 
    (ORDER BY HireDate ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)

AS last_3_sum
FROM dbo.Employees;

-- TASK 11

SELECT *,

AVG(Salary) 
OVER 
    (ORDER BY HireDate ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)

AS running_avg
FROM dbo.Employees;


-- TASK 12

SELECT *,

MAX(Salary) 
OVER 
    (ORDER BY EmployeeID ROWS BETWEEN 2 PRECEDING AND 2 FOLLOWING)

AS max_2_2
FROM dbo.Employees;


-- TASK 13


SELECT *,


CAST(

    Salary / SUM(Salary)
    OVER 
        (PARTITION BY Department) * 100 
        AS DECIMAL(10,2)
)AS contrib_emp
FROM dbo.Employees;



SELECT
    EmployeeID,
    Name,
    Department,
    Salary,
    CAST(Salary * 100.0 /
    SUM(Salary) OVER (PARTITION BY Department)
     AS DECIMAL(10,2)
     ) AS percent_contribution
FROM Employees;



