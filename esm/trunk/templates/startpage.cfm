<cfcontent reset="true"><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
	<meta http-equiv="content-type" content="text/html; charset=utf-8" />

	<title><cfoutput>#gettitle()#</cfoutput></title>

	<meta name="generator" content="BBEdit 8.2" />
	<style type="text/css" media="all">
		@import "/ui/css/c.css";
		@import "/ui/css/n.css";
		@import "/ui/css/f.css";
	</style>
	<style type="text/css" media="screen">@import "/ui/css/l.css";</style>


	<script type="text/javascript" src="/ui/js/Pre.js"></script>
	<!---><script type="text/javascript" src="/ui/js/builder.js"></script>
	<script type="text/javascript" src="/ui/js/effects.js"></script>
	<script type="text/javascript" src="/ui/js/dragdrop.js"></script>
	<script type="text/javascript" src="/ui/js/controls.js"></script>
	<script type="text/javascript" src="/ui/js/slider.js"></script>
	--->
	<script type="text/javascript"> var app; Pre.meditate(function() { app = new APP.Create(); } ); </script>

</head>
<body>
	<div id="page">
		<div id="head">
			<h1>spireESM</h1>
			<cfoutput>
				<div class="help">
					<a target="_blank" onclick="openWindow({url:'/Help/HelpItem/?m=#variables.menuObj.getModuleLabel(requestObj)#', width:800, height:600, name:'help', scrollbars:1, resizable:1});return false;">
						<img style="border:0;" src="/help/ui/help.gif" alt="Help"/>
					</a>
				</div>
			</cfoutput>
			<div id="welcome">
				<div class="inner">
					<h4>
						Welcome,
						<cfoutput>
						#session.user.getFirstName()#
						#session.user.getLastName()#.
						</cfoutput>
					</h4>

					<div class="nav">
						<ul>

							<li class="alternate">
								<a href="/Login/LoginForm/?logout">Logout</a>
							</li>
							<li>
								<cfoutput>
									<a target="_blank" href="/Help/HelpItem/?m=#variables.menuObj.getModuleLabel(requestObj)#">Help!</a>
								</cfoutput>
							</li>
						</ul>
						<br class="clear" />
					</div>
				</div>
			</div>
			<cfoutput>#application.sites.getSitesHTML(session.user)#</cfoutput>

		  <div id="top" class="nav">
				<cfoutput>#getmainmenuhtml('top')#</cfoutput>
			</div>
			<div id="top1" class="nav">
				<cfoutput>#getmainmenuhtml('addapps')#</cfoutput>
			</div>

			<div id="sub" class="nav">
				<cfoutput>#getSubMenuHtml()#</cfoutput>
			</div>
		</div>
		<div id="body">
			<div id="body-left">
				<div class="content"><!-- InstanceBeginEditable name="Side Bar" -->
					<cfoutput>#renderItem('browseContent','panels')#</cfoutput>
				<!-- InstanceEndEditable --></div>
			</div>
			<div id="body-right">
				<div class="content">
				 	<cfoutput>#renderItem('main','simple')#</cfoutput>
				</div>
			</div>
			<div class="clear">&nbsp;</div>
		</div>

	</div>
	<div id="trace"></div>
</body>
</html>
