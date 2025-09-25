@echo off
echo Stopping production services...
docker-compose -f docker-compose.prod.yml down

echo.
echo All services stopped.
pause