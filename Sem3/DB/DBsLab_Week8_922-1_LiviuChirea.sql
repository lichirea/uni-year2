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
VALUES('MemberWeaponTest'),
---the second test should be something around a manytomany relation i think
