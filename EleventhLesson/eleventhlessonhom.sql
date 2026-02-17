CREATE DATABASE eleventhlessonhom;
GO


USE eleventhlessonhom;
GO

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    Name NVARCHAR(50),
    Department NVARCHAR(50),
    Salary INT
);

INSERT INTO Employees (EmployeeID, Name, Department, Salary) VALUES
(1, 'Alice', 'HR', 5000),
(2, 'Bob', 'IT', 7000),
(3, 'Charlie', 'Sales', 6000),
(4, 'David', 'HR', 5500),
(5, 'Emma', 'IT', 7200);

CREATE TABLE Orders_DB1 (
    OrderID INT PRIMARY KEY,
    CustomerName NVARCHAR(50),
    Product NVARCHAR(50),
    Quantity INT
);

INSERT INTO Orders_DB1 (OrderID, CustomerName, Product, Quantity) VALUES
(101, 'Alice', 'Laptop', 1),
(102, 'Bob', 'Phone', 2),
(103, 'Charlie', 'Tablet', 1),
(104, 'David', 'Monitor', 1);

CREATE TABLE Orders_DB2 (
    OrderID INT PRIMARY KEY,
    CustomerName NVARCHAR(50),
    Product NVARCHAR(50),
    Quantity INT
);

INSERT INTO Orders_DB2 (OrderID, CustomerName, Product, Quantity) VALUES
(101, 'Alice', 'Laptop', 1),
(103, 'Charlie', 'Tablet', 1);

CREATE TABLE WorkLog (
    EmployeeID INT,
    EmployeeName NVARCHAR(50),
    Department NVARCHAR(50),
    WorkDate DATE,
    HoursWorked INT
);

INSERT INTO WorkLog (EmployeeID, EmployeeName, Department, WorkDate, HoursWorked) VALUES
(1, 'Alice', 'HR', '2024-03-01', 8),
(2, 'Bob', 'IT', '2024-03-01', 9),
(3, 'Charlie', 'Sales', '2024-03-02', 7),
(1, 'Alice', 'HR', '2024-03-03', 6),
(2, 'Bob', 'IT', '2024-03-03', 8),
(3, 'Charlie', 'Sales', '2024-03-04', 9);


CREATE TABLE #EmployeeTransfers (
    EmployeeID INT,
    Name NVARCHAR(50),
    Department NVARCHAR(50),
    Salary INT
);

INSERT INTO #EmployeeTransfers (EmployeeID, Name, Department, Salary)
SELECT EmployeeID, Name,
       CASE Department
            WHEN 'HR' THEN 'IT'
            WHEN 'IT' THEN 'Sales'
            WHEN 'Sales' THEN 'HR'
       END,
       Salary
FROM Employees;

SELECT * FROM #EmployeeTransfers;


DECLARE @MissingOrders TABLE 
(
    OrderID INT PRIMARY KEY,
    CustomerName NVARCHAR(50),
    Product NVARCHAR(50),
    Quantity INT
);

INSERT INTO @MissingOrders (OrderID, CustomerName, Product, Quantity)
SELECT OrderID, CustomerName, Product, Quantity
FROM Orders_DB1;

SELECT * FROM @MissingOrders;

GO

DROP VIEW IF EXISTS vw_MonthlyWorkSummary;
GO

CREATE VIEW vw_MonthlyWorkSummary AS 
(
SELECT DISTINCT

    EmployeeID,
    EmployeeName,
    Department,
    SUM(HoursWorked) OVER(PARTITION BY EmployeeID) AS TotalHoursWorked,

    SUM(HoursWorked) OVER(PARTITION BY Department) AS TotalHoursDepartment,

    AVG(CAST(HoursWorked AS FLOAT)) OVER(PARTITION BY Department) AS AvgHoursDepartment
    FROM WorkLog

);
GO


SELECT * FROM vw_MonthlyWorkSummary;


