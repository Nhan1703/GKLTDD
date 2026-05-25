// Chạy 1 lần: node fix-username-column.js
require('dotenv').config();
const { ensureUsernameColumn, testConnection } = require('./config/database');

(async () => {
  await testConnection();
  await ensureUsernameColumn();
  console.log('Xong. Khởi động lại: npm.cmd start');
  process.exit(0);
})().catch((e) => {
  console.error(e.message);
  process.exit(1);
});
