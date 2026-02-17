CREATE DATABASE tenthlessontut;
GO

USE tenthlessontut;


;WITH factorial(Num, Factorial) AS
(
    SELECT 1  , 1 
    UNION ALL
    SELECT Num + 1, Factorial * (Num + 1)
    FROM factorial
    WHERE Num <= 10

)


SELECT * FROM factorial;



;WITH CTE_Fibonacci(Num, Fibonacci_Num, Prev_Num) AS
(
    SELECT 1, 1, 0
    UNION ALL
    SELECT Num + 1, Fibonacci_Num + Prev_Num, Fibonacci_Num
    FROM CTE_Fibonacci
    WHERE Fibonacci_Num + Prev_Num < 11

)

SELECT Num,Fibonacci_Num FROM CTE_Fibonacci;



CREATE TABLE TestMax(


    id INT,
    Max1 INT,
    Max2 INT,
    Max3 INT
);
GO


INSERT INTO TestMax(id, Max1, Max2, Max3)
VALUES
(1, 34, 65, 78),
(2, 45, 89, 23),
(3, 54, 96, 23),
(4, 104, 67, 56);
GO


SELECT id, GREATEST(Max1, Max2, Max3) FROM TestMax;





