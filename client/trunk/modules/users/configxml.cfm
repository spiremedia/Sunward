<cfsavecontent variable="modulexml">
	<moduleInfo>
		 <action match="^Users/Login/?">
			<loadcfc>login</loadcfc>
			<template>textpage</template>
			<title>User Login Page</title>
			<description>User Login Page</description>
			<keywords>User Login Page</keywords>
		</action>
		<action match="^Users/Logout/?$">
			<loadcfc>logout</loadcfc>
			<template>textpage</template>
			<title></title>
			<description></description>
			<keywords></keywords>
		</action>
		<action match="^Users/ChangePassword/?$">
			<loadcfc>changePassword</loadcfc>
			<template>textpage</template>
			<title>Change your password</title>
			<description>Change your password</description>
			<keywords>Change your password</keywords>
		</action>
		<action match="^Users/AccessDenied/?$">
			<loadcfc>accessDenied</loadcfc>
			<template>textpage</template>
			<title>Access Denied</title>
			<description>Access Denied</description>
			<keywords>Access Denied</keywords>
		</action>
	</moduleInfo>
</cfsavecontent>

<cfset modulexml = xmlparse(modulexml)>