<cfcomponent name="model" output="false" extends="resources.abstractContentObjectEditorModel">
	
	<cffunction name="init">
		<cfargument name="requestObject">
		<cfset variables.requestObject = arguments.requestObject/>
		<cfreturn this/>
	</cffunction>
	
	<cffunction name="preprocessforwysywig">
		<cfargument name="content">
               
		<!--- client wanted to have borders work but xhtml needs css border:0. Catch them and replace with inline style. similar code online 82--->
        <!--- client wanted to have align left/right but xhtml needs css float:left/right. Catch them and replace with inline style. similar code online near 82 --->
        <cfset refinfo = refind("<img[^>]+style=""(float:left;|float:right;|border:[0-9]+px solid black;)[^>]+>", arguments.content, 0, true)>
				
	  	<cfloop condition="arraylen(refinfo.len) EQ 2">
			<cfset temp = mid(arguments.content, refinfo.pos[1], refinfo.len[1])>
			<cfset tempNew = mid(arguments.content, refinfo.pos[1], refinfo.len[1])>
			<cfset strStyle = "">
			<cfset arrStyle = ArrayNew(1)>
			
			<cfset refinfo2 = refind("border:([0-9]+)px solid black;", temp, 0, true)>
			<cfif (arraylen(refinfo2.len) EQ 2)>
				<cfset arrayAppend(arrStyle, 'border="' & mid(temp, refinfo2.pos[2], refinfo2.len[2]) & '"')>
				<cfset tempNew = reReplace(tempNew, "border:([0-9]+)px solid black;", "")>
			</cfif>
			<cfset refinfo2 = refind("float:(left|right);", temp, 0, true)>
			<cfif (arraylen(refinfo2.len) EQ 2)>
				<cfset arrayAppend(arrStyle, 'align="' & mid(temp, refinfo2.pos[2], refinfo2.len[2]) & '"')>
				<cfset tempNew = reReplace(tempNew, "float:(left|right);", "")>
			</cfif><!---  --->
			<cfset strStyle = ' ' & ArrayToList(arrStyle, " ") & ' '>
			<cfset tempNew = insert(strStyle, tempNew, 5)>
			<cfset arguments.content = replace(arguments.content, temp, tempNew, 'ALL')>
            <cfset refinfo = refind("<img[^>]+style=""(float:left;|float:right;|border:[0-9]+px solid black;)[^>]+>", arguments.content, refinfo.pos[1] + 1, true)>
        </cfloop>
		
		<!--- 
			confusing spot
			The system maintains assets by their id in the format {{asset:[id]}}.
			However, they must be viewable in the html editor. So we transform 
			{{asset:[id]}} to /assets/viewImage/?id=id for use in the wysiwyg editor 
			then back when we save it. Here we are saving it.		
		 --->
		 
		<cfset lcl.refinfo = refindnocase("src=""{{asset\[([A-Z0-9\-]{35})\]}}""", arguments.content, 0, true)>
		<cfset lcl.count = 0>
	  	<cfloop condition="arraylen(lcl.refinfo.len) EQ 2 AND lcl.count LT 200">

	  		<cfset lcl.id = mid(arguments.content, lcl.refinfo.pos[2], lcl.refinfo.len[2])>
	  		
	  		<cfset lcl.fullstring = mid(arguments.content, lcl.refinfo.pos[1], lcl.refinfo.len[1])>
	  		<cfset lcl.newstring = "src=""/assets/viewImage/?id=#lcl.id#""">

	  		<cfset arguments.content = replace(arguments.content,lcl.fullstring,lcl.newstring,"all")>

	  		<cfset lcl.count = lcl.count + 1>
	  		<cfset lcl.refinfo = refindnocase("src=""{{asset\[([A-Z0-9\-]{35})\]}}""", arguments.content, 0, true)>
	  	</cfloop>
		
		<cfset arguments.content = replaceNoCase(arguments.content,'<br class="clear" />', '', 'ALL')>
		<cfset arguments.content = replaceNoCase(arguments.content,'style=""', '', 'ALL')>

		<cfreturn arguments.content/>
	</cffunction>
	
	<cffunction name="postprocessfromwysywig">
		<cfargument name="content" required="true">
		
		<cfset var refinfo = ''>
        <cfset var refinfo2 = ''>
        <cfset var temp = ''>
        <cfset var tempNew = ''>
        <cfset var strStyle = ''>
		<cfset var arrStyle = ArrayNew(1)>
		<cfset var flagAddClear = false>
		<cfset var lcl = structnew()>
		
        <!--- ie in wysywyg editor always adds the domain, remove it  --->
        <cfset arguments.content = replacenocase(arguments.content, '#requestObject.getVar("esmurl")#', "/","all")>
        
		<!--- 
			confusing spot
			The system maintains assets by their id in the format {{asset:[id]}}.
			However, they must be viewable in the html editor. So we transform 
			{{asset:[id]}} to /assets/viewImage/?id=id for use in the wysiwyg editor 
			then back when we save it. Here we are saving it.		
		 --->
		 
		<cfset lcl.refinfo = refindnocase("src=""\/assets\/viewImage\/\?id=([A-Z0-9\-]{35})""", arguments.content, 0, true)>
		<cfset lcl.count = 0>
	  	<cfloop condition="arraylen(lcl.refinfo.len) EQ 2 AND lcl.count LT 200">

	  		<cfset lcl.id = mid(arguments.content, lcl.refinfo.pos[2], lcl.refinfo.len[2])>
	  		
	  		<cfset lcl.fullstring = mid(arguments..content, lcl.refinfo.pos[1], lcl.refinfo.len[1])>
	  		<cfset lcl.newstring = "src=""{{asset[#lcl.id#]}}""">

	  		<cfset arguments.content = replace(arguments.content,lcl.fullstring,lcl.newstring,"all")>

	  		<cfset lcl.count = lcl.count + 1>
	  		<cfset lcl.refinfo = refindnocase("src=""\/assets\/viewImage\/\?id=([A-Z0-9\-]{35})""", arguments.content, 0, true)>
	  	</cfloop>
	  	
	  	<!--- client wanted to have borders work but xhtml needs css border:0. Catch them and replace with inline style. similar code on line 19--->
        <!--- client wanted to have align left/right but xhtml needs css float:left/right. Catch them and replace with inline style. similar code online near 19 --->
        <cfset refinfo = refind("<img[^>]+(align=""left""|align=""right""|border=""[0-9]+"")[^>]+>", arguments.content, 0, true)>
      
		<cfloop condition="arraylen(refinfo.len) EQ 2">
			<cfset temp = mid(arguments.content, refinfo.pos[1], refinfo.len[1])>
			<cfset tempNew = mid(arguments.content, refinfo.pos[1], refinfo.len[1])>
			<cfset strStyle = "">
			<cfset arrStyle = ArrayNew(1)>
			
			<cfset refinfo2 = refind("border=""([0-9]+)""", temp, 0, true)>
			<cfif (arraylen(refinfo2.len) EQ 2)>
				<cfset arrayAppend(arrStyle, 'border:' & mid(temp, refinfo2.pos[2], refinfo2.len[2]) & 'px solid black;')>
				<cfset tempNew = reReplace(tempNew, "border=""([0-9]+)""", "")>
			</cfif>
			<cfset refinfo2 = refind("align=""(left|right)""", temp, 0, true)>
			<cfif (arraylen(refinfo2.len) EQ 2)>
				<cfset arrayAppend(arrStyle, 'float:' & mid(temp, refinfo2.pos[2], refinfo2.len[2]) & ';')>
				<cfset tempNew = reReplace(tempNew, "align=""(left|right)""", "")>
				<cfset flagAddClear = true>
			</cfif>
			<cfset strStyle = ' style="' & ArrayToList(arrStyle, "") & '" '>
			<cfset tempNew = insert(strStyle, tempNew, 5)>
			<cfset arguments.content = replace(arguments.content, temp, tempNew, 'ALL')>
			<cfset refinfo = refind("<img[^>]+(align=""left""|align=""right""|border=""[0-9]+"")[^>]+>", arguments.content, refinfo.pos[1] + 1, true)>
		</cfloop>
		
		<cfif flagAddClear>
        	<cfset arguments.content = insert('<br class="clear" />', arguments.content, len( arguments.content))>
		</cfif>
	  	
	  	<cfreturn arguments.content/>
	</cffunction>
	
</cfcomponent>