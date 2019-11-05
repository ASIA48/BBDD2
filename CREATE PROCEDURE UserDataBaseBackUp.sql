USE master
go
CREATE OR ALTER PROCEDURE [dbo].[UserDataBaseBackUp]
	@path VARCHAR(256) = 'C:\Backups\'
AS
BEGIN
SET NOCOUNT ON;
DECLARE @name VARCHAR(50) -- DATABASE NAME
-- DECLARE @path VARCHAR(256) -- PATH FOR BACKUP FILES
DECLARE @fileName VARCHAR(256) -- FILENAME FOR BACKUP
DECLARE @fileDate VARCHAR(20) --USED FOR FILE NAME
-- SET @path = 'C:\Backups\' -- AS SAME AS YOUR CREATED FOLDER'
SELECT @fileDate = CONVERT(VARCHAR(20),GETDATE(),104)
DECLARE db_cursor CURSOR FOR
	SELECT name 
	FROM master.dbo.sysdatabases
	-- WHERE name NOT IN ('master','model','msdb','tempdb','ReportServer','ReportServerTempDB')
 WHERE name IN ('Pubs','Northwind')
 OPEN db_cursor
 FETCH NEXT FROM db_cursor INTO @name
 WHILE @@FETCH_STATUS = 0
 BEGIN
	SET @fileName = @path + @name + '_' + @fileDate + '.BAK'
	BACKUP DATABASE @name TO DISK = @fileName
	FETCH NEXT FROM db_cursor INTO @name
END
CLOSE db_cursor
DEALLOCATE db_cursor
END


EXEC [UserDataBaseBackUp]
go
EXEC [UserDataBaseBackUp] 'D:\BACKUP'
GO
-- BACKUP DATABASE @name TO DISK @fileName WITH STATS=10, COMPRESSION
-- BACKUP DATABASE @name TO DISK @fileName WITH COPY_ONLY
-- SELECT @fileDate = replace(convert(varcha, getdate(),104,'.','')