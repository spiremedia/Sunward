<cfcomponent name="model" output="false" extends="resources.abstractContentObjectEditorModel">

	<cffunction name="init">
		<cfargument name="request" required="true">
		<cfargument name="userobj" required="true">
		<cfset variables.request = arguments.request>
		<cfset variables.userobj = arguments.userobj>
		
		<cfset loadItem(variables.request.getFormUrlVar('id'))>
		
		<cfparam name="variables.items" default="#arraynew(1)#">
		<cfparam name="variables.startsopen" default="1">
        <cfparam name="variables.dhtmltype" default="Accordion">
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getinfo">
		<cfset var idx = "">
		<cfset var parser = createobject('component','utilities.embeddedlinksandassetsparser').init(variables.request)>
	
		<cfloop from="1" to="#arraylen(variables.items)#" index="idx">
			<cfset variables.items[idx].content = parser.preprocessforwysywig(variables.items[idx].content)>
		</cfloop>
  
		<cfreturn variables>
	</cffunction>
			
	<cffunction name="setvalues">
		<cfargument name="itemdata">
		<cfset variables.id = arguments.itemdata.id>
		<cfset variables.items = arguments.itemdata.items>
        <cfset variables.startsopen = arguments.itemdata.startsopen>
        <cfset variables.dhtmltype = arguments.itemdata.dhtmltype>
	</cffunction>
	
	<cffunction name="validate">
		<cfset var lcl = structnew()>
		
		<cfset var vdtr = createObject('component','utilities.datavalidator').init()>
		<cfset var mylocal = structnew()>
		
        <cfloop from="1" to="#arraylen(items)#" index="lcl.i">
        	<cfif items[lcl.i].title EQ "">
            	<cfset vdtr.addError('items', 'Item #lcl.i# has no Title. Title is required.')>
            </cfif>
            <cfif items[lcl.i].content EQ "">
            	<cfset vdtr.addError('items', 'Item #lcl.i# has no Content. Some Content is required.')>
            </cfif>
        </cfloop>
	
		<cfreturn vdtr/>
	</cffunction>
	
	<cffunction name="save">
		<cfset var mydata = structnew()>
		<cfset var parser = createobject('component','utilities.embeddedlinksandassetsparser').init(variables.request)>
	
		<cfloop from="1" to="#arraylen(variables.items)#" index="idx">
			<cfset variables.items[idx].content = parser.postprocessfromwysywig(variables.items[idx].content)>
		</cfloop>
		
		<cfset mydata.items = variables.items>
        <cfset mydata.startsopen = variables.startsopen>
        <cfset mydata.dhtmltype = variables.dhtmltype>
				
		<cfset saveData(mydata)>
	</cffunction>

</cfcomponent>
	