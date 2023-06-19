CREATE TABLE Legion
(LegionID INT PRIMARY KEY,
LegionName VARCHAR(50),
MemberCount INT)

ALTER TABLE Legion
ADD RegDivID INT REFERENCES RegionalDivision(RegDivID);

CREATE TABLE Member
(MemberID INT PRIMARY KEY,
FirstName VARCHAR(50),
LastName VARCHAR(50),
Nickname VARCHAR(50),
MemberRank INT,
LegioniD INT REFERENCES Legion(LegionID))

CREATE TABLE Job
(JobID INT PRIMARY KEY,
JobName VARCHAR(50))

CREATE TABLE Assignment
(LegionID INT REFERENCES Legion(LegionID),
JobID INT REFERENCES Job(JobID)
PRIMARY KEY(LegionID,JobID))

CREATE TABLE Armor(
ArmorID INT PRIMARY KEY,
ArmorType VARCHAR(50),
Cost INT,
Material VARCHAR(50),
ArmorClass INT,
MemberID INT REFERENCES Member(MemberID))

CREATE TABLE SpellScroll(
SpellscrollID INT PRIMARY KEY,
SpellLevel INT,
Cost INT,
SchoolOfMagic VARCHAR(50),
MemberID INT REFERENCES Member(MemberID))

CREATE TABLE RegionalDivision(
RegDivID INT PRIMARY KEY,
RegDivName VARCHAR(50),
RegionID INT REFERENCES Region(RegionID),
GoverningID INT REFERENCES GoverningMember(GoverningID)
)


CREATE TABLE Blacksmith(
FirstName VARCHAR(50) NOT NULL,
LastName VARCHAR(50) NOT NULL,
City VARCHAR(50) NOT NULL)

CREATE TABLE GoverningMember(
GoverningID INT PRIMARY KEY,
GoverningTitle VARCHAR(50),
FirstName VARCHAR(50),
LastName VARCHAR(50))
ALTER TABLE GoverningMember
ADD RegDivID INT REFERENCES RegionalDivision(RegDivID);

CREATE TABLE Region(
RegionID INT PRIMARY KEY,
RegionName VARCHAR(50),
DemonicCorruptionLevel VARCHAR(50),
HumanPopulation INT,
HQLocation VARCHAR(50))
ALTER TABLE Region
ADD RegDivID INT REFERENCES RegionalDivision(RegDivID);

CREATE TABLE Weapon(
WeaponID INT PRIMARY KEY,
WeaponType VARCHAR(50),
Cost INT,
DamageType VARCHAR(50),
Material VARCHAR(50),
DamageDice VARCHAR(50),
MemberID INT REFERENCES Member(MemberID))

