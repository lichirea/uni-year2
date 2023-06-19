CREATE TABLE Medal
(MedalID INT PRIMARY KEY,
MedalDesc VARCHAR(50))
ALTER TABLE Medal
ADD MedalYear INT;

CREATE TABLE Awarded
(MedalID INT REFERENCES Medal(MedalID),
MemberID INT REFERENCES Member(MemberID),
PRIMARY KEY(MedalID, MemberID))


INSERT INTO Region(RegionID, RegionName, DemonicCorruptionLevel, HumanPopulation, HQLocation)
VALUES(2, 'Deep Blue', 'High', 38000, 'Ocean Point'),
(3, 'Star Mountain', 'Low', 90000, 'Five-Pointed Jerusalem'),
(4, 'Alana', 'Low', 120000, 'Saint Jo'),
(5, 'Forest of Woes', 'Medium', 2000, 'Triboar'),
(6, 'Wolffen', 'Very High', 75000, 'Shrike'),
(7, 'Shadowfell', 'Very High', 100000, 'Castle Drakenhof'),
(1, 'War Theater', 'Very High', 5000, 'Red War Camp')

INSERT INTO GoverningMember(GoverningID, GoverningTitle, FirstName, LastName)
VALUES(1, 'War Director', 'Borlyn', 'McKinnen'),
(2, 'Holy Diver', 'Joanne', 'Seymour'),
(3, 'Nova Prophet', 'Alyx', 'Fadrgrand'),
(4, 'Chancellor of Alana', 'Wanda', 'Vision'),
(5, 'Tree Concert', 'Sheera', 'Holdo')

INSERT INTO RegionalDivision
VALUES(1, 'War Actors', 1, 1),
(2, 'Sold Seashells', 2, 2),
(3, 'Star People', 3, 3),
(4, 'Peace Commission', 4, 4),
(5, 'Pale Hunters', 5, 5)

INSERT INTO Legion
VALUES(6, 'Points Blanks', 89, NULL)
--THERE WERE MORE ENTRIES HERE BUT THEY DIDNT SAVE THAT ONE TIME :((((((

UPDATE RegionalDivision
SET RegDivName = 'Moon Hunters'
WHERE RegDivID = 5

UPDATE GoverningMember
SET FirstName = 'Mynth'
WHERE LastName = 'McKinnen'

UPDATE Region
SET HumanPopulation = 110000, DemonicCorruptionLevel = 'High'
WHERE RegionName = 'Shadowfell'

DELETE FROM Region WHERE RegionName = 'Shadowfell'

DELETE FROM Legion WHERE MemberCount < 100


-- Inner join on the equipment of a member
--Left join on a member with a type of equipment as optional
-- Right join on equiptment with members that may own it as optional
--Full Join 

--INNER JOIN: Show me all jobs on which legions that have awarded members went on
SELECT DISTINCT Assignment.JobID FROM Assignment
INNER JOIN Member ON Member.LegionID = Assignment.LegionID
INNER JOIN Awarded ON Awarded.MemberID = Member.MemberID

--LEFT JOIN: Show me all members and armor they may own
SELECT Member.MemberID, Member.Nickname, Armor.ArmorID, Armor.ArmorType
FROM Member
LEFT JOIN Armor ON Member.MemberID = Armor.MemberID

--RIGHT JOIN: Show me all spells and their owners, orderered by spell level
SELECT SpellScroll.SpellscrollID, SpellScroll.SpellLevel, Member.MemberID, Member.Nickname
FROM Member
RIGHT JOIN SpellScroll ON SpellScroll.MemberID = Member.MemberID
ORDER BY SpellScroll.SpellLevel

--FULL JOIN: Show me all members who own armor, weapons and spellscrolls
SELECT SpellScroll.MemberID FROM SpellScroll
FULL JOIN Weapon on Weapon.MemberID = SpellScroll.MemberID
FULL JOIN Armor on Armor.MemberID = SpellScroll.MemberID

--UNION
--Show me all members and governers with the last names being either Seymour or Vision
SELECT LastName from Member
WHERE LastName = 'Seymour' or LastName = 'Vision'
UNION ALL
SELECT LastName from GoverningMember
WHERE LastName = 'Seymour' or LastName = 'Vision'
--Show me all costs of spellscrolls and weapons
SELECT Cost from SpellScroll
UNION
SELECT Cost from Weapon


--INTERSECT
--Intersect all the SpellScroll owners with the Weapon Owners
SELECT FirstName, LastName FROM Member
FULL JOIN SpellScroll ON SpellScroll.MemberID = Member.MemberID
INTERSECT
SELECT FirstName, LastName FROM Member
FULL JOIN Weapon ON Weapon.MemberID = Member.MemberID
--See which materials make up a full member's arsenal (both their weapon and their armor is made of the material)
SELECT DISTINCT Material FROM Weapon
FULL JOIN Member ON Member.MemberID = Weapon.MemberID AND Member.MemberID IN (1,2,3,4)
INTERSECT
SELECT Material FROM Armor
FULL JOIN Member ON Member.MemberID = Armor.MemberID AND Member.MemberID IN (1,2,3,4)

--EXCEPT
--Show all Members except those that own weapons
SELECT MemberID FROM Member
EXCEPT
SELECT MemberID FROM Weapon
--Show all members except those who don't own spellscrolls of levels 1,2,3
SELECT MemberID FROM Member
EXCEPT
SELECT MemberID FROM SpellScroll
WHERE SpellLevel NOT IN (1,2,3)

--SUBQUERY WITH IN
--Show all divisions for which governing members have a last name different from "Stevenson"
SELECT  RegDivId, RegDivName
FROM RegionalDivision
WHERE GoverningID
IN (SELECT GoverningID FROM GoverningMember WHERE LastName LIKE 'Stevenson')
--Show all Member that own Weapons with the same cost as a level 9 SpellScroll
SELECT * FROM Member
WHERE MemberID 
IN (SELECT MemberID FROM Weapon WHERE Weapon.Cost IN (SELECT Cost FROM SpellScroll WHERE SpellLevel = 9))

--EXISTS
--Show all Legions that have a member with a Mythril Weapon
SELECT *
FROM Legion
WHERE 
EXISTS (SELECT * FROM Member WHERE MemberID IN (SELECT Armor.MemberID FROM Armor WHERE Armor.Material = 'Mythril'))
--Show all legions that have a member awarded with a Bravery medal or before the year 1250
SELECT *
FROM LEGION
WHERE
EXISTS(SELECT * FROM Member WHERE MemberID IN (SELECT Awarded.MemberID FROM Awarded WHERE MedalID IN 
			(SELECT MedalID FROM Medal WHERE MedalDesc LIKE 'Bravery' OR MedalYear < 1250)))

--SUBQUERY IN FROM
--Show the Material and Damage of weapons as EquipmentSummary
SELECT EquipmentSummary.MaterialToDamageRatio FROM (SELECT Material, DamageDice AS MaterialToDamageRatio from Weapon) AS EquipmentSummary
--Show average costs of armors
SELECT x.AverageCost FROM (SELECT Avg(Armor.Cost) AS AverageCost FROM Armor) AS x

--4 queries with the GROUP BY clause, 3 of which also contain the HAVING clause; 
-- 2 of the latter will also have a subquery in the HAVING clause;
--use the aggregation operators: COUNT, SUM, AVG, MIN, MAX;
--Count the number of members of each rank, by legion
SELECT COUNT(MemberRank), LegionId
FROM Member
GROUP BY LegionID
--Get the sum of costs for all armors, grouped by material. Do not do this for iron
SELECT SUM(Cost), Material
FROM Armor
GROUP BY Material
HAVING Material NOT LIKE 'Iron'
--Show average population grouped by demonic corruption level for all regions with legions of over 1000 members
SELECT AVG(HumanPopulation) as AveragePopulation, DemonicCorruptionLevel
FROM Region
GROUP BY DemonicCorruptionLevel
HAVING DemonicCorruptionLevel IN (SELECT DemonicCorruptionLevel FROM Region WHERE RegDivID IN
			(SELECT RegDivID FROM Legion WHERE MemberCount > 1000))
--Show maximum DamageDice of weapons owned by a member of rank 3 or less
SELECT MAX(DamageDice) AS MaximumDamage, MemberID
FROM Weapon
GROUP BY MemberID
HAVING MemberID IN (SELECT MemberID FROM Member WHERE MemberRank <= 3)

--4 queries using ANY and ALL to introduce a subquery in the WHERE clause (2 queries per operator);
--rewrite 2 of them with aggregation operators, and the other 2 with IN / [NOT] IN.
--Show all armors that are made of the same material as at least one weapon of cost higher than 100
SELECT ArmorID, Armor.ArmorClass, ArmorType, Armor.Cost
FROM Armor
WHERE Armor.Material = ANY
	(SELECT Weapon.Material
	FROM Weapon
	WHERE Weapon.Cost > 100);
--REWRITTEN WITH AGGREGATION OPERATORS -- I THINK THIS IS GOOD NOW :((( SORRY
SELECT A.ArmorID, A.ArmorClass, A.ArmorType, A.Cost
FROM Armor A
INNER JOIN Weapon W ON A.Material = W.Material
WHERE W.Material IN (SELECT W2.Material FROM Weapon W2 GROUP BY MATERIAL HAVING COUNT(*) >= 1 AND W.Cost >= 100)
--Show all medals awarded to at least one member of rank higher than 3
SELECT MedalID
FROM Awarded
WHERE MemberID = ANY
	(SELECT MemberID
	FROM Member
	WHERE Member.MemberRank > 3)
--REWRITTEN WITH NOT IN
SELECT MedalID
FROM Awarded
WHERE MemberID NOT IN
	(SELECT MemberID
	FROM Member
	WHERE Member.MemberRank <= 2)
--Show all jobs assigned to all legions that have over 5000 members
SELECT JobID
FROM Assignment
WHERE LegionID = ALL
	(SELECT LegionID FROM Legion WHERE MemberCount > 5000)
--REWRITTEN WITH AGGREGATION OPERATORS
SELECT A.JobID
FROM Assignment A, Legion L
WHERE A.LegionID = L.LegionID AND (SELECT MIN(MemberCount) FROM Legion WHERE Legion.LegionID = A.LegionID) > 5000
--Show all medals assigned to all members of rank 5 from the third legion
SELECT *
FROM Awarded
WHERE MemberID = ALL
	(SELECT MemberID FROM Member WHERE MemberRank = 5 AND LegioniD = 3)
--REWRITTEN WITH NOT IN
SELECT *
FROM Awarded
WHERE MemberID NOT IN
	(SELECT MemberID FROM Member WHERE MemberRank != 5 AND LegioniD != 3)