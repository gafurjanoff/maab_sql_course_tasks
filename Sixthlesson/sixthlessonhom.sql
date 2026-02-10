

CREATE DATABASE sixthlesson;
GO

use sixthlesson;


IF OBJECT_ID('dbo.Departments', 'U') IS NOT NULL
    DROP TABLE dbo.Departments;
GO



CREATE TABLE dbo.Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(50)
);
GO



IF OBJECT_ID('dbo.Employees', 'U') IS NOT NULL
    DROP TABLE dbo.Employees;
GO

CREATE TABLE dbo.Employees (
    EmployeeID INT PRIMARY KEY,
    Name VARCHAR(50),
    DepartmentID INT NULL,
    Salary INT,
    CONSTRAINT FK_Employees_Departments
        FOREIGN KEY (DepartmentID)
        REFERENCES dbo.Departments(DepartmentID)
);
GO


IF OBJECT_ID('dbo.Projects', 'U') IS NOT NULL
    DROP TABLE dbo.Projects;
GO


CREATE TABLE dbo.Projects (
    ProjectID INT PRIMARY KEY,
    ProjectName VARCHAR(50),
    EmployeeID INT NULL,
    CONSTRAINT FK_Projects_Employees
        FOREIGN KEY (EmployeeID)
        REFERENCES dbo.Employees(EmployeeID)
);
GO



INSERT INTO dbo.Departments (DepartmentID, DepartmentName)
VALUES
    (101, 'IT'),
    (102, 'HR'),
    (103, 'Finance'),
    (104, 'Marketing');


INSERT INTO dbo.Employees (EmployeeID, Name, DepartmentID, Salary)
VALUES
    (1, 'Alice',   101, 60000),
    (2, 'Bob',     102, 70000),
    (3, 'Charlie', 101, 65000),
    (4, 'David',   103, 72000),
    (5, 'Eva',     NULL, 68000);


INSERT INTO dbo.Projects (ProjectID, ProjectName, EmployeeID)
VALUES
    (1, 'Alpha', 1),
    (2, 'Beta',  2),
    (3, 'Gamma', 1),
    (4, 'Delta', 4),
    (5, 'Omega', NULL);


SELECT * FROM dbo.Departments;
SELECT * FROM dbo.Employees;
SELECT * FROM dbo.Projects;


-- INNER JOIN


SELECT  

    e.EmployeeID AS EmployeeID,
    e.Name AS EmpName,
    d.DepartmentName AS DepartmentName,
    e.Salary AS EmpSalary
    

FROM dbo.Employees e
INNER JOIN dbo.Departments d
ON e.DepartmentID = d.DepartmentID;





-- LEFT JOIN


SELECT  

    e.EmployeeID AS EmployeeID,
    e.Name AS EmpName,
    d.DepartmentName AS DepartmentName,
    e.Salary AS EmpSalary
    

FROM dbo.Employees e
LEFT JOIN dbo.Departments d
ON e.DepartmentID = d.DepartmentID;




-- RIGHT JOIN


SELECT  

    e.EmployeeID AS EmployeeID,
    e.Name AS EmpName,
    d.DepartmentName AS DepartmentName,
    e.Salary AS EmpSalary
    

FROM dbo.Employees e
RIGHT JOIN dbo.Departments d
ON e.DepartmentID = d.DepartmentID;





-- FULL JOIN

SELECT  

    e.EmployeeID AS EmployeeID,
    e.Name AS EmpName,
    d.DepartmentName AS DepartmentName,
    e.Salary AS EmpSalary
    

FROM dbo.Employees e
FULL JOIN dbo.Departments d
ON e.DepartmentID = d.DepartmentID;




-- FULL JOIN TOTAL SALARIES



SELECT
    d.DepartmentName,
    SUM(e.Salary) AS Total_Expenses
FROM dbo.Departments d
LEFT JOIN dbo.Employees e
    ON e.DepartmentID = d.DepartmentID
GROUP BY d.DepartmentName;



-- CROSS JOIN DEPARTMENTS AND PROJECTS

SELECT
    d.DepartmentName,
    p.ProjectName
FROM dbo.Departments d
CROSS JOIN dbo.Projects p;



-- MULTIPLE JOINS

SELECT  

    e.EmployeeID AS EmployeeID,
    e.Name AS EmpName,
    d.DepartmentName AS DepartmentName,
    p.ProjectName AS ProjectName,
     e.Salary AS EmpSalary
    

FROM dbo.Employees e
LEFT JOIN dbo.Departments d
ON e.DepartmentID = d.DepartmentID
LEFT JOIN dbo.Projects p
ON e.EmployeeID = p.EmployeeID;




