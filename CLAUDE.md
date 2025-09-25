# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is an e-commerce platform built as a Turborepo monorepo with a microservices architecture. It uses TypeScript throughout, with Next.js for frontend apps and Express services for the backend.

## Tech Stack

- **Monorepo**: Turborepo with pnpm workspaces
- **Frontend**: Next.js 15 with React 19, TypeScript, Tailwind CSS
- **Backend Services**: Express.js with TypeScript (ESM modules)
- **Database**: Prisma ORM with separate database packages
- **Messaging**: Kafka for inter-service communication
- **Authentication**: Clerk
- **Payments**: Stripe
- **State Management**: Zustand (client app), React Query (admin app)
- **Forms**: React Hook Form with Zod validation
- **UI Components**: Radix UI (admin app), custom components (client app)

## Architecture

### Apps (in `apps/`)
- **client**: Customer-facing Next.js app (port 3002)
- **admin**: Admin dashboard Next.js app (port 3003)
- **auth-service**: Authentication microservice
- **product-service**: Product catalog management
- **order-service**: Order processing
- **payment-service**: Payment handling
- **email-service**: Email notifications

### Shared Packages (in `packages/`)
- **@repo/types**: Shared TypeScript types across the monorepo
- **@repo/kafka**: Kafka client and messaging utilities
- **@repo/product-db**: Product database schema and Prisma client
- **@repo/order-db**: Order database schema and Prisma client
- **@repo/eslint-config**: Shared ESLint configurations
- **@repo/typescript-config**: Shared TypeScript configurations

## Development Commands

### Install dependencies
```bash
pnpm install
```

### Development
```bash
# Run all apps and services in dev mode
pnpm dev

# Run specific app/service
pnpm dev --filter=client
pnpm dev --filter=admin
pnpm dev --filter=product-service
```

### Building
```bash
# Build all apps and packages
pnpm build

# Build specific app
pnpm build --filter=client
```

### Type Checking
```bash
# Check types across the entire monorepo
pnpm check-types

# Check types for specific app
pnpm check-types --filter=client
```

### Linting
```bash
# Lint all packages
pnpm lint

# Lint specific app
pnpm lint --filter=admin
```

### Formatting
```bash
# Format all TypeScript and Markdown files
pnpm format
```

### Database Commands
For packages with Prisma (product-db, order-db):
```bash
# Generate Prisma client
pnpm --filter=@repo/product-db db:generate

# Run migrations
pnpm --filter=@repo/product-db db:migrate

# Deploy migrations to production
pnpm --filter=@repo/product-db db:deploy
```

## Port Allocation
- Client app: 3002
- Admin app: 3003
- Microservices use ports defined in their .env files

## Environment Variables
- Services require `.env` files for configuration
- Next.js apps use `.env.local` for local development
- Database URLs are configured through `DATABASE_URL` environment variable

## Docker Services (Kafka)
Start Kafka and related services:
```bash
# Start all Docker services
docker-compose up -d

# Stop all services
docker-compose down

# View logs
docker-compose logs -f kafka
```

Services available:
- Kafka broker: localhost:9092
- Zookeeper: localhost:2181
- Kafka UI: http://localhost:8080 (web interface for monitoring)

## Code Conventions
- All packages use TypeScript with strict mode
- ESM modules for backend services (`"type": "module"` in package.json)
- Next.js apps use Turbopack for faster development builds
- Shared types are centralized in `@repo/types`
- Database operations use Prisma with separate schema packages
- Inter-service communication uses Kafka through `@repo/kafka`