
--modify the type of a column
CREATE PROCEDURE uspChangeMedalYearToString
AS
BEGIN
	ALTER TABLE Medal
	ALTER COLUMN MedalYear VARCHAR(50)
END;
GO
EXEC uspChangeMedalYearToString
GO

CREATE PROCEDURE uspChangeMedalYearToInt
AS
BEGIN
	ALTER TABLE Medal
	ALTER COLUMN MedalYear INT
END;
GO
EXEC uspChangeMedalYearToInt
GO

--add/remove a column
CREATE PROCEDURE uspAddJobDate
AS
BEGIN
	ALTER TABLE Job
	ADD JobDate VARCHAR(50)
END;
GO
EXEC uspAddJobDate
GO

CREATE PROCEDURE uspDropJobDate
AS
BEGIN
	ALTER TABLE Job
	DROP COLUMN JobDate
END;
GO
EXEC uspDropJobDate
GO

--add/remove a DEFAULT constraint
ALTER PROCEDURE uspAddDefaultMemberNickname
AS
BEGIN
	ALTER TABLE Member
	ADD CONSTRAINT df_Nickname
	DEFAULT 'Rookie' FOR Nickname;
END;
GO
EXEC uspAddDefaultMemberNickname
GO

ALTER PROCEDURE uspRemoveDefaultMemberNickname
AS
BEGIN
	ALTER TABLE Member
	DROP CONSTRAINT df_Nickname
END;
GO
EXEC uspRemoveDefaultMemberNickname
GO

--add/remove a candidate key
ALTER PROCEDURE uspRemoveJobCandidateKey
AS
BEGIN
	ALTER TABLE Job
	DROP COLUMN JobName;
END;
GO
exec uspRemoveJobCandidateKey
GO

CREATE PROCEDURE uspAddJobCandidateKey
AS
BEGIN
	ALTER TABLE Job
	ADD JobName VARCHAR(50)
END;
GO
exec uspAddJobCandidateKey
GO

--create/drop a table
ALTER PROCEDURE uspCreateTableBlacksmith
AS
BEGIN
	CREATE TABLE Blacksmith(
FirstName VARCHAR(50) NOT NULL,
LastName VARCHAR(50) NOT NULL,
City VARCHAR(50) NOT NULL)
END;
GO
exec uspCreateTableBlacksmith
GO

CREATE PROCEDURE uspDropTableBlacksmith
AS
BEGIN
	DROP TABLE Blacksmith
END;
GO
exec uspDropTableBlacksmith
GO


--add/remove primary key
ALTER PROCEDURE uspAddPrimaryKeyBlacksmith
AS
BEGIN
	ALTER TABLE Blacksmith
	ADD CONSTRAINT pk_Blacksmith PRIMARY KEY (FirstName, LastName, City)
END;
GO
EXEC uspAddPrimaryKeyBlacksmith
GO

CREATE PROCEDURE uspRemovePrimaryKeyBlacksmith
AS
BEGIN
	ALTER TABLE Blacksmith
	DROP CONSTRAINT pk_Blacksmith
END;
GO
EXEC uspRemovePrimaryKeyBlacksmith
GO


--add/remove a foreign key
ALTER PROCEDURE uspAddWeaponBlacksmithFK
AS
BEGIN
	ALTER TABLE Weapon
	ADD FirstName VARCHAR(50) NOT NULL,
	LastName VARCHAR(50) NOT NULL,
	City VARCHAR(50) NOT NULL;
	ALTER TABLE Weapon
	ADD CONSTRAINT FK_Blacksmith
	FOREIGN KEY (FirstName, LastName, City) REFERENCES Blacksmith(FirstName, LastName, City);
END;
GO
exec uspAddWeaponBlacksmithFK
GO

ALTER PROCEDURE uspRemoveWeaponBlacksmithFK
AS
BEGIN
	ALTER TABLE Weapon
	DROP CONSTRAINT FK_Blacksmith;
	ALTER TABLE Weapon
	DROP COLUMN FirstName,
	LastName,
	City;
END;
GO
EXEC uspRemoveWeaponBlacksmithFK


--VERSION PROCEDURE
CREATE TABLE Versions(
DBVersion INT PRIMARY KEY,
Upgrade VARCHAR(100),
Downgrade VARCHAR(100))

INSERT INTO Versions(DBVersion, Downgrade, Upgrade)
VALUES(1, '', 'uspChangeMedalYearToString'),
(2,  'uspChangeMedalYearToInt', 'uspAddJobDate'),
(3, 'uspDropJobDate', 'uspAddDefaultMemberNickname'),
(4, 'uspRemoveDefaultMemberNickname', 'uspRemoveJobCandidateKey'),
(5, 'uspAddJobCandidateKey', 'uspCreateTableBlacksmith'),
(6, 'uspDropTableBlacksmith', 'uspAddPrimaryKeyBlacksmith'),
(7, 'uspRemovePrimaryKeyBlacksmith', 'uspAddWeaponBlacksmithFK'),
(8, 'uspRemoveWeaponBlacksmithFK', '')


SELECT *
FROM Blacksmith

GO
CREATE PROCEDURE uspChangeVersion(@current INT, @final INT)
AS
WHILE @current != @final
BEGIN
	DECLARE @SQLString NVARCHAR(500);
	IF @current < @final
	BEGIN
		SELECT @SQLString = Upgrade
		FROM Versions
		WHERE DBVersion = @current
		EXECUTE sp_executesql @SQLString;
		SET @current += 1;
	END
	IF @current > @final
	BEGIN
		SELECT @SQLString = Downgrade
		FROM Versions
		WHERE DBVersion = @current
		EXECUTE sp_executesql @SQLString;
		SET @current -= 1;
	END
END;
GO
-- @CURRENT AND THEN @FINAL --CURRENT: 8
EXEC uspChangeVersion 2, 8

