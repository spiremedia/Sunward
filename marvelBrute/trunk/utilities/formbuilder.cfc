<cfcomponent name="formBuilder" output="false">
	
	<cffunction name="init" output="false">
		<cfargument name="requestObj" required="true">
		<cfargument name="formName" required="true">
		<cfargument name="formMethod" required="true">
		<cfargument name="validationObj" required="true">
		<cfargument name="addtlInfo" default="#structnew()#">
	
		<cfparam name="arguments.addtlinfo.showanchor" default="true">
			
		<cfset structappend(variables, arguments)>
		<cfset variables.html = arraynew(1)>

		<cfset startForm(argumentCollection = arguments)>
				
		<cfif arguments.addtlinfo.showanchor>
			<cfset addAnchor()>
		</cfif>
		
		<cfset showErrors()>
		
		<cfset variables.formErrors = arguments.validationObj.getErrorStruct()>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="showError">	
		<cfargument name="fieldname" required="true">
		<cfif variables.validationObj.fieldHasError(fieldname)>
			<cfreturn 'class="error"'>
		</cfif>
		<cfreturn "">
	</cffunction>
	
	<cffunction name="startForm" output="false">
		<cfset var anchortext = "">
		<cfparam name="arguments.addtlinfo.method" default="post">
		<cfif NOT arguments.addtlinfo.showanchor>
			<cfset anchortext = "">
		</cfif>
		<cfset add('<form action="#anchortext#" name="#arguments.formName#" id="#arguments.formname#" method="#arguments.addtlinfo.method#">')>
	</cffunction>
	
	<cffunction name="endForm" output="false">
		<cfset add('</form>')>
	</cffunction>
	
	<cffunction name="addAnchor" output="false">
		<cfset add('<a id="#variables.formName#_anchor"></a>')>
	</cffunction>
	
	<cffunction name="add"  output="false">
		<cfargument name="str" required="true">
		<cfset arrayappend(variables.html, str)>
	</cffunction>
	
	<cffunction name="addFormItem"   output="false">
		<cfargument name="name" required="true">
		<cfargument name="label" required="true">
		<cfargument name="type" required="true">
		<cfargument name="preselect" default="">
		<cfargument name="addtlinfo" default="#structnew()#">
		<cfargument name="style" default="">
		
		<cfset arguments.value = arguments.preselect>
		
		<cfif variables.requestObj.isFormUrlVarSet(arguments.name)>
			<cfset arguments.value = variables.requestObj.getFormUrlVar(arguments.name)>
		</cfif>
		
		<cfset arguments.style = 'style="#arguments.style#"'>
		
		<cfswitch expression="#arguments.type#">
			<cfcase value="hidden">
				<cfset addHiddenField(argumentcollection = arguments)>
			</cfcase>
			<cfcase value="text,password">
				<cfset addTextField(argumentcollection = arguments)>
			</cfcase>
			<cfcase value="select">
				<cfset addSelectField(argumentcollection = arguments)>
			</cfcase>
			<cfcase value="date">
				<cfset addDateField(argumentcollection = arguments)>
			</cfcase>
			<cfcase value="checkbox,radio">
				<cfset addCheckBoxRadioField(argumentcollection = arguments)>
			</cfcase>
			<cfcase value="textarea">
				<cfset addTextAreaField(argumentcollection = arguments)>
			</cfcase>
			<cfcase value="info">
				<cfset addInfoField(argumentcollection = arguments)>
			</cfcase>
			<cfcase value="html">
				<cfset addHTMLField(argumentcollection = arguments)>
			</cfcase>
		</cfswitch>
	</cffunction>
	
	<cffunction name="addHTMLField"  output="false">
		<cfif structkeyexists(arguments.addtlinfo, 'html')>			
			<cfset add('#arguments.addtlinfo.html#')>
		</cfif>
	</cffunction>
	
	<cffunction name="addInfoField"  output="false">
		<cfset add('<p #arguments.style#>#arguments.label#<br/></p>')>
	</cffunction>
	
	<cffunction name="addTextField"  output="false">
		
		<cfif structkeyexists(arguments.addtlinfo, 'editable') and (arguments.addtlinfo.editable eq false)>
			<cfset localinfo.editable = 'readonly="true"'>
		<cfelse>
			<cfset localinfo.editable = "">
		</cfif>
		
		<cfset add('<p><label #showError(arguments.name)# for="#arguments.name#">#arguments.label#</label><input type="#arguments.type#" name="#arguments.name#" id="#arguments.name#" value="#arguments.value#" #arguments.style# #localinfo.editable#></p>')>
	</cffunction>
	
	<cffunction name="addHiddenField"  output="false">
		<cfset add('<input type="hidden" name="#arguments.name#" id="#arguments.name#" value="#arguments.value#">')>
	</cffunction>
	
	<cffunction name="addSubmit"  output="false">
		<cfargument name="name" required="true">
		<cfargument name="label" required="true">
		<cfargument name="value" required="true">
		<cfargument name="style" default="">
		<cfset add('<p><label for="#arguments.name#">#arguments.label#&nbsp;</label><input type="submit" name="#arguments.name#" id="#arguments.name#" value="#arguments.value#" #arguments.style#></p>')>
	</cffunction>
	
	<cffunction name="showErrors" output="false">
		<cfif NOT variables.validationObj.passValidation()>
			<cfset add(variables.validationObj.getFormattedErrors())>
		</cfif>
	</cffunction>
	
	<cffunction name="addTextAreaField"  output="false">
		<cfset add('<p><label #showError(arguments.name)# for="#arguments.name#">#arguments.label#</label><textarea name="#arguments.name#" id="#arguments.name#" #arguments.style#>#arguments.value#</textarea></p>')>
	</cffunction>
	
	<cffunction name="addDateField"  output="false">
		<cfset add('<p><label #showError(arguments.name)# for="#arguments.name#">#arguments.label#</label><input type="text" name="#arguments.name#" id="#arguments.name#" #arguments.style# value="#arguments.value#"></p>')><!---(mm/dd/yyyy)--->
	</cffunction>
	
	<cffunction name="addSelectField"  output="false">
		<cfset var idfield = "">
		<cfset var valuefield = "">
		<cfset var selected = "">
		<cfset var localinfo = structnew()>

		<cfif NOT structkeyexists(arguments.addtlinfo, 'query') AND NOT structkeyexists(arguments.addtlinfo, 'list') >
			<cfthrow message="formBuilder : Either a query or list must be passed to the select box">
		</cfif>
		
		<cfif structkeyexists(arguments.addtlinfo, 'multiple')>
			<cfset localinfo.multiple = 'multiple="multiple" size=#arguments.addtlinfo.multiple#'>
		<cfelse>
			<cfset localinfo.multiple = "">
		</cfif>
		
		<cfset add('<p><label #showError(arguments.name)# for="#arguments.name#">#arguments.label#</label><select #localinfo.multiple# name="#arguments.name#" id="#arguments.name#" #arguments.style#>')>
		
		<cfif structkeyexists(arguments.addtlinfo, 'blankItem')>
			<cfset add('<option value="">#arguments.addtlinfo.blankItem#</option>')>
		</cfif>
		
		<cfif structkeyexists(arguments.addtlinfo, 'query')>
			<cfparam name="arguments.addtlinfo.valueskey" default="id">
			<cfparam name="arguments.addtlinfo.labelskey" default="label">
			
			<cfloop query="arguments.addtlinfo.query">	
				<cfif arguments.addtlinfo.query[arguments.addtlinfo.valueskey][arguments.addtlinfo.query.currentrow] EQ arguments.value>
					<cfset selected = "selected">
				<cfelse>
					<cfset selected = "">
				</cfif>
				<cfset add('<option #selected# value="#arguments.addtlinfo.query[arguments.addtlinfo.valueskey][arguments.addtlinfo.query.currentrow]#">#arguments.addtlinfo.query[arguments.addtlinfo.labelskey][arguments.addtlinfo.query.currentrow]#</option>')>
			</cfloop>			
		</cfif>
		
		<cfif structkeyexists(arguments.addtlinfo, 'list')>			
			<cfloop list="#arguments.addtlinfo.list#" index="localinfo.itm">
				<cfif structkeyexists(arguments.addtlinfo,'delimiter')>
					<cfset localinfo.value = getToken(localinfo.itm, 1, arguments.addtlinfo.delimiter)>
					<cfset localinfo.label = getToken(localinfo.itm, 2, arguments.addtlinfo.delimiter)>
				<cfelse>
					<cfset localinfo.value = localinfo.itm>
					<cfset localinfo.label = localinfo.itm>
				</cfif>
				<cfif localinfo.value EQ arguments.value>
					<cfset selected = "selected">
				<cfelse>
					<cfset selected = "">
				</cfif>
				<cfset add('<option #selected# value="#localinfo.value#">#localinfo.label#</option>')>
			</cfloop>			
		</cfif>
		
		<cfset add('</select></p>')>
	</cffunction>
	
	<cffunction name="addCheckBoxRadioField"  output="false">
		<cfset var idfield = "">
		<cfset var valuefield = "">
		<cfset var selected = "">
		<cfset var localinfo = structnew()>
		
		<cfif NOT structkeyexists(arguments.addtlinfo, 'query') AND NOT structkeyexists(arguments.addtlinfo, 'list') >
			<cfthrow message="formBuilder : Either a query or list must be passed to check boxes and radio boxes">
		</cfif>
			
		<cfset add('<p><label #showError(arguments.name)# for="#arguments.name#">#arguments.label#</label>')>
	
		<cfif structkeyexists(arguments.addtlinfo, 'query')>
			<cfparam name="arguments.addtlinfo.valueskey" default="value">
			<cfparam name="arguments.addtlinfo.labelskey" default="label">
			
			<cfloop query="arguments.addtlinfo.query">	
				<cfif arguments.addtlinfo.query[arguments.addtlinfo.valueskey][arguments.addtlinfo.query.currentrow] EQ arguments.value>
					<cfset selected = "checked">
				<cfelse>
					<cfset selected = "">
				</cfif>
				<cfset add('<input type="#arguments.type#" name="#arguments.name#" id="#arguments.name##arguments.addtlinfo.query.currentrow#" #selected# value="#arguments.addtlinfo.query[arguments.addtlinfo.valueskey][arguments.addtlinfo.query.currentrow]#">#arguments.addtlinfo.query[arguments.addtlinfo.labelskey][arguments.addtlinfo.query.currentrow]#')>
			</cfloop>			
		</cfif>
		
		<cfif structkeyexists(arguments.addtlinfo, 'list')>			
			<cfset localinfo.count = 0>
			<cfloop list="#arguments.addtlinfo.list#" index="localinfo.itm">
				<cfset localinfo.count = localinfo.count + 1>
				<cfif structkeyexists(arguments.addtlinfo,'delimiter')>
					<cfset localinfo.value = getToken(localinfo.itm, 1, arguments.addtlinfo.delimiter)>
					<cfset localinfo.label = getToken(localinfo.itm, 2, arguments.addtlinfo.delimiter)>
				<cfelse>
					<cfset localinfo.value = localinfo.itm>
					<cfset localinfo.label = localinfo.itm>
				</cfif>
				<cfif localinfo.value EQ arguments.value>
					<cfset selected = "checked">
				<cfelse>
					<cfset selected = "">
				</cfif>
				<cfset add('<input type="#arguments.type#" name="#arguments.name#" id="#arguments.name##localinfo.count#" #selected# value="#localinfo.value#">#localinfo.label#')>
			</cfloop>			
		</cfif>
		
		<cfset add('</p>')>
	</cffunction>
	
	<cffunction name="showHTML"  output="false">
		<cfset endForm()>
		<cfreturn arraytolist(variables.html, "#chr(13)##chr(10)#")>
	</cffunction>

	<cffunction name="dump">
		<cfdump var=#variables.html#><cfabort>
	</cffunction>
</cfcomponent>