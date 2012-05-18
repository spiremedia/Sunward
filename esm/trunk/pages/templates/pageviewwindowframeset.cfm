<cfset lcl.page=getDataItem('page')>	

<cfset lcl.info = lcl.page.getPageInfo()>

<cfoutput>
	<cfif LEN(lcl.info.relocate)>
		This page is set as a relocator in the properites. It has no content. If you wish this to be a real page, please set the relocator field in properties to be "No Relocation."
	<cfelse>
    	<script>
			function closeme(){  
				opener.parent.reloadiframe('same','same');
				top.close();
			}
			
		</script>
        <frameset id="myframe" rows="40,*" border="0" >
            <frame name="control" src="/pages/pageviewframetop/?id=#requestObj.getFormUrlVar('id')#&preview=#requestObj.getFormUrlVar('preview')#&showmembertype=#requestObj.getFormUrlVar('showmembertype')#" SCROLLING = "NO">

            <frame id="siteviewid" name="siteview" src="#variables.securityObj.getCurrentSiteUrl()##lcl.page.getPath()#?preview=#requestObj.getFormUrlVar('preview')#&showmembertype=#requestObj.getFormUrlVar('showmembertype')#">
        </frameset>
	</cfif>
</cfoutput>