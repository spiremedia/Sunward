<cfinclude template="../includes/header.cfm">

<cfoutput>

<div id="wrapper">


	<table class="ht" cellspacing="0" cellpadding="0">
		<tr>
			<td class="hlf">&nbsp;</td>
			<td class="hc" nowrap="nowrap">
	<div class="searchForm">
    <cfif requestObject.getUserObject().isloggedin()>
	    <b class="loginout"><a href="/Users/Logout/">Logout</a></b>
	<cfelse>
	    <b class="loginout"><a href="/Users/Login/">Dealer Login</a></b>
	</cfif><br />
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
            <td class="uclf">&nbsp;</td>
            <td class="uc">
            	<div>
                    <div class="specialDeals">
					#showContentObject('underNav', 'HTMLContent', 'editable')#
				</div>
				<div class="homeFlashPiece">
					#showContentObject('flashPiece', 'HTMLContent', 'editable')#
				</div>

                </div>
            </td>
            <td class="ucrf">&nbsp;</td>
        </tr>
    </table>

	<div id="lc">
		<div>
			<div>
				#showContentObject('pictureText3', 'HTMLContent', 'editable')#
			</div>
			<div>
				#showContentObject('pictureText2', 'HTMLContent', 'editable')#
			</div>
			<div>
				#showContentObject('pictureText1', 'HTMLContent', 'editable')#
			</div>
		</div>
	</div>
</div>

</cfoutput>

<div id="missionStatement"></div>

<cfinclude template="../includes/footer.cfm">