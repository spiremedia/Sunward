
<cfdocument
    filename="#requestObject.getVar('machineroot')#help/pdfs/SpireMediaEsmHelp.pdf"
    marginleft="1"
    marginright="1"
    margintop="1"
    marginbottom="1"	
    backgroundvisible="yes"
    format = "PDF"
    orientation = "landscape"
    pageType = "Letter"
    unit = "in"
    overwrite="true">
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
    <cfdocumentItem type= "header">
        <style>
            div.header {
                font-size:2em;
                font-family:Verdana, Arial, Helvetica, sans-serif;
                font-weight:bold;		
                
            }
        </style>
        <div class="header">
            <img src="/help/ui/spirelogo.jpg"/><br/>
            ESM Documentation
        </div>
    </cfdocumentitem>
    
    <cfdocumentItem type="footer">
        <cfoutput>#cfdocument.currentpagenumber# of #cfdocument.totalpagecount#</cfoutput>
    </cfdocumentitem>


    <div class="wrap">
        <cfloop query="menu">
            <cfset  model.load(label)>
            <cfif NOT model.getvar('new')>
               <!--- <cfdocumentItem type= "pagebreak"/>--->
                <cfoutput>-#model.getVar('contents')#-</cfoutput>
            </cfif>
        </cfloop>
    </div>
</cfdocument>
			
		PDF Succesfully generated. <a href="/help/pdfs/SpireMediaEsmHelp.pdf" target="_blank">Download</a>.