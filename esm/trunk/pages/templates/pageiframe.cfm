<cfset lcl.page = getDataItem('page')>
<cfset lcl.memberTypes = getDataItem('memberTypes')>
<cfset lcl.info = lcl.page.getPageInfo()>
<cfset lcl.urlpath = variables.securityObj.getCurrentSiteUrl()>

<cfoutput>
	<cfif LEN(lcl.info.relocate)>
		This page is set as a relocator in the properites. It has no content. If you wish this to be a real page, please set the relocator field in properties as blank.
	<cfelse>
    	<script>
			<!---function switchGroup (name) {
				var frame = parent.siteview;

				var newLoc = frame.src.replace(/&preview=edit&showmarketinggroup=[a-zA-Z0-9 \.\-\_\%]+/, '&showmarketinggroup=' + name);
				frame.src = newLoc;
			}--->
			function switchview(frm){
				var iframe = document.getElementById('clientView');
				var iframesrc = iframe.src;
				var newView = iframesrc.indexOf('edit') == -1?'edit':'view';
				document.getElementById('switchViewBtn').value=iframesrc.indexOf('edit') == -1?'Switch Back to Preview':'Switch Back To Edit';
				reloadiframe('same', newView);
			}
			function reloadiframe (name, view) {
				var iframe = document.getElementById('clientView');
				var iframesrc = iframe.src;
				if (name != 'same')
					iframesrc = iframesrc.replace(/showmembertype=[a-zA-Z0-9 \.\-\_\%]+/, 'showmembertype=' + name);
				if (view != 'same')
					iframesrc = iframesrc.replace(/preview=[a-zA-Z0-9 \.\-\_\%]+/, 'preview=' + view);
				iframe.src = iframesrc;
			}
			function resetoldvarsandreloadiframe(reloadpath){
				document.getElementById('pageurlold').value = document.getElementById('pageurl').value;
				document.getElementById('pagenameold').value = document.getElementById('pagename').value;
				document.getElementById('templateold').value = document.getElementById('template').value;
				document.getElementById('parentidold').value = document.getElementById('parentid').value;
				
				if (reloadpath == "0") {
					reloadiframe('same', 'same');
				} else {
					var iframe = document.getElementById('clientView');
					var iframesrc = iframe.src;
					var isolateurlpath = iframesrc.match(new RegExp("//[^/]+[/]([^?]+)"));
					str = iframesrc.replace( isolateurlpath[1], reloadpath);
					iframe.src = str;
					//update displayed url path
					document.getElementById('pageurlpath').innerHTML = '<a href="#lcl.urlpath#' + reloadpath + '" target="_blank">#lcl.urlpath#' + reloadpath + '</a>';
				}
			}
			function tofullscreen (itm) {
				var iframe = document.getElementById('clientView');
				var iframesrc = iframe.src;
				var tail = iframesrc.indexOf('?');
				
				var s  = '/pages/pageviewframeset/?id=#lcl.info.id#&' + iframesrc.substring(tail+1);
				itm.href = s;

			}
		</script>
		
    	<div style="margin-bottom:10px;">
			
			<input id="switchViewBtn" type="button" value="Switch to Preview" view="edit" onClick="switchview(this)">
			<!--- <cfif lcl.membertypes.recordcount>
				<span id="memberTypeGroupSwitchText">
				Switch Member Type
				</span>
				<select id="memberTypeSwitch" name="memberTypeSwitch" onchange="reloadiframe(this.value, 'same')">
					<option value="default">Default</option>
					<cfloop query="lcl.memberTypes">
						<option value="#URLEncodedFormat(trim(name))#">#name#</option>
					</cfloop>
				</select>
			</cfif> --->
			<a href="" onClick="tofullscreen(this)" id="clickableFullScreenLink" target="_blank">Open Full Screen</a>
        </div>
    	<div id="clientViewCntnr">
			<iframe id="clientView" height="400" width="700" name="clientView" src="#variables.securityObj.getCurrentSiteUrl()##lcl.page.getPath()#?preview=edit&showmembertype=default"></iframe>
        </div>
		
	</cfif>
</cfoutput>