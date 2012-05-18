'  SpireMedia, Inc.  Thaddeus Batt thad@spiremedia.com
'  vbscript that calls wmi service to restart the coldfusion services
'  this script can be called via the associated perl script
'  the default location of this file is
'  C:\cfusionmx7\bin\restartcfmx.vbs
'  Date: 02/23/2007
Option Explicit
Dim objWMIService, objItem, objService
Dim colListOfServices, strComputer, strService, intSleep
strComputer = "."
intSleep = 15000
WScript.Echo " Click OK, then wait " & intSleep & " milliseconds"

On Error Resume Next
' NB strService is case sensitive.
strService = " 'ColdFusion MX 7 Application Server' "
WScript.Echo strService
Set objWMIService = GetObject("winmgmts:" _
& "{impersonationLevel=impersonate}!\\" _
& strComputer & "\root\cimv2")
Set colListOfServices = objWMIService.ExecQuery _
("Select * from Win32_Service Where Name ="_
& strService & " ")
WScript.Echo colListofServices
For Each objService in colListOfServices
objService.StopService()
WSCript.Sleep intSleep
objService.StartService()
Next
WScript.Echo "Your "& strService & " service has Started"
WScript.Quit