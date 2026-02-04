CREATE DATABASE thirdlesson;
GO

USE thirdlesson;


IF OBJECT_ID('dbo.employees', 'U') IS NULL
    CREATE TABLE dbo.employees (

        employee_id INT PRIMARY KEY,
        first_name VARCHAR(50),
        last_name VARCHAR(50),
        department VARCHAR(50),
        salary DECIMAL(10,2),
        hiredate DATE

    );
GO




IF OBJECT_ID('dbo.orders', 'U') IS NULL 

    CREATE TABLE dbo.orders(

        order_id INT PRIMARY KEY,
        customer_name VARCHAR(100),
        orderdate DATE,
        total_amount DECIMAL(10,2),
        order_status VARCHAR(20),
        CONSTRAINT chk_status
         CHECK (order_status IN ('Pending', 'Shipped', 'Delivered', 'Cancelled'))
    )
GO


IF OBJECT_ID('dbo.products', 'U') IS NULL 
    CREATE TABLE dbo.products (
        ProductID INT PRIMARY KEY,
        ProductName VARCHAR(100),
        Category VARCHAR(50),
        Price DECIMAL(10,2),
        Stock INT
    );

GO



INSERT INTO dbo.employees (employee_id, first_name, last_name, department, salary, hiredate) VALUES
(1, 'Alice', 'Smith', 'IT', 120000, '2019-03-01'),
(2, 'Bob', 'Johnson', 'Finance', 110000, '2018-06-15'),
(3, 'Carol', 'Brown', 'IT', 90000, '2020-01-10'),
(4, 'David', 'Wilson', 'HR', 85000, '2021-02-20'),
(5, 'Eva', 'Taylor', 'Finance', 80000, '2019-11-05'),
(6, 'Frank', 'Anderson', 'HR', 75000, '2022-04-18'),
(7, 'Grace', 'Thomas', 'IT', 70000, '2020-08-09'),
(8, 'Henry', 'Moore', 'Finance', 68000, '2021-09-30'),
(9, 'Ivy', 'Martin', 'HR', 65000, '2022-01-12'),
(10, 'Jack', 'Lee', 'IT', 60000, '2023-03-03'),
(11, 'Karen', 'Perez', 'Finance', 58000, '2020-12-01'),
(12, 'Leo', 'White', 'HR', 55000, '2019-05-14'),
(13, 'Mona', 'Harris', 'IT', 52000, '2021-07-21'),
(14, 'Nina', 'Clark', 'Finance', 50000, '2022-10-10'),
(15, 'Oscar', 'Lewis', 'HR', 48000, '2023-01-08'),
(16, 'Paul', 'Walker', 'IT', 45000, '2020-02-02'),
(17, 'Quinn', 'Hall', 'Finance', 42000, '2021-06-06'),
(18, 'Rose', 'Allen', 'HR', 40000, '2019-09-09'),
(19, 'Steve', 'Young', 'IT', 38000, '2022-11-11'),
(20, 'Tina', 'King', 'Finance', 36000, '2023-05-05');



-- ### **Task 1: Employee Salary Report**
-- Write an SQL query that:
-- - Selects the **top 10% highest-paid** employees.
-- - Groups them by **department** and calculates the **average salary per department**.
-- - Displays a new column `SalaryCategory`:
--   - 'High' if Salary > 80,000  
--   - 'Medium' if Salary is **between** 50,000 and 80,000  
--   - 'Low' otherwise.  
-- - Orders the result by `AverageSalary` **descending**.
-- - Skips the first 2 records and fetches the next 5.


SELECT department, AVG(salary) AS AverageSalary,

        CASE 
            WHEN salary > 80000 THEN 'High'  
            WHEN salary BETWEEN 50000 AND 80000 THEN 'Medium' 
            ELSE 'Low'
        END AS SalaryCategory

FROM (SELECT TOP (10) PERCENT * FROM dbo.employees ORDER BY salary DESC) AS HighPaidEmployees

GROUP BY department,

    CASE
        WHEN Salary > 80000 THEN 'High'
        WHEN Salary BETWEEN 50000 AND 80000 THEN 'Medium'
        ELSE 'Low'
    END

ORDER BY AverageSalary DESC
-- OFFSET 2 ROWS FETCH NEXT 5 ROWS ONLY



-- SELECT  * FROM dbo.employees;



INSERT INTO dbo.orders (order_id, customer_name, orderdate, total_amount, order_status) VALUES
(1, 'Aliyev Aziz',     '2023-01-15', 1200.50, 'Pending'),
(2, 'Karimova Dilnoza','2023-02-10', 3400.00, 'Shipped'),
(3, 'Tursunov Bekzod', '2023-03-05', 780.75,  'Delivered'),
(4, 'Islomova Malika', '2023-04-22', 1500.00, 'Cancelled'),
(5, 'Rahmonov Jamshid','2023-05-18', 5200.90, 'Delivered'),
(6, 'Usmonova Nodira', '2023-06-01', 2300.40, 'Shipped'),
(7, 'Qodirov Farrux', '2023-07-14', 640.00,  'Pending'),
(8, 'Saidova Zilola', '2023-08-09', 4100.00, 'Delivered'),
(9, 'Yusupov Akmal',  '2023-09-30', 890.25,  'Cancelled'),
(10,'Abdullayeva Laylo','2023-11-11', 6700.00, 'Shipped');




INSERT INTO dbo.products (ProductID, ProductName, Category, Price, Stock) VALUES
(1, 'Noutbuk Lenovo',      'Elektronika', 850.00, 12),
(2, 'Smartfon Samsung',   'Elektronika', 720.50, 5),
(3, 'Televizor Artel',    'Maishiy texnika', 640.00, 0),
(4, 'Kir yuvish mashina', 'Maishiy texnika', 560.75, 3),
(5, 'Sovutgich LG',       'Maishiy texnika', 910.00, 8),
(6, 'Ofis stoli',         'Mebel', 210.00, 15),
(7, 'Kompyuter stuli',    'Mebel', 180.50, 2),
(8, 'Kitob javoni',       'Mebel', 150.00, 0),
(9, 'Quloqchin Sony',     'Aksessuarlar', 95.00, 25),
(10,'Sichqoncha Logitech','Aksessuarlar', 45.99, 7);


-- ### **Task 2: Customer Order Insights**
-- Write an SQL query that:
-- - Selects customers who placed orders **between** '2023-01-01' and '2023-12-31'.  
-- - Includes a new column `OrderStatus` that returns:
--   - 'Completed' for **Shipped** or **Delivered** orders.  
--   - 'Pending' for **Pending** orders.  
--   - 'Cancelled' for **Cancelled** orders.  
-- - Groups by `OrderStatus` and finds the **total number of orders** and **total revenue**.  
-- - Filters only statuses where revenue is greater than 5000.  
-- - Orders by `TotalRevenue` **descending**.


SELECT 
    CASE
        WHEN order_status IN ('Shipped', 'Delivered') THEN 'Completed'
        WHEN order_status = 'Pending' THEN 'Pending'
        ELSE 'Cancelled'
    END AS OrderStatus,

    COUNT(*) AS TotalOrders,
    SUM(total_amount) AS TotalRevenue 

FROM dbo.orders
WHERE orderdate BETWEEN '2023-01-01' and '2023-12-31'
GROUP BY
    CASE
        WHEN order_status IN ('Shipped', 'Delivered') THEN 'Completed'
        WHEN order_status = 'Pending' THEN 'Pending'
        ELSE 'Cancelled'
    END

HAVING SUM(total_amount) >= 5000

ORDER BY TotalRevenue DESC;




-- ### **Task 3: Product Inventory Check**
-- Write an SQL query that:
-- - Selects **distinct** product categories.
-- - Finds the **most expensive** product in each category.
-- - Assigns an inventory status using `IIF`:
--   - 'Out of Stock' if `Stock = 0`.  
--   - 'Low Stock' if `Stock` is **between** 1 and 10.  
--   - 'In Stock' otherwise.  
-- - Orders the result by `Price` **descending** and skips the first 5 rows.




SELECT Category, 
       MAX(Price) AS Price,

    IIF(
        MIN(Stock) = 0, 'Out of Stock',
        IIF(MIN(Stock) BETWEEN 1 AND 10, 'Low Stock', 'In Stock')
    ) AS InventoryStatus
FROM products
GROUP BY Category
ORDER BY Price DESC
OFFSET 3 ROWS;

