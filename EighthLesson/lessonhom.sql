CREATE DATABASE eighthlessonhom
GO

USE eighthlessonhom;


IF OBJECT_ID('dbo.groupings', 'U') IS NOT NULL
    DROP TABLE dbo.groupings;

GO


CREATE TABLE dbo.groupings(


    StepNumber INT,
    Status VARCHAR(20) NOT NULL
    CONSTRAINT chk_status
    CHECK(Status IN ('Passed', 'Failed'))

);
GO


INSERT INTO dbo.groupings (StepNumber, Status)
VALUES
(1,  'Passed'),
(2,  'Passed'),
(3,  'Passed'),
(4,  'Passed'),
(5,  'Failed'),
(6,  'Failed'),
(7,  'Failed'),
(8,  'Failed'),
(9,  'Failed'),
(10, 'Passed'),
(11, 'Passed'),
(12, 'Passed');


SELECT *, 

ROW_NUMBER() OVER (PARTITION BY Status ORDER BY StepNumber)
FROM dbo.groupings;



WITH CTE AS
(
    SELECT *,
        ROW_NUMBER() OVER (ORDER BY StepNumber) - 
        ROW_NUMBER() OVER (PARTITION BY Status ORDER BY StepNumber) AS grp
    FROM dbo.Groupings
) 

SELECT

    MIN(StepNumber) AS [Min Step Number],
    MAX(StepNumber) AS [Max Step Number],
    Status,
    COUNT(*) AS [Consecutive Count]
FROM CTE
GROUP BY grp, Status
ORDER BY [Min Step Number];




IF OBJECT_ID('[dbo].[EMPLOYEES_N]', 'U') IS NOT NULL
    DROP TABLE [dbo].[EMPLOYEES_N];

GO

CREATE TABLE [dbo].[EMPLOYEES_N]
(
    EMPLOYEE_ID INT NOT NULL PRIMARY KEY,
    FIRST_NAME VARCHAR(20) NULL,
    HIRE_DATE DATE NOT NULL
);


INSERT INTO [dbo].[EMPLOYEES_N] (EMPLOYEE_ID, FIRST_NAME, HIRE_DATE)
VALUES
(1, 'Alice',  '1975-03-10'),
(2, 'Bob',    '1976-07-21'),


(3, 'Carol',  '1977-01-15'),
(4, 'David',  '1979-11-30'),


(5, 'Eve',    '1980-05-09'),
(6, 'Frank',  '1982-02-17'),


(7, 'Grace',  '1983-06-25'),
(8, 'Henry',  '1984-09-12'),
(9, 'Ivy',    '1985-12-01'),
(10,'Jack',   '1990-04-18'),

(11,'Kate',   '1997-08-03'),


(12,'Leo',    '2026-01-10');





WITH Years AS (
    SELECT 1975 AS Y
    UNION ALL
    SELECT Y + 1
    FROM Years
    WHERE Y + 1 <= YEAR(GETDATE())
),

HireYears AS (
    SELECT DISTINCT YEAR(HIRE_DATE) AS Y
    FROM EMPLOYEES_N
),


MissingYears AS (
    SELECT Y
    FROM Years
    WHERE Y NOT IN (SELECT Y FROM HireYears)
),


Grouped AS (
    SELECT
        Y,
        Y - ROW_NUMBER() OVER (ORDER BY Y) AS grp
    FROM MissingYears
)


SELECT
    CONCAT(MIN(Y), ' - ', MAX(Y)) AS Years
FROM Grouped
GROUP BY grp
OPTION (MAXRECURSION 0);




