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
				
				<!--- Top Photo and caption --->
				<div class="txtTopBar">
					<cfif contentObjectNotEmpty('mainImageAndText')>
						<div class="imageText">#showContentObject('mainImageAndText', 'htmlContent', 'editable')#</div>
					</cfif>
				</div>
				
				<!--- should create length of page...  but isn't --->
				<div class="txtBottomBar1">
					<div class="splitright">
						
						<!--- Top Side Image and Verbage One and/or Two --->
						<cfif contentObjectNotEmpty('topSideImageAndVerbage1') or contentObjectNotEmpty('topSideImageAndVerbage2')>
							<div class="imageText">
								#showContentObject('topSideImageAndVerbage1', 'htmlContent', 'editable')#
							</div>
							<div>
								#showContentObject('topSideImageAndVerbage2', 'htmlContent', 'editable')#
							</div>
						</cfif>
						
						<!--- Side Content --->
						<cfif contentObjectNotEmpty('sideContent')>
							<hr />
							<div>
								#showContentObject('sideContent', 'htmlContent', 'editable')#
							</div>
						</cfif>
						
						<!--- Related Links --->
						<cfif contentObjectNotEmpty('relatedLinks')>
							<hr />
							<div>
								#showContentObject('relatedLinks', 'htmlContent', 'editable')#
							</div>
						</cfif>
					</div>
					
					<div class="splitleft">
						<!--- Headline and Sub-Head --->
						<cfif contentObjectNotEmpty('headlineAndSubHead')>
							<div class="headLine">
								#showContentObject('headlineAndSubHead', 'htmlContent', 'editable')#
							</div>
						</cfif>
						
						<!--- Body Copy One --->
						<cfif contentObjectNotEmpty('bodyCopy1')>
							<div>
								#showContentObject('bodyCopy1', 'htmlContent,Search', 'editable')#
							</div>
						</cfif>
						
						<!--- Body Copy Two --->
						<cfif contentObjectNotEmpty('bodyCopy2')>
							<div>
								#showContentObject('bodyCopy2', 'htmlContent,Search', 'editable')#
							</div>
						</cfif>
						
						<!--- Nested Image and Description --->
						<cfif contentObjectNotEmpty('nestedImageAndDescription')>
							<div class="rightFloater">
								<div class="imageText">
									#showContentObject('nestedImageAndDescription', 'htmlContent', 'editable')#
								</div>
							</div>
						</cfif>
		
						<!--- Body Content to the Side and Below the Nested Image --->
						<cfif contentObjectNotEmpty('bodyContentToSideAndBelowNestedImage')>
							<div>
								#showContentObject('bodyContentToSideAndBelowNestedImage', 'htmlContent', 'editable')#
							</div>
						</cfif>
					</div>	
				</div>
				
				<!--- Clear All Floats --->
				<div class="clear">&nbsp;</div>
			</div>
		</div>
	</div>

</cfoutput>

<cfinclude template="../footer.cfm">