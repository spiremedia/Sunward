<cfoutput>
<cfcontent reset="yes"><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
   "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html><!-- internal -->
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
					<cfif contentObjectNotEmpty('leftSideItem1title1') OR contentObjectNotEmpty('leftSideItem1title2')
						OR contentObjectNotEmpty('leftSideItem1Content') OR contentObjectNotEmpty('leftSideItem1Content2')>
					<div class="sideItem5">
						<h1>#showContentObject('leftSideItem1title1', 'SimpleContent', 'editable')#</h1>
						<h2>#showContentObject('leftSideItem1title2', 'SimpleContent', 'editable')#</h2>
						<div class="content">
							<div>#showContentObject('leftSideItem1Content', 'HTMLContent,Assets,News,FeedReader,News', 'editable')#</div>
                            <div>#showContentObject('leftSideItem1Content2', 'HTMLContent,Assets,NewsFeedReader,News', 'editable')#</div>
						</div>
					</div>
					</cfif>
                    <cfif contentObjectNotEmpty('leftSideItem2title1') OR  contentObjectNotEmpty('leftSideItem2title2')>
					<div class="sideItem6">
						<h1>#showContentObject('leftSideItem2title1', 'SimpleContent', 'editable')#</h1>
						<h2>#showContentObject('leftSideItem2title2', 'SimpleContent', 'editable')#</h2>
						<div class="content">
							<div>#showContentObject('leftSideItem2Content', 'HTMLContent,Assets,News,FeedReader,News', 'editable')#</div>
                            <div>#showContentObject('leftSideItem2Content2', 'HTMLContent,Assets,News,FeedReader,News', 'editable')#</div>
						</div>
					</div>
                    </cfif>
					<div class="c1bottomshadow"><div>&nbsp;</div></div>
                    <div class="leftBottomSpacer">
                    	&nbsp;
                    </div>
				</div>

				<div class="c2">
					<div class="c2topshadow"><div>&nbsp;</div></div>
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

                            <div class="content">
								<div>#showContentObject('middleContentItem2', 'HTMLContent,Forms,Assets,News,FeedReader,Tagcloud,dhtmlPager,Galleries,Events', 'editable')#</div>
                                <div>#showContentObject('middleContentItem2a', 'HTMLContent,Forms,Assets,News,FeedReader,Tagcloud,dhtmlPager,Galleries,Events', 'editable')#</div>
                            </div>
                        </div>
                      	<cfif contentObjectNotEmpty('middleContentItem4Title')>
                        <div class="middleItem4">
                            <h1>#showContentObject('middleContentItem4Title', 'SimpleContent', 'editable')#</h1>
                      	</div>
                        </cfif>
                        <div class="middleItem3">
                            <div class="content">
								<div>#showContentObject('middleItem2Content', 'HTMLContent,Forms,Assets,News,FeedReader,tagcloud,dhtmlPager,Galleries,Events', 'editable')#</div>
                                <div>#showContentObject('middleItem2Content2', 'HTMLContent,Forms,Assets,News,FeedReader,tagcloud,dhtmlPager,Galleries,Events', 'editable')#</div>
							</div>
                        </div>
                    </div>
                    <cfif contentObjectNotEmpty('bottomAd')>
                    <div class="ad">
						#showContentObject('bottomAd', 'HTMLContent', 'editable')#

                    </div>
                    </cfif>
                </div>

                <div class="c3">

                	<div class="c3topshadow">&nbsp;</div>
					<div class="sideItem1">
						<h1>Login</h1>
						<div class="content loginForm">
							[postprocess-usershtml]
						</div>
					</div>
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

