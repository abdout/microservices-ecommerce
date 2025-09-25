# 🚀 Vercel Deployment Guide

## Overview
This guide will help you deploy your e-commerce platform to Vercel. Since Vercel is optimized for frontend apps, we'll deploy the Next.js apps (Client and Admin) to Vercel and use external services for the backend.

## Architecture for Vercel Deployment

```
Vercel:
├── Client App (shop.vercel.app)
├── Admin App (admin.vercel.app)
└── API Routes (serverless functions)

External Services:
├── PostgreSQL (Neon - already configured)
├── MongoDB (MongoDB Atlas)
├── Clerk (Authentication)
└── Stripe (Payments)
```

## Step-by-Step Deployment

### Prerequisites
1. Install Vercel CLI:
```bash
npm i -g vercel
```

2. Create a Vercel account at https://vercel.com

### Step 1: Deploy Client App (Customer Shop)

```bash
cd apps/client
vercel
```

When prompted:
- Set up and deploy? **Y**
- Which scope? **Select your account**
- Link to existing project? **N** (first time)
- Project name? **ecom-client** (or your preferred name)
- Directory? **./** (current directory)
- Override settings? **N**

### Step 2: Deploy Admin App

```bash
cd ../admin
vercel
```

Follow similar prompts, name it **ecom-admin**

### Step 3: Set Environment Variables

#### For Client App:
Go to https://vercel.com/dashboard → Select your client project → Settings → Environment Variables

Add these variables:
```
NEXT_PUBLIC_API_URL=https://your-backend-url.com
NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY=pk_test_Y2hhcm1pbmctcmVkYmlyZC02LmNsZXJrLmFjY291bnRzLmRldiQ
CLERK_SECRET_KEY=sk_test_q6l6MdnOymV51kNPeWzrzYvJItKT48DH9Cf2OdkBaI
NEXT_PUBLIC_CLERK_SIGN_IN_URL=/sign-in
NEXT_PUBLIC_CLERK_SIGN_UP_URL=/sign-up
```

#### For Admin App:
Same environment variables as the client app.

### Step 4: Backend Services Options

Since Vercel doesn't support long-running services like Express servers, you have several options:

#### Option A: Use Vercel Functions (Recommended for Simple APIs)

1. Convert your Express endpoints to Vercel Functions:

Create `apps/client/api/products/route.ts`:
```typescript
import { NextRequest, NextResponse } from 'next/server';
import { PrismaClient } from '@repo/product-db';

const prisma = new PrismaClient();

export async function GET(request: NextRequest) {
  const products = await prisma.product.findMany();
  return NextResponse.json(products);
}

export async function POST(request: NextRequest) {
  const data = await request.json();
  const product = await prisma.product.create({ data });
  return NextResponse.json(product);
}
```

#### Option B: Deploy Backend to Railway.app (Recommended)

1. Go to https://railway.app
2. Connect your GitHub repository
3. Deploy each service:
   - Product Service
   - Order Service
   - Auth Service
   - Payment Service
   - Email Service

4. Get the deployment URLs and update your Vercel environment variables:
```
NEXT_PUBLIC_API_URL=https://product-service.up.railway.app
```

#### Option C: Deploy Backend to Render.com

1. Go to https://render.com
2. Create a new Web Service for each backend service
3. Connect your GitHub repo
4. Set build command: `pnpm install && pnpm build`
5. Set start command: `pnpm start`

#### Option D: Use Supabase for Backend

1. Replace your backend with Supabase:
   - Authentication (replaces Clerk)
   - Database (PostgreSQL)
   - Realtime subscriptions (replaces Kafka)
   - Edge Functions (replaces Express services)

### Step 5: Configure Database

Your Neon database is already configured. For MongoDB:

1. Go to https://cloud.mongodb.com
2. Create a free cluster
3. Get your connection string
4. Update the MONGO_URL in your backend service

### Step 6: Update API URLs

After deploying backends, update your Vercel environment variables:

```bash
# Redeploy with new environment variables
vercel --prod
```

### Step 7: Configure Custom Domains (Optional)

In Vercel Dashboard → Settings → Domains:
- Client App: `shop.yourdomain.com`
- Admin App: `admin.yourdomain.com`

## Simplified Deployment Script

Create `deploy-to-vercel.bat`:
```bash
@echo off
echo Deploying to Vercel...

echo Deploying Client App...
cd apps/client
call vercel --prod

echo Deploying Admin App...
cd ../admin
call vercel --prod

echo Deployment complete!
echo.
echo Next steps:
echo 1. Set environment variables in Vercel dashboard
echo 2. Deploy backend services to Railway/Render
echo 3. Update NEXT_PUBLIC_API_URL with backend URL
pause
```

## Environment Variables Reference

### Required for Frontend (Vercel):
```env
# API Configuration
NEXT_PUBLIC_API_URL=https://your-backend.railway.app

# Clerk Authentication
NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY=pk_test_...
CLERK_SECRET_KEY=sk_test_...
NEXT_PUBLIC_CLERK_SIGN_IN_URL=/sign-in
NEXT_PUBLIC_CLERK_SIGN_UP_URL=/sign-up
```

### Required for Backend (Railway/Render):
```env
# Database
DATABASE_URL=postgresql://...
MONGO_URL=mongodb+srv://...

# Services
PORT=4001
KAFKA_BROKERS=kafka.upstash.io:9092

# Authentication
CLERK_SECRET_KEY=sk_test_...
JWT_SECRET=...

# Payments (for payment service)
STRIPE_SECRET_KEY=sk_test_...
STRIPE_WEBHOOK_SECRET=whsec_...

# Email (for email service)
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=your-email@gmail.com
SMTP_PASS=your-app-password
```

## Quick Commands

### Deploy Client to Production:
```bash
cd apps/client
vercel --prod
```

### Deploy Admin to Production:
```bash
cd apps/admin
vercel --prod
```

### Check Deployment Status:
```bash
vercel ls
```

### View Logs:
```bash
vercel logs [deployment-url]
```

## Important Notes

1. **Vercel Limitations**:
   - No support for WebSocket/long-polling (Kafka)
   - Serverless functions timeout after 10s (Pro: 60s)
   - No persistent storage

2. **Recommended Architecture**:
   - Frontend: Vercel (Client + Admin apps)
   - Backend APIs: Railway or Render
   - Database: Neon (PostgreSQL) + MongoDB Atlas
   - File Storage: Cloudinary or AWS S3

3. **Cost Optimization**:
   - Vercel Free: 100GB bandwidth, unlimited deployments
   - Railway: $5 credit/month free
   - Render: Free tier available
   - MongoDB Atlas: 512MB free
   - Neon: 3GB free

## Troubleshooting

### Build Fails on Vercel
- Check build logs in Vercel dashboard
- Ensure all dependencies are in package.json
- Remove unused imports

### API Connection Issues
- Verify NEXT_PUBLIC_API_URL is set correctly
- Check CORS settings on backend
- Ensure backend services are running

### Environment Variables Not Working
- Redeploy after adding variables
- Use NEXT_PUBLIC_ prefix for client-side variables
- Check variable names match exactly

## Next Steps

1. Deploy frontend apps to Vercel ✅
2. Deploy backend to Railway/Render
3. Configure production database
4. Set up monitoring (Vercel Analytics)
5. Configure custom domain
6. Enable Vercel Edge Config for feature flags

## Support

- Vercel Docs: https://vercel.com/docs
- Railway Docs: https://docs.railway.app
- Render Docs: https://render.com/docs
- MongoDB Atlas: https://docs.atlas.mongodb.com