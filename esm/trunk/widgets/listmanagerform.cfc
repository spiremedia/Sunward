<cfcomponent name="tinymce">
	
	<cffunction name="init">
		<cfargument name="name">
		<cfargument name="id">
		<cfargument name="style">
		<cfargument name="selected">
		<cfargument name="options">
		<cfargument name="addtlInfo" default="#structnew()#">
		<cfargument name="formRef">
		
		<cfset variables.content = arraynew(1)>

		<cfif isdefined("addtlInfo.orderable")>
			<cfset variables.orderable = 1>
		<cfelse>
			<cfset variables.orderable = 0>
		</cfif>
		
		<cfset structappend(variables, arguments)>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="add">
		<cfargument name="text">
		<cfset arrayappend(variables.content, arguments.text)>
	</cffunction>
	
	
	
	<cffunction name="setInfo">
		<!--- This is required by template runner --->
	</cffunction>	
	
	<cffunction name="show">
		<cfreturn showForm()>
	</cffunction>
	
	<cffunction name="showContent">
		<cfreturn arraytolist(variables.content,"#chr(13)#")>
	</cffunction>
	
	<cffunction name="showform">
		<cfset var jsonObj = createObject('component','utilities.json')>
		<cfset var selected = listtoarray(variables.selected)>
		<cfset var itm = "">
				
		<cfset add('<select onchange="_#variables.id#_LM.itemSelect()" id="#variables.id#_LMchooser" name="#variables.name#_LMchooser">')>
		<cfset add("<option value=''>Choose Item to add to list</option>")>
		
		<cfloop query="variables.options">
			<cfset add("<option value='#variables.options['value'][variables.options.currentrow]#'>#variables.options['label'][variables.options.currentrow]#</option>")>
		</cfloop>
		
		<cfset add('</select>')>
		<cfset add('<input type="hidden" id="#variables.id#" name="#variables.name#">')>
		<cfset add('<div id="_#id#_list"></div>')>
		
		<cfset add("<script> _#variables.id#_LM = new ListManager('#variables.id#',#jsonObj.encode(selected)#, #variables.orderable#); </script>")>
		<cfreturn showContent()>
	</cffunction>

</cfcomponent>