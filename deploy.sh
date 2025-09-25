#!/bin/bash

echo "================================================"
echo "E-Commerce Platform - Production Build & Deploy"
echo "================================================"
echo ""

echo "Step 1: Building all applications..."
pnpm build

echo ""
echo "Step 2: Building Docker images..."
docker-compose -f docker-compose.prod.yml build

echo ""
echo "Step 3: Starting production environment..."
docker-compose -f docker-compose.prod.yml up -d

echo ""
echo "================================================"
echo "Deployment Complete!"
echo "================================================"
echo ""
echo "Services are running at:"
echo "- Customer Shop: http://localhost:3002"
echo "- Admin Panel: http://localhost:3003"
echo "- Auth API: http://localhost:3000"
echo "- Product API: http://localhost:4001"
echo "- Order API: http://localhost:4002"
echo "- Payment API: http://localhost:4003"
echo "- Email API: http://localhost:4004"
echo ""
echo "To stop all services, run: ./stop-production.sh"
echo "================================================"