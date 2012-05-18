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
	

	<table class="ut" cellspacing="0" cellpadding="0" border="0">
		<tr>
			<td class="uclf" rowspan="2">&nbsp;</td>
			<td class="uc">
				<div>
					<div class="homeDeals">
						#showContentObject('UK_specials', 'HTMLContent', 'editable')#
					</div>
					<div class="homeFlash">
						#showContentObject('UK_flashPiece', 'HTMLContent', 'editable')#
					</div>
				 </div>
			</td>
			<td class="ucrf" rowspan="2">&nbsp;</td>
		</tr>
		<tr>
			<td class="uc">
				<div id="lc">
					<div>
						<div>
							<div class="pictureImage">#showContentObject('UK_pictureImage1', 'HTMLContent', 'editable')#</div>
							<div class="pictureText">#showContentObject('UK_pictureText1', 'HTMLContent', 'editable')#</div>
						</div>
						<div>
							<div class="pictureImage">#showContentObject('UK_pictureImage2', 'HTMLContent', 'editable')#</div>
							<div class="pictureText">#showContentObject('UK_pictureText2', 'HTMLContent', 'editable')#</div>
						</div>
						<div>
							<div class="pictureImage">#showContentObject('UK_pictureImage3', 'HTMLContent', 'editable')#</div>
							<div class="pictureText">#showContentObject('UK_pictureText3', 'HTMLContent', 'editable')#</div>
						</div>
					</div>
				</div>
			</td>
		</tr>
	</table>

	<div class="clear">

	<table width="100%" cellpadding="0" cellspacing="0">
        <tr>
            <td class="fillerBlack">&nbsp;</td>
            <td id="missionStatement">&nbsp;</td>
            <td class="fillerTheme">&nbsp;</td>
        </tr>
    </table>
	
	<div class="clear">
		
	<cfinclude template="../footer.cfm">
	
</cfoutput>