<cfsilent>
<cfapplication 
			name="crespocom" 
			sessionmanagement="Yes" 					
			sessiontimeout="#CreateTimeSpan(0,0,60,0)#" 	
			clientmanagement="Yes">
</cfsilent>
<!--- Valid fuseaction? --->
<cfif structKeyExists(application,"lsValidFuseactions") and 
		structkeyExists(url,"do") and not listFindNoCase(application.lsValidFuseactions,url.do)>
	<!--- <cfheader statuscode="301"  statustext="Moved Permanently">
	<cfheader name="Location" value="index.cfm" /> --->
	<cflocation url="index.cfm" >
	<cfabort />
</cfif>