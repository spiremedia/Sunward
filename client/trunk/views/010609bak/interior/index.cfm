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
		<script type="text/javascript" src="/ui/js/swfobject.js"></script>
		<link type="text/css" rel="stylesheet" href="/ui/css/sunward.css" />
		<link type="text/css" rel="stylesheet" href="/ui/css/nav.css" />
<cfif ispreview()>
		<style type="text/css" media="all">@import "/ui/esm/co.css";</style>
		<script type="text/javascript" src="/ui/esm/Pre.js"></script>
		<script type="text/javascript" src="/ui/esm/co.js"></script>
</cfif>
	</head>
	<body class="interior">
		<!--
		 ///
		 /// begin template
		 ///
		 -->
		<div id="template">
			<div id="top"></div>
			<div id="content">
				<!--
				 ///
				 /// begin header
				 ///
				 -->
				<div id="header">
					<div id="homelink">
						<a href="/"><img src="/ui/img/logo.jpg" alt="Caring for Colorado Foundation" /></a>
					</div>
					<form id="frmSearch" action="/SearchResults/" method="get">
						<div>
							<input type="text" id="txtSearch" name="txtSearch" value="Search" onblur="javascript: setSearchText(false);" onfocus="javascript: setSearchText(true);" />
							<input type="image" id="btnSearchSubmit" value="submit" alt="GO" src="/ui/img/btnSearchSubmit.gif" />
						</div>
					</form>
					<span class="clear"></span>
				</div>
				<!-- end header -->
				<!--
				 ///
				 /// begin headerimage
				 ///
				 -->
				<div id="headerimage">
					<cfset pathArray = ListToArray(URL.path, "/")>
					<img src="/ui/img/banner_<cfoutput>#pathArray[1]#</cfoutput>.jpg" alt="<cfoutput>#pathArray[1]#</cfoutput>" />
				</div>
				<!-- end headerimage -->
				<!--
				 ///
				 /// begin nav
				 ///
				 -->
				<div id="nav">
					#showContentObject('mainNav', 'navigation', 'mainnav')#
				</div>
				<!-- end nav -->
				<div id="columns">
					<!--
					 ///
					 /// begin columnleft
					 ///
					 -->
					<div class="columnleft">
						<!--
						 ///
						 /// begin sidenav
						 ///
						 -->
						<div class="sidenav">
						#showContentObject('dhtmlNav', 'navigation', 'subnavblob')#
						</div>
						<!-- end sidenav -->
					</div>
					<!-- end columnleft -->
					<!--
					 ///
					 /// begin columnright
					 ///
					 -->
					<div class="columnright">
						<h2>#variables.pageinfo.title#</h2>
						<div>#showContentObject('mainContent', 'HTMLContent,Search,Forms,Assets,Events,News,FeedReader,Staff,Galleries', 'editable')#</div>

					</div>
					<!-- end columnright -->
					<div class="clear"></div>
				</div>
				<!-- end columns -->
			</div>
			<!-- end content -->
			<div id="bottom"></div>
			<cfinclude template="../footer.cfm">
		</div>
		<!-- end template -->
	</body>
</html>
</cfoutput>