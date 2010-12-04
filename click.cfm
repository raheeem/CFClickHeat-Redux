<!--- Initialize parameters --->
<cfparam name="URL.x" default="0"><!--- X-coordinate of the click --->
<cfparam name="URL.y" default="0"><!--- Y-coordinate of the click --->
<cfparam name="URL.w" default="0"><!--- Window width --->
<cfparam name="URL.h" default="0"><!--- Window height --->
<cfparam name="URL.g" default=""><!--- Group --->
<cfparam name="URL.s" default=""><!--- Site --->
<cfparam name="URL.b" default=""><!--- Browser --->

<cfif structKeyExists(application,'clickheat')>
	<cfset application.clickheat.recordClick(url.x,url.y,url.w,url.h,url.s,url.b,url.g) />
</cfif>