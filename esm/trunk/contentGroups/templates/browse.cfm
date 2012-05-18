<cfsilent>

	<cfset lcl.acc = createWidget('accordion')>
	<cfset lcl.acc.setID('browselist')>
	<cfset lcl.list = getDataItem('list')>
	
	<cfif isdataItemSet('id')>
		<cfset lcl.id = getDataItem('id')>
	<cfelse>
		<cfset lcl.id = 0>
	</cfif>

	<cfset lcl.s = structnew()>
	<cfset lcl.Secondlevelid = "">
	
	<cfif lcl.list.recordcount>
		<cfsavecontent variable="lcl.s.html">
			<div class="nav">
			<ul>
			<cfoutput query="lcl.list">
				<li><a <cfif lcl.id EQ id>class="selected"</cfif> href="/ContentGroups/editContentGroup/?id=#id#">#name#</a></li>
			</cfoutput>
			</ul>
			</div>
		</cfsavecontent>
		<cfset lcl.acc.add('Content Groups',lcl.s.html)>
	<cfelse>
		<cfset lcl.acc.add("No Content Groups Loaded","")>
	</cfif>
</cfsilent>

<cfoutput>#lcl.acc.showHTML()#</cfoutput>


<!--->
<dl class="accordion">
<dt class="selected">C</dt>
<dd>
	<div class="nav">
		<ul>
		<li><a href="/members/?s=55C03BB0-F463-3C22-BB7CAD15AF5FB7A8&amp;l=55B250E0-9779-5C0D-1DDC8177C9B4C8EB&amp;id=976BE4E9-A155-F43E-09A73475B28E0EAD&amp;props" title="Steve Clark &lt;sclark@spiremedia.com&gt;">Steve Clark<span class="informal">sclark@spiremedia.com</span></a></li>
		<li><a href="/members/?s=55C03BB0-F463-3C22-BB7CAD15AF5FB7A8&amp;l=55B250E0-9779-5C0D-1DDC8177C9B4C8EB&amp;id=97CCBB1A-E3EE-827C-AA9FBE521FD45692&amp;props" title="Liz Coldiron &lt;lcoldiron@aorn.org&gt;">Liz Coldiron<span class="informal">lcoldiron@aorn.org</span></a></li>
		<li><a href="/members/?s=55C03BB0-F463-3C22-BB7CAD15AF5FB7A8&amp;l=55B250E0-9779-5C0D-1DDC8177C9B4C8EB&amp;id=FDE80A77-F336-EB33-562A5B4061DF60F8&amp;props" title="Test Content &lt;content@spiremedia.com&gt;">Test Content<span class="informal">content@spiremedia.com</span></a></li>
		</ul>
	</div>
</dd>
<dt>D</dt>
<dd style="display: none;">
	<div class="nav">
		<ul>
		<li><a href="/members/?s=55C03BB0-F463-3C22-BB7CAD15AF5FB7A8&amp;l=55B250E0-9779-5C0D-1DDC8177C9B4C8EB&amp;id=97CDAEE0-F590-7E55-B0863A6B70AEF574&amp;props" title="Tracy Daniel &lt;tdaniel@aorn.org&gt;">Tracy Daniel<span class="informal">tdaniel@aorn.org</span></a></li>
		</ul>
	</div>
</dd>
<dt>H</dt>
<dd style="display: none;">
	<div class="nav">
		<ul>
		<li><a href="/members/?s=55C03BB0-F463-3C22-BB7CAD15AF5FB7A8&amp;l=55B250E0-9779-5C0D-1DDC8177C9B4C8EB&amp;id=69164F51-F8A0-CB64-88CE68577C847368&amp;props" title="Andrew Hawks &lt;andy@spiremedia.com&gt;">Andrew Hawks<span class="informal">andy@spiremedia.com</span></a></li>
		</ul>
	</div>
</dd>
<dt>L</dt>
<dd style="display: none;">
	<div class="nav">
		<ul>
		<li><a href="/members/?s=55C03BB0-F463-3C22-BB7CAD15AF5FB7A8&amp;l=55B250E0-9779-5C0D-1DDC8177C9B4C8EB&amp;id=FCEB8E63-BBF6-D792-227DE0ECA79348C3&amp;props" title="Larry Lee &lt;larry@spiremedia.com&gt;">Larry Lee<span class="informal">larry@spiremedia.com</span></a></li>
		<li><a href="/members/?s=55C03BB0-F463-3C22-BB7CAD15AF5FB7A8&amp;l=55B250E0-9779-5C0D-1DDC8177C9B4C8EB&amp;id=DE73A9E3-C1DF-AE20-D5BD2BF5E422244C&amp;props" title="lkjlkj lkjlkjlkj &lt;andre@spiremedia.com&gt;">lkjlkj lkjlkjlkj<span class="informal">andre@spiremedia.com</span></a></li>
		</ul>
	</div>
</dd>
<dt>M</dt>
<dd style="display: none;">
	<div class="nav">
		<ul>
		<li><a href="/members/?s=55C03BB0-F463-3C22-BB7CAD15AF5FB7A8&amp;l=55B250E0-9779-5C0D-1DDC8177C9B4C8EB&amp;id=49FF4F19-0D8C-F442-F6213265FD9CBA07&amp;props" title="Justina Maierhofer &lt;justina.maierhofer@web.de&gt;">Justina Maierhofer<span class="informal">justina.maierhofer@web.de</span></a></li>
		<li><a href="/members/?s=55C03BB0-F463-3C22-BB7CAD15AF5FB7A8&amp;l=55B250E0-9779-5C0D-1DDC8177C9B4C8EB&amp;id=255782C9-911D-DD32-F3C1893812EDAB59&amp;props" title="Tina Maierhofer &lt;tina@spiremedia.com&gt;">Tina Maierhofer<span class="informal">tina@spiremedia.com</span></a></li>
		<li><a href="/members/?s=55C03BB0-F463-3C22-BB7CAD15AF5FB7A8&amp;l=55B250E0-9779-5C0D-1DDC8177C9B4C8EB&amp;id=990F84A5-915B-8E97-F37CA4AB3AA0C0B7&amp;props" title="Tim Meyers &lt;tmeyers@aorn.org&gt;">Tim Meyers<span class="informal">tmeyers@aorn.org</span></a></li>
		</ul>
	</div>
</dd>
<dt>P</dt>
<dd style="display: none;">
	<div class="nav">
		<ul>
		<li><a href="/members/?s=55C03BB0-F463-3C22-BB7CAD15AF5FB7A8&amp;l=55B250E0-9779-5C0D-1DDC8177C9B4C8EB&amp;id=97CE74B4-987D-0A4C-9411BB7D543F0065&amp;props" title="Justin Pollard &lt;jpollard@aorn.org&gt;">Justin Pollard<span class="informal">jpollard@aorn.org</span></a></li>
		</ul>
	</div>
</dd>
</dl>

	--->