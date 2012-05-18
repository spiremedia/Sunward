<cfcomponent name="tinymce">
	
	<cffunction name="init">
		<cfargument name="name">
		<cfargument name="id">
		<cfargument name="style">
		<cfargument name="value">
		<cfargument name="addtlInfo" default="#structnew()#">
		<cfargument name="formRef">
		<cfset structappend(variables, arguments)>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="setInfo">
		<!--- This is required by template runner --->
	</cffunction>	
	
	<cffunction name="show">
		<cfset variables.formRef.addUnique('tinyhead', getHead())>
		<cfreturn showForm()>
	</cffunction>
	
	<cffunction name="getHead">
		<cfset var head = ''>
		
		<cfsetting showdebugoutput=false>
		<cfsavecontent variable="head">
			<script language="javascript" type="text/javascript" src="/ui/tiny_mce/tiny_mce.js"></script>
			<script language="javascript" type="text/javascript">
			tinyMCE.init({
				mode : "textareas", 
			    editor_selector : "myconfig", 
			   	theme : "advanced",  
			   	<!--- theme_advanced_buttons1 : "bold,underline, bullist,numlist,outdent,indent",
			    theme_advanced_buttons2 : "bold,underline", 
			    theme_advanced_buttons3 : "pastetext,pasteword,selectall",--->
			    theme_advanced_buttons1 : "bold,italic,underline,strikethrough,|,justifyleft,justifycenter,justifyright,styleselect,formatselect",
				theme_advanced_buttons2 : "cut,copy,paste,pastetext,pasteword,|,bullist,numlist,|,outdent,indent,blockquote,|,undo,redo,|,link,unlink,anchor,image,media,cleanup,help,code",
				theme_advanced_buttons3 : "hr,removeformat,visualaid,sub,sup,|,charmap",
			    plugins : "paste,table,advimage,autosave,media",
				content_css : "/ui/css/tmce.css<cfif structkeyexists(variables.addtlinfo, 'csslink')>,#variables.addtlinfo.csslink#</cfif>",
		
			    add_form_submit_trigger : true,
			    <cfif structkeyexists(variables.addtlinfo, 'jslinklist')>
			    external_link_list_url : "#variables.addtlinfo.jslinklist#",
			    <cfelse>
				external_link_list_url : "/tinymce/showJSPageList/",
				</cfif>
				<cfif structkeyexists(variables.addtlinfo, 'jsimagelist')>
				external_image_list_url : "#variables.addtlinfo.jsimagelist#",
				<cfelse>
				external_image_list_url : "/tinymce/showJSImageList/",
				</cfif>
				convert_urls : false,
				theme_advanced_buttons3_add : "tablecontrols"<!---,
				table_styles : "Header 1=header1;Header 2=header2;Header 3=header3",
				table_cell_styles : "Header 1=header1;Header 2=header2;Header 3=header3;Table Cell=tableCel1",
				table_row_styles : "Header 1=header1;Header 2=header2;Header 3=header3;Table Row=tableRow1",
				table_cell_limit : 100,
				table_row_limit : 5,
				table_col_limit : 5--->
			});
			</script>
		</cfsavecontent>
		<cfreturn head>
	</cffunction>
	
	<cffunction name="showform">
		<cfparam name="variables.addtlinfo.style" default="width:650px">

		<cfreturn '<textarea class="myconfig" name="#variables.name#" #variables.addtlinfo.style# id="#variables.id#">#variables.value#</textarea>'><!--->#chr(13)##chr(10)#<script>tinyMCE.execCommand("mceAddControl", true, "#variables.id#");</script>'>--->
	</cffunction>

</cfcomponent>