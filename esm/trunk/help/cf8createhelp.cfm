<!--- make some pdfs to be included --->
<!--- make the title pdf --->
<cfdocument 
		format="pdf" 
		filename="#requestObject.getVar('machineroot')#help/pdfs/title.pdf" 
		bookmark="true"
		marginleft="1"
		marginright="1"
		margintop="1"
		marginbottom="1"
		overwrite="true">
	<cfdocumentsection name="#module#">
		<cfdocumentitem type="header">
			<style>
				div.header {
					font-size:2em;
					font-family:Verdana, Arial, Helvetica, sans-serif;
					font-weight:bold;		
				}
			</style>
			<div class="header">
				<img src="/help/ui/spirelogo.jpg"/><br/>
			</div>
		</cfdocumentitem>
		<style>
			div.wrap {
				font-size:10px;
				font-family:Verdana, Arial, Helvetica, sans-serif;
			}
			h1{
				font-size:14px;
				font-family:Verdana, Arial, Helvetica, sans-serif;
				font-weight:bold;
			}
			
		</style>
		<div class="wrap">
		Documentation for the Spire ESM
		</div>
	</cfdocumentsection>
</cfdocument>

<cfloop query="menu">
	<cfset  model.load(label)>
	<cfif NOT model.getvar('new')>
		<cfdocument 
					format="pdf" 
					filename="#requestObject.getVar('machineroot')#help/pdfs/#module#.pdf" 
					bookmark="true"
					marginleft="1"
					marginright="1"
					margintop="1"
					marginbottom="1"
					overwrite="true">
			<cfdocumentsection name="#module#">
				<cfdocumentitem type="header">
					<style>
						div.header {
							font-size:10px;
							font-family:Verdana, Arial, Helvetica, sans-serif;
							font-weight:bold;		
						}
					</style>
					<div class="header">
	  					<img src="/help/ui/spirelogo.jpg"/><br/>
						&nbsp;&nbsp;&nbsp;&nbsp;Documentation for <cfoutput>#label#</cfoutput>
					</div>
				</cfdocumentitem>
				<style>
					div.wrap {
						font-size:10px;
						font-family:Verdana, Arial, Helvetica, sans-serif;
						line-height:18px;
					}
					h1{
						font-size:14px;
						font-family:Verdana, Arial, Helvetica, sans-serif;
						font-weight:bold;
					}
					
				</style>
				<div class="wrap">
					<cfoutput>#model.getVar('contents')#</cfoutput>
				</div>
			</cfdocumentsection>
		</cfdocument>
	</cfif>
</cfloop>

<cfsavecontent variable="myddx">
<?xml version="1.0" encoding="UTF-8"?>
<DDX xmlns="http://ns.adobe.com/DDX/1.0/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://ns.adobe.com/DDX/1.0/ coldfusion_ddx.xsd">
<PDF result="Out1">
<PDF source="Title"/>
<!---point of failure--->
<!---<TableOfContents />--->

<cfloop query="menu">
	<cfset model.load(label)>
	<cfif NOT model.getvar('new')>
		<cfoutput><PDF source="#module#"/></cfoutput>
	</cfif>
</cfloop>
</PDF>
</DDX>
</cfsavecontent>

<cfset inputStruct=StructNew()>
<cfset inputStruct.Title="#requestObject.getVar('machineroot')#help/pdfs/title.pdf">
<cfloop query="menu">
	<cfset model.load(label)>
	<cfif NOT model.getvar('new')>
		<cfset inputStruct[module]="#requestObject.getVar('machineroot')#help/pdfs/#module#.pdf">
	</cfif>
</cfloop>

<cfset outputStruct=StructNew()>
<cfset outputStruct.Out1="#requestObject.getVar('machineroot')#help/pdfs/SpireMediaEsmHelp.pdf">

<cfpdf action="processddx" ddxfile="#myddx#" inputfiles="#inputStruct#" outputfiles="#outputStruct#" name="ddxVar">

<cfif ddxVar.out1 EQ "Successful">
	PDF Succesfully generated. <a href="/help/pdfs/SpireMediaEsmHelp.pdf" target="_blank">Download</a>.
<cfelse>
	Error during pdf creation.  Contact your system admin.
</cfif>
