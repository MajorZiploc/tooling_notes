USE System;

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

/*
Actual script below
 */

DECLARE @responseDate DATE
	  , @responseEndDate DATE
	  , @responseDateFormat VARCHAR(8)
	  , @rnMax VARCHAR(4)
	  , @rvaId INT
	  , @server VARCHAR(3);

SET @responseDate = DATEADD(D, -1, GETDATE());
SET @responseEndDate = GETDATE();
SET @server = LEFT(@@SERVERNAME, 3);

SELECT @rvaId = MIN(rva.ID)
FROM dbo.Response_Vehicles_Assigned AS rva WITH (NOLOCK)
INNER JOIN dbo.Response_Master_Incident AS rmi WITH (NOLOCK) ON rmi.ID = rva.Master_Incident_ID
WHERE ISNULL(Response_Number, '') = ''
  AND rmi.Response_Date >= @responseDate
  AND rmi.Response_Date < @responseEndDate

--SELECT @rvaId

WHILE @rvaId IS NOT NULL 
BEGIN
	-- Sets Format for RVA Response Date based on LFT vs AUS
	-- LFT Format = MMddyyyy
	-- AUS Format = yyyyMMdd
	SELECT @responseDateFormat = FORMAT(rmi.Response_Date, IIF(@server = 'LFT','MMddyyyy', 'yyyyMMdd'))
	FROM dbo.Response_Vehicles_Assigned AS rva WITH (NOLOCK)
	INNER JOIN dbo.Response_Master_Incident AS rmi WITH (NOLOCK) ON rmi.ID = rva.Master_Incident_ID
	WHERE @rvaId = rva.ID

	-- Gets New last 4 of Response number
	SELECT @rnMax = RIGHT(CONCAT('0000', MAX(RIGHT(rva.Response_Number, 4)) + 1), 4) 
	FROM dbo.Response_Vehicles_Assigned AS rva WITH (NOLOCK)
	INNER JOIN dbo.Response_Master_Incident AS rmi WITH (NOLOCK) ON rmi.ID = rva.Master_Incident_ID
	WHERE LEFT(rva.Response_Number, 8) = @responseDateFormat

	-- Insert into table for CADxChanger export
	INSERT INTO ePCR.dbo.FixedResponseNumber
	(
	    rvaId,
	    rvaResponseNumber
	)
	VALUES
	(   @rvaId, -- rvaId - int
	    CONCAT(@responseDateFormat, '-', @rnMax)  -- rvaResponseNumber - varchar(50)
	    )

	-- Selects/Updates new response number 
	UPDATE dbo.Response_Vehicles_Assigned 
	SET Response_Number = CONCAT(@responseDateFormat, '-', @rnMax)
	WHERE @rvaId = ID

	/*
	SELECT CONCAT(@responseDateFormat, '-', @rnMax)
	FROM dbo.Response_Vehicles_Assigned AS rva WITH (NOLOCK)
	INNER JOIN dbo.Response_Master_Incident AS rmi WITH (NOLOCK) ON rmi.ID = rva.Master_Incident_ID
	WHERE @rvaId = rva.ID
	*/

	-- Add Base Response number to fixed responses
	-- We noticed some discrepancy with Cancel_Reason and Base_Response_Number
	-- We chose to ignore it, and follow Tim's (Central Square) advice that first Time_Assigned is the only needed value for determining Base Response Number
	UPDATE dbo.Response_Master_Incident
	SET Base_Response_Number = brva.Response_Number
	FROM dbo.Response_Vehicles_Assigned AS rva WITH (NOLOCK)
	INNER JOIN dbo.Response_Master_Incident AS rmi WITH (NOLOCK) ON rmi.ID = rva.Master_Incident_ID
	CROSS APPLY (
		SELECT TOP 1 brva.Response_Number
		FROM dbo.Response_Vehicles_Assigned AS brva
		WHERE rmi.ID = brva.Master_Incident_ID
		ORDER BY brva.Time_Assigned
	) AS brva
	WHERE @rvaId = rva.ID

	/*
	SELECT rmi.Base_Response_Number, brva.Response_Number
	FROM dbo.Response_Vehicles_Assigned AS rva WITH (NOLOCK)
	INNER JOIN dbo.Response_Master_Incident AS rmi WITH (NOLOCK) ON rmi.ID = rva.Master_Incident_ID
	CROSS APPLY (
		SELECT TOP 1 brva.Response_Number
		FROM dbo.Response_Vehicles_Assigned AS brva
		WHERE rmi.ID = brva.Master_Incident_ID
		ORDER BY brva.Time_Assigned
	) AS brva
	WHERE @rvaId = rva.ID
	*/

	-- Gets next min RVA Id
	SELECT @rvaId = MIN(rva.ID)
	FROM dbo.Response_Vehicles_Assigned AS rva WITH (NOLOCK)
	INNER JOIN dbo.Response_Master_Incident AS rmi WITH (NOLOCK) ON rmi.ID = rva.Master_Incident_ID
	WHERE ISNULL(Response_Number, '') = ''
	  AND rmi.Response_Date >= @responseDate
	  AND rmi.Response_Date < @responseEndDate
	  AND rva.ID > @rvaId
END


/*

SELECT *
FROM ePCR.dbo.FixedResponseNumber WITH (NOLOCK)

SELECT frn.*, rva.Response_Number, rmi.Base_Response_Number, rva.Cancel_Reason, rva.*
FROM ePCR.dbo.FixedResponseNumber AS frn WITH (NOLOCK)
INNER JOIN dbo.Response_Vehicles_Assigned AS rva WITH (NOLOCK) ON rva.ID = frn.rvaId
INNER JOIN dbo.Response_Master_Incident AS rmi WITH (NOLOCK) ON rmi.ID = rva.Master_Incident_ID

SELECT *
FROM ePCR.dbo.FixedResponseNumber AS frn WITH (NOLOCK)
INNER JOIN dbo.Response_Vehicles_Assigned AS rva WITH (NOLOCK) ON rva.Response_Number = frn.rvaResponseNumber

*/

--SELECT rva.ID, *
--FROM dbo.Response_Master_Incident AS rmi WITH (NOLOCK)
--INNER JOIN dbo.Response_Vehicles_Assigned AS rva WITH (NOLOCK) ON rva.Master_Incident_ID = rmi.ID
--WHERE rmi.ID = 4629806



--	SELECT rmi.Base_Response_Number, brva.Response_Number
--	FROM dbo.Response_Vehicles_Assigned AS rva WITH (NOLOCK)
--	INNER JOIN dbo.Response_Master_Incident AS rmi WITH (NOLOCK) ON rmi.ID = rva.Master_Incident_ID
--	CROSS APPLY (
--		SELECT TOP 1 brva.Response_Number
--		FROM dbo.Response_Vehicles_Assigned AS brva
--		WHERE rmi.ID = brva.Master_Incident_ID
--		ORDER BY brva.Time_Assigned
--	) AS brva
--	WHERE 4812267 = rva.ID



--SELECT *
--FROM ePCR.dbo.FixedResponseNumber AS frn WITH (NOLOCK)
--INNER JOIN dbo.Response_Vehicles_Assigned AS rva WITH (NOLOCK) ON rva.ID = frn.rvaId

--UPDATE dbo.Response_Vehicles_Assigned
--SET Response_Number = ''
--FROM ePCR.dbo.FixedResponseNumber AS frn WITH (NOLOCK)
--INNER JOIN dbo.Response_Vehicles_Assigned AS rva WITH (NOLOCK) ON rva.ID = frn.rvaId


