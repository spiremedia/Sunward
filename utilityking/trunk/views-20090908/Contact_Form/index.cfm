<cfoutput>


	<cfcontent reset="true">
	
	<cfinclude template="../headtag.cfm"/>

	<cfinclude template="../header.cfm">

<div id="wrapper">

	<table class="ht" cellspacing="0" cellpadding="0">
		<tr>
			<td class="hlf">&nbsp;</td>
			<td class="hc" nowrap="nowrap">
            	<div id="logobtn"><a href="/"><img src="/ui/img/clear.gif" height="80" width="1000"/></a></div>
				<div class="navDiv">#showContentObject('dhtmlNav', 'navigation', 'dhtmlNav')#</div>
			</td>
			<td class="hrf">&nbsp;</td>
		</tr>
	</table>
    
	<div id="container">
		<div id="textpageContainer">

        <div id="textPageCrumbs">
            <!--- breadcrumb navigation --->
            #showContentObject('breadcrumbs', 'breadcrumbs')#
        </div>
        
        <div id="textPageInteriorTitle">
			<!--- Page Header Title --->
            <cfoutput>#variables.pageinfo.title#</cfoutput>
        </div>
        
		<div id="textPageBodyContent">
				<div id="interiorLeftBar">
					<!--- Left navigation area --->
					<div id="interiorLeftBarNav">
						#showContentObject('subNav', 'Navigation', 'subNav')#
					</div>
				</div>
				<div class="txtTopBar">
					<cfif contentObjectNotEmpty('mainContent')>
                    	<div>
                            #showContentObject('mainContent', 'htmlContent', 'editable')#
                        </div>
                    </cfif>
					<div id="contactForm">
                    			#showContentObject('contactForm', 'htmlContent,forms,contactForm', 'editable')#
					</div>
				</div>
				<div class="clear">&nbsp;</div>
			</div>
		  <div class="btmBorder">&nbsp;</div>
	</div>
    <cfinclude template="../footer.cfm">
</cfoutput>