CREATE DATABASE eleventhlessontut;
GO

USE eleventhlessontut;
GO





-- ==============

-- SQL SERVER VARIABLES

-- ===============




DECLARE @text VARCHAR(MAX);

SET @text = 'Text';


SELECT @text;




DECLARE @Num INT;
SELECT @Num;

SET @Num = 1;
SELECT @Num;

SET @Num = 2;
SELECT @Num;


;WITH cteName(n)
AS  

(  
    SELECT 1
    UNION ALL
    SELECT n + 1 FROM cteName
    WHERE n < 10
)
SELECT * INTO numbers FROM cteName
GO

DECLARE @n  INT = 0;
SELECT @n = @n + n FROM numbers;
SELECT @n;



SELECT @@SERVERNAME
SELECT @@REMSERVER
SELECT @@IDENTITY


-- ====== Table Variable 



DECLARE  @mytable TABLE (

    id INT PRIMARY KEY IDENTITY,
    name VARCHAR(20)
);

-- INSERT INTO @mytable (name)
-- VALUES('samandar') ;
SELECT * FROM @mytable



-- Transactions


BEGIN TRAN trans

INSERT INTO @mytable
VALUES
('olim');
select * from @mytable

ROLLBACK TRAN trans;
SELECT * FROM @mytable

SELECT @@TRANCOUNT






-- ====== SQL Server Temp Table 


CREATE TABLE #products(

    id INT PRIMARY KEY IDENTITY,
    product_name VARCHAR(50),
    price DECIMAL(10,2)

);
GO


INSERT INTO #products
VALUES
('apple', 10.22),
('cherry', 40.12),
('strawberry', 24.45),
('tangerines', 65.92);


SELECT * FROM #products;


-- ====== SQL GLOBAL Temp Table



CREATE TABLE #employees(

    id INT PRIMARY KEY IDENTITY,
    emp_name VARCHAR(50),
    salary DECIMAL(10,2)

);
GO

INSERT INTO #employees
VALUES
('Malika', 10.22),
('Qurbon', 40.12),
('Oybek', 24.45),
('Olim', 65.92);


SELECT * FROM #employees;



-- ====== SQL SERVER VIEW




