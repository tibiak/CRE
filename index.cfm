<cfset FUSEBOX_APPLICATION_PATH = "">
<!--- <cfset FUSEBOX_APPLICATION_KEY = "crespocom"> --->
<cftry>
	<cfinclude template="../_FB50core/fusebox5.cfm">
	
	<cfcatch>		
		<!--- Wrong fuseaction given --->
		<cfset content.externalads="">
				
		<!--- Bad page request! --->
		<cfmail from="system@crespocom.com"
				to="#application.stApp.WebmasterEmail#" 
				subject="CRESPOCOM.COM - Error!" type="html">
				ERROR DUMP<br />
				<cfdump var="#cfcatch#" /><br /><br />
				SESSION DUMP<br />
				<cfdump var="#session#"><br /><br />
				CGI DUMP<br />
				<cfdump var="#cgi#">				
		</cfmail>
		<!--- <cflocation url="index.cfm" /> --->
		<cfabort />		
	</cfcatch>
</cftry>
<LINK REL="SHORTCUT ICON" HREF="favicon.ico">