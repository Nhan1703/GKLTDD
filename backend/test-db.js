// Kiểm tra kết nối SQL: node test-db.js
require('dotenv').config();
const { testConnection, buildConfig } = require('./config/database');

console.log('Cấu hình:', JSON.stringify(buildConfig(), null, 2));

testConnection()
  .then(() => {
    console.log('Kết nối SQL Server OK.');
    process.exit(0);
  })
  .catch((e) => {
    console.error('Lỗi:', e.message);
    console.error('');
    console.error('Kiểm tra:');
    console.error('  1. SSMS kết nối được localhost\\SQLEXPRESS ?');
    console.error('  2. Đã chạy database/fellow4u_schema.sql ?');
    console.error('  3. Services: SQL Server (SQLEXPRESS) = Running');
    console.error('  4. Bật SQL Server Browser (services.msc) hoặc thêm DB_PORT=1433 vào .env');
    process.exit(1);
  });
