CREATE DATABASE eighthlessontut;
GO

USE seventhlesson;




-- ===============
------ SUBQUERY
-- ======================


SELECT 1A, 2B; -- ONE COLUMN


SELECT *, 
(SELECT MAX(Price) FROM dbo.OrderDetails WHERE ProductID = 1),
(SELECT SUM(Price) FROM dbo.OrderDetails WHERE ProductID = 1)
FROM OrderDetails;



SELECT *, (SELECT SUM(Price), MAX(Price) FROM dbo.OrderDetails WHERE ProductID = 1)
FROM OrderDetails;

