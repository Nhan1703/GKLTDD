/**
 * Fellow4U API — chạy: npm install && npm start
 * Test Postman: http://127.0.0.1:3000/api
 */
require('dotenv').config();

const express = require('express');
const cors = require('cors');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const { query, testConnection, ensureUsernameColumn, hasUsernameColumn } = require('./config/database');

const app = express();
const PORT = Number(process.env.PORT || 3000);
const JWT_SECRET = process.env.JWT_SECRET || 'fellow4u_dev_secret';

app.use(cors());
app.use(express.json());

// Trang gốc — mở trình duyệt GET (đặt trước các route khác)
app.get('/', (_req, res) => {
  res.redirect('/api');
});

app.get(['/api', '/api/'], (_req, res) => {
  res.json({
    ok: true,
    service: 'fellow4u-api',
    login: 'GET /api/auth/login?email=yoojin@gmail.com&password=password123',
    register: 'GET /api/auth/register?email=test@test.com&password=123456&firstName=A&lastName=B',
    tours: 'GET /api/tours',
    health: 'GET /api/health',
  });
});

app.get('/api/health', (_req, res) => {
  res.json({ ok: true, service: 'fellow4u-api', database: 'fellow4u_db' });
});

function authMiddleware(req, res, next) {
  const header = req.headers.authorization || '';
  const token = header.startsWith('Bearer ') ? header.slice(7) : null;
  if (!token) {
    return res.status(401).json({ error: 'Missing token' });
  }
  try {
    req.user = jwt.verify(token, JWT_SECRET);
    next();
  } catch {
    return res.status(401).json({ error: 'Invalid token' });
  }
}

function signToken(user) {
  return jwt.sign(
    { id: user.id, email: user.email },
    JWT_SECRET,
    { expiresIn: '7d' },
  );
}

function publicUser(row) {
  return {
    id: row.id,
    email: row.email,
    username: row.username,
    firstName: row.first_name,
    lastName: row.last_name,
    country: row.country,
    role: row.role,
    avatarUrl: row.avatar_url,
  };
}

async function findUserByLogin(loginId) {
  const id = (loginId || '').trim();
  if (await hasUsernameColumn()) {
    return query('SELECT TOP 1 * FROM users WHERE email = ? OR username = ?', [id, id]);
  }
  return query('SELECT TOP 1 * FROM users WHERE email = ?', [id]);
}

async function ensureDemoUser() {
  const rows = await query('SELECT TOP 1 id FROM users WHERE email = ?', ['yoojin@gmail.com']);
  const hash = await bcrypt.hash('password123', 10);
  let userId;
  if (rows.length === 0) {
    const inserted = await query(
      `INSERT INTO users (email, password_hash, first_name, last_name, country, role, avatar_url)
       OUTPUT INSERTED.id AS id
       VALUES (?, ?, N'Yoo', N'Jin', N'Vietnam', N'traveler', N'assets/images/guide_emmy.png')`,
      ['yoojin@gmail.com', hash],
    );
    userId = inserted.insertId;
    console.log('Đã tạo user demo: yoojin@gmail.com / password123');
  } else {
    userId = rows[0].id;
    await query('UPDATE users SET password_hash = ? WHERE email = ?', [hash, 'yoojin@gmail.com']);
  }

  const tripCount = await query('SELECT COUNT(*) AS c FROM trips WHERE user_id = ?', [userId]);
  if (tripCount[0].c === 0) {
    await query(
      `INSERT INTO trips (user_id, title, location, trip_date, likes_count, image_left, image_mid, image_right, status)
       VALUES (?, N'A memory in Danang', N'Danang, Vietnam', N'Jan 20, 2020', 234,
         N'assets/images/journey_danang.png', N'assets/images/exp_ba_na.png', N'assets/images/exp_hoian_bicycle.png', N'finished')`,
      [userId],
    );
  }

  const notifCount = await query('SELECT COUNT(*) AS c FROM notifications WHERE user_id = ?', [userId]);
  if (notifCount[0].c === 0) {
    await query(
      `INSERT INTO notifications (user_id, message, notif_date, avatar_asset, accent_color, badge_type, show_review)
       VALUES (?, N'Tuan Tran accepted your request for the trip in Danang, Vietnam on Jan 20, 2020',
         N'Jan 16', N'assets/images/guide_tuan_tran.png', N'#8BC34A', N'check', 0)`,
      [userId],
    );
    await query(
      `INSERT INTO notifications (user_id, message, notif_date, avatar_asset, accent_color, badge_type, show_review)
       VALUES (?, N'Thanks! Your trip in Danang has been finished. Please leave a review for Tuan Tran.',
         N'Jan 24', N'assets/images/app_icon.png', N'#3F8CFF', N'review', 1)`,
      [userId],
    );
  }

  const photoCount = await query('SELECT COUNT(*) AS c FROM photos WHERE user_id = ?', [userId]);
  if (photoCount[0].c === 0) {
    await query(
      `INSERT INTO photos (user_id, image_url, caption) VALUES (?, N'assets/images/exp_grid_1.png', N'Trip photo 1')`,
      [userId],
    );
  }
}

// --- Auth ---
async function handleRegister(data, res) {
  try {
    const { email, password, firstName, lastName, country, role, username } = data;
    if (!email || !password) {
      return res.status(422).json({ error: 'email and password required' });
    }
    if (String(password).length < 6) {
      return res.status(422).json({ error: 'password must be at least 6 characters' });
    }
    const exists = await query('SELECT id FROM users WHERE email = ?', [email]);
    if (exists.length) {
      return res.status(409).json({ error: 'Email already registered' });
    }
    const hasUserCol = await hasUsernameColumn();
    if (username && hasUserCol) {
      const uExists = await query('SELECT id FROM users WHERE username = ?', [username]);
      if (uExists.length) {
        return res.status(409).json({ error: 'Username already taken' });
      }
    }
    const hash = await bcrypt.hash(password, 10);
    const userRole = role === 'guide' ? 'guide' : 'traveler';
    let result;
    if (hasUserCol) {
      result = await query(
        `INSERT INTO users (email, username, password_hash, first_name, last_name, country, role)
         OUTPUT INSERTED.id AS id
         VALUES (?, ?, ?, ?, ?, ?, ?)`,
        [email, username || null, hash, firstName || '', lastName || '', country || null, userRole],
      );
    } else {
      result = await query(
        `INSERT INTO users (email, password_hash, first_name, last_name, country, role)
         OUTPUT INSERTED.id AS id
         VALUES (?, ?, ?, ?, ?, ?)`,
        [email, hash, firstName || '', lastName || '', country || null, userRole],
      );
    }
    const users = await query('SELECT * FROM users WHERE id = ?', [result.insertId]);
    const user = users[0];
    const token = signToken(user);
    return res.status(201).json({ token, user: publicUser(user) });
  } catch (e) {
    console.error(e);
    return res.status(500).json({ error: e.message });
  }
}

async function handleLogin(email, password, res) {
  try {
    if (!email || !password) {
      return res.status(422).json({ error: 'email and password required' });
    }
    const users = await findUserByLogin(email);
    if (!users.length) {
      return res.status(400).json({ error: 'user not found' });
    }
    const user = users[0];
    const ok = await bcrypt.compare(password, user.password_hash);
    if (!ok) {
      return res.status(400).json({ error: 'Invalid password' });
    }
    const token = signToken(user);
    return res.json({ token, user: publicUser(user) });
  } catch (e) {
    console.error(e);
    return res.status(500).json({ error: e.message });
  }
}

app.post('/api/auth/register', (req, res) => handleRegister(req.body, res));
app.get('/api/auth/register', (req, res) => handleRegister(req.query, res));

app.post('/api/auth/login', (req, res) => handleLogin(req.body.email, req.body.password, res));
app.get('/api/auth/login', (req, res) => handleLogin(req.query.email, req.query.password, res));

app.post('/api/auth/change-password', authMiddleware, async (req, res) => {
  try {
    const { currentPassword, newPassword } = req.body;
    if (!currentPassword || !newPassword || String(newPassword).length < 6) {
      return res.status(422).json({ error: 'Invalid password fields' });
    }
    const users = await query('SELECT * FROM users WHERE id = ?', [req.user.id]);
    const user = users[0];
    const ok = await bcrypt.compare(currentPassword, user.password_hash);
    if (!ok) return res.status(400).json({ error: 'Current password incorrect' });
    const hash = await bcrypt.hash(newPassword, 10);
    await query('UPDATE users SET password_hash = ? WHERE id = ?', [hash, req.user.id]);
    return res.json({ message: 'Password updated' });
  } catch (e) {
    return res.status(500).json({ error: e.message });
  }
});

// --- Profile ---
app.get('/api/profile', authMiddleware, async (req, res) => {
  const users = await query('SELECT * FROM users WHERE id = ?', [req.user.id]);
  if (!users.length) return res.status(404).json({ error: 'Not found' });
  return res.json({ user: publicUser(users[0]) });
});

app.put('/api/profile', authMiddleware, async (req, res) => {
  const { firstName, lastName, country, avatarUrl } = req.body;
  await query(
    `UPDATE users SET first_name = COALESCE(?, first_name), last_name = COALESCE(?, last_name),
     country = COALESCE(?, country), avatar_url = COALESCE(?, avatar_url) WHERE id = ?`,
    [firstName, lastName, country, avatarUrl, req.user.id],
  );
  const users = await query('SELECT * FROM users WHERE id = ?', [req.user.id]);
  return res.json({ user: publicUser(users[0]) });
});

// --- Tours ---
app.get('/api/tours', async (_req, res) => {
  const tours = await query('SELECT * FROM tours ORDER BY id');
  return res.json({ tours });
});

app.get('/api/tours/:id', async (req, res) => {
  const tours = await query('SELECT * FROM tours WHERE id = ?', [req.params.id]);
  if (!tours.length) return res.status(404).json({ error: 'Tour not found' });
  return res.json({ tour: tours[0] });
});

// --- Search ---
app.get('/api/search', async (req, res) => {
  const q = `%${req.query.q || ''}%`;
  const tours = await query(
    'SELECT * FROM tours WHERE title LIKE ? OR location LIKE ? ORDER BY id',
    [q, q],
  );
  return res.json({ tours, query: req.query.q || '' });
});

// --- Trips / Journeys ---
app.get('/api/trips', authMiddleware, async (req, res) => {
  const trips = await query('SELECT * FROM trips WHERE user_id = ? ORDER BY id DESC', [req.user.id]);
  return res.json({ trips });
});

app.get('/api/trips/:id', authMiddleware, async (req, res) => {
  const trips = await query('SELECT * FROM trips WHERE id = ? AND user_id = ?', [
    req.params.id,
    req.user.id,
  ]);
  if (!trips.length) return res.status(404).json({ error: 'Trip not found' });
  return res.json({ trip: trips[0] });
});

app.post('/api/trips', authMiddleware, async (req, res) => {
  const { title, location, tripDate, imageLeft, imageMid, imageRight } = req.body;
  if (!title || !location) {
    return res.status(422).json({ error: 'title and location required' });
  }
  const result = await query(
    `INSERT INTO trips (user_id, title, location, trip_date, image_left, image_mid, image_right)
     OUTPUT INSERTED.id AS id
     VALUES (?, ?, ?, ?, ?, ?, ?)`,
    [req.user.id, title, location, tripDate || null, imageLeft || null, imageMid || null, imageRight || null],
  );
  const trips = await query('SELECT * FROM trips WHERE id = ?', [result.insertId]);
  return res.status(201).json({ trip: trips[0] });
});

// --- Photos ---
app.get('/api/photos', authMiddleware, async (req, res) => {
  const photos = await query('SELECT * FROM photos WHERE user_id = ? ORDER BY id DESC', [req.user.id]);
  return res.json({ photos });
});

app.post('/api/photos', authMiddleware, async (req, res) => {
  const { imageUrl, caption } = req.body;
  if (!imageUrl) return res.status(422).json({ error: 'imageUrl required' });
  const result = await query(
    'INSERT INTO photos (user_id, image_url, caption) OUTPUT INSERTED.id AS id VALUES (?, ?, ?)',
    [req.user.id, imageUrl, caption || null],
  );
  const photos = await query('SELECT * FROM photos WHERE id = ?', [result.insertId]);
  return res.status(201).json({ photo: photos[0] });
});

// --- Notifications ---
app.get('/api/notifications', authMiddleware, async (req, res) => {
  const items = await query(
    'SELECT * FROM notifications WHERE user_id = ? ORDER BY id DESC',
    [req.user.id],
  );
  return res.json({ notifications: items });
});

// --- Payments ---
app.post('/api/payments', authMiddleware, async (req, res) => {
  const { tripTitle, totalAmount, upfrontAmount, cardHolder } = req.body;
  if (!tripTitle || totalAmount == null) {
    return res.status(422).json({ error: 'tripTitle and totalAmount required' });
  }
  const result = await query(
    `INSERT INTO payments (user_id, trip_title, total_amount, upfront_amount, card_holder, status)
     OUTPUT INSERTED.id AS id
     VALUES (?, ?, ?, ?, ?, N'completed')`,
    [req.user.id, tripTitle, totalAmount, upfrontAmount || totalAmount, cardHolder || null],
  );
  const rows = await query('SELECT * FROM payments WHERE id = ?', [result.insertId]);
  return res.status(201).json({ payment: rows[0], message: 'Payment recorded' });
});

// --- Trip information draft ---
app.post('/api/trip-information', authMiddleware, async (req, res) => {
  const body = req.body;
  return res.status(201).json({ message: 'Trip information saved', data: body });
});

async function start() {
  try {
    await testConnection();
    console.log('SQL Server: kết nối OK');
    await ensureUsernameColumn();
    console.log('Schema users.username: OK');
    await ensureDemoUser();
  } catch (e) {
    console.error('SQL Server lỗi:', e.message);
    console.error('→ SSMS: chạy database/fellow4u_schema.sql');
    console.error('→ Kiểm tra backend/.env (sa / 123123)');
    console.error('→ Chạy: node test-db.js');
    console.error('→ Bật service "SQL Server Browser" (services.msc) hoặc thêm DB_PORT=1433 vào .env');
    console.error('→ API vẫn chạy nhưng login/register sẽ lỗi cho đến khi SQL kết nối được.');
  }

  app.listen(PORT, '0.0.0.0', () => {
    console.log(`Fellow4U API: http://127.0.0.1:${PORT}/api`);
    console.log('Browser GET: http://127.0.0.1:3000/api/auth/login?email=yoojin@gmail.com&password=password123');
  });
}

start();
