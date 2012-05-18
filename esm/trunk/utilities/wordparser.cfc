<cfcomponent name="wordparser">

	<cffunction name="init">
        <cfset variables.words = structnew()>
        <cfset variables.phrases = structnew()>
  
		<cfreturn this>
	</cffunction>
    
	<cffunction name="loadString">
    	<cfargument name="str" required="true">
        
		<cfset var lcl = structnew()>
        <cfset var itm = "">
        
		<cfset lcl.words = structnew()>
        
        <cfset str = rereplace(str, "[^a-zA-Z0-9\_\, ]", "", "all")>
        <cfset str = replace(str, ",", " ", "all")>
        
        <cfloop collection="#variables.phrases#" item="lcl.itm">
        	<cfset lcl.p = findnocase(lcl.itm, arguments.str)>
    
        	<cfloop condition="lcl.p">
				<cfset foundword(lcl.itm)>
                <cfset lcl.p = findnocase(lcl.itm, arguments.str, lcl.p + 1)>
			</cfloop> 
        </cfloop>

        <cfloop list="#str#" delimiters=" " index="lcl.idx">
        	<cfset foundword(lcl.idx)>
        </cfloop>
        
		<cfset structappend(variables.words, lcl.words)>
	</cffunction>
    
    <cffunction name="loadList">
    	<cfargument name="list" required="true">
		
		<cfset var lcl = structnew()>
      
        <cfset lcl.words = structnew()>
    
        <cfset list = rereplace(list, "[^a-zA-Z0-9\_ ,]", "", "all")>

        <cfloop list="#list#" delimiters="," index="lcl.idx">
        	<cfset foundword(lcl.idx)>
        </cfloop>
        
		<cfset structappend(variables.words, lcl.words)>
	</cffunction>
    
    <cffunction name="foundWord">
    	<cfargument name="word">
        <cfargument name="cnt" default="1">
        
        <cfif isnumeric(word)>
        	<cfreturn>
        </cfif>
        
        <cfif structkeyexists(variables.words, word)>
        	<cfset variables.words[word].cnt = variables.words[word].cnt + arguments.cnt>
        <cfelse>
			<cfset variables.words[word] = structnew()>
            <cfset variables.words[word].cnt = arguments.cnt>
        </cfif>
    </cffunction>
    
    <cffunction name="addPhrase">
    	<cfargument name="phrase">
        
        <cfif isnumeric(phrase)>
        	<cfreturn>
        </cfif>
        
        <cfif structkeyexists(variables.phrases, phrase)>
        	<cfset variables.phrases[phrase] = variables.phrases[phrase] + 1>
        <cfelse>
			<cfset variables.phrases[phrase] = 1>
        </cfif>
    </cffunction>
    
	<cffunction name="getWords">
    	<cfargument name="mode" default="query">
    	<cfset var itm = "">
        <cfset var idx = "">
        <cfset var ro = "return object">
    	<cfset tmp = "">
		
		<cfset stripwords()>
        <cfset countwords()>
		       
        <cfswitch expression="#mode#">
        	
            <cfcase value="query">
        		<cfset ro = querynew("word,cnt,pct")>
                <cfloop collection="#variables.words#" item="idx">
                    <cfset queryaddrow(ro)>
                    <cfset querysetcell(ro, "word", idx)>
                    <cfset querysetcell(ro, "cnt", variables.words[idx].cnt)>
                    <cfset querysetcell(ro, "pct", variables.words[idx].pct)>
                </cfloop>
                <cfreturn ro>
            </cfcase>
            
            <cfcase value="array">
        		<cfset ro = arraynew(1)>
                <cfloop collection="#variables.words#" item="idx">
                    <cfset tmp = structnew()>
                    <cfset tmp.word = idx>
                    <cfset tmp.cnt = variables.words[idx].cnt>
                    <cfset tmp.pct = variables.words[idx].pct>
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
  		<cfset var stopwords = "actuall,all,I,a,and,but,description,many,page,key,about,an,there,dont,same,so,us,around,do,have,we,are,over,here,as,at,be,by,com,de,en,for,from,how,in,is,it,la,of,on,or,that,the,this,to,your,was,what,would,when,nbsp,where,who,will,with,und,them,www">
        <cfloop list="#stopwords#" index="idx">
			<cfset structdelete(variables.words, idx)>
        </cfloop>
    </cffunction>
    
    <cffunction name="countwords">
    	<cfset var idx = "">
  		<cfset var tot = 0>
        <cfloop collection="#variables.words#" item="idx">
        	<cfset tot = tot + variables.words[idx].cnt>
        </cfloop>
        
        <cfif tot EQ 0>
        	<cfloop collection="#variables.words#" item="idx">
                <cfset variables.words[idx].pct = 0>
            </cfloop>
        <cfelse>
            <cfloop collection="#variables.words#" item="idx">
                <cfset variables.words[idx].pct = decimalformat(100*variables.words[idx].cnt / tot)>
            </cfloop>
        </cfif>
        
    </cffunction>
    
</cfcomponent>