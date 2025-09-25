# E-Commerce Platform - Deployment Guide

## Architecture Overview

This is a **microservices e-commerce platform** with multiple entry points:

### 🎯 Main Entry Points (User-Facing Apps)

1. **Client App** (Port 3002) - Customer shopping interface
   - Location: `apps/client/`
   - URL: http://localhost:3002
   - Purpose: Where customers browse products, add to cart, and checkout

2. **Admin App** (Port 3003) - Store management interface
   - Location: `apps/admin/`
   - URL: http://localhost:3003
   - Purpose: Where admins manage products, orders, and customers

### 🔧 Backend Microservices (APIs)

3. **Auth Service** (Port 3000) - Authentication
   - Location: `apps/auth-service/`
   - Handles user authentication with Clerk

4. **Product Service** (Port 4001) - Product catalog
   - Location: `apps/product-service/`
   - Manages product inventory and catalog

5. **Order Service** (Port 4002) - Order processing
   - Location: `apps/order-service/`
   - Handles order creation and management

6. **Payment Service** (Port 4003) - Payment processing
   - Location: `apps/payment-service/`
   - Integrates with Stripe for payments

7. **Email Service** (Port 4004) - Notifications
   - Location: `apps/email-service/`
   - Sends email notifications

## Quick Start - Local Development

### Prerequisites
- Node.js 18+
- Docker Desktop
- pnpm (`npm install -g pnpm`)

### Step 1: Install Dependencies
```bash
pnpm install
```

### Step 2: Generate Database Clients
```bash
pnpm --filter=@repo/product-db db:generate
```

### Step 3: Start Infrastructure (Docker)
```bash
docker-compose up -d
```
This starts:
- Kafka (message broker)
- MongoDB (for orders)
- Zookeeper (Kafka dependency)

### Step 4: Run Everything
```bash
pnpm dev
```

### Step 5: Access the Apps
- **Shop**: http://localhost:3002
- **Admin**: http://localhost:3003
- **Kafka UI**: http://localhost:8080

## Production Deployment

### Option 1: Deploy to Vercel (Recommended for Next.js apps)

#### Deploy Frontend Apps:
```bash
# Deploy Client App
cd apps/client
vercel

# Deploy Admin App
cd apps/admin
vercel
```

#### Environment Variables for Vercel:
```
NEXT_PUBLIC_API_URL=https://your-api-domain.com
NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY=pk_test_...
CLERK_SECRET_KEY=sk_test_...
```

### Option 2: Deploy with Docker

#### Build Everything:
```bash
# Build all apps
pnpm build

# Build Docker images
docker build -t ecom-client ./apps/client
docker build -t ecom-admin ./apps/admin
docker build -t ecom-auth ./apps/auth-service
docker build -t ecom-product ./apps/product-service
docker build -t ecom-order ./apps/order-service
docker build -t ecom-payment ./apps/payment-service
docker build -t ecom-email ./apps/email-service
```

### Option 3: Deploy to Cloud Providers

#### AWS/Azure/GCP Deployment:
1. **Frontend Apps** → Deploy to Static Hosting (S3, Azure Static Web Apps, Cloud Storage)
2. **Microservices** → Deploy to Container Services (ECS, AKS, GKE)
3. **Databases** → Use managed services (RDS, Cosmos DB, Cloud SQL)
4. **Kafka** → Use managed Kafka (MSK, Event Hubs, Pub/Sub)

## Environment Variables Required

### For Next.js Apps (Client & Admin):
```env
NEXT_PUBLIC_API_URL=http://localhost:4001
NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY=your_key
CLERK_SECRET_KEY=your_secret
```

### For Microservices:
```env
PORT=4001
DATABASE_URL=postgresql://...
MONGO_URL=mongodb://...
KAFKA_BROKERS=localhost:9092
CLERK_SECRET_KEY=your_key
STRIPE_SECRET_KEY=your_key (for payment service)
```

## Build Commands

```bash
# Build everything
pnpm build

# Build specific app
pnpm build --filter=client
pnpm build --filter=admin

# Type checking
pnpm check-types

# Linting
pnpm lint
```

## Testing the Deployment

1. **Test Client App**:
   - Browse products
   - Add to cart
   - Checkout flow

2. **Test Admin App**:
   - Login as admin
   - Manage products
   - View orders

3. **Test APIs**:
```bash
# Test Product Service
curl http://localhost:4001/products

# Test Auth Service
curl http://localhost:3000/health
```

## Troubleshooting

### Services not starting?
- Check Docker is running: `docker ps`
- Check ports are free: `netstat -ano | findstr :3002`
- Check logs: `docker-compose logs -f`

### Database connection issues?
- Ensure PostgreSQL/MongoDB are running
- Check connection strings in .env files
- Run migrations: `pnpm --filter=@repo/product-db db:migrate`

### Kafka connection issues?
- Services will work without Kafka but messaging won't function
- Check Kafka is running: `docker-compose ps kafka`

## Production Checklist

- [ ] Replace all test API keys with production keys
- [ ] Set up production databases
- [ ] Configure production Kafka cluster
- [ ] Set up monitoring (Datadog, New Relic)
- [ ] Configure CI/CD pipelines
- [ ] Set up SSL certificates
- [ ] Configure rate limiting
- [ ] Set up backup strategies
- [ ] Configure auto-scaling

## Architecture Diagram

```
┌─────────────┐     ┌─────────────┐
│ Client App  │     │  Admin App  │
│  (Next.js)  │     │  (Next.js)  │
└──────┬──────┘     └──────┬──────┘
       │                   │
       └───────┬───────────┘
               │
        ┌──────▼──────┐
        │   Gateway   │
        │  (Optional) │
        └──────┬──────┘
               │
  ┌────────────┼────────────┐
  │            │            │
┌─▼───┐   ┌───▼───┐   ┌────▼────┐
│Auth │   │Product│   │ Order   │
│ API │   │  API  │   │  API    │
└─────┘   └───────┘   └─────────┘
  │            │            │
  └────────────┼────────────┘
               │
         ┌─────▼─────┐
         │   Kafka   │
         │ Message   │
         │   Bus     │
         └───────────┘
```