--Lab 5

CREATE TABLE Ta(
aid INT PRIMARY KEY,
a2 INT UNIQUE
)

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
CREATE PROC Ta_Proc @rows INT
AS
BEGIN
	WHILE @rows != 0
	BEGIN
		INSERT INTO Ta VALUES(@rows, @rows);
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

EXEC Ta_Proc @rows = 5000
EXEC Tb_Proc @rows = 5000
EXEC Tc_Proc @rows = 5000



--clustered index seek
SELECT * FROM Ta WHERE aid = 4500

--clustered index scan


--nonclustered index seek
SELECT a2 FROM Ta WHERE a2 BETWEEN 4900 AND 4904

--non-clustered index scan
SELECT * FROM Ta 

--key lookup

