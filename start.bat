@echo off
echo Starting E-Commerce Platform...
echo.

echo Step 1: Starting Docker services (Kafka, MongoDB)...
docker-compose up -d

echo.
echo Step 2: Waiting for services to be ready...
timeout /t 5

echo.
echo Step 3: Starting all applications...
pnpm dev

echo.
echo ====================================
echo Services are running at:
echo Client App: http://localhost:3002
echo Admin App: http://localhost:3003
echo Kafka UI: http://localhost:8080
echo ====================================