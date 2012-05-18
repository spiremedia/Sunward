<cfcomponent extends="resources.system"
	displayname="spireESM Client Application"
	hint=''>
	<cfscript>
		This.name="sunwardesmclient654654860451";
		This.applicationtimeout = CreateTimeSpan(2, 0, 0, 0);
		This.clientmanagement = false;
		this.clientstorage = "none";
		This.sessionmanagement = true;
		This.sessiontimeout = CreateTimeSpan(0, 0, 20, 0);
		This.setclientcookies = true;
		This.setdomaincookies = true;
		This.scriptprotect = false;
		This.loginStorage = "cookie";
	</cfscript>
	
</cfcomponent>