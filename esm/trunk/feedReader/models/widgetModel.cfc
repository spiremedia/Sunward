<cfcomponent name="model" output="false" extends="resources.abstractContentObjectEditorModel">

	<cffunction name="init">
		<cfargument name="request" required="true">
		<cfargument name="userobj" required="true">
		<cfset variables.request = arguments.request>
		<cfset variables.userobj = arguments.userobj>
		
		<cfset loadItem(variables.request.getFormUrlVar('id'))>
		
		<cfparam name="variables.feedurl" default="">
		<cfparam name="variables.showtitle" default="">
		<cfparam name="variables.DESCRIPTIONOPTIONS" default="all">
        <cfparam name="variables.rowcount" default="all">
        <cfparam name="variables.rowmaxlen" default="200">
     	
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getinfo">
		<cfset var r = structnew()>
		
		<cfset r.id = variables.id>
    
		<cfset r.feedurl = variables.feedurl>
		<cfset r.rowcount = variables.rowcount>
		<cfset r.descriptionoptions = variables.descriptionoptions>
        <cfset r.rowcount = variables.rowcount>
        <cfset r.rowmaxlen = variables.rowmaxlen>
        
		<cfreturn r>
	</cffunction>
	
	<cffunction name="setvalues">
		<cfargument name="itemdata">
        <cfparam name="arguments.itemdata.descriptionoptions" default="">
		<cfset variables.id = arguments.itemdata.id>
		<cfset variables.feedurl = arguments.itemdata.feedurl>
		<cfset variables.rowcount = arguments.itemdata.rowcount>
        <cfset variables.descriptionoptions = arguments.itemdata.descriptionoptions>
		<cfset variables.rowmaxlen = arguments.itemdata.rowmaxlen>
	</cffunction>
	
	<cffunction name="validate">		
		<cfset var lcl = structnew()>
		
		<cfset var vdtr = createObject('component','utilities.datavalidator').init()>
		<cfset var mylocal = structnew()>
		
		<cfif variables.feedurl EQ "">
			<cfset vdtr.addError('feedurl', 'Please choose a feedurl.(http://site/feed.rss)')>
		</cfif>
        
        <cfif not refindnocase("^(http|https):\/\/+[\w\-\.,@?^=%&amp;:/~\+##]+\.[a-z]{2,3}[\w\-\@?^=%\.&amp;/~\+##]+$",variables.feedurl)>
        	<cfset vdtr.addError('feedurl', 'The feed must be a valid url (http://site/feed.rss)')>
        </cfif>
	
		<cfreturn vdtr/>
	</cffunction>
	
	<cffunction name="save">
		<cfset var mydata = structnew()>

		<cfset mydata.feedurl = variables.feedurl>
		<cfset mydata.rowcount = variables.rowcount>
        <cfset mydata.showtitle = variables.showtitle>
		<cfset mydata.rowmaxlen = variables.rowmaxlen>
        <cfset mydata.descriptionoptions = variables.descriptionoptions>

		<cfset saveData(mydata)>
	</cffunction>

</cfcomponent>
	