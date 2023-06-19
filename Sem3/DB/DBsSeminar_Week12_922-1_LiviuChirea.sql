DROP TABLE StationsRoutes
DROP TABLE Stations
DROP TABLE Routes
DROP TABLE Trains
DROP TABLE TrainTypes
GO

CREATE TABLE TrainTypes
	(TrainTypeID INT PRIMARY KEY,
	TTName VARCHAR(50),
	TTDescription VARCHAR(300))

CREATE TABLE Trains
	(TrainID INT PRIMARY KEY,
	TName VARCHAR(50),
	TrainTypeID INT REFERENCES TrainTypes(TrainTypeID))

CREATE TABLE Routes
	(RouteID INT PRIMARY KEY,
	RName VARCHAR(50) UNIQUE,
	TrainID INT REFERENCES Trains(TrainID))

CREATE TABLE Stations
	(StationID INT PRIMARY KEY,
	STName VARCHAR(50) UNIQUE)

CREATE TABLE StationsRoutes
	(RouteID INT REFERENCES Routes(RouteID),
	StationID INT REFERENCES Stations(StationID),
	Arrival TIME,
	Departure TIME,
	PRIMARY KEY(RouteID, StationID))
GO


CREATE OR ALTER PROC uspUpdateRoute (@RName VARCHAR(50), @SName VARCHAR(50), @Arrival TIME, @Departure TIME)
AS
	DECLARE @RID INT, @SID INT
	IF NOT EXISTS (SELECT * FROM Routes WHERE RName = @RName)
	BEGIN
		RAISEERROR('Invalid route.', 16, 1)
		RETURN
	END

	IF NOT EXISTS (SELECT * FROM Stations WHERE SName = @SName)
	BEGIN
		RAISEERROR('Invalid station.', 16, 1)
		RETURN
	END

	SELECT @RID = (SELECT RouteID FROM ROutes WHERE RName = @RName),
		@SID = (SELECT StationID FROM Stations WHERE SName = @SName)

