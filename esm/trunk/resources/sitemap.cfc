<cfcomponent name="sitemap" hint="Tree cfc" output="false">

	<cffunction output="false" access="public" name="init">
		<cfargument name="siteid" required="Yes" type="string">
		<cfargument name="dsn" required="Yes" type="string">		
		<cfset variables.siteid = arguments.siteid>
		<cfset variables.dsn = arguments.dsn>
		<cfset variables.tablename = 'sitepages_view'>
		<cfset variables.debug = 1>
		<cfset variables.fieldlist = 'id,sort,siteid,parentid,pagename,pageurl,title,description,summary,innavigation,template,keywords,ownerid,status,urlpath,relocate,membertypes,subsite,showdate,hidedate,searchindexable'>
	</cffunction>
	
	<!---
	<cffunction returntype="string" name="getsortid" output="false">
		<cfargument name="uuid" required="Yes" type="string">
		<cfquery name="me" datasource="#variables.dsn#">
			SELECT id from sitepages WHERE tre_uuid = <cfqueryparam value="#uuid#" cfsqltype="CF_SQL_VARCHAR">
		</cfquery>
		<cfreturn me.tre_id/>
	</cffunction>
	--->
	
	<cffunction name="setinfo">
		<cfargument name="data">
		<cfset variables.pagedata = arguments.data>
	</cffunction>
	
	<cffunction access="public" returnType="string" name="Add" output="false">

		<cfset var me = "">
		<cfset var nextsort = "">
		<cfset var id = "">
				
		<cfset nextsort = getNextSortid(variables.pageData.parentid)>

		<cfset id = createuuid()>
		
		<!--- <cfoutput>#parent#:#getsortid(parent)#:#nextid#<br></cfoutput> --->		
		<cfparam name="variables.pageData.innavigation" default="0">
		<cfparam name="variables.pageData.subsite" default="0">
        <cfparam name="variables.pageData.searchindexable" default="0">
	
		
		<cfif NOT isBoolean(variables.pageData.subsite)>
			<cfset variables.pageData.subsite = 0>
		</cfif>

		<cfquery name="me" datasource="#variables.dsn#">
			INSERT INTO #variables.tablename# (
				id,
				sort,
				siteid,
				pagename,
				pageurl,
				title,
				description,
				keywords,
				summary,
				<cfif structkeyexists(variables.pagedata, "ownerid")>
                	ownerid,
                </cfif>
				parentid,
				status,
				modifiedby,
				modifieddate,
				template,
				innavigation,
				relocate,
               membertypes,
				
				subsite,
				
				showdate,
				hidedate,
                searchindexable
			) VALUES (
				<cfqueryparam value="#id#" cfsqltype="CF_SQL_VARCHAR">,
				<cfqueryparam value="#nextsort#" cfsqltype="CF_SQL_VARCHAR">,
				<cfqueryparam value="#variables.siteid#" cfsqltype="CF_SQL_VARCHAR">,
				<cfqueryparam value="#variables.pageData.pagename#" cfsqltype="CF_SQL_VARCHAR">,
				<cfqueryparam value="#variables.pageData.pageurl#" cfsqltype="CF_SQL_VARCHAR">,
				<cfqueryparam value="#variables.pageData.title#" cfsqltype="CF_SQL_VARCHAR">,
				<cfqueryparam value="#variables.pageData.description#" cfsqltype="CF_SQL_VARCHAR">,
				<cfqueryparam value="#variables.pageData.keywords#" cfsqltype="CF_SQL_VARCHAR">,
				<cfqueryparam value="#variables.pageData.summary#" cfsqltype="CF_SQL_VARCHAR">,
				<cfif structkeyexists(variables.pagedata, "ownerid")>
                	<cfqueryparam value="#variables.pageData.ownerid#" cfsqltype="CF_SQL_VARCHAR">,
                </cfif>
				<cfqueryparam value="#variables.pageData.parentid#" cfsqltype="CF_SQL_VARCHAR">,
				<cfqueryparam value="Draft" cfsqltype="CF_SQL_VARCHAR">,
				<cfqueryparam value="#variables.pageData.modifiedby#" cfsqltype="CF_SQL_VARCHAR">,
				<cfqueryparam value="#variables.pageData.modifieddate#" cfsqltype="CF_SQL_TIMESTAMP">,
				<cfqueryparam value="#variables.pageData.template#" cfsqltype="CF_SQL_VARCHAR">,
				<cfqueryparam value="#variables.pageData.innavigation#" cfsqltype="CF_SQL_INTEGER">,
				<cfqueryparam value="#variables.pageData.relocate#" cfsqltype="CF_SQL_VARCHAR">,
                <cfqueryparam value="#variables.pageData.membertypes#" cfsqltype="CF_SQL_VARCHAR">,
                <cfqueryparam value="#variables.pageData.subsite#" cfsqltype="CF_SQL_INTEGER">,
				
				<cfqueryparam value="#variables.pageData.showdate#" null="#variables.pageData.showdate EQ ""#" cfsqltype="CF_SQL_VARCHAR">,
				<cfqueryparam value="#variables.pageData.hidedate#" null="#variables.pageData.hidedate EQ ""#" cfsqltype="CF_SQL_VARCHAR">,
                <cfqueryparam value="#variables.pageData.searchindexable#" cfsqltype="CF_SQL_INTEGER">
                
			)
		</cfquery>
		
		<cfreturn id/>
	</cffunction>
	
	<cffunction name="validate">
		<cfargument name="vdtr">
		<cfset data = variables.pageData>
		<cfset vdtr.notblank('pagename', data.pagename,'page name is required')>
		<cfset vdtr.notblank('title', data.title,'Title is required')>
		<cfset vdtr.notblank('description', data.description,'description is required')>
		<cfset vdtr.notblank('keywords', data.keywords,'keywords is required')>
		<cfreturn vdtr/>
	</cffunction>

	<cffunction output="false" access="public" name="Edit">
		<cfset var me = "">
		<cfset var cnt = 1>
		<cfparam name="variables.pageData.innavigation" default="0">
		<cfparam name="variables.pageData.subsite" default="0">
	
		<cfparam name="variables.pageData.searchindexable" default="0">
        
		<cfif NOT isBoolean(variables.pageData.subsite)>
			<cfset variables.pageData.subsite = 0>
		</cfif>
		
		<cfquery name="me" datasource="#variables.dsn#">
			UPDATE #variables.tablename# SET 
				pagename = <cfqueryparam value="#variables.pageData.pagename#" cfsqltype="CF_SQL_VARCHAR">,
				pageurl = <cfqueryparam value="#variables.pageData.pageurl#" cfsqltype="CF_SQL_VARCHAR">,
				title = <cfqueryparam value="#variables.pageData.title#" cfsqltype="CF_SQL_VARCHAR">,
				description = <cfqueryparam value="#variables.pageData.description#" cfsqltype="CF_SQL_VARCHAR">,
				keywords = <cfqueryparam value="#variables.pageData.keywords#" cfsqltype="CF_SQL_VARCHAR">,
				summary = <cfqueryparam value="#variables.pageData.summary#" cfsqltype="CF_SQL_VARCHAR">,
				innavigation = <cfqueryparam value="#variables.pageData.innavigation#" cfsqltype="CF_SQL_INTEGER">,
				ownerid = <cfqueryparam value="#variables.pageData.ownerid#" cfsqltype="CF_SQL_VARCHAR">,
				template = <cfqueryparam value="#variables.pageData.template#" cfsqltype="CF_SQL_VARCHAR">,
				parentid = <cfqueryparam value="#variables.pageData.parentid#" cfsqltype="CF_SQL_VARCHAR">,
				relocate = <cfqueryparam value="#variables.pageData.relocate#" cfsqltype="CF_SQL_VARCHAR">,
                membertypes = <cfqueryparam value="#variables.pageData.membertypes#" cfsqltype="CF_SQL_VARCHAR">,
				subsite = <cfqueryparam value="#variables.pageData.subsite#" cfsqltype="CF_SQL_INTEGER">,
				
				showdate = <cfqueryparam value="#variables.pageData.showdate#" null="#variables.pageData.showdate EQ ""#" cfsqltype="CF_SQL_VARCHAR">,
				hidedate = <cfqueryparam value="#variables.pageData.hidedate#" null="#variables.pageData.hidedate EQ ""#"cfsqltype="CF_SQL_VARCHAR">,
                searchindexable = <cfqueryparam value="#variables.pageData.searchindexable#" cfsqltype="CF_SQL_INTEGER">
                
			WHERE siteid = <cfqueryparam value="#variables.siteid#" cfsqltype="CF_SQL_VARCHAR">
			 	AND id = <cfqueryparam value="#variables.pageData.id#" cfsqltype="CF_SQL_VARCHAR">
		</cfquery>

	</cffunction>
	
	<!---
	<cffunction output="false" access="public" name="updateidbyuuid">
		<cfargument name="newid" required="Yes" type="string">
		<cfargument name="uuid" required="Yes" type="string">
		<cfset var me = "">
		
		<cfquery name="me" datasource="#variables.dsn#">
			UPDATE #variables.tablename# SET 
				tre_id = <cfqueryparam value="#arguments.newid#" cfsqltype="CF_SQL_VARCHAR">
			WHERE tre_uuid = <cfqueryparam value="#arguments.uuid#" cfsqltype="CF_SQL_VARCHAR">
		</cfquery>
		
		<cfreturn 1/>
	</cffunction>

	<cffunction output="false" access="public" name="calculatenextid">
		<cfargument name="parent" required="Yes" type="string">
		
		<cfset var mykids = variables.getChildren(parent,1)>
		<cfset var nextid = "">
		
		<!--- tre_id is a string so will not sort right, turn it into an array and sort that --->
		<cfset var ids = arraynew(1)>
		<cfloop query="mykids">
			<cfset arrayappend(ids,listlast(mykids.tre_id,"."))>
		</cfloop>
		<cfset arraysort(ids,'numeric')>
	
		<!--- determine the next one --->
		<cfif arraylen(ids)>
			<cfset nextid = arraymax(ids) + 1>
		<cfelse>
			<cfset nextid = 1>
		</cfif>
		
		<!--- padd with zeroes --->
		<cfset nextid = RepeatString("0", variables.keystringline-len(nextid)) & nextid>
		
		<cfset nextid = listappend(parent,nextid,".")>		
		
		<cfreturn nextid/>
	</cffunction>
	--->
	
	<cffunction access="private" name="getNextSortId">
		<cfargument name="parentid" required="Yes" type="string">
	
		<cfset var nextid = "">
		
		<cfquery name="me" datasource="#variables.dsn#">
			SELECT max(sort) m FROM #variables.tablename#
			WHERE 
				<cfif arguments.parentid EQ 'null' OR arguments.parentid EQ ''>
					parentid IS null
				<cfelse>
					parentid = <cfqueryparam value="#arguments.parentid#" cfsqltype="CF_SQL_VARCHAR">
				</cfif>
				AND siteid = <cfqueryparam value="#variables.siteid#" cfsqltype="CF_SQL_VARCHAR">
		</cfquery>
		
		<cfif me.m EQ "">
			<cfset nextid = 1>
		<cfelse>
			<cfset nextid = me.m + 1>
		</cfif>
		
		<cfreturn nextid/>
	</cffunction>

	<cffunction access="public"  name="moveToFolder">
		<cfargument name="idtomove" required="yes" type="string">
		<cfargument name="targetparentid" required="yes" type="string">
		
		<cfset var nextsortid = getNextSortId(targetparentid)>
		<cfset var me = "">
		
		<!-- first check targetparent is valid -->	
		<cfquery name="me" datasource="#variables.dsn#">
			SELECT COUNT(*) c FROM sitepages
			WHERE id = <cfqueryparam value="#targetparentid#" cfsqltype="cf_sql_varchar">
		</cfquery>

		<cfif me.c EQ 0>
			<cfthrow message="invalid targetparentid in movetofolder">
		</cfif>
		
		<cfquery name="me" datasource="#variables.dsn#">
			UPDATE sitepages SET
				parentid = <cfqueryparam value="#arguments.targetparentid#" cfsqltype="cf_sql_varchar">,
				sort = <cfqueryparam value="#nextsortid#" cfsqltype="cf_sql_varchar">
			WHERE id = <cfqueryparam value="#arguments.idtomove#" cfsqltype="CF_SQL_VARCHAR">
		</cfquery>
				
	</cffunction>
	
	<cffunction access="public" name="Moveupdown" output="false">
		<cfargument name="id" required="Yes" type="string">
		<cfargument name="direction" required="Yes" type="string">
		
		<cfset var current = "">
		<cfset var switchwith = "">
		<cfset var updateoriginal = "">
		<cfset var updateswitchwith = "">
		<cfset var switchinfo = structnew()>
		
		<cfquery name="current" datasource="#variables.dsn#">
			SELECT
			id,
			sort,
			parentid,
			title
			FROM #variables.tablename#
			WHERE id = <cfqueryparam value="#arguments.id#" cfsqltype="CF_SQL_VARCHAR">
				AND siteid = <cfqueryparam value="#variables.siteid#" cfsqltype="CF_SQL_VARCHAR">
		</cfquery>
		
		<cfdump var=#current#>
		
		<cfif current.recordcount EQ 0>
			<cfthrow message="Target switch id '#arguments.id#' not found">
		</cfif>
		
		
		
		<cfquery name="switchwith" datasource="#variables.dsn#" result="m">
			SELECT top 1
			id,
			sort
			FROM #variables.tablename#
			WHERE sort <cfif arguments.direction EQ 'up'> < <cfelse> > </cfif> <cfqueryparam value="#current.sort#" cfsqltype="CF_SQL_VARCHAR">
				AND parentid = <cfqueryparam value="#current.parentid#" cfsqltype="CF_SQL_VARCHAR">
				AND siteid = <cfqueryparam value="#variables.siteid#" cfsqltype="CF_SQL_VARCHAR">
			ORDER BY sort <cfif arguments.direction EQ 'up'> DESC <cfelse> ASC </cfif>
		</cfquery>
			
		<cfif switchwith.recordcount EQ 0>	
			<cfdump var=#m#><cfabort>
			<!---<cfthrow message="could not find switchwith">--->
			<cfreturn>
		</cfif>
		
		<cfset switchinfo.currentsort = current.sort>
		<cfset switchinfo.currentid = current.id>
		<cfset switchinfo.switchsort = switchwith.sort>
		<cfset switchinfo.switchid = switchwith.id>
		
		<cfquery name="updateoriginal" datasource="#variables.dsn#">
			UPDATE #variables.tablename#
			SET sort = <cfqueryparam value="#switchinfo.switchsort#" cfsqltype="CF_SQL_VARCHAR">
			WHERE id = <cfqueryparam value="#switchinfo.currentid#" cfsqltype="CF_SQL_VARCHAR">
				AND siteid = <cfqueryparam value="#variables.siteid#" cfsqltype="CF_SQL_VARCHAR">
		</cfquery>
		
		<cfquery name="updateswitchwith" datasource="#variables.dsn#">
			UPDATE #variables.tablename#
			SET sort = <cfqueryparam value="#switchinfo.currentsort#" cfsqltype="CF_SQL_VARCHAR">
			WHERE id = <cfqueryparam value="#switchinfo.switchid#" cfsqltype="CF_SQL_VARCHAR">
				AND siteid = <cfqueryparam value="#variables.siteid#" cfsqltype="CF_SQL_VARCHAR">
		</cfquery>
		
		<cfreturn/>
	</cffunction>
	
	<cffunction output="false" access="public" returnType="query" name="getParent">
		<cfargument name="id" required="Yes" type="string">
		<cfset var me = "">
		
		<cfquery name="me" datasource="#variables.dsn#" result="mmme">
			SELECT b.#replace(variables.fieldlist,",",",b.","all")# 
			FROM #variables.tablename# b
			INNER JOIN #variables.tablename# c ON b.id = c.parentid
			WHERE 
				c.id = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_varchar">
				AND b.siteid = <cfqueryparam value="#variables.siteid#" cfsqltype="cf_sql_varchar">
		</cfquery>
	
		<cfreturn me/>
	</cffunction>
	
	<cffunction output="false" access="public" returnType="query" name="getParents">
		<cfargument name="id" required="Yes" type="string">
		
		<cfset var fld = "">
		<cfset var q = querynew(variables.fieldlist)>
		<cfset var countlimit = 0>
		<cfset var parent = getParent(arguments.id)>
		
		<cfloop condition="parent.recordcount">
			<cfset queryaddrow(q)>
			<cfloop list="#variables.fieldlist#" index="fld">
				<cfset querysetcell(q,fld,parent[fld][1])>
			</cfloop>
			<cfset parent = getParent(parent.id)>
		</cfloop>
		
		<cfreturn q/>
	</cffunction>
	
	<cffunction output="false" returnType="query" name="getChildren">
		<cfargument name="parentid" required="Yes" type="string">
	
		<cfquery name="me" datasource="#variables.dsn#">
			SELECT
				#variables.fieldlist#
			FROM #variables.tablename#
			WHERE 
				<cfif arguments.parentid EQ 'null' OR arguments.parentid EQ "">
					(parentid IS NULL
					OR parentid = '')
				<cfelse>
					parentid = <cfqueryparam value="#arguments.parentid#" cfsqltype="CF_SQL_VARCHAR">
				</cfif>
				AND siteid = <cfqueryparam value="#variables.siteid#" cfsqltype="CF_SQL_VARCHAR">
			ORDER BY sort
		</cfquery>

		<cfreturn me>
	</cffunction>
    
	<!---
	<cffunction output="false" returnType="query" name="getChildren">
		<cfargument name="sortid" required="Yes" type="string">
		<cfargument name="level" required="no" type="string" default="0">
		<cfset var me = "">
		<cfset var re = "">
		<cfset var newq = "">
		<cfset ida = listtoarray(sortid,".")>

		<cfquery name="me" datasource="#variables.dsn#">
			SELECT
			tre_id,
			tre_uuid
			<cfloop from="1" to="#arraylen(variables.mappings)#" index="i">
				,tre_value#i#
			</cfloop>
			FROM #variables.tablename#
			WHERE tre_groupname = <cfqueryparam value="#variables.groupname#">
			<cfif sortid NEQ "">
				AND tre_id LIKE <cfqueryparam value="#sortid#.%"  cfsqltype="CF_SQL_VARCHAR">
				
			</cfif>
			ORDER BY tre_id
		</cfquery>
		<!--- AND len(tre_id) = #len(sortid) + variables.keystringline + 1# --->
		
		<cfif arguments.level EQ 0>
			<cfreturn me/>
		</cfif>

		<cfset newq = querynew(me.columnlist)>
		
		<cfif arraylen(ida)>
			<cfset re = "^" & arraytolist(ida,"\.") & "\.[0-9]{#variables.keystringline#}" & "$">
		<cfelse>
			<cfset re = "^[0-9]{#variables.keystringline#}" & "$">
		</cfif>

		<cfloop index="i" from="1" to="#me.recordcount#">
			<cfif refind(re,me.tre_id[i])>
				<cfset Queryaddrow(newq)>
				<cfloop index="col" list="#me.columnlist#">
					<cfset querysetcell(newq,col,me[col][i])>
				</cfloop>
			</cfif>
		</cfloop>
		<cfreturn newq/>
	</cffunction>
	--->
    
	<cffunction output="false" name="hasChildren">
		<cfargument name="id" type="string">
		
		<cfquery name="me" datasource="#variables.dsn#" result="mmme">
			SELECT count(id) cnt 
			FROM #variables.tablename# 
			WHERE 
				parentid = <cfqueryparam value="#arguments.id#"  cfsqltype="CF_SQL_VARCHAR">
				AND siteid = <cfqueryparam value="#variables.siteid#">
		</cfquery>
		
		<cfreturn me.cnt>
	</cffunction>
	
	<cffunction output="false" access="public" returnType="query" name="getBrothers">
		<cfargument name="id" required="Yes" type="string">
		
		<cfset var me = "">
		
		<cfquery name="me" datasource="#variables.dsn#" >
			SELECT b.#replace(variables.fieldlist,",",",b.","all")# 
			FROM #variables.tablename# b
			INNER JOIN #variables.tablename# c
			WHERE 
				b.parentid = c.parentid
				AND b.id <> c.id
				AND m.siteid = <cfqueryparam value="#variables.siteid#">
			ORDER BY b.sort
		</cfquery>
		
	</cffunction>

	<cffunction output="false" access="public" name="getTree">
		<cfargument name="security" required="true">
		<cfargument name="formatter" required="true">
		<cfargument name="startid" default="null">
		
		<cfset var temp = structnew()>
		<cfset var itm = "">
		<cfset var item = "">
		<cfset var depth = 0>
		<cfset variables.groupcount = 1>
		
		<cfif startid NEQ 'null'>
			<cfset formatter.preGroup(depth, variables.groupcount)>
			<cfset item = getItem(startid)>

			<cfloop list="#variables.fieldlist#" index="itm">
				<cfset temp[itm] = item[itm][1]>
			</cfloop>
			
			<cfset formatter.preItem(temp, depth, variables.groupcount, 1)>
			<cfset formatter.Item(temp, depth, variables.groupcount, 1)>
		</cfif>
		
		<cfset subTree( security = security,
						formatter = formatter, 
						parentid = startid, 
						depth = depth)>
						
		<cfif startid NEQ 'null'>
			<cfset formatter.postItem(temp, depth, variables.groupcount, 1)>
			<cfset formatter.postGroup(depth)>
		</cfif>
		
		<cfreturn formatter.render()/>
	</cffunction>
		
	<cffunction name="subtree" access="private">
		<cfargument name="security" required="true">
		<cfargument name="formatter" required="true">
		<cfargument name="parentid">
		<cfargument name="depth">
		
		<cfset var item = getChildren(arguments.parentid)>
		<cfset var itemcount = 0>

		<cfif item.recordcount>
			<cfset depth = depth + 1>
			<cfset variables.groupcount = variables.groupcount + 1>
	
			<cfset formatter.preGroup(depth, variables.groupcount)>
			
			<cfloop query="item">
				<cfset itemcount = itemcount + 1>
				<cfset temp = structnew()>
				
				<cfloop list="#variables.fieldlist#" index="itm">
					<cfset temp[itm] = item[itm][currentrow]>
				</cfloop>
				
				<cfset formatter.preItem(temp, depth, variables.groupcount, itemcount)>
				<cfset formatter.Item(temp, depth, variables.groupcount, itemcount)>
				<cfset subTree(security = security, 
								formatter = formatter, 
								parentid = temp.id, 
								depth = depth)>
				
				<cfset formatter.postItem(temp, depth, variables.groupcount, itemcount)>
			</cfloop>
			
			<cfset formatter.postGroup(depth)>
		</cfif>
	</cffunction>

	<cffunction output="false" access="public" returnType="query" name="getTopItem">
		<cfargument name="id" required="no" default="">
		<cfquery name="me" datasource="#variables.dsn#" result="mmme">
			SELECT #variables.fieldlist# 
			FROM #variables.tablename# 
			WHERE 
				<cfif arguments.id EQ 'null' OR arguments.id EQ "">
					(parentid is null  OR parentid = '')
				<cfelse>
					id = <cfqueryparam value="#arguments.id#" cfsqltype="CF_SQL_VARCHAR">
				</cfif>
				AND siteid = <cfqueryparam value="#variables.siteid#">
		</cfquery>
		
		<cfreturn me>
	</cffunction>
	
	<cffunction output="false" access="public" returnType="query" name="getitem">
		<cfargument name="id">
		<cfset var me = "">
		<cfset var why = "">
		
		<cfquery name="me" datasource="#variables.dsn#" result="why">
			SELECT 
			#variables.fieldlist#
			FROM #variables.tablename#
			WHERE id = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_varchar">
				AND siteid = <cfqueryparam value="#variables.siteid#">
		</cfquery>
	
		<cfreturn me/>
	</cffunction>
	
	<cffunction output="false" access="public" name="getPath">
		<cfargument name="id">
		
		<cfset var path = ''>
		<cfset var path2 = arraynew(1)>
		<cfset var parents = getParents(arguments.id)>
		<cfset var item = getItem(arguments.id)>
		<cfset var itmcntr = "">
		
		<cfif item.recordcount EQ 0>
			<cthrow message="Could not find '#id#' at getpath">
		</cfif>
		
		<cfset path = listtoarray(valuelist(parents.pageurl))>
		
		<cfloop from="#arraylen(path)#" to="1" step="-1" index="itmcntr">
			<cfset arrayappend(path2,path[itmcntr])>
		</cfloop>
		
		<cfset arrayappend(path2,item.pageurl)>
		
		<!--- <cfloop from="1" to="#arraylen(path2)#" index="itmcntr">
			<cfset path2[itmcntr] = rereplace(path2[itmcntr],"[^a-zA-Z0-9]","","all")>
		</cfloop> --->
		
		<cfreturn arraytolist(path2,"/") & '/'>
	</cffunction>
	
	<cffunction output="false" access="public" name="deletetree">
		<cfset var me = "">
		
		<cfquery name="me" datasource="#variables.dsn#">
			DELETE FROM #variables.tablename# WHERE siteid = <cfqueryparam value="#variables.siteid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		
	</cffunction>
	
	<cffunction output="false" access="public" name="delete">
		<cfargument name="id">
		<cfset var me = "">
		
		<cfset var c = variables.getchildren(id)>
		<cfif c.recordcount>
			<cfreturn "This item has children">
		</cfif>
		
		<cfquery name="me" datasource="#variables.dsn#">
			DELETE FROM #variables.tablename# WHERE 
				 id = <cfqueryparam value="#arguments.id#" cfsqltype="CF_SQL_VARCHAR">
 		</cfquery>
		<!--- TODO : Readd this.  Site should delete both published and staged. Or redo delete to be virtual.
		siteid = <cfqueryparam value="#variables.siteid#" cfsqltype="CF_SQL_VARCHAR"> --->
		
		<cfreturn "1"/>
	</cffunction>
	
	<!---
	<cffunction output="false" access="public" name="setinfo">
		<cfargument name="mappings" required="Yes" type="string">
		<cfargument name="groupname" required="Yes" type="string">
		<cfset variables.mappings = listtoarray(mappings)>
		<cfset variables.groupname = groupname>
		<cfreturn/>
	</cffunction>
	
	<cffunction output="false" access="public" returnType="query" name="mapquery">
		<cfargument name="qin" type="query" required="yes">
		<cfset var qout = "">
		<cfset var level = "">
		<cfset var levelindex = 0>
		<cfset var levelbefore = "">
		<cfset var nextlevel = "">
		<cfset var levelafter = "">
		<cfset var startlevel = "">
		
		<cfif variables.debug>
			<cfset qout = querynew("hid,id,levelindex,levelbefore,levelafter,#arraytolist(variables.mappings,",")#")>
		<cfelse>
			<cfset qout = querynew("id,levelindex,levelbefore,levelafter,#arraytolist(variables.mappings,",")#")>
		</cfif>
		<cfif qin.recordcount>
			<cfset startlevel = listlen(qin['tre_id'][1],".")-1>
		</cfif>
		
		<cfloop index="i" from="1" to="#qin.recordcount#">
			<cfset QueryAddRow(qout)>
			<!--- set the id --->
			<cfset querysetcell(qout,"id",qin['tre_uuid'][i])>
			<cfif variables.debug>
				<cfset querysetcell(qout,"hid",qin['tre_id'][i])>
			</cfif>
			<!--- set the fields --->
			<cfloop index="j" from="1" to="#arraylen(variables.mappings)#">
				<cfset querysetcell( qout, variables.mappings[ j ], qin[ 'tre_value' & j ][ i ])>
			</cfloop>
			<!--- calculate the positive indentation --->
			<cfset thislevel = listlen(qin['tre_id'][i],".")>
			<cfif thislevel GT level>
				<cfset levelbefore = "+">
			<cfelse>
				<cfset levelbefore = "">
			</cfif>
			<cfset level = thislevel>
			<!--- nextlevel calculation --->
			<cfif qin.recordcount EQ i>
				<cfset nextlevel = startlevel>
			<cfelse>
				<cfset nextlevel = listlen(qin['tre_id'][i+1],".")>
			</cfif>
			<!--- calculate the negative indentation --->
			<cfif thislevel GT nextlevel >
				<cfset levelafter = RepeatString('-', thislevel - nextlevel)>
			<cfelse>
				<cfset levelafter = ""> 
			</cfif>
			<!--- calculate the level index --->
			<cfset levelindex = levelindex + len(levelbefore)>
			<cfif i NEQ 1>
				<cfset levelindex = levelindex - len(qout['levelafter'][i-1])>
			</cfif>
			<!--- now save it --->
			<cfset querysetcell( qout, 'levelbefore', levelbefore)>
			<cfset querysetcell( qout, 'levelafter', levelafter)>
			<cfset querysetcell( qout, 'levelindex', levelindex)>
		</cfloop>

		<cfreturn qout/>
	</cffunction>
	--->
	<cffunction output="false" access="public" returnType="query" name="search">
		<cfargument name="criteria" required="yes">
		<cfargument name="field" default="all">
		<cfset var me = "">
		<cfset var itm = "">
	
		<cfquery name="me" datasource="#variables.dsn#">
			SELECT #variables.fieldlist#
			FROM #variables.tablename#
			WHERE 
				siteid = <cfqueryparam value="#variables.siteid#" cfsqltype="cf_sql_varchar">
				AND
				<cfif arguments.field EQ "all">
					(<cfloop list="#variables.fieldlist#" index="itm">
						<cfif itm NEQ 'id'>OR </cfif>
						#itm# LIKE <cfqueryparam value="%#arguments.criteria#%" cfsqltype="CF_SQL_VARCHAR">
					</cfloop>)
				<cfelse>
					#arguments.field# = <cfqueryparam value="#arguments.criteria#" cfsqltype="CF_SQL_VARCHAR">
				</cfif>
		</cfquery>
		
		<cfreturn me/>
	</cffunction>
	
	<cffunction name="dump">
		<cfset var me = "">
		<cfquery name="me" datasource="#variables.dsn#">
			SELECT #variables.fieldlist#
			FROM #variables.tablename#
			WHERE siteid = <cfqueryparam value="#variables.siteid#" cfsqltype="cf_sql_varchar">
			ORDER BY parentid,sort
		</cfquery>
		<cfdump var=#me#>
	</cffunction>

</cfcomponent>