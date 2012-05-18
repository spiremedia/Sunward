<cfcomponent name="tree" hint="Tree cfc" output="false">

	<cffunction output="false" access="public" name="init">
		<cfargument name="mappings" required="Yes" type="string">
		<cfargument name="groupname" required="Yes" type="string">
		<cfargument name="tablename" required="Yes" type="string">
		<cfargument name="dsn" required="Yes" type="string">
		<cfset variables.mappings = listtoarray(arguments.mappings)>
		<cfset variables.tablename = arguments.tablename>
		<cfset variables.groupname = arguments.groupname>
		<cfset variables.dsn = arguments.dsn>
		<cfset variables.keystringline = 3>
		<cfset variables.debug = 1>
	</cffunction>
	
	<cffunction returntype="string" name="getsortid" output="false">
		<cfargument name="uuid" required="Yes" type="string">
		<cfquery name="me" datasource="#variables.dsn#">
			SELECT tre_id from #variables.tablename# WHERE tre_uuid = <cfqueryparam value="#uuid#" cfsqltype="CF_SQL_VARCHAR">
		</cfquery>
		<cfreturn me.tre_id/>
	</cffunction>
	
	<cffunction access="public" returnType="string" name="Add" output="false">
		<cfargument name="data" required="Yes" type="struct">
		<cfargument name="parent" required="No" type="string" default="">
		<cfset var me = "">
		<cfset var nextid = "">
				
		<cfset nextid = calculatenextid(getsortid(parent))>
		<cfset uuid = createuuid()>
		<!--- <cfoutput>#parent#:#getsortid(parent)#:#nextid#<br></cfoutput> --->		
		<cfquery name="me" datasource="#variables.dsn#">
			INSERT INTO #variables.tablename# (
				tre_uuid,
				tre_id,
				tre_groupname
				<cfloop index="i" from="1" to="#arraylen(variables.mappings)#">
					<cfif structkeyexists(data,variables.mappings[i])>,tre_value#i#</cfif>
				</cfloop>
			) VALUES (
				<cfqueryparam value="#uuid#" cfsqltype="CF_SQL_VARCHAR">,
				<cfqueryparam value="#nextid#" cfsqltype="CF_SQL_VARCHAR">,
				<cfqueryparam value="#variables.groupname#" cfsqltype="CF_SQL_VARCHAR">
				<cfloop index="i" from="1" to="#arraylen(variables.mappings)#">
					<cfif structkeyexists(data,variables.mappings[i])>,<cfqueryparam value="#data[variables.mappings[i]]#" cfsqltype="CF_SQL_VARCHAR"></cfif>
				</cfloop>
			)
		</cfquery>
		
		<cfreturn uuid/>
	</cffunction>

	<cffunction output="false" access="public" name="Edit">
		<cfargument name="data" required="Yes" type="struct">
		<cfargument name="id" required="Yes" type="string">

		<cfset var me = "">
		<cfset var cnt = 1>
		
		<cfquery name="me" datasource="#variables.dsn#">
			UPDATE #variables.tablename# SET 
				<cfloop index="i" from="1" to="#arraylen(variables.mappings)#">
					<cfif structkeyexists(data,variables.mappings[i])>
						<cfif cnt NEQ 1>,</cfif><cfset cnt = cnt + 1>
						tre_value#i# = <cfqueryparam value="#data[variables.mappings[i]]#" cfsqltype="CF_SQL_VARCHAR">
					</cfif>
				</cfloop>
			WHERE tre_groupname = <cfqueryparam value="#variables.groupname#" cfsqltype="CF_SQL_VARCHAR">
			 	AND tre_uuid = <cfqueryparam value="#id#" cfsqltype="CF_SQL_VARCHAR">
		</cfquery>

	</cffunction>
	
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
	
	<cffunction output="false" access="public" name="getuuid">
		<cfargument name="id" required="Yes" type="string">
		<cfset var me = "">
		
		<cfquery name="me" datasource="#variables.dsn#">
			SELECT tre_uuid FROM #variables.tablename#
			WHERE tre_id = <cfqueryparam value="#arguments.id#" cfsqltype="CF_SQL_VARCHAR">
				AND tre_groupname = <cfqueryparam value="#variables.groupname#" cfsqltype="CF_SQL_VARCHAR">
		</cfquery>
		
		<cfreturn me.tre_uuid/>
	</cffunction>
	
	<cffunction access="public"  name="moveToFolder">
		<cfargument name="uuidtomove" required="yes" type="string">
		<cfargument name="targetparentuuid" required="yes" type="string">
		
		<cfset var sortidtomove = getsortid(arguments.uuidtomove)>
		<cfset var moveingiteminfo = getItem(arguments.uuidtomove, 0)>
		<cfset var sortidtargetparentid = getsortid(arguments.targetparentuuid)>
		<cfset var children = getchildren(sortidtomove)>
		<cfset var nextid = calculatenextid(sortidtargetparentid)>
		<cfset var updateid = "">
		
		<cfif arguments.uuidtomove EQ arguments.targetparentuuid>
			<cfthrow message="cannot move an item to itself">
		</cfif>
		
		<!--- first move the first id --->
		<cfquery name="me" datasource="#variables.dsn#">
			UPDATE #variables.tablename# SET
			tre_id = <cfqueryparam value="#nextid#" cfsqltype="cf_sql_varchar">
			WHERE tre_uuid = <cfqueryparam value="#arguments.uuidtomove#" cfsqltype="CF_SQL_VARCHAR">
		</cfquery>
		
		<!--- then its children --->
		<cfloop query="children">
			<cfset updateid = replace(children.tre_id, sortidtomove, nextid)>
			<cfquery name="me" datasource="#variables.dsn#">
				UPDATE #variables.tablename# SET
				tre_id = <cfqueryparam value="#updateid#" cfsqltype="cf_sql_varchar">
				WHERE tre_uuid = <cfqueryparam value="#children.tre_uuid#" cfsqltype="CF_SQL_VARCHAR">
			</cfquery>
		</cfloop>
				
	</cffunction>
	
	<cffunction access="public" name="Moveupdown" output="false">
		<cfargument name="id" required="Yes" type="string">
		<cfargument name="direction" required="Yes" type="string">
		
		<cfset var me = "">
		<cfset var switchwith = "">
		<cfset var thisone = "">
		<cfset var nextone = "">
		<cfset var mybros = "">
		<cfset var thisuuid = "">
		<cfset var nextuuid = "">
		<cfset var sortid = getsortid(id)>
		
		<cfset mybros = variables.getbrothers(sortid,false)><!--- doesnt get brothers kids --->

		<!--- Check for only sibling  --->
		<cfif mybros.recordcount LTE 1>
			<cfreturn/>
		</cfif>
		
		<!--- check if already top --->
		<cfif arguments.direction EQ 'up' AND mybros['tre_id'][1] EQ sortid>
			<cfreturn/>
		</cfif>
		
		<!--- check if already bottom --->
		<cfif arguments.direction EQ 'down' AND mybros['tre_id'][mybros.recordcount] EQ sortid>
			<cfreturn/>
		</cfif>
		
		<!--- sighh, ok move it. --->
		<!--- first figure out which to switch with --->
		<cfloop index="i" from="1" to="#mybros.recordcount#">
			<cfif sortid EQ mybros['tre_id'][i]>
				<cfif arguments.direction EQ 'up'>
					<cfset switchwith = mybros['tre_id'][i-1]>
				<cfelse>
					<cfset switchwith = mybros['tre_id'][i+1]>
				</cfif>
			</cfif>
		</cfloop>
		
		<!--- get the original id and kids --->
		<cfset thisone = variables.getchildren(sortid,0)>
		<cfset thisuuid = getuuid(sortid)>
		
		<!--- get the switchee and kids --->
		<cfset nextone = variables.getchildren(switchwith,0)>
		<cfset nextuuid = getuuid(switchwith)>
		
		<!--- switch the kids of the original --->
		<cfloop query="thisone">
			<cfset tgt = switchwith & RemoveChars(tre_id, 1, len(sortid))>
			<cfset variables.updateidbyuuid(tgt,thisone.tre_uuid)>
		</cfloop>
		<!--- now swith the original --->
		<cfset variables.updateidbyuuid(switchwith,thisuuid)> 
		
		<!--- switch the kids of the switchee --->
		<cfloop query="nextone">
			<cfset tgt = sortid & RemoveChars(tre_id, 1, len(switchwith))>
			<cfset variables.updateidbyuuid(tgt,nextone.tre_uuid)>
		</cfloop>
		<!--- now swith the switchee --->
		<cfset variables.updateidbyuuid(sortid,nextuuid)> 

		<cfreturn/>
	</cffunction>
	
	<cffunction output="false" access="public" returnType="query" name="getParent">
		<cfargument name="id" required="Yes" type="string">
		<cfset var me = "">
		<cfset var sortid = getsortid(id)>
		
		<cfset var ida = listtoarray(sortid,".")>
		
		<cfif arraylen(ida)>
			<cfset ArrayDeleteAt( ida, arraylen(ida) )>
		</cfif>
		
		<cfquery name="me" datasource="#variables.dsn#">
			SELECT
			tre_id,
			tre_uuid
			<cfloop from="1" to="#arraylen(variables.mappings)#" index="i">
				,tre_value#i#
			</cfloop>
			FROM #variables.tablename#
			WHERE tre_groupname = <cfqueryparam value="#variables.groupname#" cfsqltype="CF_SQL_VARCHAR">
				AND tre_id = <cfqueryparam value="#arraytolist(ida,".")#" cfsqltype="CF_SQL_VARCHAR">
			ORDER BY tre_id
		</cfquery>
		
		<cfreturn variables.mapquery(me)/>
	</cffunction>
	
	<cffunction output="false" access="public" returnType="query" name="getParents">
		<cfargument name="id" required="Yes" type="string">
		
		<cfset var sortid = variables.getsortid(id)>
		<cfset var me = "">
		<cfset var stra = arraynew(1)>
		<cfset var str = "">
		<cfset var ida = listtoarray(sortid,".")>

		<cfif arraylen(ida)>
			<cfset ArrayDeleteAt( ida, arraylen(ida) )>
		</cfif>
		
		<cfloop index="i" from="1" to="#arraylen(ida)#">
			<cfset str = "">
			<cfloop index="j" from="1" to="#i#">
				<cfset str = listappend(str,ida[j],'.')>
			</cfloop>
			<cfset arrayappend(stra,"#str#")>
		</cfloop>
		
		<cfquery name="me" datasource="#variables.dsn#">
			SELECT 
			tre_id,
			tre_uuid
			<cfloop from="1" to="#arraylen(variables.mappings)#" index="i">
				,tre_value#i#
			</cfloop>
			FROM #variables.tablename#
			WHERE tre_groupname = <cfqueryparam value="#variables.groupname#" cfsqltype="CF_SQL_VARCHAR">
				AND tre_id IN ('#arraytolist(stra,"','")#')
			ORDER BY tre_id
		</cfquery>
		
		<cfreturn variables.mapquery(me)/>
	</cffunction>
	
	<cffunction output="false" returnType="query" name="getSubItems">
		<cfargument name="id" required="Yes" type="string">
		<cfargument name="level" required="no" type="string" default="0">
		
		<cfset var sortid = getsortid(id)>

		<cfreturn variables.mapquery(variables.getChildren(sortid,arguments.level))/>
	</cffunction>
	
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
	
	<cffunction output="false" name="hasChildren">
		<cfargument name="sortid" type="string">
		<cfargument name="id" type="string">
		
		<cfset var me = "">
		
		<cfif not isdefined("arguments.sortid") AND not isdefined("arguments.id")>
			<cfthrow message="for haschildren, either the sortid or the id must be passed in arguments">
		</cfif>

		<cfquery name="me" datasource="#variables.dsn#" result="mmme">
			SELECT count(m.tre_id) cnt 
			FROM #variables.tablename# m
			<cfif isdefined("arguments.sortid")>
				m.tre_id LIKE <cfqueryparam value="#sortid#____%"  cfsqltype="CF_SQL_VARCHAR">
			<cfelse>
				INNER JOIN #variables.tablename# c ON c.tre_id LIKE m.tre_id + '____'
				WHERE 
					m.tre_uuid = <cfqueryparam value="#arguments.id#"  cfsqltype="CF_SQL_VARCHAR">
					AND c.tre_groupname = <cfqueryparam value="#variables.groupname#">
			</cfif>
			AND m.tre_groupname = <cfqueryparam value="#variables.groupname#">
		</cfquery>
		
		<cfreturn me.cnt>
	</cffunction>
	
	<cffunction output="false" access="public" returnType="query" name="getBrothers">
		<cfargument name="id" required="Yes" type="string">
		<cfargument name="mapme" required="No" type="string" default="1">
		<cfset var me = "">
		<cfset var sibs = "">
		<cfset var re = "">
		<cfset var newq = "">
		<cfset var ida = listtoarray(getsortid(id),".")>
			
		<cfif arraylen(ida)>
			<cfset ArrayDeleteAt( ida, arraylen(ida) )>
		</cfif>
		<cfset sibs = variables.getChildren(arraytolist(ida,"."))>
		<cfset newq = querynew(sibs.columnlist)>
		<cfif arraylen(ida)>
			<cfset re = "^" & arraytolist(ida,"\.") & "\.[0-9]{#variables.keystringline#}" & "$">
		<cfelse>
			<cfset re = "^[0-9]{#variables.keystringline#}" & "$">
		</cfif>

		<cfloop index="i" from="1" to="#sibs.recordcount#">
			<cfif refind(re,sibs.tre_id[i])>
				<cfset Queryaddrow(newq)>
				<cfloop index="col" list="#sibs.columnlist#">
					<cfset querysetcell(newq,col,sibs[col][i])>
				</cfloop>
			</cfif>
		</cfloop>

		<cfif arguments.mapme>
			<cfreturn variables.mapquery(newq)/>	
		<cfelse>
			<cfreturn newq/>	
		</cfif>
	</cffunction>

	<cffunction output="false" access="public" returnType="query" name="gettree">
		<cfargument name="aditl">
		<cfset var me = "">
		<cfparam name="arguments.aditl" default="">
		<cfloop index="i" from="1" to="#arraylen(variables.mappings)#"> 
			<cfset arguments.aditl = replace(arguments.aditl,variables.mappings[i],'tre_value' & i,"all")>
		</cfloop>
		<cfquery name="me" datasource="#variables.dsn#">
			SELECT 
			tre_id,
			tre_uuid
			<cfloop from="1" to="#arraylen(variables.mappings)#" index="i">
				,tre_value#i#
			</cfloop>
			FROM #variables.tablename#
			WHERE tre_groupname = <cfqueryparam value="#variables.groupname#" cfsqltype="cf_sql_varchar">
			<cfif arguments.aditl NEQ "">
				AND #arguments.aditl#	
			</cfif>
			ORDER BY tre_id
		</cfquery>
		
		<cfreturn variables.mapquery(me)/>
	</cffunction>
	
	<cffunction output="false" access="public" returnType="query" name="getitem">
		<cfargument name="id">
		<cfargument name="map" required="false" default="1">
		<cfset var me = "">
		<cfset var i = "">
		<!--- <cfset var sortid = getsortid(id)> --->
		<cfquery name="me" datasource="#variables.dsn#">
			SELECT 
			tre_id,
			tre_uuid
			<cfloop from="1" to="#arraylen(variables.mappings)#" index="i">
				,tre_value#i#
			</cfloop>
			FROM #variables.tablename#
			WHERE tre_uuid = <cfqueryparam value="#arguments.id#">
				AND tre_groupname = <cfqueryparam value="#variables.groupname#">
		</cfquery>
		
		<cfif arguments.map>
			<cfreturn variables.mapquery(me)/>
		<cfelse>
			<cfreturn me/>
		</cfif>
	</cffunction>
	
	<cffunction output="false" access="public" name="deletetree">
		<cfset var me = "">
		
		<cfquery name="me" datasource="#variables.dsn#">
			DELETE FROM #variables.tablename# WHERE tre_groupname = <cfqueryparam value="#variables.groupname#">
		</cfquery>
		
	</cffunction>
	
	<cffunction output="false" access="public" name="delete">
		<cfargument name="id">
		<cfset var me = "">
		
		<cfif variables.getSubItems(id).recordcount>
			<cfreturn "This item has children">
		</cfif>
		
		<cfquery name="me" datasource="#variables.dsn#">
			DELETE FROM #variables.tablename# WHERE tre_groupname = <cfqueryparam value="#variables.groupname#" cfsqltype="CF_SQL_VARCHAR">
				AND tre_uuid = <cfqueryparam value="#id#" cfsqltype="CF_SQL_VARCHAR">
 		</cfquery>
		
		<cfreturn "1"/>
	</cffunction>
	
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
	
	<cffunction output="false" access="public" returnType="query" name="search">
		<cfargument name="criteria" required="yes">
		<cfargument name="field" default="all">
		<cfset var me = "">
		<cfset var i = "">
	
		<!-- 20070708 DRE only tested with field = id -->
		<cfquery name="me" datasource="#variables.dsn#">
			SELECT tre_id,
			tre_uuid
			<cfloop from="1" to="#arraylen(variables.mappings)#" index="i">
				,tre_value#i#
			</cfloop>
			FROM #variables.tablename#
			WHERE 
				<cfif arguments.field EQ "all">
					(<cfloop list="1,2,3,4,5" index="i">
						<cfif i NEQ 1>,</cfif>
						tre_value#i# LIKE <cfqueryparam value="%#arguments.criteria#%" cfsqltype="CF_SQL_VARCHAR">
					</cfloop>)
				<cfelse>
					tre_value#listfind(arraytolist(variables.mappings),arguments.field)# = <cfqueryparam value="#arguments.criteria#" cfsqltype="CF_SQL_VARCHAR">
				</cfif>
				AND tre_groupname = <cfqueryparam value="#variables.groupname#" cfsqltype="CF_SQL_VARCHAR">
		</cfquery>
		
		<cfreturn mapquery(me)/>
	</cffunction>

</cfcomponent>