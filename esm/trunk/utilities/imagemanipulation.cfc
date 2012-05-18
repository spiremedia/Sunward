<cfcomponent name="asset model" output="false" extends="resources.abstractmodel">

	<cffunction name="init">
		<cfargument name="request" required="true">
		<cfargument name="userobj" required="true">
		<cfset variables.request = arguments.request>
		<cfset variables.userobj = arguments.userobj>
		<cfreturn this>
	</cffunction>
    
    <cffunction name="getInfo">
		<cfargument name="imgfile" required="true">
        
        <cfset var lcl = structnew()>
		<cfset var lcl2 = structnew()>
        <cfimage
            action = "info"
            source = "#arguments.imgfile#"
            structname = "lcl.imginfo">
        
       	<cfset lcl2.w = lcl.imginfo.width>
		<cfset lcl2.h = lcl.imginfo.height>
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
        
		<cfreturn lcl2>
	</cffunction>
    
    <cffunction name="rotate">
		<cfargument name="imgfile" required="true">
        <cfargument name="degrees" required="true">
      
		<cfset var lcl = structnew()>
        
        <!---<cfimage source="#imgfile#" name="lcl.myimg">--->
          
        <cfimage
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
        <cfset lcl2.found = 1>
        
		<cfreturn lcl2>
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
	
        <cfimage 
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
        <cfset lcl2.found = 1>
        
		<cfreturn lcl2>
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
	