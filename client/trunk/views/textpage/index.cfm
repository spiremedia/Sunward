<cfinclude template="../includes/header.cfm">

<cfoutput>

<div id="textpageWrapper">

    <table class="ht" cellspacing="0" cellpadding="0" border="0">
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
            #variables.pageinfo.title#
        </div>
        <div id="textPageBodyContent">
            <div id="interiorLeftBar">
				<!--- Left Navigation Area --->
                <div id="interiorLeftBarNav">
                    #showContentObject('subNav', 'Navigation', 'subNav')#
                </div>
            </div>
            <div class="txtTopBar"  >
				<!--- Top Photo and caption --->
                <cfif contentObjectNotEmpty('mainImageAndText')>
                    <div class="imageText">#showContentObject('mainImageAndText', 'htmlContent,Galleries', 'editable')#</div>
                </cfif>
            </div>
            <div class="txtBottomBar1">
                <div class="splitright">
                    <cfif contentObjectNotEmpty('topSideImageAndVerbage1') or contentObjectNotEmpty('topSideImageAndVerbage2')>
                        <div><!---  class="imageText" --->
                            #showContentObject('topSideImageAndVerbage1', 'htmlContent', 'editable')#
                        </div>
                        <div>
                            #showContentObject('topSideImageAndVerbage2', 'htmlContent', 'editable')#
                        </div>
                    </cfif>
    
                    <cfif contentObjectNotEmpty('sideContent')>
                        <hr />
                        <div>
                            #showContentObject('sideContent', 'htmlContent', 'editable')#
                        </div>
                    </cfif>
    
                    <cfif contentObjectNotEmpty('relatedLinks')>
                        <hr />
                        <div>
                            #showContentObject('relatedLinks', 'htmlContent', 'editable')#
                        </div>
                    </cfif>
                </div>
                <div class="splitleft">
                    <cfif contentObjectNotEmpty('headlineAndSubHead')>
                        <div class="headLine">
                             #showContentObject('headlineAndSubHead', 'htmlContent', 'editable')#
                        </div>
                    </cfif>

                    <cfif contentObjectNotEmpty('bodyCopy1')>
                       <div>
                            #showContentObject('bodyCopy1', 'htmlContent,contactForm,dealershipForm,Search', 'editable')#
                       </div>
                    </cfif>
                    <cfif contentObjectNotEmpty('bodyCopy2')>
                       <div>
                            #showContentObject('bodyCopy2', 'htmlContent,contactForm,dealershipForm,Search', 'editable')#
                       </div>
                    </cfif>

                    <cfif contentObjectNotEmpty('nestedImageAndDescription')>
                        <div class="rightFloater">
                            <div class="imageText">
                                #showContentObject('nestedImageAndDescription', 'htmlContent', 'editable')#
                            </div>
                        </div>
                    </cfif>

                    <cfif contentObjectNotEmpty('bodyContentToSideAndBelowNestedImage')>
                    	<div>
                            #showContentObject('bodyContentToSideAndBelowNestedImage', 'htmlContent', 'editable')#
                        </div>
                    </cfif>
                </div>	
            </div>
            <div class="clear">&nbsp;</div>
        </div>
    </div>
    <cfinclude template="../includes/footer.cfm">
</div>
</body>

</html>

</cfoutput>