
<style type="text/css">
	<!--
	#hideAll {
	position:absolute;
	left:287px;
	top:132px;
	width:567px;
	height:331px;
	z-index:1;
	visibility: hidden;
	}
	#aboutUs {
	position:absolute;
	left:290px;
	top:132px;
	z-index:2;
	background-color: #2E5162;
	visibility: hidden;
	}
	#products {
	position:absolute;
	left:364px;
	top:132px;
	z-index:3;
	background-color: #2E5162;
	visibility: hidden;
	}
	#dealsSales {
	position:absolute;
	left:437px;
	top:132px;
	z-index:4;
	background-color: #2E5162;
	visibility: hidden;
	}
	#qualityFeatures {
	position:absolute;
	left:526px;
	top:132px;
	z-index:5;
	background-color: #2E5162;
	visibility: hidden;
	}
	#dealerships {
	position:absolute;
	left:638px;
	top:132px;
	z-index:6;
	background-color: #2E5162;
	visibility: hidden;
	}
	#contactUs {
	position:absolute;
	left:737px;
	top:132px;
	z-index:7;
	background-color: #2E5162;
	visibility: hidden;
	}
	-->
</style>

<script type="text/JavaScript">
	<!--
	function restoreImage() { //v3.0
		var i,x,a=document.MM_sr;
		for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) {
			x.src=x.oSrc;
		}
	}
	
	function MM_preloadImages() { //v3.0
		var d=document;
		if(d.images) {
			if(!d.MM_p) d.MM_p=new Array();
			var i,j=d.MM_p.length,a=MM_preloadImages.arguments;
			for(i=0; i<a.length; i++) {
				if (a[i].indexOf("#")!=0) {
					d.MM_p[j]=new Image;
					d.MM_p[j++].src=a[i];
				}
			}
		}
	}
	
	function MM_findObj(n, d) { //v4.01
		var p,i,x;
		if(!d) d=document;
		if((p=n.indexOf("?"))>0&&parent.frames.length) {
			d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);
		}
		if(!(x=d[n])&&d.all) x=d.all[n];
		for (i=0;!x&&i<d.forms.length;i++) 
			x=d.forms[i][n];
			
		for(i=0;!x&&d.layers&&i<d.layers.length;i++) 
			x=MM_findObj(n,d.layers[i].document);		
		
		if(!x && d.getElementById)
			x=d.getElementById(n);	
		
		return x;
	}
	
	function MM_swapImage() { //v3.0
		var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
		if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
	}

	function MM_showHideLayers() { //v6.0
		var i,p,v,obj,args=MM_showHideLayers.arguments;
		for (i=0; i<(args.length-2); i+=3) if ((obj=MM_findObj(args[i]))!=null) { v=args[i+2];
		if (obj.style) { obj=obj.style; v=(v=='show')?'visible':(v=='hide')?'hidden':v; }
		obj.visibility=v; }
	}
//-->
</script>

<body onLoad="MM_preloadImages(	'/ui/img/buttons/btn_history_over.png',
								'/ui/img/buttons/btn_factories_over.png',
								'/ui/img/buttons/btn_mission_over.png',
								'/ui/img/buttons/btn_marketing_over.png',
								'/ui/img/buttons/btn_agriculture_over.png',
								'/ui/img/buttons/btn_utilityShops_over.png',
								'/ui/img/buttons/btn_barnsRiding_over.png',
								'/ui/img/buttons/btn_AviationAircraft_over.png',
								'/ui/img/buttons/btn_miniWarehouses_over.png',
								'/ui/img/buttons/btn_retail_over.png',
								'/ui/img/buttons/btn_industrial_over.png',
								'/ui/img/buttons/btn_customDesigns_over.png',
								'/ui/img/buttons/btn_certifications_over.png',
								'/ui/img/buttons/btn_expressionQuality_over.png',
								'/ui/img/buttons/btn_aisc_over.png',
								'/ui/img/buttons/btn_findADealer_over.png',
								'/ui/img/buttons/btn_dealershipOpportunities_over.png',
								'/ui/img/buttons/btn_contactForm_over.png',
								'/ui/img/buttons/btn_contactInfo_over.png')">

	<div id="hideAll" onMouseOver="MM_showHideLayers('hideAll','','hide','aboutUs','','hide','products','','hide','dealsSales','','hide','qualityFeatures','','hide','dealerships','','hide','contactUs','','hide')"><img src="file:///U|/PiT/s/Sunward/DEV/client/trunk/ui/img/transparent.gif" width="100%" height="100%"></div>
	
	<div id="aboutUs">
		<a href="/AboutUs/History/"
				onMouseOut="restoreImage()"
				onMouseOver="MM_swapImage('historyNav','','/ui/img/buttons/btn_history_over.png',1)">
			<img src="/ui/img/buttons/btn_history.png" name="historyNav"/>		</a><br/>
		<a href="/AboutUs/Factories/"
				onMouseOut="restoreImage()"
				onMouseOver="MM_swapImage('factoriesNav','','/ui/img/buttons/btn_factories_over.png',1)">
			<img src="/ui/img/buttons/btn_factories.png" name="factoriesNav"/>
		</a><br/>
		<a href="/AboutUs/MissionStatement/"
				onMouseOut="restoreImage()"
				onMouseOver="MM_swapImage('missionNav','','/ui/img/buttons/btn_mission_over.png',1)">
			<img src="/ui/img/buttons/btn_mission.png" name="missionNav"/>
		</a><br/>
		<a href="/AboutUs/Marketing/"
				onMouseOut="restoreImage()"
				onMouseOver="MM_swapImage('marketingNav','','/ui/img/buttons/btn_marketing_over.png',1)">
			<img src="/ui/img/buttons/btn_marketing.png" name="marketingNav"/>
		</a>
</div>
	
	<div id="products">
		<a href="/Products/Agriculture/"
				onMouseOut="restoreImage()"
				onMouseOver="MM_swapImage('agricultureNav','','/ui/img/buttons/btn_agriculture_over.png',1)">
			<img src="/ui/img/buttons/btn_agriculture.png" name="agricultureNav"/>		</a><br/>
		<a href="/Products/UtilityShops/"
				onMouseOut="restoreImage()"
				onMouseOver="MM_swapImage('utilityShopsNav','','/ui/img/buttons/btn_utilityShops_over.png',1)">
			<img src="/ui/img/buttons/btn_utilityShops.png" name="utilityShopsNav"/>
		</a><br/>
		<a href="/Products/BarnsAndRidingArena/"
				onMouseOut="restoreImage()"
				onMouseOver="MM_swapImage('barnesRidingNav','','/ui/img/buttons/btn_barnsRiding_over.png',1)">
			<img src="/ui/img/buttons/btn_barnsRiding.png" name="barnesRidingNav"/>
		</a><br/>
		<a href="/Products/AviationAircraftHangars/"
				onMouseOut="restoreImage()"
				onMouseOver="MM_swapImage('aviationAircraftNav','','/ui/img/buttons/btn_AviationAircraft_over.png',1)">
			<img src="/ui/img/buttons/btn_AviationAircraft.png" name="aviationAircraftNav"/>
		</a><br/>
		<a href="/Products/MiniWarehouses/"
				onMouseOut="restoreImage()"
				onMouseOver="MM_swapImage('miniWarehousesNav','','/ui/img/buttons/btn_miniWarehouses_over.png',1)">
			<img src="/ui/img/buttons/btn_miniWarehouses.png" name="miniWarehousesNav"/>
		</a><br/>
		<a href="/Products/Retail/"
				onMouseOut="restoreImage()"
				onMouseOver="MM_swapImage('retailNav','','/ui/img/buttons/btn_retail_over.png',1)">
			<img src="/ui/img/buttons/btn_retail.png" name="retailNav"/>
		</a><br/>
		<a href="/Products/Industrial/"
				onMouseOut="restoreImage()"
				onMouseOver="MM_swapImage('industrialNav','','/ui/img/buttons/btn_industrial_over.png',1)">
			<img src="/ui/img/buttons/btn_industrial.png" name="industrialNav"/>
		</a><br/>
		<a href="/Products/CustomDesigns/"
				onMouseOut="restoreImage()"
				onMouseOver="MM_swapImage('customDesignsNav','','/ui/img/buttons/btn_customDesigns_over.png',1)">
			<img src="/ui/img/buttons/btn_customDesigns.png" name="customDesignsNav"/>
		</a>
</div>
	
	<div id="dealsSales"></div>
	
	<div id="qualityFeatures">
		<a href="/QualityFeatures/Certifications/"
				onMouseOut="restoreImage()"
				onMouseOver="MM_swapImage('certificationsNav','','/ui/img/buttons/btn_certifications_over.png',1)">
			<img src="/ui/img/buttons/btn_certifications.png" name="certificationsNav"/>		</a><br/>
		<a href="/QualityFeatures/ExpressionOfQuality/"
				onMouseOut="restoreImage()"
				onMouseOver="MM_swapImage('expressionQualityNav','','/ui/img/buttons/btn_expressionQuality_over.png',1)">
			<img src="/ui/img/buttons/btn_expressionQuality.png" name="expressionQualityNav">
		</a><br/>
		<a href="/QualityFeatures/AISC/"
				onMouseOut="restoreImage()"
				onMouseOver="MM_swapImage('aiscNav','','/ui/img/buttons/btn_aisc_over.png',1)">
			<img src="/ui/img/buttons/btn_aisc.png" name="aiscNav"/>
		</a>
</div>
	
	<div id="dealerships">
		<a href="/Dealerships/FindADealer/"
				onMouseOut="restoreImage()"
				onMouseOver="MM_swapImage('findDealerNav','','/ui/img/buttons/btn_findADealer_over.png',1)">
			<img src="/ui/img/buttons/btn_findADealer.png" name="findDealerNav">		</a><br/>
		<a href="/Dealerships/DealershipOpportunities/"
				onMouseOut="restoreImage()"
				onMouseOver="MM_swapImage('dealershipOpportunitiesNav','','/ui/img/buttons/btn_dealershipOpportunities_over.png',1)">
			<img src="/ui/img/buttons/btn_dealershipOpportunities.png" name="dealershipOpportunitiesNav"/>
		</a>
</div>
	
	<div id="contactUs">
		<a href="/ContactUs/ContactForm/"
				onMouseOut="restoreImage()"
				onMouseOver="MM_swapImage('conactFormNav','','/ui/img/buttons/btn_contactForm_over.png',1)">
			<img src="/ui/img/buttons/btn_contactForm.png" name="conactFormNav"/>		</a><br/>
		<a href="/ContactUs/FrequentlyAskedQuestions/"
				onMouseOut="restoreImage()"
				onMouseOver="MM_swapImage('faqNav','','/ui/img/buttons/btn_faq_over.png',0)">
			<img src="/ui/img/buttons/btn_faq.png" name="faqNav"/>
		</a><br/>
		<a href="/ContactUs/Directions/"
				onMouseOut="restoreImage()"
				onMouseOver="MM_swapImage('directionsNav','','/ui/img/buttons/btn_contactInfo_over.png',1)">
			<img src="/ui/img/buttons/btn_contactInfo.png" name="directionsNav"/>
		</a>
</div>
	
	<div id="headerNav">
	
		<ul>
			<li><div class="nav">
				<a href="/AboutUs/"
					onmouseover="document.images.btnImg_about.src='/ui/img/buttons/btn_about_over.png';MM_showHideLayers('hideAll','','show','aboutUs','','show','products','','hide','dealsSales','','hide','qualityFeatures','','hide','dealerships','','hide','contactUs','','hide')"
					onmouseout="document.images.btnImg_about.src='/ui/img/buttons/btn_about.png'">
				<img src="/ui/img/buttons/btn_about.png" alt="" name="btnImg_about"/></a>
			</div>
			</li>
			
			<li><div class="nav">
				<a href="/Products/"
					onmouseover="document.images.btnImg_products.src='/ui/img/buttons/btn_products_over.png';MM_showHideLayers('hideAll','','show','aboutUs','','hide','products','','show','dealsSales','','hide','qualityFeatures','','hide','dealerships','','hide','contactUs','','hide')"
					onmouseout="document.images.btnImg_products.src='/ui/img/buttons/btn_products.png'">
				<img src="/ui/img/buttons/btn_products.png" alt="" name="btnImg_products" /></a>
			</div>
			</li>
			
			<li><div class="nav">
				<a href="/Dealerships/"
					onmouseover="document.images.btnImg_dealerships.src='/ui/img/buttons/btn_dealerships_over.png';MM_showHideLayers('hideAll','','hide','aboutUs','','hide','products','','hide','dealsSales','','hide','qualityFeatures','','hide','dealerships','','hide','contactUs','','hide')"
					onmouseout="document.images.btnImg_dealerships.src='/ui/img/buttons/btn_dealerships.png'">
				<img src="/ui/img/buttons/btn_dealerships.png" alt="" name="btnImg_dealerships" /></a>
			</div>
			</li>
			
			<li><div class="nav">
				<a href="/QualityFeatures/"
					onmouseover="document.images.btnImg_features.src='/ui/img/buttons/btn_features_over.png';MM_showHideLayers('hideAll','','show','aboutUs','','hide','products','','hide','dealsSales','','hide','qualityFeatures','','show','dealerships','','hide','contactUs','','hide')"
					onmouseout="document.images.btnImg_features.src='/ui/img/buttons/btn_features.png'">
				<img src="/ui/img/buttons/btn_features.png" alt="" name="btnImg_features" /></a>
			</div>
			</li>
			
			<li><div class="nav">
				<a href="/DealsAndSales/"
					onmouseover="document.images.btnImg_dealsSales.src='/ui/img/buttons/btn_dealsSales_over.png';MM_showHideLayers('hideAll','','show','aboutUs','','hide','products','','hide','dealsSales','','hide','qualityFeatures','','hide','dealerships','','show','contactUs','','hide')"
					onmouseout="document.images.btnImg_dealsSales.src='/ui/img/buttons/btn_dealsSales.png'">
				<img src="/ui/img/buttons/btn_dealsSales.png" alt="" name="btnImg_dealsSales" /></a>
			</div>
			</li>
			
			<li><div class="nav">
				<a href="/ContactUs/"
					onmouseover="document.images.btnImg_contact.src='/ui/img/buttons/btn_contact_over.png';MM_showHideLayers('hideAll','','show','aboutUs','','hide','products','','hide','dealsSales','','hide','qualityFeatures','','hide','dealerships','','hide','contactUs','','show')"
					onmouseout="document.images.btnImg_contact.src='/ui/img/buttons/btn_contact.png'">
				<img src="/ui/img/buttons/btn_contact.png" alt="" name="btnImg_contact" /></a>
			</div>
			</li>
			
			<li><div class="nav">
				<a href="/Home/"
					onmouseover="document.images.btnImg_home.src='/ui/img/buttons/btn_home_over.png';MM_showHideLayers('hideAll','','hide','aboutUs','','hide','products','','hide','dealsSales','','hide','qualityFeatures','','hide','dealerships','','hide','contactUs','','hide')"
					onmouseout="document.images.btnImg_home.src='/ui/img/buttons/btn_home.png'">
				<img name="btnImg_home" src="/ui/img/buttons/btn_home.png" alt="" /></a>
			</div>
			</li>
		</ul>
	
	</div>
	
</body>