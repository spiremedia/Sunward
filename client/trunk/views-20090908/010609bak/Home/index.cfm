<cfoutput>
<cfcontent reset="true"><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
	<head>
		<meta http-equiv="content-type" content="text/html;charset=utf-8" />
		<meta http-equiv="Content-Style-Type" content="text/css" />
		<meta name="description" content="#variables.pageinfo.description#" />
		<meta name="keywords" content="#variables.pageinfo.keywords#" />
		<title>#variables.pageinfo.title#</title>
		<script type="text/javascript" src="/ui/js/nav.js"></script>
		<swcript type="text/javascript" src="/ui/js/swfobject.js"></script>
		<link type="text/css" rel="stylesheet" href="/ui/css/sunward.css" />
		<link type="text/css" rel="stylesheet" href="/ui/css/nav.css" />
<cfif ispreview()>
		<style type="text/css" media="all">@import "/ui/esm/co.css";</style>
		<script type="text/javascript" src="/ui/esm/Pre.js"></script>
		<script type="text/javascript" src="/ui/esm/co.js"></script>
</cfif>
	</head>


<body class="homeBody">


<cfif isDefined('variables.toolbarobj')>
	<cfset variables.toolBarObj.renderControl()>
</cfif>

		<div id="container">

			<div id="header">
				<div id="logobtn"><a href="/"><img src="/ui/img/clear.gif" height="80" width="300"/></a></div>
						#showContentObject('dhtmlNav', 'navigation', 'dhtmlNav')#


				<div id="bodyContentHome">
					<div id="bodyContentTop">

						<!--- top left area under nav bar on home page --->
						<div id="bodyContentTopLeft">
							<!---<cfif c.content[1].hasContent() or c.content[1].preview>
								<div><cfset c.content[1].renderControl()>&nbsp;</div>
							</cfif>--->
						</div>

						<!--- top right area under nav bar on home page,  should contain swf --->
						<div id="bodyContentTopRight">


							<div id="flashcontent" >

							</div>

							<script type="text/javascript">
							  var so = new SWFObject("/docs/A3530C21-BD6F-89DB-30CE2208C9415B23/sunwardHomepage.swf", "mymovie", "609", "270", "8", "##336699");
							  so.addParam('wmode','transparent');
							  so.write("flashcontent");
							</script>
						</div>

					</div>


					<div id="bodyContentBottom">
						<div id="bodyContentBottomBlkPnl">

							<div class="blackPanels">
								<!--- Center of Home Page, far left Image/Area --->
								<div class="blkPanelsImgSlot">
									#showContentObject('mainContent1', 'HTMLContent,Forms,Assets,Galleries', 'editable')#
								</div>
							</div>

							<div class="blackPanels">
								<!--- Center of Home Page, middle pannel Image/Area --->
								<div class="blkPanelsImgSlot">
									#showContentObject('mainContent2', 'HTMLContent,Forms,Assets,Galleries', 'editable')#
								</div>
							</div>

							<div class="blackPanels">
								<!--- Center of Home Page, far right pannel Image/Area --->
								<div class="blkPanelsImgSlot">
									#showContentObject('mainContent3', 'HTMLContent,Forms,Assets,Galleries', 'editable')#
								</div>
							</div>
							<br style="clear:both">
						</div>

						<!--- Bottom of Home Page, left panel --->
						<div class="bluePanels">
									#showContentObject('mainContent4', 'HTMLContent,Forms,Assets,Galleries', 'editable')#
						</div>

						<!--- Bottom of Home Page, Right Panel --->
						<div class="bluePanels">
									#showContentObject('mainContent5', 'HTMLContent,Forms,Assets,Galleries', 'editable')#
						</div>

						<br style="clear:both">

						<!--- very Bottom of Home page, panel that spans accors page width --->
						<div class="btmImgSlot">
									#showContentObject('mainContent6', 'HTMLContent,Forms,Assets,Galleries', 'editable')#
						</div
						><br style="clear:both">
					</div>
				</div>
			<cfinclude template="../footer.cfm">
		</div>
		<!-- end template -->
	</body>
</html>
</cfoutput>