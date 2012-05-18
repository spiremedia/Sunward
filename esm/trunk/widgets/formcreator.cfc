<cfcomponent name="formcreator" output="false">
	<cffunction name="init" output="false">
		<cfset variables.html = arraynew(1)>
		<cfset variables.uniques = structnew()>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="add" output="false">
		<cfargument name="item" required="true">
		<cfset arrayappend(variables.html, item)>
	</cffunction>
	
	<cffunction name="setInfo">
		<!--- This is required by template runner --->
	</cffunction>	
	
	<cffunction name="addUnique">
		<cfargument name="m">
		<cfargument name="cntent">
		
		<cfset variables.uniques[m] = cntent>
	</cffunction>
	
	<cffunction name="addformitem" output="false">
		<cfargument name="name" required="true">
		<cfargument name="label" required="true">
		<cfargument name="required" required="true">
		<cfargument name="type" required="true">
		<cfargument name="value">
		<cfargument name="addtlinfo" default="#structnew()#">
		
		<cfset var lcl = structnew()>
		
		<cfif arguments.type EQ 'hidden'>
			<cfset add("<input type='hidden' name='#arguments.name#' id='#arguments.name#' value=""#htmleditformat(value)#"">")>
			<cfreturn>
		</cfif>
		
		<cfif structkeyexists(arguments.addtlinfo,'style')>
			<cfset arguments.addtlinfo.style = " style='#addtlinfo.style#' ">
		<cfelse>
			<cfset arguments.addtlinfo.style = "">
		</cfif>
			
		<cfset add("<tr>")>
		
		<cfset add("<td>")>
		
		<cfset add("<img class=""errorimages"" id=""valimg_#arguments.name#"" src='/ui/css/images/pending.gif'>")>
		
		<cfif arguments.required>
			<cfset add("<img src='/ui/css/images/label.required-bkgd.gif'>")>
		</cfif>
		<cfset add("</td>")>
		
		<cfset add("<td class='label'>")>
		
		
		<cfset add("<label for='#arguments.name#'>")>
		<cfset add(arguments.label)>
		<cfset add("</label>")>
		
		<cfset add("</td>")>
		
		<cfset add("<td>")>
	
		<cfswitch expression="#arguments.type#">
			<cfcase value="text,password">
				<cfif structkeyexists(arguments.addtlinfo,'size')>
					<cfset arguments.addtlinfo.size = " size='#addtlinfo.size#' ">
				<cfelse>
					<cfset arguments.addtlinfo.size = "">
				</cfif>
				
				<cfif structkeyexists(arguments.addtlinfo,'maxlength')>
					<cfset arguments.addtlinfo.maxlength = " maxlength='#addtlinfo.maxlength#' ">
				<cfelse>
					<cfset arguments.addtlinfo.maxlength = "">
				</cfif>
				
				<cfif NOT structkeyexists(arguments,'value')>
					<cfset arguments.value = "">
				</cfif>
				
				<cfif arguments.type EQ "password" OR (isdefined("arguments.addtlinfo.preventcache") AND arguments.addtlinfo.preventcache)>
					<cfset arguments.addtlinfo.preventcache = ' AUTOCOMPLETE="OFF"'>
				<cfelse>
					<cfset arguments.addtlinfo.preventcache = ''>
				</cfif>
				
				<cfset add("<input type='#arguments.type#' name='#arguments.name#' id='#arguments.name#' value=""#htmleditformat(value)#"" #arguments.addtlinfo.style# #arguments.addtlinfo.maxlength# #arguments.addtlinfo.size# #arguments.addtlinfo.preventcache#>")>
			</cfcase>

			<cfcase value="textarea">			
				<cfif NOT structkeyexists(arguments,'value')>
					<cfset arguments.value = "">
				</cfif>
				<cfparam name="arguments.addtlinfo.style" default="">
				
				<cfset add("<textarea name='#arguments.name#' id='#arguments.name#' #arguments.addtlinfo.style#>#htmleditformat(value)#</textarea>")>
			</cfcase>
			
			<cfcase value="date">			
				<cfif NOT structkeyexists(arguments,'value')>
					<cfset arguments.value = "">
				</cfif>
				
				<cfset add("<input type='text' id='#arguments.name#' name='#arguments.name#' #IIF(find('MSIE 6', cgi.HTTP_USER_AGENT), DE(''), DE("datepicker='true'"))# datepicker_format='MM/DD/YYYY'  maxlength='10' size='15' value='#dateformat(value,"mm/dd/yyyy")#'>(mm/dd/yyyy)")>		
			</cfcase>
			
			<cfcase value="autocomplete">	
				
				<cfif structkeyexists(arguments.addtlinfo,'maxlength')>
					<cfset arguments.addtlinfo.maxlength = " maxlength='#addtlinfo.maxlength#' ">
				<cfelse>
					<cfset arguments.addtlinfo.maxlength = "">
				</cfif>
				
				<cfif NOT structkeyexists(arguments,'value')>
					<cfset arguments.value = "">
				</cfif>
				
				<cfif NOT structkeyexists(arguments.addtlinfo,'list')>
					<cfthrow message="for field '#arguments.name#' no list was specified. The list might be useful to do autocompletion">
				</cfif>
				
				<cfif left(arguments.addtlinfo.list,1) NEQ "'">
					<cfset arguments.addtlinfo.list = "'" & replace(arguments.addtlinfo.list,",","','","all") & "'">
				</cfif>

				<cfset add("<input type='text' name='#arguments.name#' id='#arguments.name#' value=""#htmleditformat(value)#"" #arguments.addtlinfo.style# #arguments.addtlinfo.maxlength#> (auto complete)")>
				<cfset add('<div id="#arguments.name#_autocomplete" class="autocomplete"></div>')>
				<cfset add('<script type="text/javascript">//<![CDATA[')>
				<cfset add("var #arguments.name#_auto_completer = new Autocompleter.lcl('#arguments.name#', '#arguments.name#_autocomplete', [#arguments.addtlinfo.list#], {})")>
				<cfset add('//]]></script>')>
			</cfcase>		
			
			<cfcase value="file">					
				<cfset add("<input type='file' name='#arguments.name#' id='#arguments.name#'/>")>
			</cfcase>
			
			<cfcase value="tiny-mce">			
				<cfif NOT structkeyexists(arguments,'value')>
					<cfset arguments.value = "">
				</cfif>
				<cfset lcl.tinymce = createObject('component','widgets.tinymce').init(
						name = arguments.name,
						id = arguments.name,
						style = '',
						value = value,
						addtlinfo = arguments.addtlinfo,
						formref = this )>
						
				<cfset add(lcl.tinymce.show())>
			</cfcase>
					
			<cfcase value="checkbox,radio">			

				<cfif NOT structkeyexists(arguments,'value')>
					<cfset arguments.value = "">
				</cfif>
				
				<!--- if options come over as a query --->
				<cfif isquery( arguments.addtlinfo.options)>
					<cfif NOT structkeyexists(arguments.addtlinfo,'valueskey')>
						<cfset arguments.addtlinfo.valueskey = "value">
					</cfif>
					
					<cfif NOT structkeyexists(arguments.addtlinfo,'labelskey')>
						<cfset arguments.addtlinfo.labelskey = "label">
					</cfif>
					
					<cfif not isquery(arguments.addtlinfo.options)>
						<cfthrow message="form item '#name#' requires a query for the 'options' key in addtionalitems to populate the form.">
					</cfif>
				
					<cfset lcl.optionsq = arguments.addtlinfo.options>
					
				<cfelseif issimplevalue(arguments.addtlinfo.options)>
					<!--- if options come over as a string --->
					<cfset arguments.addtlinfo.labelskey = "label">
					<cfset arguments.addtlinfo.valueskey = "value">
					<cfset lcl.optionsq = querynew('value,label')>
					<cfloop list="#arguments.addtlinfo.options#" index="lcl.opt">
						<cfset queryaddrow(lcl.optionsq)>
						<cfset querysetcell(lcl.optionsq, 'value', lcl.opt)>
						<cfset querysetcell(lcl.optionsq, 'label', replace(lcl.opt,"_"," ","all"))>
					</cfloop>
				</cfif>
				
				<cfloop query="lcl.optionsq">
					<cfif listfind(rereplace(arguments.value,"[^a-zA-Z0-9,]","_","all"), lcl.optionsq[arguments.addtlinfo.valueskey][lcl.optionsq.currentrow])>
						<cfset lcl.checked = 'checked '>
					<cfelse>
						<cfset lcl.checked = ''>
					</cfif>
					<cfset add("<input type='#arguments.type#' id='#arguments.name#_#lcl.optionsq.currentrow#' #lcl.checked# name='#arguments.name#' value=""#htmleditformat(lcl.optionsq[arguments.addtlinfo.valueskey][lcl.optionsq.currentrow])#"">#lcl.optionsq[arguments.addtlinfo.labelskey][lcl.optionsq.currentrow]# ")>
				</cfloop>
	
			</cfcase>
			
			<cfcase value="select">		

				<cfif structkeyexists(arguments.addtlinfo,'multiple')>
					<cfif structkeyexists(arguments.addtlinfo,'size')>
						<cfset arguments.addtlinfo.size = " size=#arguments.addtlinfo.size# ">
					<cfelse>
						<cfset arguments.addtlinfo.size = "">
					</cfif>
					<cfset arguments.addtlinfo.multiple = "multiple #arguments.addtlinfo.size#">
				<cfelse>
					<cfset arguments.addtlinfo.multiple = "">
				</cfif>
				
				<cfif NOT structkeyexists(arguments,'value')>
					<cfset arguments.value = "">
				</cfif>
				
				<!--- if options come over as a query --->
		
				<cfif isquery( arguments.addtlinfo.options)>
					<cfif NOT structkeyexists(arguments.addtlinfo,'valueskey')>
						<cfset arguments.addtlinfo.valueskey = "value">
					</cfif>
					
					<cfif NOT structkeyexists(arguments.addtlinfo,'labelskey')>
						<cfset arguments.addtlinfo.labelskey = "label">
					</cfif>
					
					<cfif not isquery(arguments.addtlinfo.options)>
						<cfthrow message="form item '#name#' requires a query for the 'options' key in addtionalitems to populate the form.">
					</cfif>
				
					<cfset lcl.optionsq = arguments.addtlinfo.options>
					
				<cfelseif issimplevalue(arguments.addtlinfo.options)>
					<!--- if options come over as a string --->
					<cfset arguments.addtlinfo.labelskey = "label">
					<cfset arguments.addtlinfo.valueskey = "value">
					<cfset lcl.optionsq = querynew('value,label')>
					<cfloop list="#arguments.addtlinfo.options#" index="lcl.opt">
						<cfset queryaddrow(lcl.optionsq)>
						<cfset querysetcell(lcl.optionsq, 'value', lcl.opt)>
						<cfset querysetcell(lcl.optionsq, 'label', replace(lcl.opt,"_"," ","all"))>
					</cfloop>
				</cfif>
								
				<cfset add('<select id="#arguments.name#" name="#arguments.name#" #arguments.addtlinfo.multiple#>')>
				
				<cfif isdefined("arguments.addtlinfo.addblank") AND arguments.addtlinfo.addblank>
					<cfparam name="arguments.addtlinfo.blanktext" default="">
					<cfset add("<option value=''>#arguments.addtlinfo.blanktext#</option>")>
				</cfif>
				
				<cfloop query="lcl.optionsq">
					<cfif listfindnocase(arguments.value, lcl.optionsq[arguments.addtlinfo.valueskey][lcl.optionsq.currentrow])>
						<cfset lcl.selected = 'selected '>
					<cfelse>
						<cfset lcl.selected = ''>
					</cfif>
					<cfset add("<option #lcl.selected# value=""#htmleditformat(lcl.optionsq[arguments.addtlinfo.valueskey][lcl.optionsq.currentrow])#"">#lcl.optionsq[arguments.addtlinfo.labelskey][lcl.optionsq.currentrow]#</option>")>
				</cfloop>
				
				<cfset add('</select>')>
				
			</cfcase>
			
			<cfcase value="autocompleter">
				<cfset autocompleter(argumentcollection = arguments)>
			</cfcase>
			
			<cfcase value="listmanager">
				<cfif NOT structkeyexists(arguments,'value')>
					<cfset arguments.value = "">
				</cfif>
				
				<cfif not isquery(arguments.addtlinfo.options)>
					<cfthrow message="form item '#name#' requires a query for the 'options' key in addtionalitems to populate the listmanager.">
				</cfif>
				
				<cfif NOT structkeyexists(arguments.addtlinfo,'valueskey')>
					<cfset arguments.addtlinfo.valueskey = "value">
				</cfif>
				
				<cfif NOT structkeyexists(arguments.addtlinfo,'labelskey')>
					<cfset arguments.addtlinfo.labelskey = "label">
				</cfif>
				
				<cfset lcl.q = querynew('label,value')>
				<cfloop query="arguments.addtlinfo.options">
					<cfset queryaddrow(lcl.q)>
					<cfset querysetcell(lcl.q, 'value', arguments.addtlinfo.options[arguments.addtlinfo.valueskey][arguments.addtlinfo.options.currentrow])>
					<cfset querysetcell(lcl.q, 'label', arguments.addtlinfo.options[arguments.addtlinfo.labelskey][arguments.addtlinfo.options.currentrow])>
				</cfloop>
												
				<cfset lcl.listmanager = createObject('component','widgets.listmanagerform').init(
						name = arguments.name,
						id = arguments.name,
						style = '',
						selected = value,
						options = lcl.q,
						addtlinfo = arguments.addtlinfo,
						formref = this )>
						
				<cfset add(lcl.listmanager.show())>
			</cfcase>
		
		</cfswitch>
		
		<cfset add("</td>")>
		
		<cfif structkeyexists(arguments.addtlinfo, 'posthtml')>
			<cfset add("<td>")>
			<cfset add(arguments.addtlinfo.posthtml)>
			<cfset add("</td>")>
		</cfif>
		
		<cfset add("</tr>")>
		
	</cffunction>
	
	<cffunction name="addcustomformitem" output="false">
		<cfargument name="html">
		<cfset add("<tr>")>
		<cfset add("<td align='center' colspan='3'>#html#</td>")>
		<cfset add("</tr>")>
	</cffunction>
	
	<cffunction name="startform" output="false">
		<cfset add("<table class='formtable'>")>
	</cffunction>
	
	<cffunction name="endform" output="false">
		<cfset var itm = "">
		<cfset add("</table>")>
		<cfloop collection="#variables.uniques#" item="itm">
			<cfset add(variables.uniques[itm])>
		</cfloop>
	</cffunction>
	
	<cffunction name="showhtml" output="false">
		<cfreturn arraytolist(variables.html,"#chr(13)##chr(10)#")>
	</cffunction>
	
	<!---
	<cffunction name="autocompleter" output="false">

		<cfset add("<input type='hidden' name='#arguments.name#' id='#arguments.name#' >")>
		<cfset add("<input type='text' name='#arguments.name#_autocomplete' id='#arguments.name#_autocomplete' >")>
		<cfset add("<input type='button' name='#arguments.name#_autocomplete_button' id='#arguments.name#_autocomplete_button' value=""Add"">")>
		
		
		
		<cfset add("</td></tr><tr><td colspan='3'>")>
	</cffunction>
	--->>
</cfcomponent>