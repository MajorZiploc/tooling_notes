USE System;

-- Declare a table, ie a record / list of records
DECLARE @endUser table (
  EndUserId INT
  ,[Name] VARCHAR(50)
  , [Age] INT
)

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


