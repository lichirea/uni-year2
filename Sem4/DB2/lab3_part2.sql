use LibraryDB

--Dirty Reads 2 SOLUTION: CHANGE TO COMMITTED (this reads an uncommitted value which may change)
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
BEGIN TRAN
	 SELECT * FROM Books
	 WAITFOR DELAY '00:00:15'
	 SELECT * FROM Books
COMMIT TRAN


--Non-Repeatable Reads 2 - reads 2 different committed values in the same transaction,
--to solve put level REPEATABLE READ
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
BEGIN TRAN
	 SELECT * FROM Books
	 WAITFOR DELAY '00:00:15'
	 SELECT * FROM Books
COMMIT TRAN

--Phantom Read 2: a row is inserted and committed during the transaction
--solution: put level to SERIALIZABLE
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRAN
	 SELECT * FROM Books
	 WAITFOR DELAY '00:00:05'
	 SELECT * FROM Books
COMMIT TRAN

--Deadlock 2:
BEGIN TRAN
	UPDATE Authors SET NAME = 'Petre Ispirescu transaction2' where id = 1;
	WAITFOR DELAY '00:00:10'

	UPDATE Books SET title='La Cirese transaction 2' WHERE id=1;

COMMIT TRAN