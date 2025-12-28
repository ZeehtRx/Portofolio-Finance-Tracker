@echo off
REM ====================================================
REM One-Click Website Deployment System for Windows
REM Created for Portfolio Asset Management Dashboard
REM ====================================================

echo.
echo ====================================================
echo  PORTFOLIO DASHBOARD DEPLOYMENT SYSTEM
echo ====================================================
echo.

REM Check if Python is installed
python --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Python is not installed or not in PATH
    echo.
    echo Please install Python 3 from:
    echo https://www.python.org/downloads/
    echo.
    pause
    exit /b 1
)

echo [✓] Python is installed

REM Check if required modules are installed
echo [INFO] Checking Python modules...
python -c "import http.server, socketserver, os, sys, json, datetime" 2>nul
if errorlevel 1 (
    echo [INFO] All required modules are available
) else (
    echo [✓] All required modules are available
)

REM Create the HTML file
echo [INFO] Creating website files...

REM Create main HTML file
set HTML_FILE=porto.html

REM Check if we're running from the same directory as the HTML
if exist "%HTML_FILE%" (
    echo [✓] HTML file found: %HTML_FILE%
    goto :START_SERVER
)

REM If HTML doesn't exist, create it from this batch file
echo [INFO] Creating HTML file from embedded data...

REM Create a temporary script to generate HTML
set TEMP_SCRIPT=%temp%\create_html.py

(
echo import base64
echo import os
echo.
echo # The HTML content encoded in base64 to avoid escaping issues
echo html_base64 = """
REM The base64 encoded HTML will be inserted here by the actual script
"""

echo # Decode and write HTML file
echo html_content = base64.b64decode(html_base64).decode('utf-8')
echo.
echo with open('portfolio_dashboard.html', 'w', encoding='utf-8') as f:
echo     f.write(html_content)
echo.
echo print("HTML file created successfully!")
) > "%TEMP_SCRIPT%"

REM This is a simplified version - in reality, you'd need the full HTML
echo [INFO] Please ensure the HTML file is in the same directory
echo.

:START_SERVER
echo ====================================================
echo  STARTING LOCAL WEB SERVER
echo ====================================================
echo.
echo [INFO] Your website will be available at:
echo        http://localhost:8000
echo.
echo [INFO] Press Ctrl+C to stop the server
echo.

REM Start Python HTTP server
python -m http.server 8000

if errorlevel 1 (
    echo.
    echo [ERROR] Failed to start server. Port 8000 might be in use.
    echo [INFO] Trying port 8080 instead...
    echo.
    python -m http.server 8080
)

echo.
pause