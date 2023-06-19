INSERT INTO dbo.Tables(dbo.Tables.Name)
VALUES('Legion'),
('Member')

INSERT INTO dbo.Tables(dbo.Tables.Name)
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
('Weapon')

GO
CREATE VIEW view_MembersHighRank AS
SELECT * FROM Member
WHERE Member.MemberRank > 3

GO
CREATE VIEW view_MembersAndTheirWeapons AS
SELECT Nickname, FirstName, LastName, MemberRank FROM Member
LEFT JOIN Weapon ON Member.MemberID = Weapon.MemberID

GO
INSERT INTO dbo.Views
VALUES('view_MembersHighRank'),
('view_MembersAndTheirWeapons')

INSERT INTO dbo.Tests(dbo.Tests.Name)
VALUES('MemberWeaponTest')
---the second test should be something around a manytomany relation i think

INSERT INTO dbo.TestTables
VALUES(1, 13, 1000, 1),
(1, 2, 1000, 2)

INSERT INTO dbo.TestViews
VALUES(1, 1),
(1, 2)


GO
CREATE PROC InsertIntoTable(@tbl NVARCHAR(50), @n INT)
AS
BEGIN
	DECLARE @ParmDefinition NVARCHAR(500);
	SET @ParmDefinition = N'@rows int'; 
	EXECUTE sp_executesql @tbl, @ParmDefinition, @rows = @n;
END;

GO
CREATE PROC Weapon(@rows INT)
AS
BEGIN
	DELETE FROM Weapon;
	WHILE @rows != 0
	BEGIN
		INSERT INTO Weapon VALUES(@rows, 'Spear', '100', 'Piercing', 'Iron', '1d8', NULL);
		SET @rows -= 1;
	END;
END;

