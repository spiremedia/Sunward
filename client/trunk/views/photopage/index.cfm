<cfinclude template="../includes/header.cfm">

<script type="text/javascript" src="/ui/js/jquery-1.2.6.pack.js"></script>

<cfoutput>

<div id="textpageWrapper">


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
                <div id="interiorLeftBarNav">
                    #showContentObject('subNav', 'Navigation', 'subNav')#
                </div>
            </div>
            <div class="txtBottomBar1" style="margin-top:15px;">
                <div class="splitrightImagePage" style="width:250px;">
                    <cfif contentObjectNotEmpty('topRightImageText')>
                        <div class="imageText">#showContentObject('topRightImageText', 'htmlContent', 'editable')#</div>
                    </cfif>
                </div>

                <div class="splitleft">
                    <cfif contentObjectNotEmpty('TopLeftImageText')>
                        <div class="imageText" style="background:white">
                            #showContentObject('TopLeftImageText', 'htmlContent', 'editable')#
                        </div>
                    </cfif>
                </div>
            </div>
            <div class="txtTopBar" style="margin-top:5px;">
                <!--- Big Photo and caption --->
                <cfif contentObjectNotEmpty('MainImageText')>
                    <div class="imageText">
                        #showContentObject('MainImageText', 'htmlContent,Galleries', 'editable')#
                    </div>
                </cfif>

                <cfif contentObjectNotEmpty('pageTitleVerbage')>
                    <div class="headLine">
                        #showContentObject('pageTitleVerbage', 'htmlContent,Galleries', 'editable')#
                    </div>
                </cfif>
            </div>
            <div class="txtBottomBar1TextOnly">
                <div class="leftCol50">
                    <cfif contentObjectNotEmpty('mainContentLeft')>
                        #showContentObject('mainContentLeft', 'htmlContent', 'editable')#
                    </cfif>
                </div>

                <div class="rightCol50">
                    <cfif contentObjectNotEmpty('mainContentRight')>
                       #showContentObject('mainContentRight', 'htmlContent', 'editable')#
                    </cfif>
                </div>
            </div>
			<div class="clear">&nbsp;</div>
		</div>
        <cfinclude template="../includes/footer.cfm">
    </div>
</body>


</html>
</cfoutput>