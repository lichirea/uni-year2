CREATE TABLE Legion
(LegionName VARCHAR(50) PRIMARY KEY,
MemberCount INT)

CREATE TABLE Member
(MemberID INT PRIMARY KEY,
FirstName VARCHAR(50),
LastName VARCHAR(50),
Nickname VARCHAR(50),
MemberRank INT,
LegionName VARCHAR(50) REFERENCES Legion(LegionName))

CREATE TABLE Job
(JobName VARCHAR(50) PRIMARY KEY)

CREATE TABLE Assignment
(LegionName VARCHAR(50) REFERENCES Legion(LegionName),
JobName VARCHAR(50) REFERENCES Job(JobName)
PRIMARY KEY(LegionName,JobName))
--does this count as a many-many relationship? because on the diagram it doesnt seem like it is one, its just 2 of them are 1-n to this one

