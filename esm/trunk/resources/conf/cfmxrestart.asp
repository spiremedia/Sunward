<% 
    set wshell = CreateObject("WScript.Shell") 
    'wshell.run "cscript C:\Inetpub\wwwroot\client\applications\scripts\restartcfmx.vbs > c:\temp\batout.txt", 0, TRUE 
    'wshell.run "%COMSPEC% /C dir C:\Inetpub\wwwroot\client\applications\scripts\ > c:\temp\batout.txt", 0, TRUE 
    wshell.run "%COMSPEC% /C cscript C:\Inetpub\wwwroot\client\applications\scripts\restartcfmx.vbs > c:\temp\batout.txt", 0, TRUE 
    set wshell = nothing 
 
    set fso = CreateObject("Scripting.FileSystemObject") 
    set fs = fso.openTextFile("c:\temp\batout.txt", 1, TRUE) 
    response.write replace(replace(fs.readall,"<","<"),vbCrLf,"<br>") 
    fs.close: set fs = nothing: set fso = nothing 
%>

done