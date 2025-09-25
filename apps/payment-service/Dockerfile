FROM node:20-alpine AS builder
WORKDIR /app

RUN npm install -g pnpm

COPY pnpm-workspace.yaml ./
COPY package.json ./
COPY pnpm-lock.yaml ./

COPY apps/payment-service ./apps/payment-service
COPY packages ./packages

RUN pnpm install --frozen-lockfile

WORKDIR /app
RUN pnpm --filter=payment-service build || echo "No build script"

FROM node:20-alpine AS runner
WORKDIR /app

RUN npm install -g pnpm tsx

COPY --from=builder /app/pnpm-workspace.yaml ./
COPY --from=builder /app/package.json ./
COPY --from=builder /app/pnpm-lock.yaml ./
COPY --from=builder /app/apps/payment-service ./apps/payment-service
COPY --from=builder /app/packages ./packages

RUN pnpm install --prod --frozen-lockfile

WORKDIR /app/apps/payment-service

EXPOSE 4003

CMD ["tsx", "src/index.ts"]