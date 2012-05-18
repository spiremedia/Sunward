<cfcomponent  
	displayname="String Utils"
	hint='<fusedoc fuse="" language="ColdFusion" version="2.0">
			<responsibilities>
				A strings utility object
			</responsibilities>
			<properties>
				<history date="2006-01-10" author="Matthew Gaddis" email="matthew@spiremedia.com" type="create" role="architect">
					Refactored from com.spiremedia.string and com.spiremedia.cms.text
				</history>
			</properties>
		</fusedoc>'>
	<cffunction name="init" 
		access="public" 
		output=false
		returntype="any" 
		hint='<fusedoc fuse="" language="ColdFusion" version="2.0">
			<responsibilities>
				Provides an itialized instance of this object
			</responsibilities>
			<properties>
				<history date="2006-01-24" author="Matthew Gaddis" email="matthew@spiremedia.com" type="create" role="architect" />
			</properties>
			<io>
				<in></in>
				<out>
					<object />
				</out>
			</io>
		</fusedoc>'>
		<!--- init code --->
		<cfreturn this>
	</cffunction>
	
	
	<cffunction 
		name="createUnique" 
		access="public" 
		output=true 
		returntype="string" 
		hint='<fusedoc fuse="" language="ColdFusion" version="2.0">
				<responsibilities>
					Uses an algorithm similar to the one CF uses when resolving
					file name conflicts from http form post file uploads to create 
					a unique valued string.
					This function will use up to 10 digits for an increment value.
					The [arguments.strIn] value will be truncated to {arguments.intLength} less 10 
					(to ensure there is room for the digit sequence)
				</responsibilities>
				<properties>
					<history date="2006-04-18" author="Matthew Gaddis" email="matthew@spiremedia.com" type="create" role="architect" />
				</properties>
				<io>
					<in>
						<string name="strIn" optional="false" />
						<numeric name="intLength" optional="true" default="100" />
					</in>
					<out>
						<string />
					</out>
				</io>
			</fusedoc>'>
		<!--- function code --->
		<cfargument name="strIn" required=true type="string">
		<cfargument name="intLength" required=false type="numeric" default="100" hint="This is the maximum length of a string that createUnique will return.">
		
		<cfset var match  = ReFind('\d{1,10}$', strIn, 1, true)>
		<cfset var strOut = ''>
		

		
		<cfscript>
			/*/////////////////////////////////////////////////
			///
			///	Basic string structure (in regex)
			///	.{,arguments.intLength - 10}\d{1,10}
			/// 1. Part 1 - a string of any characters up to {arguments.intLength - 10}
			///		The reason for this length behavior is to leave room for the 10 digits that are concatinated and 
			///		then incremented.
			///	2. Part 2 - a sequece of 10 digits that are first concatinated to [arguments.strIn]
			/// 	and then incremented once there are 10 digits
			/*/
		
			if(match.len[1] lt 10)
			{
				if(match.pos[1] gt 0)
				{
					strOut = Left
					(
						Mid
						(
							arguments.strIn, 
							1, 
							match.pos[1] - 1
						), 
						arguments.intLength - 10
					) & 
					Mid
					(
						arguments.strIn,
						match.pos[1],
						match.len[1]
					) & '1';
				}
				else
				{
					strOut = Left(arguments.strIn, arguments.intLength - 10) & '1';
				}
				
			}
			else
			{
				strOut = ReReplace
				(
					arguments.strIn, 
					'\d{10}$', 
					(
						Mid
						(
							arguments.strIn, 
							match.pos[1], 
							match.len[1]
						)
					) + 1
				);
			}
			return strOut;
		</cfscript>
	</cffunction>
	
	
	<cffunction 
		name="getTidy" 
		access="public" 
		output=false 
		returntype="any" 
		hint='<fusedoc fuse="" language="ColdFusion" version="2.0">
				<responsibilities>
					Will return a Java org.w3c.tidy.Tidy object. 
					If the object could not be instantiated this will return "false"
					JTidy JavaDoc path: 
					~\resources\docs\jtidy-04aug2000r7-dev\
				</responsibilities>
				<properties>
					<history date="2006-04-12" author="Matthew Gaddis" email="matthew@spiremedia.com" type="create" role="architect" />
					<dependancies>
						<functional>
							<asset>
								<artifact abstract-type="generic" name="Tidy.jar">
									File can be in any one of the following locations:
									1. {cfroot}/lib/
									2. cf classpath, specified in cf administrator
									3. ~/resources/jar/ of the current web application
								</artifact>
							</asset>
						</functional>
					</dependancies>
				</properties>
				<io>
					<out>
						<any />
					</out>
				</io>
			</fusedoc>'>
		<!--- function code --->
		<cfset var objObject = CreateObject('component', 'utilities.object').init()>
		<cfset var strTidyClassName = 'org.w3c.tidy.Tidy'>
		
		<cfreturn objObject.getJavaObject(strTidyClassName, getTidyJarFilePath())>
	</cffunction>
	
	
	<cffunction 
		name="getTidyJarFilePath" 
		access="public" 
		output=false 
		returntype="string" 
		hint='<fusedoc fuse="" language="ColdFusion" version="2.0">
				<responsibilities>
					Returns the absolute file path of the Tidy.jar file system path.
				</responsibilities>
				<properties>
					<history date="2006-05-15" author="Matthew Gaddis" email="matthew@spiremedia.com" type="create" role="architect" />
				</properties>
				<io>
					<in></in>
					<out>
						<string />
					</out>
				</io>
			</fusedoc>'>
		<!--- function code --->
		<cfreturn  ReReplaceNoCase
		(
			GetCurrentTemplatePath(), 
			'[\\\/]utilities.+$', 
			''
		) & '\resources\jar\Tidy.jar'>
	</cffunction>
	
	<cffunction 
		name="parseHtml" 
		access="public" 
		output=true 
		returntype="string" 
		hint='<fusedoc fuse="" language="ColdFusion" version="2.0">
				<responsibilities>
					This function reads in a string, checks and corrects any invalid HTML
				</responsibilities>
				<properties>
					<history date="2006-04-30" author="Matthew Gaddis" email="matthew@spiremedia.com" type="update" role="architect">
						Added a set flag for stripping out word 2000 markup.
					</history>
					<history date="2006-04-12" author="Matthew Gaddis" email="matthew@spiremedia.com" type="update" role="architect">
						Refactored UDF from:
						http://gregs.tcias.co.uk/cold_fusion/jtidy_with_no_temp_files.cfm
						Enhancement: 
							Added parameter set whether input is parsed into html or xhtml
					</history>
					<history date="2004-09-09" author="Greg Stewart" email="gregs@teacupinastorm.com" type="update">
						* @version 1.1, September 09, 2004
						* with the help of Mark Woods this UDF no longer requires temp files and only accepts
						* the string to parse
					</history>
					<history date="2004-09-09" author="Greg Stewart" email="gregs@teacupinastorm.com" type="update">
						@param strToParse The string to parse (will be written to file).
						* accessible from the web browser
						* @return returnPart
						* @author Greg Stewart (gregs(at)tcias.co.uk)
						* @version 1, August 22, 2004
					</history>
				</properties>
				<assertions>
					<assert that="class org.w3c.tidy.Tidy exists" else="throw 2006.platform.ClassNotFoundException" />
				</assertions>
				<io>
					<in></in>
					<out></out>
				</io>
			</fusedoc>'>
		<!--- function code --->
		<cfargument name="strHtml" required=true type="string">
		<cfargument name="asXhtml" required=false default=false type="boolean">
		
		<cfset var javaObj = StructNew()>
		<cfset var Tidy = getTidy()>
		<cfset var objObject = CreateObject('component', 'utilities.object').init()>
		<cfset var strCleanHtml = ''>

		<cfif not(isObject(Tidy))>
			<cfthrow type="2006.platform.ClassNotFoundException" message="Could not create Tidy class.">
		</cfif>
		
		<cfscript>
			javaObj.configuration = objObject.getJavaObject
			(
				'org.w3c.tidy.Configuration', 
				getTidyJarFilePath()
			);
			
			Tidy.setMakeClean(true);
			Tidy.setCharEncoding(javaObj.configuration.utf8);
			Tidy.setDropFontTags(true);
			Tidy.setQuiet(true);
			Tidy.setIndentContent(false);
			Tidy.setSmartIndent(false);
			Tidy.setIndentAttributes(false);
			Tidy.setDropEmptyParas(true);
			Tidy.setFixComments(true);
			Tidy.setNumEntities(true);
			//Tidy.setWraplen(1024);
			Tidy.setWord2000(true);
			Tidy.setShowWarnings(false);
			if(arguments.asXhtml)
				Tidy.setXHTML(true);
			
			// protect em dashes &mdash; #chr(151)#
			arguments.strHtml = replaceNoCase( arguments.strHtml, '&mdash;', '[|emdash|]', 'ALL' );
			// protect en dashes &ndash; #chr(150)#
			arguments.strHtml = replaceNoCase( arguments.strHtml, '&ndash;', '[|endash|]', 'ALL' );
			///
			/// create the in and out streams for Tidy
			///
			
			
			javaObj.readBuffer = objObject.getJavaObject('java.lang.String').init
			(
				trim(arguments.strHtml)
			).getBytes('UTF8');
			
			javaObj.inStream = objObject.getJavaObject('java.io.ByteArrayInputStream').init
			(
				javaObj.readBuffer
			);
			
			javaObj.outStream = objObject.getJavaObject('java.io.ByteArrayOutputStream').init();
			
			// do the parsing
			Tidy.parse(javaObj.inStream, javaObj.outStream);
			
			
			///
			/// Remove bogus tags and DTD
			///
			strCleanHtml = ReReplaceNoCase
			(
				javaObj.outStream.toString('UTF8'), 
				/*'(?sm).+(<object[^>]*>.+</object>)?.*<body>(.+)</body>.+', */
				'(?sm)</?(html|body|head|title|meta|o:p|!)[^>]*>',
				'',
				'all'
			);
			
			// protect em dashes &mdash;
			strCleanHtml = replaceNoCase( strCleanHtml, '[|emdash|]', '&mdash;', 'ALL' );
			// protect en dashes &ndash;
			strCleanHtml = replaceNoCase( strCleanHtml, '[|endash|]', '&ndash;', 'ALL' );
			
			
			///
			/// Remove style attributes
			//removed by dre 20071225
			///
			//strCleanHtml = ReReplaceNoCase
			//(
			//	strCleanHtml,
			//	'(?sm)[\s]+style=[''"][^''"]*[''"]',
			//	'',
			//	'all'
			//);
						
			javaObj.inStream.close();
			javaObj.outStream.close();
			
			return  strCleanHtml;
		</cfscript>
	</cffunction>


	

	
	<cffunction 
		name="LSPhoneFormat" 
		access="public" 
		output=false 
		returntype="string" 
		hint='<fusedoc fuse="" language="ColdFusion" version="2.0">
				<responsibilities>
					Locale Format for Phone Numbers
				</responsibilities>
				<properties>
					<history date="2006-01-10" author="Matthew Gaddis" email="matthew@spiremedia.com" type="create" role="architect">
						Refactored from com.spiremedia.string
					</history>
				</properties>
				<io>
					<in>
						<string name="phoneNumber" optional="false" />
					</in>
					<out>
						<string />
					</out>
				</io>
			</fusedoc>'>
		<!--- function code --->
		<cfargument name="phoneNumber" type="string" required=true>
		<cfset var phone = ''>
		<cfset var match = StructNew()>
		<cfscript>
			//replace all non-numeric characters
			arguments.phoneNumber = ReReplace(arguments.phoneNumber, '\D', '', 'all');
			
			switch(getLocale())
			{
				case 'English (US)':
				case 'en_US':
					match = ReFind('^(011)?(\d{3})(\d{3})(\d{4})(\d*)?$', arguments.phoneNumber, 1, true);
					if(ArrayLen(match.len) eq 6)
					{
						phone = '(' & Mid(arguments.phoneNumber, match.pos[3], match.len[3]) & ') ' & //area code
								Mid(arguments.phoneNumber, match.pos[4], match.len[4]) & '-' & Mid(arguments.phoneNumber, match.pos[5], match.len[5]); //phone number
						if(match.len[6] gt 0)
							phone = phone & ' x' &  Mid(arguments.phoneNumber, match.pos[6], match.len[6]); //extension
					}
					break;
			}
			return phone;
		</cfscript>
	</cffunction>
	<cffunction 
		name="getWords" 
		access="public" 
		output=false 
		returntype="string" 
		hint='<fusedoc fuse="" language="ColdFusion" version="2.0">
				<responsibilities>
					Returns a string of {arguments.intMaxWordCount} words. 
					If there are more words than {arguments.inMaxWordCount} an elllipses will be appended to the string.
				</responsibilities>
				<properties>
					<history date="2006-02-26" author="Matthew Gaddis" email="matthew@spiremedia.com" type="create" role="architect">
						Refactored from com.spiremedia.cms.text
					</history>
				</properties>
				<io>
					<in>
						<string name="strText" optional="false" />
						<numeric name="intMaxWordCount" optional="true" default="12" />
					</in>
					<out>
						<string />
					</out>
				</io>
			</fusedoc>'>
		<!--- function code --->
		<cfargument name="strText" type="string" required=true>
		<cfargument name="intMaxWordCount" type="numeric" required=false default=12>
		<cfset var i = 1>
		<cfset var arrWords = ''>
		<cfset var strEllipses = ''>
		<cfscript>
			arrWords = ListToArray(ReReplace(arguments.strText, '\s+', ' ', 'all'), ' ');
			
			if(ArrayLen(arrWords) gt arguments.intMaxWordCount)
				strEllipses = '&hellip;';

			for(i = ArrayLen(arrWords); i gt arguments.intMaxWordCount; i = i - 1)
				ArrayDeleteAt(arrWords, i);
			
			return XmlFormat(ArrayToList(arrWords, ' ')) & strEllipses;
		</cfscript>
	</cffunction>
	
	<cffunction 
		name="makeRTESafe" 
		access="public" 
		output=false 
		returntype="string" 
		hint='<fusedoc fuse="" language="ColdFusion" version="2.0">
				<responsibilities>
					To be used with the Rich Text Editor, not the Hardcore Version: call it on any input text to the editor
				</responsibilities>
				<properties>
					<history date="2006-02-26" author="Matthew Gaddis" email="matthew@spiremedia.com" type="create" role="architect">
						Refactored from com.spiremedia.cms.text
					</history>
				</properties>
				<io>
					<in>
						<string name="strText" optional="false" />
					</in>
					<out>
						<string />
					</out>
				</io>
			</fusedoc>'>
		<!--- function code --->
		<cfargument name="strText" type="string" required=true>
		
		<cfset var arrMatches = ArrayNew(1)>
		<cfset var arrReplaces = ArrayNew(1)>
		<cfscript>

			arrMatches[1] = chr(145);
			arrMatches[2] = chr(146);
			arrMatches[3] = chr(147);
			arrMatches[4] = chr(148);
			arrMatches[5] = "'";
			arrMatches[6] = chr(10);
			arrMatches[7] = chr(13);
						
			arrReplaces[1] = chr(39);
			arrReplaces[2] = chr(39);
			arrReplaces[3] = chr(34);
			arrReplaces[4] = chr(34);
			arrReplaces[5] = '&##39;';
			arrReplaces[6] = ' ';
			arrReplaces[7] = ' ';
			
			return ReplaceList(trim(arguments.strText), ArrayToList(arrMatches), ArrayToList(arrReplaces));
		</cfscript>
	</cffunction>
	
	<cffunction 
		name="makeHardcoreWebeditorSafe" 
		access="public" 
		output=false 
		returntype="string" 
		hint='<fusedoc fuse="" language="ColdFusion" version="2.0">
				<responsibilities>
					String Parsing for the Hardcore RTE.
				</responsibilities>
				<properties>
					<history date="2006-02-26" author="Matthew Gaddis" email="matthew@spiremedia.com" type="create" role="architect">
						Refactored from com.spiremedia.cms.text
					</history>
				</properties>
				<io>
					<in></in>
					<out></out>
				</io>
			</fusedoc>'>
		<!--- function code --->
		<cfargument name="strText" type="string" required=true>		
		<cfreturn Replace(Replace(Replace(Replace(Replace(arguments.strText, '\', '\\', 'All'), '''', '\''', 'All'), Chr(13), '\r', 'All'), Chr(10), '\n', 'All'), 'script', 'scr''+''ipt', 'All')>
	</cffunction>
	
	<!---<cffunction 
		name="htmlentities" 
		access="public" 
		output=false 
		returntype="string" 
		hint='<fusedoc fuse="" language="ColdFusion" version="2.0">
				<responsibilities>
				</responsibilities>
				<properties>
					<history date="2006-02-26" author="Matthew Gaddis" email="matthew@spiremedia.com" type="create" role="architect">
						Refactored from com.spiremedia.cms.text
					</history>
				</properties>
				<io>
					<in>
						<string name"strText" optional="false" />
						<bool name="omitAngleBrackets" optional="true" default="true" />
					</in>
					<out>
						<string />
					</out>
				</io>
			</fusedoc>'>
		<!--- function code --->
		<cfargument name="strText" type="string" required=true>
		<cfargument name="omitAngleBrackets" type="boolean" required=false default=true hint="If set to false, &lt; and &gt; will be replaced with &amp;lt; and &amp;gt; respectively.">
		<cfscript>
			arrMatches = ArrayNew(1);
			
			arrMatches[1] = chr(34);
			//arrMatches[2] = chr(38);
			//arrMatches[3] = chr(39);
			arrMatches[4] = chr(160);
			arrMatches[5] = chr(161);
			arrMatches[6] = chr(162);
			arrMatches[7] = chr(163);
			arrMatches[8] = chr(164);
			arrMatches[9] = chr(165);
			arrMatches[10] = chr(166);
			arrMatches[11] = chr(167);
			arrMatches[12] = chr(168);
			arrMatches[13] = chr(169);
			arrMatches[14] = chr(170);
			arrMatches[15] = chr(171);
			arrMatches[16] = chr(172);
			arrMatches[17] = chr(173);
			arrMatches[18] = chr(174);
			arrMatches[19] = chr(175);
			arrMatches[20] = chr(176);
			arrMatches[21] = chr(177);
			arrMatches[22] = chr(178);
			arrMatches[23] = chr(179);
			arrMatches[24] = chr(180);
			arrMatches[25] = chr(181);
			arrMatches[26] = chr(182);
			arrMatches[27] = chr(183);
			arrMatches[28] = chr(184);
			arrMatches[29] = chr(185);
			arrMatches[30] = chr(186);
			arrMatches[31] = chr(187);
			arrMatches[32] = chr(188);
			arrMatches[33] = chr(189);
			arrMatches[34] = chr(190);
			arrMatches[35] = chr(191);
			arrMatches[36] = chr(192);
			arrMatches[37] = chr(193);
			arrMatches[38] = chr(194);
			arrMatches[39] = chr(195);
			arrMatches[40] = chr(196);
			arrMatches[41] = chr(197);
			arrMatches[42] = chr(198);
			arrMatches[43] = chr(199);
			arrMatches[44] = chr(200);
			arrMatches[45] = chr(201);
			arrMatches[46] = chr(202);
			arrMatches[47] = chr(203);
			arrMatches[48] = chr(204);
			arrMatches[49] = chr(205);
			arrMatches[50] = chr(206);
			arrMatches[51] = chr(207);
			arrMatches[52] = chr(208);
			arrMatches[53] = chr(209);
			arrMatches[54] = chr(210);
			arrMatches[55] = chr(211);
			arrMatches[56] = chr(212);
			arrMatches[57] = chr(213);
			arrMatches[58] = chr(214);
			arrMatches[59] = chr(215);
			arrMatches[60] = chr(216);
			arrMatches[61] = chr(217);
			arrMatches[62] = chr(218);
			arrMatches[63] = chr(219);
			arrMatches[64] = chr(220);
			arrMatches[65] = chr(221);
			arrMatches[66] = chr(222);
			arrMatches[67] = chr(223);
			arrMatches[68] = chr(224);
			arrMatches[69] = chr(225);
			arrMatches[70] = chr(226);
			arrMatches[71] = chr(227);
			arrMatches[72] = chr(228);
			arrMatches[73] = chr(229);
			arrMatches[74] = chr(230);
			arrMatches[75] = chr(231);
			arrMatches[76] = chr(232);
			arrMatches[77] = chr(233);
			arrMatches[78] = chr(234);
			arrMatches[79] = chr(235);
			arrMatches[80] = chr(236);
			arrMatches[81] = chr(237);
			arrMatches[82] = chr(238);
			arrMatches[83] = chr(239);
			arrMatches[84] = chr(240);
			arrMatches[85] = chr(241);
			arrMatches[86] = chr(242);
			arrMatches[87] = chr(243);
			arrMatches[88] = chr(244);
			arrMatches[89] = chr(245);
			arrMatches[90] = chr(246);
			arrMatches[91] = chr(247);
			arrMatches[92] = chr(248);
			arrMatches[93] = chr(249);
			arrMatches[94] = chr(250);
			arrMatches[95] = chr(251);
			arrMatches[96] = chr(252);
			arrMatches[97] = chr(253);
			arrMatches[98] = chr(254);
			arrMatches[99] = chr(255);
			arrMatches[100] = chr(338);
			arrMatches[101] = chr(339);
			arrMatches[102] = chr(352);
			arrMatches[103] = chr(353);
			arrMatches[104] = chr(376);
			arrMatches[105] = chr(402);
			arrMatches[106] = chr(710);
			arrMatches[107] = chr(732);
			arrMatches[108] = chr(913);
			arrMatches[109] = chr(914);
			arrMatches[110] = chr(915);
			arrMatches[111] = chr(916);
			arrMatches[112] = chr(917);
			arrMatches[113] = chr(918);
			arrMatches[114] = chr(919);
			arrMatches[115] = chr(920);
			arrMatches[116] = chr(921);
			arrMatches[117] = chr(922);
			arrMatches[118] = chr(923);
			arrMatches[119] = chr(924);
			arrMatches[120] = chr(925);
			arrMatches[121] = chr(926);
			arrMatches[122] = chr(927);
			arrMatches[123] = chr(928);
			arrMatches[124] = chr(929);
			arrMatches[125] = chr(931);
			arrMatches[126] = chr(932);
			arrMatches[127] = chr(933);
			arrMatches[128] = chr(934);
			arrMatches[129] = chr(935);
			arrMatches[130] = chr(936);
			arrMatches[131] = chr(937);
			arrMatches[132] = chr(945);
			arrMatches[133] = chr(946);
			arrMatches[134] = chr(947);
			arrMatches[135] = chr(948);
			arrMatches[136] = chr(949);
			arrMatches[137] = chr(950);
			arrMatches[138] = chr(951);
			arrMatches[139] = chr(952);
			arrMatches[140] = chr(953);
			arrMatches[141] = chr(954);
			arrMatches[142] = chr(955);
			arrMatches[143] = chr(956);
			arrMatches[144] = chr(957);
			arrMatches[145] = chr(958);
			arrMatches[146] = chr(959);
			arrMatches[147] = chr(960);
			arrMatches[148] = chr(961);
			arrMatches[149] = chr(962);
			arrMatches[150] = chr(963);
			arrMatches[151] = chr(964);
			arrMatches[152] = chr(965);
			arrMatches[153] = chr(966);
			arrMatches[154] = chr(967);
			arrMatches[155] = chr(968);
			arrMatches[156] = chr(969);
			arrMatches[157] = chr(977);
			arrMatches[158] = chr(978);
			arrMatches[159] = chr(982);
			arrMatches[160] = chr(8194);
			arrMatches[161] = chr(8195);
			arrMatches[162] = chr(8201);
			arrMatches[163] = chr(8204);
			arrMatches[164] = chr(8205);
			arrMatches[165] = chr(8206);
			arrMatches[166] = chr(8207);
			arrMatches[167] = chr(8211);
			arrMatches[168] = chr(8212);
			arrMatches[169] = chr(8216);
			arrMatches[170] = chr(8217);
			arrMatches[171] = chr(8218);
			arrMatches[172] = chr(8220);
			arrMatches[173] = chr(8221);
			arrMatches[174] = chr(8222);
			arrMatches[175] = chr(8224);
			arrMatches[176] = chr(8225);
			arrMatches[177] = chr(8226);
			arrMatches[178] = chr(8230);
			arrMatches[179] = chr(8240);
			arrMatches[180] = chr(8242);
			arrMatches[181] = chr(8243);
			arrMatches[182] = chr(8249);
			arrMatches[183] = chr(8250);
			arrMatches[184] = chr(8254);
			arrMatches[185] = chr(8260);
			arrMatches[186] = chr(8364);
			arrMatches[187] = chr(8465);
			arrMatches[188] = chr(8472);
			arrMatches[189] = chr(8476);
			arrMatches[190] = chr(8482);
			arrMatches[191] = chr(8501);
			arrMatches[192] = chr(8592);
			arrMatches[193] = chr(8593);
			arrMatches[194] = chr(8594);
			arrMatches[195] = chr(8595);
			arrMatches[196] = chr(8596);
			arrMatches[197] = chr(8629);
			arrMatches[198] = chr(8656);
			arrMatches[199] = chr(8657);
			arrMatches[200] = chr(8658);
			arrMatches[201] = chr(8659);
			arrMatches[202] = chr(8660);
			arrMatches[203] = chr(8704);
			arrMatches[204] = chr(8706);
			arrMatches[205] = chr(8707);
			arrMatches[206] = chr(8709);
			arrMatches[207] = chr(8711);
			arrMatches[208] = chr(8712);
			arrMatches[209] = chr(8713);
			arrMatches[210] = chr(8715);
			arrMatches[211] = chr(8719);
			arrMatches[212] = chr(8721);
			arrMatches[213] = chr(8722);
			arrMatches[214] = chr(8727);
			arrMatches[215] = chr(8730);
			arrMatches[216] = chr(8733);
			arrMatches[217] = chr(8734);
			arrMatches[218] = chr(8736);
			arrMatches[219] = chr(8743);
			arrMatches[220] = chr(8744);
			arrMatches[221] = chr(8745);
			arrMatches[222] = chr(8746);
			arrMatches[223] = chr(8747);
			arrMatches[224] = chr(8756);
			arrMatches[225] = chr(8764);
			arrMatches[226] = chr(8773);
			arrMatches[227] = chr(8776);
			arrMatches[228] = chr(8800);
			arrMatches[229] = chr(8801);
			arrMatches[230] = chr(8804);
			arrMatches[231] = chr(8805);
			arrMatches[232] = chr(8834);
			arrMatches[233] = chr(8835);
			arrMatches[234] = chr(8836);
			arrMatches[235] = chr(8838);
			arrMatches[236] = chr(8839);
			arrMatches[237] = chr(8853);
			arrMatches[238] = chr(8855);
			arrMatches[239] = chr(8869);
			arrMatches[240] = chr(8901);
			arrMatches[241] = chr(8968);
			arrMatches[242] = chr(8969);
			arrMatches[243] = chr(8970);
			arrMatches[244] = chr(8971);
			arrMatches[245] = chr(9001);
			arrMatches[246] = chr(9002);
			arrMatches[247] = chr(9674);
			arrMatches[248] = chr(9824);
			arrMatches[249] = chr(9827);
			arrMatches[250] = chr(9829);
			arrMatches[251] = chr(9830);
			
			arrReplaces = ArrayNew(1);
			
			arrReplaces[1] = '''';
			//arrReplaces[2] = '&##38;';
			//arrReplaces[3] = '&##39;';
			arrReplaces[4] = '&##160;';
			arrReplaces[5] = '&##161;';
			arrReplaces[6] = '&##162;';
			arrReplaces[7] = '&##163;';
			arrReplaces[8] = '&##164;';
			arrReplaces[9] = '&##165;';
			arrReplaces[10] = '&##166;';
			arrReplaces[11] = '&##167;';
			arrReplaces[12] = '&##168;';
			arrReplaces[13] = '&##169;';
			arrReplaces[14] = '&##170;';
			arrReplaces[15] = '&##171;';
			arrReplaces[16] = '&##172;';
			arrReplaces[17] = '&##173;';
			arrReplaces[18] = '&##174;';
			arrReplaces[19] = '&##175;';
			arrReplaces[20] = '&##176;';
			arrReplaces[21] = '&##177;';
			arrReplaces[22] = '&##178;';
			arrReplaces[23] = '&##179;';
			arrReplaces[24] = '&##180;';
			arrReplaces[25] = '&##181;';
			arrReplaces[26] = '&##182;';
			arrReplaces[27] = '&##183;';
			arrReplaces[28] = '&##184;';
			arrReplaces[29] = '&##185;';
			arrReplaces[30] = '&##186;';
			arrReplaces[31] = '&##187;';
			arrReplaces[32] = '&##188;';
			arrReplaces[33] = '&##189;';
			arrReplaces[34] = '&##190;';
			arrReplaces[35] = '&##191;';
			arrReplaces[36] = '&##192;';
			arrReplaces[37] = '&##193;';
			arrReplaces[38] = '&##194;';
			arrReplaces[39] = '&##195;';
			arrReplaces[40] = '&##196;';
			arrReplaces[41] = '&##197;';
			arrReplaces[42] = '&##198;';
			arrReplaces[43] = '&##199;';
			arrReplaces[44] = '&##200;';
			arrReplaces[45] = '&##201;';
			arrReplaces[46] = '&##202;';
			arrReplaces[47] = '&##203;';
			arrReplaces[48] = '&##204;';
			arrReplaces[49] = '&##205;';
			arrReplaces[50] = '&##206;';
			arrReplaces[51] = '&##207;';
			arrReplaces[52] = '&##208;';
			arrReplaces[53] = '&##209;';
			arrReplaces[54] = '&##210;';
			arrReplaces[55] = '&##211;';
			arrReplaces[56] = '&##212;';
			arrReplaces[57] = '&##213;';
			arrReplaces[58] = '&##214;';
			arrReplaces[59] = '&##215;';
			arrReplaces[60] = '&##216;';
			arrReplaces[61] = '&##217;';
			arrReplaces[62] = '&##218;';
			arrReplaces[63] = '&##219;';
			arrReplaces[64] = '&##220;';
			arrReplaces[65] = '&##221;';
			arrReplaces[66] = '&##222;';
			arrReplaces[67] = '&##223;';
			arrReplaces[68] = '&##224;';
			arrReplaces[69] = '&##225;';
			arrReplaces[70] = '&##226;';
			arrReplaces[71] = '&##227;';
			arrReplaces[72] = '&##228;';
			arrReplaces[73] = '&##229;';
			arrReplaces[74] = '&##230;';
			arrReplaces[75] = '&##231;';
			arrReplaces[76] = '&##232;';
			arrReplaces[77] = '&##233;';
			arrReplaces[78] = '&##234;';
			arrReplaces[79] = '&##235;';
			arrReplaces[80] = '&##236;';
			arrReplaces[81] = '&##237;';
			arrReplaces[82] = '&##238;';
			arrReplaces[83] = '&##239;';
			arrReplaces[84] = '&##240;';
			arrReplaces[85] = '&##241;';
			arrReplaces[86] = '&##242;';
			arrReplaces[87] = '&##243;';
			arrReplaces[88] = '&##244;';
			arrReplaces[89] = '&##245;';
			arrReplaces[90] = '&##246;';
			arrReplaces[91] = '&##247;';
			arrReplaces[92] = '&##248;';
			arrReplaces[93] = '&##249;';
			arrReplaces[94] = '&##250;';
			arrReplaces[95] = '&##251;';
			arrReplaces[96] = '&##252;';
			arrReplaces[97] = '&##253;';
			arrReplaces[98] = '&##254;';
			arrReplaces[99] = '&##255;';
			arrReplaces[100] = '&##338;';
			arrReplaces[101] = '&##339;';
			arrReplaces[102] = '&##352;';
			arrReplaces[103] = '&##353;';
			arrReplaces[104] = '&##376;';
			arrReplaces[105] = '&##402;';
			arrReplaces[106] = '&##710;';
			arrReplaces[107] = '&##732;';
			arrReplaces[108] = '&##913;';
			arrReplaces[109] = '&##914;';
			arrReplaces[110] = '&##915;';
			arrReplaces[111] = '&##916;';
			arrReplaces[112] = '&##917;';
			arrReplaces[113] = '&##918;';
			arrReplaces[114] = '&##919;';
			arrReplaces[115] = '&##920;';
			arrReplaces[116] = '&##921;';
			arrReplaces[117] = '&##922;';
			arrReplaces[118] = '&##923;';
			arrReplaces[119] = '&##924;';
			arrReplaces[120] = '&##925;';
			arrReplaces[121] = '&##926;';
			arrReplaces[122] = '&##927;';
			arrReplaces[123] = '&##928;';
			arrReplaces[124] = '&##929;';
			arrReplaces[125] = '&##931;';
			arrReplaces[126] = '&##932;';
			arrReplaces[127] = '&##933;';
			arrReplaces[128] = '&##934;';
			arrReplaces[129] = '&##935;';
			arrReplaces[130] = '&##936;';
			arrReplaces[131] = '&##937;';
			arrReplaces[132] = '&##945;';
			arrReplaces[133] = '&##946;';
			arrReplaces[134] = '&##947;';
			arrReplaces[135] = '&##948;';
			arrReplaces[136] = '&##949;';
			arrReplaces[137] = '&##950;';
			arrReplaces[138] = '&##951;';
			arrReplaces[139] = '&##952;';
			arrReplaces[140] = '&##953;';
			arrReplaces[141] = '&##954;';
			arrReplaces[142] = '&##955;';
			arrReplaces[143] = '&##956;';
			arrReplaces[144] = '&##957;';
			arrReplaces[145] = '&##958;';
			arrReplaces[146] = '&##959;';
			arrReplaces[147] = '&##960;';
			arrReplaces[148] = '&##961;';
			arrReplaces[149] = '&##962;';
			arrReplaces[150] = '&##963;';
			arrReplaces[151] = '&##964;';
			arrReplaces[152] = '&##965;';
			arrReplaces[153] = '&##966;';
			arrReplaces[154] = '&##967;';
			arrReplaces[155] = '&##968;';
			arrReplaces[156] = '&##969;';
			arrReplaces[157] = '&##977;';
			arrReplaces[158] = '&##978;';
			arrReplaces[159] = '&##982;';
			arrReplaces[160] = '&##8194;';
			arrReplaces[161] = '&##8195;';
			arrReplaces[162] = '&##8201;';
			arrReplaces[163] = '&##8204;';
			arrReplaces[164] = '&##8205;';
			arrReplaces[165] = '&##8206;';
			arrReplaces[166] = '&##8207;';
			arrReplaces[167] = '&##8211;';
			arrReplaces[168] = '&##8212;';
			arrReplaces[169] = '&##8216;';
			arrReplaces[170] = '&##8217;';
			arrReplaces[171] = '&##8218;';
			arrReplaces[172] = '&##8220;';
			arrReplaces[173] = '&##8221;';
			arrReplaces[174] = '&##8222;';
			arrReplaces[175] = '&##8224;';
			arrReplaces[176] = '&##8225;';
			arrReplaces[177] = '&##8226;';
			arrReplaces[178] = '&##8230;';
			arrReplaces[179] = '&##8240;';
			arrReplaces[180] = '&##8242;';
			arrReplaces[181] = '&##8243;';
			arrReplaces[182] = '&##8249;';
			arrReplaces[183] = '&##8250;';
			arrReplaces[184] = '&##8254;';
			arrReplaces[185] = '&##8260;';
			arrReplaces[186] = '&##8364;';
			arrReplaces[187] = '&##8465;';
			arrReplaces[188] = '&##8472;';
			arrReplaces[189] = '&##8476;';
			arrReplaces[190] = '&##8482;';
			arrReplaces[191] = '&##8501;';
			arrReplaces[192] = '&##8592;';
			arrReplaces[193] = '&##8593;';
			arrReplaces[194] = '&##8594;';
			arrReplaces[195] = '&##8595;';
			arrReplaces[196] = '&##8596;';
			arrReplaces[197] = '&##8629;';
			arrReplaces[198] = '&##8656;';
			arrReplaces[199] = '&##8657;';
			arrReplaces[200] = '&##8658;';
			arrReplaces[201] = '&##8659;';
			arrReplaces[202] = '&##8660;';
			arrReplaces[203] = '&##8704;';
			arrReplaces[204] = '&##8706;';
			arrReplaces[205] = '&##8707;';
			arrReplaces[206] = '&##8709;';
			arrReplaces[207] = '&##8711;';
			arrReplaces[208] = '&##8712;';
			arrReplaces[209] = '&##8713;';
			arrReplaces[210] = '&##8715;';
			arrReplaces[211] = '&##8719;';
			arrReplaces[212] = '&##8721;';
			arrReplaces[213] = '&##8722;';
			arrReplaces[214] = '&##8727;';
			arrReplaces[215] = '&##8730;';
			arrReplaces[216] = '&##8733;';
			arrReplaces[217] = '&##8734;';
			arrReplaces[218] = '&##8736;';
			arrReplaces[219] = '&##8743;';
			arrReplaces[220] = '&##8744;';
			arrReplaces[221] = '&##8745;';
			arrReplaces[222] = '&##8746;';
			arrReplaces[223] = '&##8747;';
			arrReplaces[224] = '&##8756;';
			arrReplaces[225] = '&##8764;';
			arrReplaces[226] = '&##8773;';
			arrReplaces[227] = '&##8776;';
			arrReplaces[228] = '&##8800;';
			arrReplaces[229] = '&##8801;';
			arrReplaces[230] = '&##8804;';
			arrReplaces[231] = '&##8805;';
			arrReplaces[232] = '&##8834;';
			arrReplaces[233] = '&##8835;';
			arrReplaces[234] = '&##8836;';
			arrReplaces[235] = '&##8838;';
			arrReplaces[236] = '&##8839;';
			arrReplaces[237] = '&##8853;';
			arrReplaces[238] = '&##8855;';
			arrReplaces[239] = '&##8869;';
			arrReplaces[240] = '&##8901;';
			arrReplaces[241] = '&##8968;';
			arrReplaces[242] = '&##8969;';
			arrReplaces[243] = '&##8970;';
			arrReplaces[244] = '&##8971;';
			arrReplaces[245] = '&##9001;';
			arrReplaces[246] = '&##9002;';
			arrReplaces[247] = '&##9674;';
			arrReplaces[248] = '&##9824;';
			arrReplaces[249] = '&##9827;';
			arrReplaces[250] = '&##9829;';
			arrReplaces[251] = '&##9830;';
			
			if(omitAngleBrackets eq false)
			{
				arrMatches[252] = chr(60);
				arrMatches[253] = chr(62);
				
				arrReplaces[252] = '&##60;';
				arrReplaces[253] = '&##62;';
			}
		
			return ReplaceList(trim(strText), ArrayToList(arrMatches), ArrayToList(arrReplaces));
		</cfscript>
	</cffunction>--->
	
	<cffunction 
		name="htmlentities" 
		access="public" 
		output=false 
		returntype="string" 
		hint='<fusedoc fuse="" language="ColdFusion" version="2.0">
				<responsibilities>
				</responsibilities>
				<properties>
					<history date="2006-02-26" author="Matthew Gaddis" email="matthew@spiremedia.com" type="create" role="architect">
						Refactored from com.spiremedia.cms.text
					</history>
				</properties>
				<io>
					<in>
						<string name"strText" optional="false" />
						<bool name="omitAngleBrackets" optional="true" default="true" />
					</in>
					<out>
						<string />
					</out>
				</io>
			</fusedoc>'>
		<!--- function code --->
		<cfargument name="strText" type="string" required=true>
		<cfargument name="omitAngleBrackets" type="boolean" required=false default=true hint="If set to false, &lt; and &gt; will be replaced with &amp;lt; and &amp;gt; respectively.">

	<cfset var buf = CreateObject("java", "java.lang.StringBuffer")>
	<cfset var len = Len(arguments.strText)>
	<cfset var char = "">
	<cfset var charcode = 0>
	<cfset buf.ensureCapacity(JavaCast("int", len+20))>
	<cfif NOT len>
		<cfreturn arguments.str>
	</cfif>
	<cfloop from="1" to="#len#" index="i">
		<cfset char = arguments.strText.charAt(JavaCast("int", i-1))>
		<cfset charcode = JavaCast("int", char)>
		<cfif (charcode GT 31 AND charcode LT 127) OR charcode EQ 10
			OR charcode EQ 13 OR charcode EQ 9>
				<cfset buf.append(JavaCast("string", char))>
		<cfelse>
			<cfset buf.append(JavaCast("string", "&##"))>
			<cfset buf.append(JavaCast("string", charcode))>
			<cfset buf.append(JavaCast("string", ";"))>
		</cfif>
	</cfloop>
	<cfreturn buf.toString()>
	</cffunction>

</cfcomponent>