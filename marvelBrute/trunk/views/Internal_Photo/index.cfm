<cfoutput>

	<cfcontent reset="true">

	<cfinclude template="../headtag.cfm"/>

	<cfinclude template="../header.cfm">

	<table class="ht" cellspacing="0" cellpadding="0">
		<tr>
			<td class="hlf">&nbsp;</td>
			<td class="hc" nowrap="nowrap">
	<div class="searchForm">
		<form action="/Search/" method="get" >
			<input name="search" type="text"  size="19" class="text" />
			<input type="submit" name="button" value="Search" class="searchButton" />
		</form>
	</div>
				<div class="navDiv">#showContentObject('dhtmlNav', 'navigation', 'dhtmlNav')#</div>
			</td>
			<td class="hrf">&nbsp;</td>
		</tr>
	</table>
	

	<div id="interiorContainer">
		<div id="textpageContainer">
		
			<!--- breadcrumb navigation --->
			<div id="textPageCrumbs">
				#showContentObject('breadcrumbs', 'breadcrumbs')#
			</div>

			<!--- Page Header Title --->
			<div id="textPageInteriorTitle">
				#variables.pageinfo.title#
			</div>

			<!--- Text Page Body Content --->
			<div id="textPageBodyContent">

				<!--- Left Navigation Area --->
				<div id="interiorLeftBar">
					<div id="interiorLeftBarNav">
						#showContentObject('subNav', 'Navigation', 'subNav')#
					</div>
				</div>

				<!--- Text Bottom Bar --->
				<div class="txtBottomBar1" style="margin-top:15px;">
				
					<!--- Top Right Image Text --->
					<div class="splitrightImagePage" style="width:250px;">
						<cfif contentObjectNotEmpty('topRightImageText')>
							<div class="imageText">#showContentObject('topRightImageText', 'htmlContent', 'editable')#</div>
						</cfif>
					</div>
					
					<!--- Split Left --->
					<div class="splitleft">
						<cfif contentObjectNotEmpty('TopLeftImageText')>
							<div class="imageText" style="background:white">
								#showContentObject('TopLeftImageText', 'htmlContent', 'editable')#
							</div>
						</cfif>
					</div>
				</div>
	
				<div class="txtTopBar" style="margin-top:5px;">
				
					<!--- Main Image Text --->
					<cfif contentObjectNotEmpty('MainImageText')>
						<div class="imageText">
							#showContentObject('MainImageText', 'htmlContent,Galleries', 'editable')#
						</div>
					</cfif>
					
					<!--- Page Title Verbage --->
					<cfif contentObjectNotEmpty('pageTitleVerbage')>
						<div class="headLine">
							#showContentObject('pageTitleVerbage', 'htmlContent,Galleries', 'editable')#
						</div>
					</cfif>
				</div>
				
				<div class="txtBottomBar1TextOnly">
					
					<!--- Main Content Right --->
					<div class="rightCol50">
						<cfif contentObjectNotEmpty('mainContentRight')>
							#showContentObject('mainContentRight', 'htmlContent', 'editable')#
						</cfif>
					</div>
					
					<!--- main Content Left --->
					<div class="leftCol50">
						<cfif contentObjectNotEmpty('mainContentLeft')>
							#showContentObject('mainContentLeft', 'htmlContent', 'editable')#
						</cfif>
					</div>
				</div>
				
				<!--- Clear Floats --->
				<div class="clear">&nbsp;</div>
				
			</div>
		</div>

	<cfinclude template="../footer.cfm">

</cfoutput>