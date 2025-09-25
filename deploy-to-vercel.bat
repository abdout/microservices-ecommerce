@echo off
echo ================================
echo Deploying to Vercel
echo ================================
echo.

echo Installing Vercel CLI if not installed...
where vercel >nul 2>nul
if %errorlevel% neq 0 (
    echo Installing Vercel CLI...
    npm i -g vercel
)

echo.
echo Step 1: Building applications...
call pnpm build --filter=client --filter=admin

echo.
echo Step 2: Deploying Client App (Customer Shop)...
cd apps\client
echo.
echo When prompted:
echo - Project name: ecom-client (or your choice)
echo - Override settings: No
echo.
call vercel --prod

echo.
echo Step 3: Deploying Admin App...
cd ..\admin
echo.
echo When prompted:
echo - Project name: ecom-admin (or your choice)
echo - Override settings: No
echo.
call vercel --prod

cd ..\..

echo.
echo ================================
echo Deployment Complete!
echo ================================
echo.
echo IMPORTANT NEXT STEPS:
echo.
echo 1. Go to https://vercel.com/dashboard
echo 2. Select each project and go to Settings - Environment Variables
echo 3. Add these variables:
echo    - NEXT_PUBLIC_API_URL (your backend URL)
echo    - NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY
echo    - CLERK_SECRET_KEY
echo.
echo 4. For backend services, deploy to:
echo    - Railway.app (recommended)
echo    - Render.com
echo    - Or convert to Vercel API routes
echo.
echo Your frontend apps are now live on Vercel!
echo Check your Vercel dashboard for the URLs.
echo ================================
pause