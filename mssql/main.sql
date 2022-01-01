-- SHOW QUERY PLAN, must be executed on its own. will affect all other queries until OFF is called
-- all other queries will only be estimates of resources to perform the query, not the results of the actual query
SET SHOWPLAN_ALL ON;
SET SHOWPLAN_ALL OFF;
-- SHOWPLAN_TEXT, SHOWPLAN_XML, STATISTICS PROFILE, STATISTICS IO, STATISTICS TIME also operate the same way

-- CROSS APPLY (like INNER JOIN) and OUTER APPLY (like LEFT JOIN) is to remove sub queries from select statments
-- convert this...
select
thing = (select top(1) t2.yo as thing from dbo.t2)
from dbo.t1
-- to this
select
thing = ca.thing
from dbo.t1
cross apply (
  select top(1) t2.yo as thing
  from dbo.t2
) as ca

-- PIVOT (like unmelt in pandas) UNPIVOT (like melt in pandas)

-- microsoft docs for mssql
https://docs.microsoft.com/en-us/sql/t-sql/language-reference?view=sql-server-ver15

-- Declare a table, ie a record / list of records
DECLARE @endUser table (
  EndUserId INT
  ,[Name] VARCHAR(50)
  , [Age] INT
)

-- OUTPUT..INTO EXAMPLES BEGIN
-- Get auto generated id back from an insert along with other info using a table variable with OUTPUT..INTO
INSERT INTO dbo.EndUser
(
  Name
  ,Age
)
OUTPUT INSERTED.EndUserId, INSERTED.Name, INSERTED.Age
INTO @endUser
VALUES
(
  'Bob'
  ,24
)
;

DELETE Production.ProductProductPhoto
OUTPUT DELETED.ProductID,
p.Name,
p.ProductModelID,
DELETED.ProductPhotoID
INTO @MyTableVar
FROM Production.ProductProductPhoto AS ph
JOIN Production.Product as p
ON ph.ProductID = p.ProductID
WHERE p.ProductModelID BETWEEN 120 and 130
;

DECLARE @MyTableVar TABLE (
EmpID INT NOT NULL,
OldVacationHours INT,
NewVacationHours INT,
ModifiedDate DATETIME);

UPDATE TOP (10) HumanResources.Employee
SET VacationHours = VacationHours * 1.25,
ModifiedDate = GETDATE()
OUTPUT inserted.BusinessEntityID,
deleted.VacationHours,
inserted.VacationHours,
inserted.ModifiedDate
INTO @MyTableVar
WHERE ...
;

-- OUTPUT..INTO EXAMPLES END

-- setting a variable and multi variable declaration
DECLARE @STR NVARCHAR(100), @LEN1 INT, @LEN2 INT;
SET @STR = N'This is a sentence with spaces in it.';
SET @LEN1 = LEN(@STR);
SET @STR = REPLACE(@STR, N' ', N'');
SET @LEN2 = LEN(@STR);
SELECT N'Number of spaces in the string: ' + CONVERT(NVARCHAR(20), @LEN1 - @LEN2);
GO

-- can swap COUNT with any agg function in these examples

-- COUNT and other aggregation functions can take DISTINCT
SELECT COUNT(DISTINCT Title)  
FROM HumanResources.Employee;

-- Ignores null
COUNT(*)

-- Includes null
COUNT(*)

-- Bulk insert from a select statement
INSERT INTO Customers (CustomerName, City, Country)
SELECT SupplierName, City, Country FROM Suppliers
WHERE Country='Germany';

-- Date operations
SELECT TOP(1) DATEPART (day,'12/20/1974') FROM dbo.DimCustomer;  
-- Returns: 20

-- JSON operations
SELECT PersonID,FullName,
  JSON_QUERY(CustomFields,'$.OtherLanguages') AS Languages
FROM Application.People

-- String functions
REVERSE
REPLACE
UPPER
NCHAR
SOUNDEX
TRANSLATE
String
STUFF
SUBSTRING
FORMAT
ASCII
STRING_AGG
PATINDEX
UNICODE
TRIM
CONCAT_WS
LOWER
LEFT
DIFFERENCE
STR
CONCAT
LTRIM
CHAR
SPACE
RTRIM
CHARINDEX
RIGHT
LEN
QUOTENAME
STRING_ESCAPE
REPLICATE

