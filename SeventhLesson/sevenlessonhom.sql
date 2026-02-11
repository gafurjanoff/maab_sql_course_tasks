CREATE DATABASE seventhlesson;
GO

USE seventhlesson;


IF OBJECT_ID('dbo.Customers', 'U') IS NOT NULL
    DROP TABLE dbo.Customers;
GO

CREATE TABLE dbo.Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100) NOT NULL
);


IF OBJECT_ID('dbo.Orders', 'U') IS NOT NULL
    DROP TABLE dbo.Orders;
GO

CREATE TABLE dbo.Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT NOT NULL,
    OrderDate DATE NOT NULL,
    CONSTRAINT FK_Orders_Customers
        FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);


IF OBJECT_ID('dbo.Products', 'U') IS NOT NULL
    DROP TABLE dbo.Products;
GO

CREATE TABLE dbo.Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100) NOT NULL,
    Category VARCHAR(50) NOT NULL
);


IF OBJECT_ID('dbo.OrderDetails', 'U') IS NOT NULL
    DROP TABLE dbo.OrderDetails;
GO

CREATE TABLE dbo.OrderDetails (
    OrderDetailID INT PRIMARY KEY,
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL,
    Price DECIMAL(10,2) NOT NULL,
    CONSTRAINT FK_OrderDetails_Orders
        FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    CONSTRAINT FK_OrderDetails_Products
        FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);





INSERT INTO Customers VALUES
(1, 'Alice'),
(2, 'Bob'),
(3, 'Charlie'),
(4, 'Diana');

INSERT INTO Orders VALUES
(101, 1, '2024-01-10'),
(102, 1, '2024-02-15'),
(103, 2, '2024-03-05'),
(104, 3, '2024-03-20');

INSERT INTO Products VALUES
(1, 'Laptop', 'Electronics'),
(2, 'Mouse', 'Electronics'),
(3, 'Notebook', 'Stationery'),
(4, 'Pen', 'Stationery');

INSERT INTO OrderDetails VALUES
(1, 101, 1, 1, 1200.00),
(2, 101, 2, 2, 25.00),
(3, 102, 3, 5, 3.50),
(4, 103, 4, 10, 1.50),
(5, 104, 1, 1, 1200.00);


SELECT * FROM dbo.Customers;
SELECT * FROM dbo.Orders;
SELECT * FROM dbo.OrderDetails;
SELECT * FROM dbo.Products;



SELECT 
    c.CustomerID,
    c.CustomerName,
    o.OrderID,
    o.OrderDate
FROM dbo.Customers c 
LEFT JOIN dbo.Orders o
ON c.CustomerID = o.CustomerID



SELECT 
    c.CustomerID,
    c.CustomerName,
    o.OrderID,
    o.OrderDate
FROM dbo.Customers c 
LEFT JOIN dbo.Orders o
ON c.CustomerID = o.CustomerID
WHERE o.CustomerID is NULL;




SELECT 
    o.OrderID,
    o.OrderDate,
    p.ProductName,
    od.Quantity,
    od.Price
FROM dbo.Orders o
INNER JOIN dbo.OrderDetails od
    ON o.OrderID = od.OrderID
INNER JOIN Products p 
    ON od.ProductID = p.ProductID
ORDER BY p.ProductName, od.Quantity;


-- TASK 4

WITH RankedCustomers AS 
(SELECT 
    c.CustomerID,
    c.CustomerName,
    o.OrderID,
    o.OrderDate,
ROW_NUMBER() OVER(PARTITION BY c.CustomerID
    ORDER BY o.OrderDate) AS rank_customer
FROM dbo.Customers c 
LEFT JOIN dbo.Orders o
ON c.CustomerID = o.CustomerID
)

SELECT 
    CustomerID,
     CustomerName,
      OrderID, 
      OrderDate FROM RankedCustomers
WHERE rank_customer >= 2;



SELECT 
    c.CustomerID,
    c.CustomerName
FROM dbo.Customers c 
LEFT JOIN dbo.Orders o
ON c.CustomerID = o.CustomerID
GROUP BY 
    c.CustomerID,
    c.CustomerName
HAVING COUNT(o.OrderID) > 1;





-- SELECT 
--     o.OrderID,
--     p.ProductName,
--     od.Price,
--     ROW_NUMBER() OVER (PARTITION BY o.OrderID ORDER BY od.Price DESC) AS rn
-- FROM dbo.Orders o
-- INNER JOIN dbo.OrderDetails od
--     ON o.OrderID = od.OrderID
-- INNER JOIN dbo.Products p 
--     ON od.ProductID = p.ProductID
-- ORDER BY o.OrderID, rn;



SELECT *
FROM(

    SELECT 
    o.OrderID,
    p.ProductName,
    od.Price,
    ROW_NUMBER() OVER (PARTITION BY o.OrderID
    ORDER BY od.Price DESC) AS rn
FROM dbo.Orders o
INNER JOIN dbo.OrderDetails od
    ON o.OrderID = od.OrderID
INNER JOIN Products p 
    ON od.ProductID = p.ProductID
)
AS t
WHERE rn = 1;



SELECT *
FROM(
    SELECT 
    c.CustomerID,
    c.CustomerName,
    o.OrderID,
    o.OrderDate,
    ROW_NUMBER() OVER(PARTITION BY c.CustomerID
ORDER BY o.OrderDate) AS rn
FROM dbo.Customers c 
JOIN dbo.Orders o
ON c.CustomerID = o.CustomerID)
AS t
WHERE rn = 1;



SELECT 
    c.CustomerID, c.CustomerName
FROM Customers c
INNER JOIN Orders o
    ON c.CustomerID = o.CustomerID
INNER JOIN dbo.OrderDetails od
    ON o.OrderID = od.OrderID
INNER JOIN Products p 
    ON od.ProductID = p.ProductID
GROUP BY c.CustomerID, c.CustomerName
HAVING COUNT(DISTINCT CASE 
WHEN p.Category <> 'Electronics' THEN 1 END) = 0;






SELECT 
    c.CustomerID, c.CustomerName
FROM Customers c
WHERE EXISTS(
    SELECT 1 FROM Orders o  
    INNER JOIN dbo.OrderDetails od
        ON o.OrderID = od.OrderID
    INNER JOIN dbo.Products p
        ON od.ProductID = p.ProductID
    WHERE o.CustomerID = c.CustomerID
      AND p.Category = 'Stationery'
);


SELECT DISTINCT c.CustomerID, c.CustomerName
FROM dbo.Customers c
JOIN dbo.Orders o
    ON c.CustomerID = o.CustomerID
JOIN dbo.OrderDetails od
    ON o.OrderID = od.OrderID
JOIN dbo.Products p
    ON od.ProductID = p.ProductID
WHERE p.Category = 'Stationery';




SELECT c.CustomerID, c.CustomerName
FROM dbo.Customers c
JOIN dbo.Orders o
    ON c.CustomerID = o.CustomerID
JOIN dbo.OrderDetails od
    ON o.OrderID = od.OrderID
JOIN dbo.Products p
    ON od.ProductID = p.ProductID
GROUP BY c.CustomerID, c.CustomerName
HAVING COUNT(CASE WHEN p.Category = 'Stationery' THEN 1 END) >= 1;






SELECT 
    c.CustomerID,
    c.CustomerName,
    SUM(od.Price * od.Quantity)
        AS Total_Spent
FROM Customers c
INNER JOIN dbo.Orders o
ON c.CustomerID = o.CustomerID
INNER JOIN dbo.OrderDetails od
    ON o.OrderID = od.OrderID
INNER JOIN Products p 
    ON od.ProductID = p.ProductID
GROUP BY c.CustomerID, c.CustomerName
ORDER BY c.CustomerID;




