--INSERT INTO dbo.Tables(dbo.Tables.Name)
VALUES('Armor'),
('Assignment'),
('Awarded'),
('Blacksmith'),
('GoverningMember'),
('Job'),
('Medal'),
('Region'),
('RegionalDivision'),
('Spellscroll'),
('Weapon'),
('Legion'),
('Member')


GO
--INSERT INTO dbo.Views
VALUES('view_MembersHighRank'),
('view_MembersAndTheirWeapons')

--INSERT INTO dbo.Views
VALUES('view_MedalsGroupedByRank')

--INSERT INTO dbo.Views
VALUES('view_JobsByLegion')



GO
CREATE VIEW view_JobsByLegion AS
SELECT COUNT(Job.JobID) as NumberOfJobs, LegionID FROM Job
INNER JOIN Assignment ON Job.JobId = Assignment.JobID
GROUP BY LegionID;


GO
CREATE VIEW view_MedalsGroupedByRank AS
SELECT COUNT(Awarded.MedalID) AS NumberOfMedals, Member.MemberRank FROM Member
INNER JOIN Awarded ON Awarded.MemberID = Member.MemberID
GROUP BY MemberRank;

GO
CREATE VIEW view_MembersHighRank AS
SELECT * FROM Member
WHERE Member.MemberRank > 3

GO
ALTER VIEW view_MembersAndTheirWeapons AS
SELECT Nickname, MemberRank, WeaponType FROM Member
LEFT JOIN Weapon ON Member.MemberID = Weapon.MemberID


--INSERT INTO dbo.Tests(dbo.Tests.Name)
VALUES('MemberWeaponTest')
--INSERT INTO dbo.Tests(dbo.Tests.Name)
VALUES('AwardedMemberTest')
--INSERT INTO dbo.Tests(dbo.Tests.Name)
VALUES('JobsLegionTest')


--INSERT INTO dbo.TestTables
VALUES(1, 13, 1500, 1),
(1, 2, 1500, 2)

--INSERT INTO dbo.TestTables
VALUES(2, 13, 1500, 3),
(2, 7, 1500, 2),
(2, 3, 1500, 1)

--INSERT INTO dbo.TestTables
VALUES(3, 11, 1500, 3),
(3, 12, 1500, 2),
(3, 6, 1500, 1)


--INSERT INTO dbo.TestViews
VALUES(1, 1),
(1, 2),
(2, 3)
--INSERT INTO dbo.TestViews
VALUES(3, 4)


GO
ALTER PROC udp_TestInsert @tbl NVARCHAR(50), @n INT
AS
BEGIN
	DECLARE @ParmDefinition NVARCHAR(500);
	SET @tbl = CONCAT(N'EXEC ', @tbl, N'_Proc @rows = @rows');
	SET @ParmDefinition = N'@rows INT'; 
	EXECUTE sp_executesql @tbl, @ParmDefinition, @rows = @n;
END;



GO
CREATE PROC Job_Proc @rows INT
AS
BEGIN
	WHILE @rows != 0
	BEGIN
		INSERT INTO Job VALUES(@rows, 'A Good Day');
		SET @rows -= 1;
	END;
END;

GO
CREATE PROC Legion_Proc @rows INT
AS
BEGIN
	WHILE @rows != 0
	BEGIN
		INSERT INTO Legion VALUES(@rows, 'A Good Name', 1000, 1);
		SET @rows -= 1;
	END;
END;

GO
CREATE PROC Assignment_Proc @rows INT
AS
BEGIN
	WHILE @rows != 0
	BEGIN
		INSERT INTO Assignment VALUES(@rows, @rows);
		SET @rows -= 1;
	END;
END;


GO
ALTER PROC Member_Proc @rows INT
AS
BEGIN
	WHILE @rows != 0
	BEGIN
		INSERT INTO Member VALUES(@rows, 'John', 'Doe', 'Dark Knight', 5, NULL);
		SET @rows -= 1;
	END;
END;

GO
ALTER PROC Weapon_Proc @rows INT
AS
BEGIN
	WHILE @rows != 0
	BEGIN
		INSERT INTO Weapon VALUES(@rows, 'Spear', 100, 'Piercing', 'Iron', '1d8', @rows, 'A', 'A', 'A');
		SET @rows -= 1;
	END;
END;


GO
ALTER PROC Medal_Proc @rows INT
AS
BEGIN
	WHILE @rows != 0
	BEGIN
		INSERT INTO Medal VALUES(@rows, 'Medal for being really cool', 2008);
		SET @rows -= 1;
	END;
END;

GO
CREATE PROC Awarded_Proc @rows INT
AS
BEGIN
	WHILE @rows != 0
	BEGIN
		INSERT INTO Awarded VALUES(@rows, @rows)
		SET @rows -= 1;
	END;
END;


GO
ALTER PROC Run_Test(@testnumber INT)
AS
BEGIN
	--PREPARE FOR EVERYTHING
	DECLARE @t1 DATETIME;
	DECLARE @t2 DATETIME;
	DECLARE @tablet1 DATETIME;
	DECLARE @tablet2 DATETIME;
	SET @t1 = GETDATE();

	INSERT INTO dbo.TestRuns VALUES(CONCAT('A very nice test', @testnumber), @t1, NULL);
	DECLARE @testrunid INT;
	SET @testrunid = (SELECT dbo.TestRuns.TestRunID FROM dbo.TestRuns WHERE dbo.TestRuns.StartAt = @t1)

	DECLARE @pos INT;
	SET @pos = 1;
	DECLARE @poscount INT;
	SET @poscount = (SELECT MAX(Position) FROM TestTables WHERE TestID = @testnumber);

	DECLARE @tblname NVARCHAR(100);
	DECLARE @query NVARCHAR(500)

	--DELETE ALL DATA
	WHILE @pos <= @poscount
	BEGIN
		SET @tblname = (SELECT dbo.Tables.Name FROM dbo.Tables
							INNER JOIN dbo.TestTables 
								ON  dbo.Tables.TableID = dbo.TestTables.TableID 
									WHERE dbo.TestTables.Position = @pos AND dbo.TestTables.TestID = @testnumber)
		SET @query = 'DELETE FROM ' + @tblname;
		EXEC sp_executesql @query;
		SET @pos += 1;
	END;
	

	--DO THE INSERTS ON THE TABLES
	DECLARE @numberofrows INT;
	DECLARE @tableid INT;
	SET @pos -= 1;
	WHILE @pos > 0
	BEGIN
		SET @tblname = (SELECT dbo.Tables.Name FROM dbo.Tables
							INNER JOIN dbo.TestTables 
								ON  dbo.Tables.TableID = dbo.TestTables.TableID 
									WHERE dbo.TestTables.Position = @pos AND dbo.TestTables.TestID = @testnumber)
		SET @numberofrows = (SELECT dbo.TestTables.NoOfRows FROM dbo.TestTables
								INNER JOIN dbo.Tables
									ON dbo.Tables.TableID = dbo.TestTables.TableID
										WHERE dbo.Tables.Name = @tblname AND dbo.TestTables.TestID = @testnumber)

				
		--ACTUAL TESTS
		SET @tablet1 = GETDATE();
		EXEC udp_TestInsert @tbl = @tblname, @n = @numberofrows
		SET @tablet2 = GETDATE();

		SET @tableid = (SELECT dbo.Tables.TableID FROM dbo.Tables WHERE dbo.Tables.Name = @tblname)
		INSERT INTO dbo.TestRunTables VALUES(@testrunid, @tableid, @tablet1, @tablet2)

		SET @pos -= 1;

	END;

	--TESTING THE VIEWS NOW
	SET @pos = 1;
	SET @poscount = (SELECT COUNT(dbo.TestViews.ViewID) FROM dbo.TestViews);
	DECLARE @viewname NVARCHAR(100);
	WHILE @pos <= @poscount
	BEGIN
		IF (SELECT COUNT(dbo.TestViews.ViewID) FROM dbo.TestViews 
					WHERE dbo.TestViews.TestID = @testnumber AND dbo.TestViews.ViewID = @pos) = 1
			BEGIN
				SET @viewname = (SELECT dbo.Views.Name FROM dbo.Views WHERE dbo.Views.ViewID = @pos);
				SET @query = N'SELECT * FROM ' + @viewname

				SET @tablet1 = GETDATE();
				EXEC sp_executesql @query;
				SET @tablet2 = GETDATE();

				--ADD IT TO OUR RECORDS
				INSERT INTO dbo.TestRunViews VALUES(@testrunid, @pos, @tablet1, @tablet2);
			END;

		SET @pos += 1;
	END;


	--FINALIZE RECORD KEEPING
	SET @t2 = GETDATE();
	UPDATE dbo.TestRuns
	SET dbo.TestRuns.EndAt = @t2
	WHERE dbo.TestRuns.StartAt = @t1

	--CLEANUP
	SET @pos = 1;
	SET @poscount = (SELECT MAX(Position) FROM TestTables WHERE TestID = @testnumber);
	WHILE @pos <= @poscount
	BEGIN
		SET @tblname = (SELECT dbo.Tables.Name FROM dbo.Tables
							INNER JOIN dbo.TestTables 
								ON  dbo.Tables.TableID = dbo.TestTables.TableID 
									WHERE dbo.TestTables.Position = @pos AND dbo.TestTables.TestID = @testnumber)
		SET @query = 'DELETE FROM ' + @tblname;
		EXEC sp_executesql @query;
		SET @pos += 1;
	END;

END;

GO
EXEC Run_Test @testnumber = 2;


SELECT * FROM TestRuns
SELECT * FROM TestRunTables
SELECT * FROM TestRunViews


