# Build stage
FROM node:20-alpine AS builder
WORKDIR /app

# Install pnpm
RUN npm install -g pnpm

# Copy workspace files
COPY pnpm-workspace.yaml ./
COPY package.json ./
COPY pnpm-lock.yaml ./

# Copy app and shared packages
COPY apps/product-service ./apps/product-service
COPY packages ./packages

# Install dependencies
RUN pnpm install --frozen-lockfile

# Generate Prisma client
WORKDIR /app/packages/product-db
RUN pnpm db:generate

# Build TypeScript
WORKDIR /app
RUN pnpm --filter=product-service build

# Production stage
FROM node:20-alpine AS runner
WORKDIR /app

# Install pnpm for production
RUN npm install -g pnpm

# Copy package files
COPY --from=builder /app/pnpm-workspace.yaml ./
COPY --from=builder /app/package.json ./
COPY --from=builder /app/pnpm-lock.yaml ./

# Copy built application
COPY --from=builder /app/apps/product-service ./apps/product-service
COPY --from=builder /app/packages ./packages

# Install production dependencies only
RUN pnpm install --prod --frozen-lockfile

WORKDIR /app/apps/product-service

EXPOSE 4001

ENV NODE_ENV production

CMD ["node", "dist/index.js"]