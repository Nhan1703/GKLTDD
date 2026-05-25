# Build từ thư mục gốc repo: docker build -t fellow4u-api .
# Hoặc build trong backend: cd backend && docker build -t fellow4u-api .

FROM node:20-alpine

WORKDIR /app

COPY backend/package.json backend/package-lock.json ./
RUN npm ci --omit=dev

COPY backend/ ./

ENV NODE_ENV=production

EXPOSE 3000

CMD ["npm", "start"]
