--Lab 5

CREATE TABLE Ta(
aid INT PRIMARY KEY,
a2 INT UNIQUE
)
ALTER TABLE Ta
ADD yr INT

CREATE TABLE Tb(
bid INT PRIMARY KEY,
b2 INT 
)

CREATE TABLE Tc(
cid INT PRIMARY KEY,
aid INT REFERENCES Ta(aid),
bid INT REFERENCES Tb(bid)
)

GO
ALTER PROC Ta_Proc @rows INT
AS
BEGIN
	WHILE @rows != 0
	BEGIN
		INSERT INTO Ta VALUES(@rows, @rows, @rows);
		SET @rows -= 1;
	END;
END;

GO
CREATE PROC Tb_Proc @rows INT
AS
BEGIN
	WHILE @rows != 0
	BEGIN
		INSERT INTO Tb VALUES(@rows, @rows);
		SET @rows -= 1;
	END;
END;

GO
CREATE PROC Tc_Proc @rows INT
AS
BEGIN
	WHILE @rows != 0
	BEGIN
		INSERT INTO Tc VALUES(@rows, @rows, @rows);
		SET @rows -= 1;
	END;
END;

DELETE Ta
DELETE Tb
DELETE Tc
EXEC Ta_Proc @rows = 5000
EXEC Tb_Proc @rows = 5000
EXEC Tc_Proc @rows = 5000




CREATE NONCLUSTERED INDEX nice_index 
ON Ta (a2)


--clustered index scan
SELECT * FROM Ta where a2 > 200

--clustered index seek
SELECT * FROM Ta WHERE aid = 4500

--non-clustered index scan
SELECT DISTINCT(a2) FROM Ta 

--non-clustered index seek
SELECT a2 FROM Ta WHERE a2 BETWEEN 4900 AND 4904

--key lookup
SELECT yr FROM Ta WHERE a2 = 400


CREATE NONCLUSTERED INDEX TbIndex
ON Tb (b2)

ALTER INDEX TbIndex
ON Tb DISABLE


ALTER INDEX TbIndex 
ON Tb REBUILD

SELECT * FROM Tb WHERE b2 = 104

CREATE VIEW NiceView
AS
    SELECT a.a2, a.yr, b.b2
    FROM Ta a INNER JOIN Tc c ON a.aid = c.aid INNER JOIN Tb b ON c.bid = b.bid
GO

SELECT * FROM NiceView WHERE b2 < 300