<cfcomponent  
	hint='<fusedoc fuse="" language="ColdFusion" version="2.0">
			<responsibilities>
				Java Object Class Invoker
			</responsibilities>
			<properties>
				<history date="2006-05-15" author="Matthew Gaddis" email="matthew@spiremedia.com" type="create" role="architect" />
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
				<history date="2006-05-15" author="Matthew Gaddis" email="matthew@spiremedia.com" type="create" role="architect" />
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
		name="getJavaObject" 
		access="public" 
		output=false 
		returntype="any" 
		hint='<fusedoc fuse="" language="ColdFusion" version="2.0">
				<responsibilities>
					Will try to load a java class either by the CreateObject method
					or 
					the Java Url Class Loader
				</responsibilities>
				<properties>
					<history date="2006-01-10" author="Matthew Gaddis" email="matthew@spiremedia.com" type="create" role="architect" />
				</properties>
				<io>
					<in>
						<string name="className" optional="false" />
						<string name="jarFilePath" optional="true" />
					</in>
					<out>
						<any>
							any java object or false if the object could not be instantiated.
						</any>
					</out>
				</io>
			</fusedoc>'>
		<!--- function code --->
		<cfargument name="className" type="string" required=true>
		<cfargument name="jarFilePath" type="string" required=false>
		
		<cfset var arr = ArrayNew(1)>
		<cfset var obj = false>
		<cfset var objUrl = ''>
		
		<cfscript>
			try
			{
				obj = CreateObject
				(
					'java', 
					arguments.className
				);
			}
			catch(Object e)
			{
				if(StructKeyExists(arguments, 'jarFilePath'))
				{
					try
					{
						///
						/// Java URL Object, used as a parameter to the 
						/// URLClassLoader constructor
						///
						arr[1] = createObject
						(
							'java',
							'java.net.URL'
						).init
						(
							'file:' & arguments.jarFilePath
						);
						
						///
						/// Create a URLClassLoader w/ passing the Tidy jar file path 
						///
						objUrl = createObject
						(
							'java',
							'java.net.URLClassLoader'
						).init
						(
							arr
						);
						
						obj = objUrl.loadClass(arguments.className).newInstance();
						
					}
					catch(java.lang.SecurityException e)
					{
						///
						/// Possible Class Exceptions include
						/// 1. java.lang.SecurityException
						/// 2. java.lang.ClassNotFoundException
						///
					}
				}
			}
		
			return obj;
		</cfscript>
	</cffunction>
</cfcomponent>