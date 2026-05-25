-- Fellow4U — SQL Server (SSMS)
-- Server: localhost\SQLEXPRESS  |  User: sa (hoặc Windows Authentication)
-- Mở SSMS → New Query → dán và chạy (F5) toàn bộ file.

IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'fellow4u_db')
BEGIN
  CREATE DATABASE fellow4u_db;
END
GO

USE fellow4u_db;
GO

-- Bảng users (đăng ký / đăng nhập)
IF OBJECT_ID(N'dbo.users', N'U') IS NULL
BEGIN
  CREATE TABLE dbo.users (
    id            INT IDENTITY(1,1) PRIMARY KEY,
    email         NVARCHAR(255) NOT NULL UNIQUE,
    username      NVARCHAR(100) NULL,
    password_hash NVARCHAR(255) NOT NULL,
    first_name    NVARCHAR(100) NOT NULL DEFAULT N'',
    last_name     NVARCHAR(100) NOT NULL DEFAULT N'',
    country       NVARCHAR(100) NULL,
    role          NVARCHAR(20) NOT NULL DEFAULT N'traveler'
                  CONSTRAINT CK_users_role CHECK (role IN (N'traveler', N'guide')),
    avatar_url    NVARCHAR(500) NULL,
    created_at    DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    updated_at    DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
  );
  CREATE UNIQUE INDEX UX_users_username ON dbo.users(username) WHERE username IS NOT NULL;
END
GO

-- Tours
IF OBJECT_ID(N'dbo.tours', N'U') IS NULL
BEGIN
  CREATE TABLE dbo.tours (
    id          INT IDENTITY(1,1) PRIMARY KEY,
    title       NVARCHAR(255) NOT NULL,
    location    NVARCHAR(255) NOT NULL,
    tour_date   NVARCHAR(50) NULL,
    days_label  NVARCHAR(50) NULL,
    price       DECIMAL(10, 2) NOT NULL DEFAULT 0,
    distance_km NVARCHAR(50) NULL,
    image_asset NVARCHAR(255) NULL,
    description NVARCHAR(MAX) NULL,
    created_at  DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
  );
END
GO

-- Trips (My Journeys)
IF OBJECT_ID(N'dbo.trips', N'U') IS NULL
BEGIN
  CREATE TABLE dbo.trips (
    id          INT IDENTITY(1,1) PRIMARY KEY,
    user_id     INT NOT NULL,
    title       NVARCHAR(255) NOT NULL,
    location    NVARCHAR(255) NOT NULL,
    trip_date   NVARCHAR(50) NULL,
    likes_count INT NOT NULL DEFAULT 0,
    image_left  NVARCHAR(255) NULL,
    image_mid   NVARCHAR(255) NULL,
    image_right NVARCHAR(255) NULL,
    status      NVARCHAR(20) NOT NULL DEFAULT N'draft'
                CONSTRAINT CK_trips_status CHECK (status IN (N'draft', N'pending', N'confirmed', N'finished')),
    created_at  DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT FK_trips_user FOREIGN KEY (user_id) REFERENCES dbo.users(id) ON DELETE CASCADE
  );
END
GO

-- Photos
IF OBJECT_ID(N'dbo.photos', N'U') IS NULL
BEGIN
  CREATE TABLE dbo.photos (
    id          INT IDENTITY(1,1) PRIMARY KEY,
    user_id     INT NOT NULL,
    image_url   NVARCHAR(500) NOT NULL,
    caption     NVARCHAR(255) NULL,
    created_at  DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT FK_photos_user FOREIGN KEY (user_id) REFERENCES dbo.users(id) ON DELETE CASCADE
  );
END
GO

-- Notifications
IF OBJECT_ID(N'dbo.notifications', N'U') IS NULL
BEGIN
  CREATE TABLE dbo.notifications (
    id            INT IDENTITY(1,1) PRIMARY KEY,
    user_id       INT NOT NULL,
    message       NVARCHAR(MAX) NOT NULL,
    notif_date    NVARCHAR(20) NULL,
    avatar_asset  NVARCHAR(255) NULL,
    accent_color  NVARCHAR(20) NULL,
    badge_type    NVARCHAR(30) NULL,
    show_review   BIT NOT NULL DEFAULT 0,
    is_read       BIT NOT NULL DEFAULT 0,
    created_at    DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT FK_notifications_user FOREIGN KEY (user_id) REFERENCES dbo.users(id) ON DELETE CASCADE
  );
END
GO

-- Payments
IF OBJECT_ID(N'dbo.payments', N'U') IS NULL
BEGIN
  CREATE TABLE dbo.payments (
    id             INT IDENTITY(1,1) PRIMARY KEY,
    user_id        INT NOT NULL,
    trip_title     NVARCHAR(255) NOT NULL,
    total_amount   DECIMAL(10, 2) NOT NULL,
    upfront_amount DECIMAL(10, 2) NOT NULL,
    card_holder    NVARCHAR(255) NULL,
    status         NVARCHAR(20) NOT NULL DEFAULT N'pending'
                   CONSTRAINT CK_payments_status CHECK (status IN (N'pending', N'completed', N'failed')),
    created_at     DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT FK_payments_user FOREIGN KEY (user_id) REFERENCES dbo.users(id) ON DELETE CASCADE
  );
END
GO

-- Dữ liệu tour mẫu
IF NOT EXISTS (SELECT 1 FROM dbo.tours WHERE title = N'Da Nang - Ba Na - Hoi An')
BEGIN
  INSERT INTO dbo.tours (title, location, tour_date, days_label, price, distance_km, image_asset, description)
  VALUES
    (N'Da Nang - Ba Na - Hoi An', N'Danang, Vietnam', N'Jan 30, 2020', N'3 days', 400.00, N'120 km', N'assets/images/journey_danang.png', N'Explore central Vietnam'),
    (N'Melbourne - Sydney', N'Australia', N'Jan 30, 2020', N'7 days', 600.00, N'2817 km', N'assets/images/tour_sydney.png', N'Coast to coast'),
    (N'Hanoi - Ha Long Bay', N'Hanoi, Vietnam', N'Jan 30, 2020', N'5 days', 300.00, N'1247 km', N'assets/images/tour_halong.png', N'Northern highlights');
END
GO

-- User demo + trips + notifications: tạo tự động khi chạy backend (npm start)
-- Email: yoojin@gmail.com  |  Password: password123

PRINT N'Fellow4U database ready on fellow4u_db';
GO
