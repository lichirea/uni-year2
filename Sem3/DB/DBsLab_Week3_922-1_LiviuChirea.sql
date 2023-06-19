INSERT INTO Region(RegionName, DemonicCorruptionLevel, HumanPopulation, HQLocation)
VALUES('War Theater', 'Very High', 5000, 'Red War Camp')
INSERT INTO GoverningMember(GoverningTitle, FirstName, LastName)
VALUES('War Director', 'Jonah', 'Felling')
INSERT INTO RegionalDivision
VALUES('War Boys', 'War Theater', 'War Director')

UPDATE Region
SET RegDivName = 'War Boys'
WHERE RegionName = 'War Theater'
UPDATE GoverningMember
SET RegDivName = 'War Boys'
WHERE GoverningTitle = 'War Director'

SELECT *
FROM Region

INSERT INTO Region(RegionName, DemonicCorruptionLevel, HumanPopulation, HQLocation)
VALUES('Westfall', 'Low', 900000, 'City of Groves')
INSERT INTO GoverningMember(GoverningTitle, FirstName, LastName)
VALUES('Administrator of the Groverule', 'Lupina', 'Yharon')
INSERT INTO RegionalDivision
VALUES('Grovers', 'Westfall', 'Administrator of the Groverule')

UPDATE Region
SET RegDivName = 'Grovers'
WHERE RegionName = 'Westfall'
UPDATE GoverningMember
SET RegDivName = 'Grovers'
WHERE GoverningTitle = 'Administrator of the Groverule'

SELECT *
FROM RegionalDivision
INNER JOIN Region
on RegionalDivision.RegDivName = Region.RegDivName;

SELECT Region.RegionName, Region.DemonicCorruptionLevel, GoverningMember.FirstName, GoverningMember.LastName
FROM Region
LEFT JOIN GoverningMember
ON Region.RegDivName = GoverningMember.RegDivName;



