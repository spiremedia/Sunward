<cfcomponent name="navigation" extends="resources.abstractController">
	
	<cffunction name="init">
		<cfargument name="requestObject">
		<cfargument name="parameterList" default="#structnew()#">
		<cfargument name="pageref">
		<cfargument name="possibleModules">
		<cfargument name="data">
										
		<cfset structappend(variables,arguments)>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="makeSubNav">
		<!--- Apologies for the proceduralness DRE --->
		<cfset var contents = "">
		<cfset var lcl = structnew()>
		<cfset var nav2 = querynew("hi")>
		<cfset var nav3 = querynew("hi")>
		<cfset var nav4 = querynew("hi")>
		<cfset var selectd = structnew()>
		<cfset var path = variables.requestObject.getformurlvar('path')>
		<cfset var isSubsite = 0>

		<cfset lcl.breadcrumbs = listtoarray(pageref.getField('breadcrumbs'),"|")>
		<cfif arraylen(lcl.breadcrumbs) EQ 0>
			<cfreturn "">
		</cfif>
		<cfif arraylen(lcl.breadcrumbs) EQ 1>
			<!--- home page or recycled nav --->
			<cfset nav3 = pageRef.getChildPages(getToken(lcl.breadcrumbs[1], 2, "~"))>
		<cfelse>
			<!--- normal --->
			<cfloop from="2" to="#arraylen(lcl.breadcrumbs)#" index="lcl.itm">
				<cfset "nav#lcl.itm+1#" = pageRef.getChildPages(getToken(lcl.breadcrumbs[lcl.itm], 2, "~"))>
			</cfloop>
		</cfif>

		<!--- determine if subsite --->
		<cfif isArray(lcl.breadcrumbs) AND arraylen(lcl.breadcrumbs) AND (gettoken(lcl.breadcrumbs[1],1,"~") neq 'Home')>
			<cfset isSubsite = 1>
		</cfif>

<!--- this is the side navagation that is seen within the site / outside ofthe home page --->
		
		<cfparam name="nav3.displayurlpath" default="">
		<cfparam name="nav4.displayurlpath" default="">
		<cfparam name="nav5.displayurlpath" default="">

		<cfsavecontent variable="contents">
			<ul>
				<cfoutput>
				<cfset isFirstMenuItem = true>
				<!--- loop first interior level of navigation --->
				<cfloop query="nav3">
					<cfif len(nav3.displayurlpath) neq len(reReplaceNoCase(nav3.pagename, " |&|-|_", "", "ALL")) + 2>
						<cfset selectd['l3'] = refindnocase("^#nav3.displayurlpath#", "/" & path)>
						<li class="sidenavlevel3<cfif selectd['l3']> itemOn3<cfif isFirstMenuItem eq true> itemOn3First</cfif></cfif><cfif selectd['l3'] AND nav4.recordcount eq 0> sidenavlevel3NoSubnav</cfif>">
							<a href="#nav3.displayurlpath#" <cfif left(nav3.displayurlpath,1) EQ "h">target="_blank"</cfif>>#ucase(nav3.pagename)#<br></a>
							<!--- loop second interior level of navigation --->
							<cfif isDefined("nav4.displayURLPath")>
								<cfif findNoCase(nav3.displayurlpath, nav4.displayURLPath)>
									<cfloop query="nav4">
										<cfset selectd['l4'] = refindnocase("^#nav4.displayurlpath#", "/" & path)>
										<li class="sidenavlevel4<cfif nav4.displayurlpath EQ "/" & path OR selectd['l4'] AND nav5.recordcount> itemOn4</cfif>"><a href="#nav4.displayurlpath#" <cfif left(nav4.displayurlpath,1) EQ "h">target="_blank"</cfif>>#nav4.pagename#</a></li>
										<!--- loop third interior level of navigation --->
										<cfif isDefined("nav5.displayURLPath")>
											<cfif findNoCase(nav4.displayurlpath, nav5.displayURLPath)>
												<cfloop query="nav5">
												<cfset selectd['l5'] = refindnocase("^#nav5.displayurlpath#", "/" & path)>
													<li class="sidenavlevel5<cfif selectd['l5']> itemOn5</cfif>">
														<a href="#nav5.displayurlpath#" <cfif left(nav5.displayurlpath,1) EQ "h">target="_blank"</cfif>>
															#nav5.pagename#
														</a>
													</li>
												</cfloop>
												<!--- loop fourth interior level of navigation --->
												<cfif isDefined("nav6.displayURLPath")>
													<cfif findNoCase(nav5.displayurlpath, nav6.displayURLPath)>
														<cfloop query="nav6">
															<cfset selectd['l6'] = refindnocase("^#nav6.displayurlpath#", "/" & path)>
															<li class="sidenavlevel6<cfif selectd['l6']> itemOn6</cfif>">
																<a href="#nav6.displayurlpath#" <cfif left(nav6.displayurlpath,1) EQ "h">target="_blank"</cfif>>
																	#nav6.pagename#
																</a>
															</li>
														</cfloop>
													</cfif>
												</cfif>
											</cfif>
										</cfif>
									</cfloop>
								</cfif>
							</cfif>
						</li>
					</cfif>
				</cfloop>
				</cfoutput>   
			</ul>
		</cfsavecontent>
		<cfreturn contents>
	</cffunction>
    
	<cffunction name="makeMainFlashNav">
		<cfset var lcl = structnew()>
	
		<cfset lcl.flashvars = structnew()>
		<cfset lcl.silo = listfirst(requestObject.getformurlvar('path'),'/')>

		<cfset lcl.season = requestObject.getVar('season')>		
    	<cfset lcl.backgroundimgs = '""'>			
    	<cfset lcl.height = ''>
    	<cfset lcl.width = '968'>
		<cfset lcl.pagetemplate = pageref.getField('template')>
		
		<cfif lcl.pageTemplate EQ 'home'>
			<cfset lcl.silo = lcl.silo & 'home'>
		</cfif>
		
		<cfset lcl.breadcrumbs = pageref.getField('breadcrumbs')>
		<cfset lcl.breadcrumbs = listtoarray(lcl.breadcrumbs,"|")>

		<!--- get list of background images based on silo, if silo folder doesn't exist use default folder --->
    	<cfset lcl.backgroundimgs = getImageFiles('/docs/#lcl.season#bgimages/#lcl.silo#/')>		
		
		<cfif not structkeyexists(lcl.backgroundimgs, 'name')>
    		<cfset lcl.backgroundimgs = getImageFiles('/docs/#lcl.season#bgimages/default/')>
        </cfif>		
        
        <cfif lcl.silo EQ 'home'>
        	<cfset lcl.flashvars.showweather = 1>
        </cfif>
        
		<cfset lcl.flashvars.backgroundimgs = '"#valuelist(lcl.backgroundimgs.name,",")#"'>
				
		<!--- homepage vars - other page vars --->
		<cfif lcl.pageTemplate EQ 'home'>
    		<cfset lcl.height = '505'>
			<cfset lcl.flashvars.homepage = 1>
		<cfelse>
    		<cfset lcl.height = '164'>
		</cfif>

		<cfreturn lcl.html>
	</cffunction>	

	<cffunction name="makeDHTMLNav">
		<cfset var contents = "">
		<cfset var lcl = structnew()>
		<cfset var path = variables.requestObject.getformurlvar('path')>
		<cfset var cntrs = 1>
        <cfset var tclass = arraynew(1)>
		
		<cfset lcl.breadcrumbs = pageref.getField('breadcrumbs')>
		<cfset lcl.breadcrumbs = listtoarray(lcl.breadcrumbs,"|")>
		<cfset lcl.topid = "">
		<cfif (isArray(lcl.breadcrumbs) AND arraylen(lcl.breadcrumbs))>
			<cfset lcl.topid = gettoken(lcl.breadcrumbs[1],2,"~")>
		</cfif>
		<cfset lcl.dhtmlnav = pageref.getDHTMLnav(id = lcl.topid)>

<!--- this is the main Navigation module --->
		<cfsavecontent variable="contents">
			<ul id="nav">
			<cfparam name="incValue" default="0">
			<cfoutput query="lcl.dhtmlnav" group="secondLevelid">
			<cfset incValue = incrementValue(incValue)>
            	<cfset arrayclear(tclass)>
            	<cfif lcl.dhtmlnav.currentrow EQ 1><cfset arrayappend(tclass, 'first')></cfif>
                <cfif refindnocase("^#lcl.dhtmlnav.secondurlpath#", path)><cfset arrayappend(tclass, 'itemOn')></cfif>
				<li <cfif arraylen(tclass)>class="#arraytolist(tclass," ")#"</cfif>>
                	<cfset navImageName = "">
                	<cfset navImageName = replace(secondpagename, " ", "", "all")>
                	<cfset navImageName = replace(navImageName, "&", "", "all")>
                    <a href="#secondurlpath#" onmouseover="document.Image#incValue#.src='/ui/images/menuButtons/btn_#trim(navImageName)#_over.gif'"
onmouseout="document.Image#incValue#.src='/ui/images/menuButtons/btn_#trim(navImageName)#.gif'">
                        <img src="/ui/images/menuButtons/btn_#trim(navImageName)#.gif" name="Image#incValue#" />
                    </a>
				<cfif thirdurlpath NEQ "">
				<cfset cntrs = 0>
				<cfoutput>
					<cfset cntrs = cntrs + 1>
					<cfif cntrs EQ 1>
						<ul class="sub">
                            <li><a href="#thirdurlpath#">#thirdpagename#</a></li>
					<cfelse>
                            <li><a href="#thirdurlpath#">#thirdpagename#</a></li>
					</cfif>
				</cfoutput>
				<cfif cntrs>
					</ul>
				</cfif>
				</cfif>
				</li>
			</cfoutput>
			</ul>
		</cfsavecontent>

		<cfset contents = rereplace(contents, ">[ \t\r\n]+<","><","all")>	

		<cfreturn contents>
	</cffunction>
	
	<cffunction name="makeXMLNav">
		<cfset var contents = "">
		<cfset var lcl = structnew()>
		<cfset var path = variables.requestObject.getformurlvar('path')>
		<cfset var cntrs = 1>
        <cfset var tclass = arraynew(1)>
		<cfset var navstart = ''>
		<cfif requestObject.isformurlvarset('navstart')>
			<cfset navstart = requestObject.getFormUrlVar('navstart')>
		</cfif>
		<cfset lcl.dhtmlnav = pageref.getDHTMLnav(navstart)>

		<cfsavecontent variable="contents">
			<menu>
			<cfoutput query="lcl.dhtmlnav" group="secondLevelid">
				<item>
					<link>#secondurlpath#</link>
					<label>#secondpagename#</label>
				<cfif thirdurlpath NEQ "">
				<cfset cntrs = 0>
				<cfoutput>
					<item>
						<link>#thirdurlpath#</link>
						<label>#thirdpagename#</label>
					</item>
				</cfoutput>
				</cfif>
				</item>
			</cfoutput>
			</menu>
		</cfsavecontent>

		<cfset contents = rereplace(contents, ">[ \t\r\n]+<","><","all")>	

		<cfreturn contents>
	</cffunction>
	<!--->
	<cffunction name="makeMainNav">
		<cfset var contents = "">
		<cfset var lcl = structnew()>
		<cfset var path = variables.requestObject.getformurlvar('path')>
		<cfset var cntrs = 1>
        <cfset var tclass = arraynew(1)>

		<cfset lcl.dhtmlnav = pageref.getDHTMLnav()>

		<cfsavecontent variable="contents">
			<ul>
			<cfoutput query="lcl.dhtmlnav" group="secondLevelid">
				<li>
					<a href="#secondurlpath#">#secondpagename#</a>
				<cfif thirdurlpath NEQ "">
					<ul>
				<cfset cntrs = 0>
				<cfoutput>
					<li>
						<a href="#thirdurlpath#">#thirdpagename#</a>
					</li>
				</cfoutput>
				</ul>
				</cfif>
				</li>
			</cfoutput>
			</ul>
		</cfsavecontent>

		<cfset contents = rereplace(contents, ">[ \t\r\n]+<","><","all")>	

		<cfreturn contents>
	</cffunction>
	--->
    
	<cffunction name="showHTML">
		
		<cfset var contents = "">
		<cfset var lcl = structnew()>
		<cfset var path = variables.requestObject.getformurlvar('path')>

		<cfif structkeyexists(variables.parameterList, 'dhtmlnav')>
			<cfreturn makeDHTMLNav()>
		<cfelseif structkeyexists(variables.parameterList, 'mainFlashNav')>
			<cfreturn makeMainFlashNav()>
		<cfelseif structkeyexists(variables.parameterList, 'subnav')>
			<cfreturn makeSubNav()>
		<cfelseif structkeyexists(variables.parameterList, 'subnavblob')>
			<cfreturn makeSubNavBlob()>
		<cfelseif structkeyexists(variables.data, 'view') AND variables.data.view EQ 'xmlnav'>
			<cfreturn makexmlnav()>
		<cfelse>
			<cfreturn makeMainNav()>
		</cfif>
		
		<cfreturn contents>
	</cffunction>
</cfcomponent>