<cfcomponent name="image manipulation model" output="false" extends="resources.abstractmodel">

	<cffunction name="init">
		<cfargument name="request" required="true">
		<cfargument name="userobj" required="true">
		<cfset variables.request = arguments.request>
		<cfset variables.userobj = arguments.userobj>
        <cfset variables.imgmodel = createObject("component","utilities.images.image")>
		<cfreturn this>
	</cffunction>
    
    <cffunction name="getInfo">
		<cfargument name="imgfile" required="true">
        
        <cfset var lcl2 = structnew()>
        <cfset var lcl = variables.imgmodel.getImageInfo("", arguments.imgfile)>

        <!---<cfimage
            action = "info"
            source = "#arguments.imgfile#"
            structname = "lcl.imginfo">--->
        
       	<cfset lcl2.w = lcl.width>
		<cfset lcl2.h = lcl.height>
        
        <cfset lcl2.found = 1>
        
		<cfreturn lcl2>
	</cffunction>
       
    <cffunction name="crop">
		<cfargument name="imgfile" required="true">
        <cfargument name="x" required="true">
        <cfargument name="y" required="true">
        <cfargument name="w" required="true">
        <cfargument name="h" required="true">
      
		<cfset var lcl = structnew()>
        
        <cfset variables.imgmodel.crop("", imgfile, imgfile, x, y, w, h)>
        <!---
        <cfimage source="#imgfile#" name="lcl.myimg">
              
        <cfset ImageCrop(lcl.myimg, x, y, w, h)>
        
		<cfimage source="#lcl.myimg#" action="write" destination="#imgfile#" overwrite="yes">

		<cfimage
            action = "info"
            source = "#lcl.myimg#"
            structname = "lcl.imginfo">
        
       	<cfset lcl2.w = lcl.imginfo.width>
		<cfset lcl2.h = lcl.imginfo.height>
        <cfset lcl2.found = 1>
        --->
		<cfreturn getinfo(imgfile)>
	</cffunction>
    
    <cffunction name="rotate">
		<cfargument name="imgfile" required="true">
        <cfargument name="degrees" required="true">
      
		<cfset var lcl = structnew()>
        
        <cfset variables.imgmodel.rotate("", imgfile, imgfile, degrees)>
        
        <!---<cfimage source="#imgfile#" name="lcl.myimg">--->
          
        <!---<cfimage
            action = "rotate"
            angle = "#degrees#"
            source = "#imgfile#"
            destination="#imgfile#"
            overwrite = "yes">

		<cfimage
            action = "info"
            source = "#imgfile#"
            structname = "lcl.imginfo">
        
       	<cfset lcl2.w = lcl.imginfo.width>
		<cfset lcl2.h = lcl.imginfo.height>
        <cfset lcl2.found = 1>--->
        
		<cfreturn getInfo(imgfile)>
	</cffunction>
    
    <cffunction name="resize">
		<cfargument name="imgfile" required="true">
        <cfargument name="w" required="true">
        <cfargument name="h" required="true">
      	<cfargument name="newimgfile" required="false">
		<cfset var lcl = structnew()>
   		
		<cfif NOT isdefined("arguments.newimgfile")>
			<cfset newimgfile = imgfile>
		</cfif>
		
        <cfset variables.imgmodel.resize("", imgfile, newimgfile, w, h)>
    	
        <!---<cfimage 
         	action="resize" 
            source="#imgfile#" 
            width="#w#"
   	 		height="#h#" 
            destination="#newimgfile#"
            overwrite="yes">
   
		<cfimage
            action = "info"
            source = "#newimgfile#"
            structname = "lcl.imginfo">
        
       	<cfset lcl2.w = lcl.imginfo.width>
		<cfset lcl2.h = lcl.imginfo.height>
        <cfset lcl2.found = 1>--->
        
		<cfreturn getinfo(newimgfile)>
	</cffunction>
	
	<cffunction name="resizetomax">
		<cfargument name="imgfile" required="true">
        <cfargument name="maxw" required="true">
        <cfargument name="maxh" required="true">
      	<cfargument name="newimgfile" required="false">
		
		<cfset var newh = "">
		<cfset var neww = "">
		<cfset var calc = structnew()>
		<cfset var imginfo = "">
		
		<!--- get current size --->
		<cfset imginfo = getInfo(imgfile)>

		<cfset newh = imginfo.h>
		<cfset neww = imginfo.w>
		
		<!--- calculate new size --->
		<!--- <cfif imginfo.w GTE arguments.maxw 
			OR imginfo.h GTE arguments.maxh> --->

			<cfset calc.widthscale = imginfo.w/arguments.maxw>
            <cfset calc.heightscale = imginfo.h/arguments.maxh>
            
            <cfif calc.widthscale GTE calc.heightscale>
                <cfset neww = arguments.maxw>
                <cfset newh = imginfo.h / calc.widthscale>
            <cfelse>
                <cfset newh = arguments.maxh>
                <cfset neww = imginfo.w / calc.heightscale>
            </cfif>
		<!--- </cfif> --->
		<!--- resize (or just rename) --->
		<cfreturn resize(imgfile, neww, newh, newimgfile)>
	</cffunction>
	
</cfcomponent>
	