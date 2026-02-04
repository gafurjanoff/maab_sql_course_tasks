USE AdventureWorks2025;
-- RESTORE FILELISTONLY
-- FROM DISK = '/var/opt/mssql/backup/AdventureWorks2025.bak';

-- RESTORE DATABASE AdventureWorks2025
-- FROM DISK = '/var/opt/mssql/backup/AdventureWorks2025.bak'
-- WITH
--     MOVE 'AdventureWorks' TO '/var/opt/mssql/data/AdventureWorks2025.mdf',
--     MOVE 'AdventureWorks_log' TO '/var/opt/mssql/data/AdventureWorks2025_log.ldf',
--     REPLACE;


-- SELECT name FROM sys.databases WHERE name LIKE 'Adventure%';


SELECT TOP 10 PERCENT *  FROM Production.ProductCategory;


SELECT TOP 1 PERCENT * FROM Production.vProductAndDescription; 




