@echo off
makelove --version >nul 2>&1

if errorlevel 1 (
    echo "makelove not found. Please install it with 'pip install makelove'."
    exit /b 1
)

cd src/ && makelove && cd ..

if errorlevel 1 (
    cd ..
    echo "Failed to build the game."
    exit /b 1
)

pause

exit /b 0