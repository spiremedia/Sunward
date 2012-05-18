<cfcontent reset="true"><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
	<meta http-equiv="content-type" content="text/html; charset=utf-8" />

	<title><cfoutput>#gettitle()#</cfoutput></title>

	<style type="text/css" media="all">@import "/ui/css/c.css";</style>
	<style type="text/css" media="screen">@import "/ui/css/l.css";</style>
	<style type="text/css" media="all">@import "/ui/css/n.css";</style>
	<style type="text/css" media="all">@import "/ui/css/f.css";</style>
	<script type="text/javascript" src="/ui/js/Pre.js"></script>
	<script type="text/javascript" src="/ui/js/popUp.js"></script>
	<script type="text/javascript" src="/ui/js/listManager.js"></script>
	<script type="text/javascript"> var app; Pre.meditate(function() { app = new APP.Create(); } ); </script>

	<!--
	///
	/// Form Wizard ILM-ish special effects brought to you by...
	/// Script.acolo.us 1.6.0
	///
	--->
	<script type="text/javascript" src="/ui/js/scriptaculous1_6_1/builder.js"></script>
	<script type="text/javascript" src="/ui/js/scriptaculous1_6_1/controls.js"></script>
	<script type="text/javascript" src="/ui/js/scriptaculous1_6_1/dragdrop.js"></script>
	<script type="text/javascript" src="/ui/js/scriptaculous1_6_1/effects.js"></script>

	<!--
	///
	/// Form Wizard Mechanics
	/// /ui/js/Browser.js - the machine that enables the recipient browser list
	/// /ui/js/FormWizard.js - the machine that handles the drag-n-drop
	/// aspects between the tool bar and the palette.
	/// /ui/css/fw.css - css styles of the form wizard
	-->

	<script type="text/javascript" src="/ui/js/scriptaculous1_6_1/Browser.js"></script>
	<script type="text/javascript">
		var ExternalValues =
		{
			deleteConfirmMessage:
				'You are about to delete this field.\nContinue?',
			Ajax_InPlaceTextEditorUrl:
				'<cfoutput>#getEsmUrl()#</cfoutput>widgets/inplaceeditor1.0/?method=renderEchoView',
			ValueHere:
				'&lt;Value Here&gt;',
			LableHere:
				'&lt;Label Here&gt;'
		}
	</script>
	<style type="text/css" media="screen">@import "/ui/css/fw.css";</style>

		<!---><style type="text/css" media="screen">
			@import url("/ui/css/tools.css");
			@import url("/ui/css/typo.css");
			@import url("/ui/css/forms.css");
			@import url("/ui/css/layout-navtop-localleft.css");
			@import url("/ui/css/layout.css");
		</style>
		<style type="text/css" media="all">@import "/ui/esm/co.css";</style>
		<script type="text/javascript" src="/ui/esm/co.js"></script>--->

</head>
<body>
	<div id="page">
		<div id="head">
			<h1>spireESM</h1>
			<cfoutput>
				<div class="help">
					<a target="_blank" href="/Help/HelpItem/?m=#variables.menuObj.getModuleLabel(requestObj)#"><img style="border:0;" src="/help/ui/help.gif" alt="Help"/></a>
				</div>
			</cfoutput>
		</div>
		<div id="body">
			<div id="body-left">
				<div class="content" id="leftContent">

					<cfoutput>#renderItem('browseContent','panels')#</cfoutput>
				</div>
			</div>
			<div id="body-right">
				<script charset="javascript:1.2">
					function submitAjaxForm(){
						if (typeof(tinyMCE) == 'object') tinyMCE.triggerSave();
						var myForm = Form.serialize('myForm');
						$('trace').innerHTML = myForm;
						ajaxWResponseJsCaller('/<cfoutput>#requestObj.getModuleFromPath()#/#getFormSubmit()#</cfoutput>/',myForm);
						return false;
					}
				</script>
				<form name="myForm" id="myForm" onsubmit="return submitAjaxForm();" enctype="application/x-www-form-urlencoded">
				<div class="content" id="rightContent">

					<cfoutput>#renderItem('title','title')#
					<div class="group">
						<div class="inner">
							<div class="bottom">
								<div class="inner">
									<div class="panel">
									<div id="msg"><cfif requestObj.isformurlvarset('msg')>#requestObj.getformurlvar('msg')#<cfelse>&nbsp;</cfif></div>
										#renderItem('maincontent','accordion')#
										</div>
								</div>
							</div>
						</div>
					</div>
					</cfoutput>
				</div>
				</form>
				<script type="text/javascript" src="/ui/js/scriptaculous1_6_1/FormWizard.js"></script>
			</div>
			<div class="clear">&nbsp;</div>
		</div>

	</div>
	<div id="status"><img src="/ui/images/status/green.png"/></div>
	<div id="trace"></div>
	<div id="dump"></div>
	<!--- added dre 20080313 not sure if should stay --->
	<script>
		window.resizeTo(1100, 730);
	</script>
</body>

</html>


