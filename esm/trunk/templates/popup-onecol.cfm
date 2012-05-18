<cfcontent reset="true"><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head><!-- one col -->
	<meta http-equiv="content-type" content="text/html; charset=utf-8" />


	<title><cfoutput>#gettitle()#</cfoutput></title>


	<style type="text/css" media="all">
		@import "/ui/css/c.css";
		@import "/ui/css/n.css";
		@import "/ui/css/f.css";
		@import "/ui/css/datepickercontrol.css";
	</style>
	<style type="text/css" media="screen">@import "/ui/css/l.css";</style>

	<cfif isformsubmit()>
		<script type="text/javascript" src="/ui/js/prototype.js"></script>
		<script type="text/javascript" src="/ui/js/datepickercontrol.js"></script>
	</cfif>

	<script type="text/javascript" src="/ui/js/Pre.js"></script>
	<script type="text/javascript" src="/ui/js/popUp.js"></script>
	<script type="text/javascript" src="/ui/js/listManager.js"></script>

	<script type="text/javascript" src="/ui/js/scriptaculous.js"></script>
	<script type="text/javascript" src="/ui/js/builder.js"></script>
	<script type="text/javascript" src="/ui/js/effects.js"></script>
	<script type="text/javascript" src="/ui/js/dragdrop.js"></script>
	<script type="text/javascript" src="/ui/js/controls.js"></script>
	<script type="text/javascript" src="/ui/js/slider.js"></script>

	<script type="text/javascript"> var app; Pre.meditate(function() { app = new APP.Create(); } ); </script>

</head>
<body id="popup">
	<div id="page">

		<div id="bodyNoBg">

			<div id="body-right">
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
				<cfif isformsubmit()>
					</form>
				</cfif>
			</div>
			<div class="clear">&nbsp;</div>
		</div>
	</div>
	<div id="status"><img src="/ui/images/status/green.png"/></div>
	<div id="trace"></div>
	<div id="dump"></div>

</body>
</html>
