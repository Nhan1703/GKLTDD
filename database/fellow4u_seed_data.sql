-- Fellow4U — Dữ liệu mẫu (SQL Server)
-- GearHost: đổi USE thành tên DB của bạn (vd. newdatabase11)
-- Local:   USE fellow4u_db;

USE newdatabase11;
GO

-- User demo (password: password123) — bcrypt hash, khớp backend Node
IF NOT EXISTS (SELECT 1 FROM dbo.users WHERE email = N'yoojin@gmail.com')
BEGIN
  INSERT INTO dbo.users (email, username, password_hash, first_name, last_name, country, role, avatar_url)
  VALUES (
    N'yoojin@gmail.com',
    N'yoojin',
    N'$2a$10$X.wBI9tSd6VudumIf1VNkui6rSg/NUg/N4XIrzfIGXmhkmNKqYHr.',
    N'Yoo',
    N'Jin',
    N'Vietnam',
    N'traveler',
    N'assets/images/guide_emmy.png'
  );
  PRINT N'Đã tạo user demo: yoojin@gmail.com / password123';
END
GO

DECLARE @uid INT = (SELECT TOP 1 id FROM dbo.users WHERE email = N'yoojin@gmail.com');
IF @uid IS NULL
BEGIN
  RAISERROR(N'Không tìm thấy user yoojin@gmail.com sau INSERT.', 16, 1);
  RETURN;
END

/* ========== TOURS (nếu thiếu) ========== */
IF NOT EXISTS (SELECT 1 FROM dbo.tours WHERE title = N'Da Nang - Ba Na - Hoi An')
BEGIN
  INSERT INTO dbo.tours (title, location, tour_date, days_label, price, distance_km, image_asset, description)
  VALUES
    (N'Da Nang - Ba Na - Hoi An', N'Danang, Vietnam', N'Jan 30, 2020', N'3 days', 400.00, N'120 km', N'assets/images/journey_danang.png', N'Explore central Vietnam'),
    (N'Melbourne - Sydney', N'Australia', N'Jan 30, 2020', N'7 days', 600.00, N'2817 km', N'assets/images/tour_sydney.png', N'Coast to coast'),
    (N'Hanoi - Ha Long Bay', N'Hanoi, Vietnam', N'Jan 30, 2020', N'5 days', 300.00, N'1247 km', N'assets/images/tour_halong.png', N'Northern highlights');
END

/* ========== TRIPS (My Journeys) ========== */
IF NOT EXISTS (SELECT 1 FROM dbo.trips WHERE user_id = @uid AND title = N'A memory in Danang')
BEGIN
  INSERT INTO dbo.trips (user_id, title, location, trip_date, likes_count, image_left, image_mid, image_right, status)
  VALUES
    (@uid, N'A memory in Danang', N'Danang, Vietnam', N'Jan 20, 2020', 234,
      N'assets/images/journey_danang.png', N'assets/images/exp_ba_na.png', N'assets/images/exp_hoian_bicycle.png', N'finished'),
    (@uid, N'Sapa in spring', N'Sapa, Vietnam', N'Jan 18, 2020', 189,
      N'assets/images/exp_grid_5.png', N'assets/images/exp_grid_6.png', N'assets/images/exp_grid_1.png', N'confirmed');
END

/* ========== PHOTOS ========== */
IF NOT EXISTS (SELECT 1 FROM dbo.photos WHERE user_id = @uid)
BEGIN
  INSERT INTO dbo.photos (user_id, image_url, caption)
  VALUES
    (@uid, N'assets/images/exp_grid_1.png', N'Trip photo 1'),
    (@uid, N'assets/images/exp_grid_2.png', N'Danang sunset'),
    (@uid, N'assets/images/exp_hoian_bicycle.png', N'Hoi An'),
    (@uid, N'assets/images/journey_danang.png', N'My journey');
END

/* ========== NOTIFICATIONS ========== */
IF NOT EXISTS (SELECT 1 FROM dbo.notifications WHERE user_id = @uid)
BEGIN
  INSERT INTO dbo.notifications (user_id, message, notif_date, avatar_asset, accent_color, badge_type, show_review, is_read)
  VALUES
    (@uid,
      N'Tuan Tran accepted your request for the trip in Danang, Vietnam on Jan 20, 2020',
      N'Jan 16', N'assets/images/guide_tuan_tran.png', N'#8BC34A', N'check', 0, 0),
    (@uid,
      N'Emmy sent you an offer for the trip in Ho Chi Minh, Vietnam on Feb 12, 2020',
      N'Jan 16', N'assets/images/guide_emmy.png', N'#FFC107', N'offer', 0, 0),
    (@uid,
      N'Thanks! Your trip in Danang has been finished. Please leave a review for Tuan Tran.',
      N'Jan 24', N'assets/images/app_icon.png', N'#3F8CFF', N'review', 1, 0);
END

/* ========== PAYMENTS ========== */
IF NOT EXISTS (SELECT 1 FROM dbo.payments WHERE user_id = @uid)
BEGIN
  INSERT INTO dbo.payments (user_id, trip_title, total_amount, upfront_amount, card_holder, status)
  VALUES
    (@uid, N'Da Nang - Ba Na - Hoi An', 400.00, 200.00, N'Yoo Jin', N'completed'),
    (@uid, N'Hanoi - Ha Long Bay', 300.00, 150.00, N'Yoo Jin', N'completed'),
    (@uid, N'Melbourne - Sydney', 600.00, 300.00, N'Yoo Jin', N'pending');
END
GO

-- Kiểm tra nhanh
SELECT N'users' AS tbl, COUNT(*) AS cnt FROM dbo.users
UNION ALL SELECT N'tours', COUNT(*) FROM dbo.tours
UNION ALL SELECT N'trips', COUNT(*) FROM dbo.trips
UNION ALL SELECT N'photos', COUNT(*) FROM dbo.photos
UNION ALL SELECT N'notifications', COUNT(*) FROM dbo.notifications
UNION ALL SELECT N'payments', COUNT(*) FROM dbo.payments;
GO

PRINT N'Seed data xong.';
GO
