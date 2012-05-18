<cfcomponent name="wordparser">

	<cffunction name="init">
		<!---<cfargument name="requestObject">
		<cfset variables.requestObj = arguments.requestObject>--->
        <cfset variables.words = structnew()>
		<cfreturn this>
	</cffunction>
    
	<cffunction name="loadString">
    	<cfargument name="str" required="true">
		<cfset var lcl = structnew()>
        
		<cfset lcl.words = structnew()>
        
        <cfset str = rereplace(str, "[^a-zA-Z0-9\_\, ]", "", "all")>
        <cfset str = replace(str, ",", " ", "all")>

        <cfloop list="#str#" delimiters=" " index="lcl.idx">
        	<cfset addword(lcl.idx)>
        </cfloop>
        
		<cfset structappend(variables.words, lcl.words)>
	</cffunction>
    
    <cffunction name="loadList">
    	<cfargument name="list" required="true">
		
		<cfset var lcl = structnew()>
      
        <cfset lcl.words = structnew()>
    
        <cfset list = rereplace(list, "[^a-zA-Z0-9\_ ,]", "", "all")>

        <cfloop list="#list#" delimiters="," index="lcl.idx">
        	<cfset addword(lcl.idx)>
        </cfloop>
        
		<cfset structappend(variables.words, lcl.words)>
	</cffunction>
    
    <cffunction name="addWord">
    	<cfargument name="word">
        
        <cfif isnumeric(word)>
        	<cfreturn>
        </cfif>
        
        <cfif structkeyexists(variables.words, word)>
        	<cfset variables.words[word] = variables.words[word] + 1>
        <cfelse>
			<cfset variables.words[word] = 1>
        </cfif>
    </cffunction>
    
	<cffunction name="getWords">
    	<cfargument name="mode" default="query">
    	<cfset var itm = "">
        <cfset var idx = "">
        <cfset var ro = "return object">
    	<cfset tmp = "">
		<cfset stripwords()>
      
        <cfswitch expression="#mode#">
        	
            <cfcase value="query">
        		<cfset ro = querynew("word,cnt")>
                <cfloop collection="#variables.words#" item="idx">
                    <cfset queryaddrow(ro)>
                    <cfset querysetcell(ro, "word", idx)>
                    <cfset querysetcell(ro, "cnt", variables.words[idx])>
                </cfloop>
                <cfreturn ro>
            </cfcase>
            
            <cfcase value="array">
        		<cfset ro = arraynew(1)>
                <cfloop collection="#variables.words#" item="idx">
                    <cfset tmp = structnew()>
                    <cfset tmp.word = idx>
                    <cfset tmp.cnt = variables.words[idx]>
					<cfset arrayappend(ro,tmp)>
                </cfloop>
                <cfreturn ro>
            </cfcase>
            
            <cfcase value="struct">
        		<cfreturn variables.words>
            </cfcase>

        </cfswitch>
	</cffunction>
    
	<cffunction name="stripwords">
    	<cfset var idx = "">
  		<cfset var stopwords = "all,I,a,and,description,many,page,key,about,an,are,as,at,be,by,com,de,en,for,from,how,in,is,it,la,of,on,or,that,the,this,to,was,what,when,where,who,will,with,und,them,www">
        <cfloop list="#stopwords#" index="idx">
			<cfset structdelete(variables.words, idx)>
        </cfloop>
    </cffunction>
    
</cfcomponent>