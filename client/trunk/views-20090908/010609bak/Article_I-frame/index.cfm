<cfoutput>
<cfcontent reset="yes"><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
   "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html><!-- iframe -->
<cfinclude template="../headtag.cfm"/>

<body class="level2">
	<div id="outercontainer">
		<div id="container">
        	<cfinclude template="../header.cfm">
			<div class="navWrap">
                <div class="nav">
                    <div class="innerNav">
                        <div style="width: 660px; margin-left: auto; margin-right: auto;">
                            #showContentObject('dhtmlNav', 'Navigation', 'dhtmlnav')#
                        </div>
                    </div>
                </div>
			</div>
			<div id="bodyContent">
				<div class="c1">
					<div class="c1topshadow"><div>&nbsp;</div></div>
					<div class="secondNav">
						#showContentObject('leftnav', 'Navigation', 'subnav')#
					</div>

					<cfif contentObjectNotEmpty('leftSideItem1titlea') OR contentObjectNotEmpty('leftSideItem1titleb') 
						OR contentObjectNotEmpty('leftSideItem1Contenta') OR contentObjectNotEmpty('leftSideItem1Contentb')>
					<div class="sideItem5">
						<h1>#showContentObject('leftSideItem1titleA', 'SimpleContent', 'editable')#</h1>
						<h2>#showContentObject('leftSideItem1titleB', 'SimpleContent', 'editable')#</h2>
						<div class="content">
							<div>#showContentObject('leftSideItem1ContentA', 'HTMLContent,Assets,IFrames,News,TagCloud,News', 'editable')#</div>
                            <div>#showContentObject('leftSideItem1ContentB', 'HTMLContent,Assets,IFrames,News,TagCloud,News', 'editable')#</div
						></div>
					</div>
					</cfif>
					<div class="c1bottomshadow"><div>&nbsp;</div></div>
					<div class="leftBottomSpacer">
					     &nbsp;
                    </div>
				</div>
				<div class="c2Wide">
					<div class="c2widetopshadow"><div>&nbsp;</div></div>
                    <div class="c2container">
                        <div id="breadCrumbs">
                            #showContentObject('breadcrumbs', 'breadcrumbs')#
                        </div>
                        <div class="middleItem1">
                            <h1>
								<cfif ispreview('edit') OR contentObjectNotEmpty('pagetitle')>
									#showContentObject('pagetitle', 'SimpleContent', 'editable')#
								<cfelse>	
									#getField('pagename')#
								</cfif>
							</h1>
                      	</div>
                        <div class="middleItem2">
                        	<cfif ispreview('edit')>
                                <div class="hint">Hint : Embedded Iframes can be edited by clicking on the lower 20pixels.</div>
                            </cfif>
                            <div class="content">
								<div>#showContentObject('middleContentItem2A', 'HTMLContent,iFrames,Forms,News,Assets,FeedReader,TagCloud,News', 'editable')#</div>
                                <div>#showContentObject('middleContentItem2B', 'HTMLContent,iFrames,Forms,News,Assets,FeedReader,TagCloud,News', 'editable')#</div>
                            </div>
                        </div>
					</div>
                    <cfif contentObjectNotEmpty('bottomAd')>
                    <div class="ad">
						#showContentObject('bottomAd', 'HTMLContent', 'editable')#
                    </div>
                    </cfif>
                </div>
			</div>
            <br class="clear"/>
            <cfinclude template="../footer.cfm">
		</div>
	</div>
</body>
</html>
</cfoutput>

