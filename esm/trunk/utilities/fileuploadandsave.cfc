<cfcomponent name="fileuploadandsave">
	<cffunction name="init">
		<cfargument name="target" required="true">
		<cfargument name="sitepath" required="true">
		<cfargument name="file" required="true">
		<cfargument name="filetodelete" required="false">
		
		<cfset var result = ''>
		
		<cfif isdefined('arguments.filetodelete') AND (arguments.filetodelete NEQ "") AND fileexists("#sitepath#docs/#target#/#filetodelete#")>
			<cffile action="delete" file="#sitepath#docs/#target#/#filetodelete#">
		</cfif>
	
		<cffile result="result" action="upload" filefield="#file#" destination="#sitepath#docs/#target#/" nameconflict="makeunique">
		
		<!--- check if filename is valid --->
		<cfif refindnocase("[^a-zA-Z0-9-_]+", result.clientFileName)>
			<cfset tempFile = REReplace(result.clientFileName, "[^a-zA-Z0-9-_]+", "", "ALL")>
			<cfset tempFileExt = result.clientFileExt>
			<!--- check if new filename doesn't already exist --->
			<cfif not fileexists("#sitepath#docs/#target#/#tempFile#.#tempFileExt#")>
				<cffile action="rename" source="#sitepath#docs/#target#/#result.serverFile#" destination="#sitepath#docs/#target#/#tempFile#.#tempFileExt#">
			<cfelse>
				<!--- make filename unique --->
				<cfloop from="1" to="1000" index="i">
					<cfif not fileexists("#sitepath#docs/#target#/#tempFile##i#.#tempFileExt#")>
						<cfset tempFile = "#tempFile##i#">
						<cffile action="rename" source="#sitepath#docs/#target#/#result.serverFile#" destination="#sitepath#docs/#target#/#tempFile#.#tempFileExt#">
						<cfbreak>
					</cfif>
				</cfloop>
			</cfif>
			<cfset result.serverFile = "#tempFile#.#tempFileExt#">
		</cfif> 
		
		<cfset variables.serverFile = result.serverFile>
		<cfset variables.filesize = result.filesize>
		<cfset variables.success = result.filewassaved>

		<cfreturn this>
	</cffunction>
	<cffunction name="success">
		<cfreturn variables.success>
	</cffunction>
	<cffunction name="filesize">
		<cfreturn variables.filesize>
	</cffunction>
	<cffunction name="savedName">
		<cfreturn variables.serverfile>
	</cffunction>
</cfcomponent>