@echo off
echo Stopping E-Commerce Platform...
echo.

echo Stopping Docker services...
docker-compose down

echo.
echo All services stopped.
pause