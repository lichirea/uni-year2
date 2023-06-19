--Lab3 DMBS

CREATE TABLE Books(
id INT PRIMARY KEY IDENTITY,
title VARCHAR(100),
language VARCHAR(100))

CREATE TABLE Authors(
id INT PRIMARY KEY IDENTITY,
name VARCHAR(100))

CREATE TABLE BooksAuthors(
author_id INT FOREIGN KEY REFERENCES Authors(id),
book_id INT FOREIGN KEY REFERENCES Books(id),
CONSTRAINT pk_BooksAuthors PRIMARY KEY (author_id, book_id))


--see the database
SELECT * FROM Authors
SELECT * FROM Books
SELECT * FROM BooksAuthors


--add records
INSERT INTO Books VALUES ('1984', 'english'), ('Animal Farm', 'english'), ('Three Body Problem', 'mandarin')
INSERT INTO Authors VALUES ('Liu Cixin'), ('George Orwell')
INSERT INTO BooksAuthors VALUES(2,1), (2,2), (1,3)
INSERT INTO Books VALUES ('Peter Pan', 'romanian')
GO;

CREATE OR ALTER PROCEDURE test_insert @Author nvarchar(100),
									  @Book_Title nvarchar(100),
									  @Book_Language nvarchar(100)
AS
	BEGIN TRAN insert_tran
	SAVE TRAN beginning

	DECLARE @successcount INT;
	SET @successcount = 0;

	PRINT('TRYING TO INSERT AUTHOR')
	BEGIN TRY
		INSERT INTO Authors VALUES(@Author)
		IF (SELECT COUNT(*) FROM Authors WHERE name = @Author) > 1
			BEGIN
				SET @successcount = @successcount + 1;
				RAISERROR('Author already in database', 16, 1)
			END
		SET @successcount = @successcount + 1;
		PRINT('ADDED AUTHOR')
	END TRY
	BEGIN CATCH
		PRINT('COULDNT ADD AUTHOR, ROLLING BACK')
		ROLLBACK TRAN beginning
	END CATCH


	SAVE TRAN AddedAuthor
	PRINT('SAVEPOINT AddedAuthor')

	PRINT('TRYING TO INSERT BOOK')
	BEGIN TRY
		INSERT INTO Books VALUES(@Book_Title, @Book_Language)
		IF (SELECT COUNT(*) FROM Books WHERE title = @Book_Title AND language = @Book_Language) > 1
			BEGIN
				RAISERROR('Book already in database', 16, 1)
			END
		SET @successcount = @successcount + 1;
		PRINT('ADDED BOOK')
	END TRY
	BEGIN CATCH
		PRINT('COULDNT ADD BOOK, ROLLING BACK TO AddedAuthor SAVEPOINT')
		ROLLBACK TRAN AddedAuthor
	END CATCH

	IF @successcount = 2
		BEGIN
			PRINT('ADDING TO THE BooksAuthors TABLE NOW')
			DECLARE @id_author INT;
			DECLARE @id_book INT;
			SET @id_author = (SELECT id FROM Authors WHERE name = @Author)
			SET @id_book = (SELECT id FROM Books WHERE title = @Book_Title and language = @Book_Language)
			INSERT INTO BooksAuthors VALUES(@id_author, @id_book)
		END
	ELSE
		BEGIN
			PRINT('CANNOT ADD THE RELATION TO THE BooksAuthors TABLE')
		END

	COMMIT TRAN
GO;


EXEC test_insert @Author = 'Terry Pratchett', @Book_Title = 'Mort', @Book_Language = 'english'
EXEC test_insert @Author = 'Terry Pratchett', @Book_Title = 'Night Watch', @Book_Language = 'english'
DELETE FROM Authors WHERE name='Terry Pratchett'
DELETE FROM Books WHERE title in ('Mort', 'Night Watch')



--CONCURRENCY ISSUES

--Dirty Reads 1
UPDATE Books SET language ='english' WHERE id = 2
BEGIN TRAN
	UPDATE Books SET language ='romanian' WHERE id = 2
	WAITFOR DELAY '00:00:10'
ROLLBACK TRAN

--Non-Repeatable Reads 1
UPDATE BOOKS SET language ='romanian' WHERE title = 'Peter Pan'
BEGIN TRAN 
	WAITFOR DELAY '00:00:10'
	UPDATE BOOKS SET language ='english' WHERE title = 'Peter Pan'
COMMIT TRAN
	
--Phantom Read part 1
DELETE FROM Books WHERE title = 'Morometii'
BEGIN TRAN
	WAITFOR DELAY '00:00:04'
	INSERT INTO Books VALUES('Morometii', 'romanian')
COMMIT TRAN

--Deadlock 1:
BEGIN TRAN
	UPDATE Books SET title='La Cirese transaction 2' WHERE id=1;
	WAITFOR DELAY '00:00:10'

	UPDATE Authors SET NAME = 'Petre Ispirescu transaction 2' where id = 1;
COMMIT TRAN