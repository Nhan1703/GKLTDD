/**
 * Kết nối SQL Server — Fellow4U (SSMS: localhost\SQLEXPRESS)
 */
require('dotenv').config({ path: require('path').join(__dirname, '..', '.env') });

const sql = require('mssql');

function buildConfig() {
  const useWindowsAuth = process.env.DB_USE_WINDOWS_AUTH === 'true';
  const serverRaw = (process.env.DB_SERVER || 'localhost\\SQLEXPRESS').trim();
  const explicitPort = process.env.DB_PORT ? Number(process.env.DB_PORT) : undefined;

  let server = serverRaw;
  let instanceName;

  if (serverRaw.includes('\\')) {
    const parts = serverRaw.split('\\');
    server = parts[0] || 'localhost';
    instanceName = parts[1];
  } else if (serverRaw.includes('/')) {
    const parts = serverRaw.split('/');
    server = parts[0] || 'localhost';
    instanceName = parts[1];
  }

  const config = {
    server: server === '.' ? 'localhost' : server,
    database: process.env.DB_NAME || 'fellow4u_db',
    connectionTimeout: Number(process.env.DB_CONNECT_TIMEOUT || 30000),
    requestTimeout: Number(process.env.DB_REQUEST_TIMEOUT || 30000),
    options: {
      encrypt: process.env.DB_ENCRYPT === 'true',
      trustServerCertificate: process.env.DB_TRUST_CERT !== 'false',
      enableArithAbort: true,
    },
    pool: {
      max: 10,
      min: 0,
      idleTimeoutMillis: 30000,
    },
  };

  if (explicitPort) {
    config.port = explicitPort;
  } else if (instanceName) {
    config.options.instanceName = instanceName;
  }

  if (useWindowsAuth) {
    config.options.trustedConnection = true;
  } else {
    config.user = process.env.DB_USER || 'sa';
    config.password = process.env.DB_PASSWORD || '';
  }

  return config;
}

const config = buildConfig();

let pool;

async function connectWithRetry(maxAttempts = 3) {
  let lastError;
  for (let attempt = 1; attempt <= maxAttempts; attempt += 1) {
    try {
      if (pool) {
        try {
          await pool.close();
        } catch (_) {}
        pool = null;
      }
      pool = await sql.connect(config);
      return pool;
    } catch (e) {
      lastError = e;
      console.warn(`SQL connect lần ${attempt}/${maxAttempts} thất bại: ${e.message}`);
      if (attempt < maxAttempts) {
        await new Promise((r) => setTimeout(r, 2000));
      }
    }
  }
  throw lastError;
}

async function getPool() {
  if (!pool) {
    pool = await connectWithRetry();
  }
  return pool;
}

function bindParams(request, text, params) {
  let index = 0;
  const sqlText = text.replace(/\?/g, () => {
    const name = `p${index}`;
    const value = params[index];
    index += 1;
    if (value === null || value === undefined) {
      request.input(name, sql.NVarChar, null);
    } else if (typeof value === 'number' && Number.isInteger(value)) {
      request.input(name, sql.Int, value);
    } else if (typeof value === 'number') {
      request.input(name, sql.Decimal(10, 2), value);
    } else if (typeof value === 'boolean') {
      request.input(name, sql.Bit, value);
    } else {
      request.input(name, sql.NVarChar, String(value));
    }
    return `@${name}`;
  });
  return sqlText;
}

async function query(text, params = []) {
  const p = await getPool();
  const request = p.request();
  const sqlText = bindParams(request, text, params);
  const result = await request.query(sqlText);
  const rows = result.recordset || [];
  const insertId = rows[0]?.id;
  if (insertId != null) {
    return Object.assign(rows, { insertId });
  }
  return rows;
}

async function testConnection() {
  const p = await connectWithRetry();
  await p.request().query('SELECT DB_NAME() AS db, @@SERVERNAME AS srv');
  return true;
}

async function hasUsernameColumn() {
  const rows = await query(`
    SELECT COUNT(*) AS c FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_SCHEMA = N'dbo' AND TABLE_NAME = N'users' AND COLUMN_NAME = N'username'
  `);
  return Number(rows[0]?.c) > 0;
}

/** Đảm bảo cột username tồn tại (DB tạo từ schema cũ). */
async function ensureUsernameColumn() {
  if (await hasUsernameColumn()) {
    return true;
  }
  const p = await getPool();
  await p.request().query('ALTER TABLE dbo.users ADD username NVARCHAR(100) NULL');
  console.log('Đã thêm cột dbo.users.username');
  try {
    await p.request().query(
      'CREATE UNIQUE INDEX UX_users_username ON dbo.users(username) WHERE username IS NOT NULL',
    );
  } catch (e) {
    if (!String(e.message).includes('already exists') && !String(e.message).includes('UX_users_username')) {
      console.warn('Index UX_users_username:', e.message);
    }
  }
  return true;
}

module.exports = {
  sql,
  config,
  getPool,
  query,
  testConnection,
  buildConfig,
  hasUsernameColumn,
  ensureUsernameColumn,
};
