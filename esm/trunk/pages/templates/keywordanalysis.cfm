<cfoutput>
<input type="button" value="Calculate" onclick="$('analysis').innerHTML = 'Calculating';ajaxWResponseJsCaller('/pages/keywordanalysis/','id=#getDataItem("id")#')"/>
</cfoutput>
<div id="analysis" style="padding:3px;"></div>