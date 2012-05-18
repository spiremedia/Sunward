<cfcontent reset="yes"><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html lang="<cfoutput>#getLocale()#</cfoutput>" xml:lang="en" xmlns="http://www.w3.org/1999/xhtml">

<!-- InstanceBegin template="/Templates/home.dwt.cfm" codeOutsideHTMLIsLocked="false" -->
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<!-- InstanceBeginEditable name="doctitle" -->
	<title><cfoutput>#this.mPage.SiteTitle#</cfoutput> - <cfoutput>#this.mPage.title#</cfoutput></title>
<!-- InstanceEndEditable -->
	<!---<base href="<cfoutput>#this.mPage.baseUrl#</cfoutput>" />--->
	<!---
	///
	/// Dublin Core Metadata Forward thinking schema for Meta Data, compliant with XHTML 1.1
	///
	--->
	<link rel="schema.DC" href="http://purl.org/dc/elements/1.1/" />
	<link rel="schema.DCTERMS" href="http://purl.org/dc/terms/" />
	<meta name="DC.title" content="<cfoutput>#XmlFormat(this.mPage.title)#</cfoutput>" />
	<meta name="DC.keywords" content="<cfoutput>#XmlFormat(this.mPage.keywords)#</cfoutput>" />
	<meta name="DC.description" content="<cfoutput>#XmlFormat(this.mPage.description)#</cfoutput>" />
	<meta name="DC.date" content="<cfoutput>#XmlFormat(this.mPage.published)#</cfoutput>" />
	<meta name="DC.publisher" content="<cfoutput>#XmlFormat(this.mPage.author)#</cfoutput>" />
	<meta name="Author" content="<cfoutput>#this.mPage.Author#</cfoutput>" />
	<meta name="author-email" content="<cfoutput>#this.mPage.AuthorEmail#</cfoutput>" />
	<meta name="keywords" content="<cfoutput>#this.mPage.keywords#</cfoutput>" />
	<meta name="description" content="<cfoutput>#this.mPage.description#</cfoutput>" />
	<meta name="generator" content="<cfoutput>#this.mPage.generator#</cfoutput>" />

	<!--
	///
	/// SpireESM Required assets
	///
	-->
	<style type="text/css" media="all">@import "/ui/esm/co.css";</style>
	<script type="text/javascript" src="/ui/esm/Pre.js"></script>
	<script type="text/javascript" src="/ui/esm/co.js"></script>

	<cfif isDefined('variables.toolbarobj')>
		<style type="text/css" media="all">@import "/ui/esm/t.css";</style>
		<script type="text/javascript" src="/ui/esm/effects.js"></script>
		<script type="text/javascript" src="/ui/esm/Toolbar.js"></script>
	</cfif>

	<script type="text/javascript" src="/ui/js/nav.js"></script>

	<style type="text/css" media="all">
		@import url("/ui/css/sunward.css");
		@import url("/ui/css/nav.css");
    </style>

</head>
<body class="homeBody">
<cfif isDefined('variables.toolbarobj')>
	<cfset variables.toolBarObj.renderControl()>
</cfif>
	<!---
	///
	/// The div#custom-template-container should be used as a <body> tag replacement in css
	/// e.g. with the setting of css background images. This creates a more concise and
	/// predictable container beneath the toolbar control.
	///
	--->
	<!-- InstanceBeginEditable name="Custom Template Container" -->

	<div id="container">
		<div id="header">
			<cfset c.mainnav.renderControl()>

			<div id="bodyContent">

				<div id="breadCrumb">
					<ul style="display: inline; list-style-type:none;">
						<li style="display: inline;"><a href="/Home/">Home </a><cfset Variables.c.navBreadCrumb.renderControl()></li>
					</ul>
				</div>

				<div id="interiortitle">
					<!--- Page Header Title --->
					<cfoutput>#this.mPage.title#</cfoutput>
				</div>

				<div id="interiorLeftBar">
					<!--- Left Navigation Area --->
					<div id="interiorLeftBarNav">
						<cfset c.navLeft.renderControl()>
					</div>
				</div>

				<div class="photoTopBar">
					<!---Top Right Photo Area/Caption--->
					<div class="photoTopBarRight">
					<cfif c.content[2].hasContent() or c.content[2].preview>
						<div><cfset c.content[2].renderControl()>&nbsp;</div>
					</cfif>

					</div>

					<!--- Top Left Photo Area/Caption --->
					<div class="photoTopBarLeft">

						<cfif c.content[1].hasContent() or c.content[1].preview>
							<div><cfset c.content[1].renderControl()>&nbsp;</div>
						</cfif>



					</div>

				</div>

				<div class="photoBottomBar">

					<!---Middle Photo Area/Caption --->
					<div class="photoBottomTop">
						<cfif c.content[3].hasContent() or c.content[3].preview>
							<div><cfset c.content[3].renderControl()>&nbsp;</div>
						</cfif>
					</div>

					<div class="photoBottomColContainer">
						<!--- Head line text for photo page --->
						<cfif c.content[4].hasContent() or c.content[4].preview>
							<div><cfset c.content[4].renderControl()>&nbsp;</div>
						</cfif>

						<cfif this.previewPage>
							<script type="text/javascript">
								if(parent != window) {
									new editBlock.ESM
										('<cfoutput>#JsStringFormat(this.mPage.cmsUrl)#/content/?smid=#this.mPage.id#</cfoutput>');
								}
							</script>
						</cfif>

						<!---        Photo Description text area       --->

						<!---Left Column --->
						<div class="photoBottomCol">
							<cfif c.content[5].hasContent() or c.content[5].preview>
								<div><cfset c.content[5].renderControl()>&nbsp;</div>
							</cfif>

							<cfif this.previewPage>
								<script type="text/javascript">
									if(parent != window) {
										new editBlock.ESM
											('<cfoutput>#JsStringFormat(this.mPage.cmsUrl)#/content/?smid=#this.mPage.id#</cfoutput>');
									}
								</script>
							</cfif>
						</div>

						<!--- Right Column Heading --->
						<div class="photoBottomCol">
							<cfif c.content[6].hasContent() or c.content[6].preview>
								<div><cfset c.content[6].renderControl()>&nbsp;</div>
							</cfif>

							<cfif this.previewPage>
								<script type="text/javascript">
									if(parent != window) {
										new editBlock.ESM
											('<cfoutput>#JsStringFormat(this.mPage.cmsUrl)#/content/?smid=#this.mPage.id#</cfoutput>');
									}
								</script>
							</cfif>
						</div>
					</div>

				</div>

				<div class="clear">&nbsp;</div>

			</div>

			<cfinclude template="/view/includes/footer.cfm">		<!---	Included footer, same footer on all templates	--->
		</div>
	</div>
<!-- InstanceEndEditable -->

	<cfif this.previewPage>
		<script type="text/javascript">
			if(parent != window)
			{
				new editBlock.ESM
				(
					'<cfoutput>#JsStringFormat(this.mPage.cmsUrl)#/content/?smid=#this.mPage.id#</cfoutput>',
					{ containers: ['assetlist', 'text', 'form'] }
				);
			}
		</script>
	</cfif>
</body>
<!-- InstanceEnd -->
</html>