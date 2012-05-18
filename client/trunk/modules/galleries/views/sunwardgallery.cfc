<cfcomponent name="sunwardGallery">
	
	<cffunction name="init">
		<cfargument name="requestObject">
		<cfargument name="data">
		<cfargument name="name">
		<cfset variables.requestObject = arguments.requestObject>
		<cfset variables.data = arguments.data>
		<cfset variables.name = arguments.name>
		<cfset variables.itemsinrow = 5>
		<cfreturn this>
	</cffunction>
    
    <cffunction name="setModel">
        <cfargument name="Mdl">
        <cfset variables.Mdl = arguments.Mdl>
	</cffunction>
	
	<cffunction name="showHTML">
		<cfset var lcl = structnew()>
        <cfset lcl.qry = mdl.getGalleriesData(data.gallerygroupid)>
		<cfset objRequest = GetPageContext().GetRequest() />
		<cfset strUrl = objRequest.GetRequestUrl().Append("?" & objRequest.GetQueryString()).ToString() />
        <cfsavecontent variable="lcl.html">
			<cfoutput>
            <div id="containerBlock">
            <div class="galleryIndexReturn"><input type="button" name="return" value="&lt; Return to Gallery Index"></div>
			<div id="largeBlock">
				<link rel="stylesheet" href="/ui/css/galleries/sunwardGallery.css" type="text/css" />
				<script type="text/javascript" src="/ui/js/galleries/sunwardGallery.js" language="javascript"></script>

<cfset i = 1>
				<cfloop query="lcl.qry">
				<cfif i eq 1>
            <h2 class="title">#title#</h2>
					<a href="##" <cfif i eq 1>class="first"</cfif>><img src="/docs/imagegalleries/#id#/#rereplace(filename,"\.(jpg|png)$", "_med.\1")#" title="#title#" alt="#description#" /></a>
				        <p class="imageDescription">#description#</p>
					<cfset i = 2>
				</cfif>	
				</cfloop>

			</div>
            <div id="emailPrint">
            	<!-- sendToFriendForm -->
                <div id="galleryEmailImage">
                    <a id="sendToFriendLink" href="##">Send to Friend</a>
                </div>
                <!--- print photo --->
                <div id="galleryPrintImage">
                    <a href="##">Print Photo</a>
                </div>
            </div>
			<!---<div id="previewBlock"></div>--->
			        <div style="clear: both;"></div>
		<div id="sendToFriendForm">

			
			<div id="formContainer">
			<form name="sendToFriend" id="sendToFriendPost" method="post">
			<a id="closeSend" href="##">[x]&nbsp;<strong>Close</strong></a>
				<h3>Tell a friend about this gallery</h3>
				<input type="hidden" name="photo_link" id="photo_link" value="#strURL#" />
				<input type="hidden" name="client_name" id="client_name" value="Sunward Consolidated Group" />
				<span id="sendToFriendLeft">
				<p>

					<label>Friends Name:</label>
					<input type="text" name="friends_name" id="friends_name" />
				</p>
				<p>
					<label>Friends Email:</label>
					<input type="text" name="friends_email" id="friends_email" />
				</p>
				<p>

					<label>Your Name:</label>
					<input type="text" name="your_name" id="your_name" />
				</p>
				<p>
					<label>Your Email:</label>
					<input type="text" name="your_email" id="your_email" />
				</p>
				</span>

				<span id="sendToFriendRight">
				<p style="margin-bottom: 7px;">
					<label>Additional Message:</label>
					<textarea name="message" id="message" style="width: 215px" rows="6">

					
					 </textarea>
				</p>
				<p>
					<span id="submitItems"><input type="submit" name="submitSendFriend" id="submitSendFriend" value="Send Email" /> | <a id="cancelSend" href="##">Cancel</a></span><span id="loadingMessage">Sending Message...</span>

				</p>
				</span>
			</form>
			</div>
			<div id="responseMessage"><span id="addResult"></span><a id="tryAgainLink" href="##">Click here to send another one</a></div>
		</div>
        <div style="clear: both;"></div>
		<!---<div id="galleryControls">
			<div id="galleryPlayOptions">
				<a id="previous" href="##"><img src="/ui/img/galleries/btn_prev.gif" width="34" height="33" border="0" alt="" id="previous" /></a>&nbsp;&nbsp;<a id="play" href="##"><img src="/ui/img/galleries/btn_play.gif" width="33" height="33" border="0" alt="" /></a><a id="pause" href="##"><img src="/ui/img/galleries/pause.gif" width="33" height="33" border="0" alt="" /></a>&nbsp;&nbsp;<a id="next" href="##"><img src="/ui/img/galleries/btn_next.gif" width="34" height="33" border="0" alt="" /></a><br />
			</div>
			<div style="clear: both;"></div>
		</div>--->	<!-- galleryControls -->			
					
					
        <div id="thumbnailBlock">
        	<!--- width of ul is based off of thumbnail width and query count  -  this is th only way I could avoid using an iframe and still get the propper output because IE is garbage, we have to do a smidge of conditional processing....  LAME! --->
            <cfif FindNoCase('MSIE 6','#CGI.HTTP_USER_AGENT#')>
				<cfset ulWidth = 45 * lcl.qry.recordcount>
            <cfelse>
            	<cfset ulWidth = 40 * lcl.qry.recordcount>
            </cfif>
            <ul style=" width: #ulWidth#px; ">
				<cfset i = 1>
                <cfloop query="lcl.qry">
                    <li><a href="/docs/imagegalleries/#id#/#rereplace(filename,"\.(jpg|png)$", "_med.\1")#" <cfif i eq 1>class="first"</cfif>><img src="/docs/imagegalleries/#id#/#rereplace(filename,"\.(jpg|png)$", "_thmb.\1")#" title="#title#" alt="#description#" id="#i#" rel="/docs/imagegalleries/#id#/#rereplace(filename,"\.(jpg|png)$", "_med.\1")#" width="35" height="35" /></a></li>
                    <cfset i = i + 1>
                </cfloop>
            </ul>
        </div>

<div style="clear:both"></div>
</div>
	<div id="response" style="text-align: center; padding-top: 10px;"></div>
	

             <cfif requestObject.isFormUrlVarSet('hi')>
            	#requestObject.getFormUrlVar('hi')#

                <cfdump var=#requestObject.getallformurlvars()#>
            </cfif>
			</cfoutput>
        </cfsavecontent>
        <cfreturn lcl.html>
    </cffunction>
	
</cfcomponent>