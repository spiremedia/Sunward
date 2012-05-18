<cfparam name="attributes.urlidentifyer" type="string">
<cfparam name="attributes.duration" type="integer">
<cfparam name="attributes.postProcess" default="#arraynew(1)#">
<cfparam name="attributes.requestObject">

<cfset filename = lcase(attributes.urlidentifyer)>

<cfset rootpath = GetDirectoryFromPath(GetCurrentTemplatePath())>
<cfset directory = "cache/pages/">
<cfset folderpath = rootpath & directory>
<cfset filepath = rootpath & directory & lcase(filename)>

<cfif NOT isdefined("url.preview")>
	<cfif Thistag.executionmode EQ "start">
		<cflock name="#attributes.urlidentifyer#" type="readonly" timeout="3">
			<cfif fileexists(filepath)>
                <cfdirectory name="fileinfo" directory="#folderpath#" filter="#fileName#">
                <cfif fileinfo.recordcount>
					<cfset datemade = createodbcdatetime(fileinfo.datelastmodified)>
                    <cfset datemade = dateadd("n", attributes.duration, datemade)>
    			<cfelse>
                	<cfset datemade = now()>
                </cfif>
                <cfif datecompare(datemade, now()) is 1 AND NOT structkeyexists(url, "reset")>
                    <cfinclude template="cache/pages/#filename#">
                    <cfset html = trim(html)>
                    <cfloop from="1" to="#arraylen(attributes.postProcess)#" index="i">
                    	<cfset obj = createObject('component', 'modules.#attributes.postProcess[i].folder#.controller').init(									
								structnew(), 
								attributes.requestObject, 
								attributes.postProcess[i].parameterList, 
								"")>
                        <cfset html = replacenocase(html, 
													attributes.postProcess[i].replacestring, 
													obj.showHTML())>
                    </cfloop>
                    <cfoutput><cfcontent reset="yes">#html#</cfoutput>
                    <cfexit>
                </cfif>
            </cfif>
        </cflock>
		<cfif structkeyexists(url, "reset") AND fileexists(filepath)>
			<cflock name="#attributes.urlidentifyer#" type="exclusive" timeout="3">
				<cffile action="delete" file="#filepath#">
	        </cflock>
		</cfif>
	<cfelseif caller.cachelength NEQ 0>
		<!--- NOTE
			Not cacheing files with a name longer than 255 chars
			Filenames longer than 255 cause a File Not Found Error when attempting to write them.
			Not an option to just save the first 255 chars of the name because the marketing group would be cut off the name, and users could potentially see the wrong content or the wrong pages
		 --->
		<cfif len(filename) lte 255>
			<cflock name="#filename#" type="exclusive" timeout="3">
				<cfif caller.is404>
					<cfheader statuscode="404" statustext="Not Found">
				</cfif>
				<cffile action="write" file="#filepath#" output="<cfsavecontent variable=""html"">#IIF(caller.is404,DE('<cfheader statuscode="404" statustext="Not Found">'),DE(""))##thistag.generatedcontent#</cfsavecontent>">
			</cflock>
		</cfif>
	</cfif>
</cfif>

<cfif thistag.executionmode EQ 'end'>
	<cfset thistag.generatedcontent = trim(thistag.generatedcontent)>
	<cfloop from="1" to="#arraylen(attributes.postProcess)#" index="i">
    	<cfif findnocase(attributes.postProcess[i].replacestring, thistag.generatedContent)>
		<cfset obj = createObject('component', 'modules.#attributes.postProcess[i].folder#.controller').init(									
                structnew(), 
                attributes.requestObject, 
                attributes.postProcess[i].parameterList, 
                "")>
               
        <cfset thistag.generatedcontent = replacenocase(thistag.generatedcontent, 
				attributes.postProcess[i].replacestring, 
				obj.showHTML())>
        </cfif>
    </cfloop>
</cfif>