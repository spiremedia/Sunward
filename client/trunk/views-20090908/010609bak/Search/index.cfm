<cfoutput>
<cfcontent reset="yes"><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
   "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html><!-- Search -->
<cfinclude template="../headtag.cfm"/>

<body class="col1wide search">
	<div id="outercontainer">
		<div id="container">
        	<cfinclude template="../header.cfm">
			<div class="navWrap">
                <div class="nav">
                    <div class="innerNav">
                    <table class="navTable">
                    <tr>
                    <td>
						#showContentObject('dhtmlNav', 'Navigation', 'dhtmlnav')#
                    </td>
                    </tr>
                    </table>
                    </div>
                </div>
			</div>
			<div id="bodyContent">
				<div class="c1Wide">
					<div class="c1widetopshadow"><div>&nbsp;</div></div>
					<div class="sideItem1">
                    	<div class="journalSearch">
                        	<a href=""><img src="/ui/images/searchJournalBtn.gif" /></a>
                        </div>
                    	<div id="breadCrumbs">
                        	#showContentObject('breadcrumbs', 'BreadCrumbs')#
                        </div>
						<h1 class="pageTitle">
                            <cfif ispreview('edit') OR contentObjectNotEmpty('pagetitle')>
								#showContentObject('pagetitle', 'SimpleContent', 'editable')#
							<cfelse>	
								#getField('pagename')#
                            </cfif>
						</h1>
						<div class="content">
							<div>#showContentObject('pageContent', 'Search,HTMLContent,iFrames,Forms', 'editable')#</div>
                            <div>#showContentObject('pageContent2', 'Search,HTMLContent,iFrames,Forms', 'editable')#</div>
						</div>
					</div>
					<div class="c1bottomshadow"><div>&nbsp;</div></div>
				</div>

                <div class="c3">
                	<div class="c3topshadow">&nbsp;</div>
					<div class="rightSideAds">
						#showContentObject('rideSideAds', 'HTMLContent', 'editable')#
					</div>
					<div class="c3bottomshadow"><div>&nbsp;</div></div>
				</div>
			</div>
            <br class="clear"/>
            <cfinclude template="../footer.cfm">
		</div>
	</div>
</body>
</html>
</cfoutput>

