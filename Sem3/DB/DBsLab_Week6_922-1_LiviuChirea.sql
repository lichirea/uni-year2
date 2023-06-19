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




-- Inner join on the equipment of a member
--Left join on a member with a type of equipment as optional
-- Right join on equiptment with members that may own it as optional

--INNER JOIN: Show me members who own weapons and those weapons
SELECT Member.MemberID, Member.Nickname, Weapon.WeaponID, Weapon.WeaponType
FROM Member
INNER JOIN Weapon ON Member.MemberID = Weapon.MemberID

--LEFT JOIN: Show me all members and armor they may own
SELECT Member.MemberID, Member.Nickname, Armor.ArmorID, Armor.ArmorType
FROM Member
LEFT JOIN Armor ON Member.MemberID = Armor.MemberID

--RIGHT JOIN: Show me all spells and their owners, orderered by spell level
SELECT SpellScroll.SpellscrollID, SpellScroll.SpellLevel, Member.MemberID, Member.Nickname
FROM Member
RIGHT JOIN SpellScroll ON SpellScroll.MemberID = Member.MemberID
ORDER BY SpellScroll.SpellLevel



--UNION
--DESC
SELECT LastName from Member
WHERE LastName = 'Seymour' or LastName = 'Vision'
UNION ALL
SELECT GoverningTitle, LastName from GoverningMember
WHERE LastName = 'Seymour' or LastName = 'Vision'
--DESC
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
SELECT Material FROM Weapon
FULL JOIN Member ON Member.MemberID = Weapon.MemberID AND Member.MemberID IN (1,2,3,4)
INTERSECT
SELECT Material FROM Armor
FULL JOIN Member ON Member.MemberID = Armor.MemberID AND Member.MemberID IN (1,2,3,4)

