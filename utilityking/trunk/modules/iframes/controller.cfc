<cfcomponent name="iframes" extends="resources.abstractController">
	
	<cffunction name="init">
		<cfargument name="data">
		<cfargument name="requestObject">
		<cfargument name="parameterlist" default="">
		
		<cfset variables.requestObject = arguments.requestObject>
		<cfset variables.parameterlist = arguments.parameterlist>
		
		<cfif isstruct(data)>
			<cfset variables.data = arguments.data>
		<cfelse>
			<cfset variables.data = structnew()>
			<cfset variables.data.src = arguments.data>
		</cfif>
		
		<cfparam name="variables.data.src" default="">
		<cfreturn this>
	</cffunction>
	
	<cffunction name="showHTML">
    	<cfset var me = "">
        <cfset var userObj = variables.requestObject.getUserObject()>
		<cfset var isgwebsite = trim(variables.requestObject.getVar("isgwebsite"))>
		<cfset var src = ''>
		<cfset var iframeheight = '100%'>
		<cfset var token = urlencodedformat(userObj.getImisToken())>
		<cfset var returnPage = urlencodedformat(variables.requestObject.getVar('siteurl') & variables.requestObject.getformurlvar('path'))>
		
		<cfif variables.requestObject.isFormUrlVarSet('ContinueURL')>
			<cfset src = variables.requestObject.getFormUrlVar('ContinueURL')>
		<cfelse>
			<cfset src = trim(variables.data.src)>
		</cfif>	
		
		
		<cfif structkeyexists(variables.parameterlist,'iframeheight')>
			<cfset iframeheight = variables.parameterlist.iframeheight> 
		</cfif>
		
		<!--- attach token to url in preview edit mode occasionally causes page to reload 
		<cfif NOT (variables.requestObject.isFormUrlVarSet('preview') AND variables.requestObject.getFormUrlVar('preview') EQ 'edit')>
		</cfif> --->
		<!--- attach token to url --->
		<cfset src = src & iif(find('?',src),DE("&"),DE("?")) & 'Token=' & token>
		<cfset src = src & '&ReturnPage=' & returnPage>
	
		<cfif trim(variables.data.src) neq "">		
			<cfsavecontent variable="me">
			
			<cfoutput>
				<iframe src="#src#"
						isgwebsite="#isgwebsite#" 
						name="ISGwebContainer"
						id="ISGwebContainer"
						scrolling="auto"
						marginwidth="0" 
						marginheight="0"
						frameborder="0" 
						vspace="0"
						hspace="0" 
						width="98%"
						height="#iframeheight#"
						style="overflow:auto;">
							Please use a browser that supports iframes.
					</iframe>
				#userObj.renderTokenControl(requestObject = requestObject)#
        	</cfoutput>
        </cfsavecontent>
		</cfif>
	
		<cfreturn me>
	</cffunction>

	<cffunction name="getCacheLength">
		<cfreturn 0>
	</cffunction>
	
</cfcomponent>