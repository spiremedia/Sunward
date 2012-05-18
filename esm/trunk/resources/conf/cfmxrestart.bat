@echo off

REM - File: cfmxrestart.bat
REM - Description: Restart's ColdFusion MX Services
REM - Author: Pete Freitag CFDEV.COM

echo Restarting ColdFusion MX...
echo ======================================================
net stop "ColdFusion MX 7 Application Server"
net stop "ColdFusion MX 7 ODBC Agent"
net stop "ColdFusion MX 7 ODBC Server"

net start "ColdFusion MX 7 Application Server"
net start "ColdFusion MX 7 ODBC Agent"
net start "ColdFusion MX 7 ODBC Server"
echo ======================================================
echo ColdFusion MX Restarted