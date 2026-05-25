-- Thêm cột username (chạy 1 lần nếu DB đã tạo trước đó)
USE fellow4u_db;
GO

IF COL_LENGTH('dbo.users', 'username') IS NULL
BEGIN
  ALTER TABLE dbo.users ADD username NVARCHAR(100) NULL;
  CREATE UNIQUE INDEX UX_users_username ON dbo.users(username) WHERE username IS NOT NULL;
  PRINT N'Đã thêm cột username.';
END
GO
