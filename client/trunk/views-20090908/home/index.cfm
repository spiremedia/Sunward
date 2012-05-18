<cfinclude template="../includes/header.cfm">

<cfoutput>

<!--- DO 1 to underNav as htmlContent,asset --->
<!--- DO 2 to notExistant as htmlContent,asset --->
<!--- DO 3 to pictureText1 as htmlContent,asset --->
<!--- DO 4 to pictureText2 as htmlContent,asset --->
<!--- DO 5 to pictureText3 as htmlContent,asset --->
<!--- DO 6 to bluepanel1 as htmlContent,asset --->
<!--- DO 7 to bluepanel2 as htmlContent,asset --->
<!--- DO 8 to bluepanel3 as htmlContent,asset --->

<div id="wrapper">

	<cfif requestObject.getUserObject().isloggedin()>
	    <b class="loginout"><a href="/Users/Logout/">Logout</a></b>
	<cfelse>
	    <b class="loginout"><a href="/Users/Login/">Dealer Login</a></b>
	</cfif>

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