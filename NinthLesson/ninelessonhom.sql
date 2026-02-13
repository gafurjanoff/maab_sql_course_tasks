CREATE DATABASE ninthhom;
GO
USE ninthhom;



IF OBJECT_ID('dbo.Employees', 'U') IS NOT NULL
    DROP TABLE dbo.Employees;
GO




CREATE TABLE Employees
(
	EmployeeID  INTEGER PRIMARY KEY,
	ManagerID   INTEGER NULL,
	JobTitle    VARCHAR(100) NOT NULL
);

INSERT INTO Employees (EmployeeID, ManagerID, JobTitle) 
VALUES
	(1001, NULL, 'President'),
	(2002, 1001, 'Director'),
	(3003, 1001, 'Office Manager'),
	(4004, 2002, 'Engineer'),
	(5005, 2002, 'Engineer'),
	(6006, 2002, 'Engineer');

SELECT * FROM dbo.Employees;



WITH  Employee_CTE AS (

    SELECT EmployeeID,
            ManagerID,
             JobTitle, 
             0 AS Depth FROM Employees 
    WHERE ManagerID IS NULL

    UNION ALL

    SELECT
        em1.EmployeeID,
        em1.ManagerID,
        em1.JobTitle,
        em2.Depth + 1
    FROM Employees em1
    INNER JOIN Employee_CTE em2
        ON em1.ManagerID = em2.EmployeeID
)

SELECT * FROM Employee_CTE
ORDER BY Depth, ManagerID;

DECLARE @N INT = 10;

WITH Factorials AS
(
    SELECT
        1 AS Num,
        CAST(1 AS BIGINT) AS Factorial

    UNION ALL

    SELECT
        Num + 1,
        Factorial * (Num + 1)
    FROM Factorials
    WHERE Num + 1 <= @N
)
SELECT *
FROM Factorials;




DECLARE @q INT = 10;

WITH Fibonacci AS
(
    SELECT
        1 AS n,
        1 AS Fib,
        1 AS NextFib

    UNION ALL

    SELECT
        n + 1,
        NextFib,
        Fib + NextFib
    FROM Fibonacci
    WHERE n + 1 <= @q
)
SELECT
    n,
    Fib AS Fibonacci_Number
FROM Fibonacci;