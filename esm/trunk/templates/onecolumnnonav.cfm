<cfcontent reset="true"><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
	<meta http-equiv="content-type" content="text/html; charset=utf-8" />

	<title><cfoutput>#getTitle()#</cfoutput></title>


	<style type="text/css" media="all">
		@import "/ui/css/c.css";
		@import "/ui/css/n.css";
		@import "/ui/css/f.css";
		@import "/ui/css/datepickercontrol.css";
	</style>
	<style type="text/css" media="screen">@import "/ui/css/l.css";</style>


	<script type="text/javascript" src="/ui/js/prototype.js"></script>
	<script type="text/javascript" src="/ui/js/datepickercontrol.js"></script>


	<script type="text/javascript" src="/ui/js/Pre.js"></script>
	<script type="text/javascript" src="/ui/js/listManager.js"></script>

	<script type="text/javascript"> var app; Pre.meditate(function() { app = new APP.Create(); } ); </script>

</head>
<body>
	<div id="page">
		<div id="head">
			<div id="status"><img src="/ui/images/status/green.png"/></div>
			<h1>spireESM</h1>
		</div>

		<div id="bodynomenu">
			<div style="width:400px;margin-right:auto;margin-left:auto;margin-top:30px;">

				<script charset="javascript:1.2">
				<cfif isformsubmit()>
					function submitAjaxForm(){
						if (typeof(tinyMCE) == 'object') tinyMCE.triggerSave();
						var myForm = Form.serialize('myForm');
						$('trace').innerHTML = myForm;
						ajaxWResponseJsCaller('/<cfoutput>#requestObj.getModuleFromPath()#/#getFormSubmit()#</cfoutput>/',myForm);
						return false;
					}
				</cfif>
				</script>

				<cfif isformsubmit()>
					<form name="myForm" id="myForm" onsubmit="return submitAjaxForm();">
				</cfif>
				<div id="msg"></div>
				<cfoutput>#renderItem('maincontent','plain')#</cfoutput>

				<cfif isformsubmit()>
					</form>
				</cfif>

			</div>
			<div class="clear">&nbsp;</div>
		</div>

	</div>
	<div id="trace"></div>
	<div id="dump"></div>
</body>
</html>
