<!--- <cferror type="EXCEPTION" template="circuits/commmon/v/dsp_Error.cfm"> --->

<cfset self="index.cfm" /><!--- /anu/index.cfm --->
<cfset myself="#self#?#application.fusebox.fuseactionVariable#=" />
<cfset Request.sDSN = "crespo">

<cfparam name="url.appReload" default="false" type="string">

<!--- App clock. Becasue this app is hosted on a server
			in states i need to calculate the time diference. --->
	<cfset info = GetTimeZoneInfo()>
	<cfset gmt  = dateAdd("h",info.utcHourOffset,now())>
	<cfset tmpDate = dateFormat(gmt,"dd-mmm-yyyy")>
	<cfset tmpTime = replace(replace(replace(replace(createODBCTime(gmt),"t",""),"{","","all"),"}","","all"),"'","","all")>
	<!--- <cfset tmpTime = listDeleteAt(tmpTime,listLen(tmpTime,":"),":")> --->
	<cfset application.stApp.GMT =  tmpDate & tmpTime>
	

<cfif not structKeyExists(application,"appStarted") or url.appReload>
	
	<!--- Valid Fuseactions --->
	<cfset variables.arrValidFuseaction = arrayNew(1) />
	<cfloop collection="#myFusebox.getApplication().circuits#" item="thisCircuit">
		<cfif myFusebox.getApplication().circuits['#thisCircuit#'].access eq "public">
			<!--- Debbug: #thisCircuit#<br /> --->
			<cfloop list="#structKeyList(myFusebox.getApplication().circuits['#thisCircuit#'].fuseactions)#" index="thisFA">
				<cfset arrayAppend(variables.arrValidFuseaction,"#thisCircuit#.#thisFA#")>
			</cfloop>
		</cfif>	
	</cfloop>
	
	<!--- ---------------------------------------------------------------------------------------
		LOAD DISPLAY CONTENT IN APPLICATION STRUCTURE ONCE
	---------------------------------------------------------------------------------------- --->	
	<!--- Obtain the list of pages which have labels --->	
	<cftry>
		<cfdirectory action="list" directory="#expandPath('.')#\translationfiles" name="qDir" />
		<cfset application.gui.lsDisplayFuseactions = valueList(qDir.name) />
		<cfcatch>
			<cfset application.gui.lsDisplayFuseactions = "" />
		</cfcatch>
	</cftry>
	
	<!--- This is the final structure containing the content in multi languages.
			Example: stMultiLangContent.en.security.login.username= "Username" --->	 
	<cfset stMultiLangContent = structNew() />
	
	<!--- Loop through directories representing the page ids --->
	<cfoutput query="qDir">
		
		<!--- Create struct key: stMultiLangContent.DIRNAMEPAGEID --->
		<cfif not structKeyExists(stMultiLangContent,qDir.name)>
			<cfset structInsert(stMultiLangContent,qDir.name,structNew()) />					
		</cfif>	
		
		<!--- For each PAGEID directory open the translation files, create a structure key and read the content. --->
		<cfdirectory action="list" directory="#expandPath('.')#\translationfiles\#qDir.name#" name="qFiles">
		
			<cfloop query="qFiles">				
				
				<!--- Open the file and read the content as a list of carriage return separated elements --->
				<cffile action="read" file="#expandPath('.')#\translationfiles\#qDir.name#\#qFiles.name#" variable="fileContent" />
				
				<!--- Create a key structure out of the file name which is the language code: stMultiLangContent.DIRNAMEPAGEID.LANG. --->
				<cfif not structKeyExists(stMultiLangContent[qDir.name],left(qFiles.name,2))>
					<cfset structInsert(stMultiLangContent[qDir.name],left(qFiles.name,2),listToArray(fileContent,chr(13))) />					
				</cfif>	
			
			</cfloop>
			
		<!--- Get the file translations and create struct keys --->
	</cfoutput>
	
	<cfset application.stMultiLangContent = stMultiLangContent />
	<!--- ---------------------------------------------------------------------------------- --->

	<cflock scope="Application" type="exclusive" timeout="10">
		<!--- <cfset application.qCat = queryNew("id,name") /> --->     
		<cfset application.appStarted = True />
		<cfset application.cfcPath = "cfc" />
		<!--- <cfset application.admin = CreateObject("component","cfc.admin").init(Request.sDSN)> --->	
				
		<cfset application.CustomerDAO = CreateObject("component","#application.cfcPath#.customerDAO").init(Request.sDSN)>
		<cfset application.CustomerGateway = CreateObject("component","#application.cfcPath#.customerGateway").init(Request.sDSN)>
		<cfset application.AddressDAO = CreateObject("component","#application.cfcPath#.addressDAO").init(Request.sDSN)>		
		<cfset application.OrderDAO = CreateObject("component","#application.cfcPath#.orderDAO").init(Request.sDSN)>	
		<cfset application.OrderGateway = CreateObject("component","#application.cfcPath#.OrderGateway").init(Request.sDSN)>	
		<cfset application.security = CreateObject("component","#application.cfcPath#.security").init(Request.sDSN)>
		<!--- <cfset application.user = CreateObject("component","#application.cfcPath#.user").init()> --->
		<cfset application.utils = CreateObject("component","#application.cfcPath#.utils").init()>
		<cfset application.calendar = CreateObject("component","#application.cfcPath#.calendar").init() />
		<cfset application.calendarCrespo = CreateObject("component","#application.cfcPath#.calendarCrespo") />
		
		
		<cfset application.stApp.EmailInfo = "office@crespocom.com,crespocom@yahoo.co.uk">
		<cfset application.stApp.EmailAllStaff = "office@crespocom.com,crespocom@yahoo.co.uk,tibiakiss@yahoo.com">
		<cfset application.stApp.WebmasterEmail = "tibiakiss@yahoo.com">
		<cfset application.stApp.ErrorEmail = "tibiakiss@yahoo.com">
		<cfset application.stApp.CustomerResponseEmail = "office@crespocom.com">
		<cfset application.stApp.OfficeEmail = "office@crespocom.com">
		
		<cfif findNoCase("localhost",cgi.server_name)>					
			<cfset application.stApp.URL = "http://localhost/cre/">
		<cfelse>
			<cfset application.stApp.URL = "http://www.crespocom.com">
		</cfif>
		<cfset application.stApp.IP = "#cgi.server_name#">				
	</cflock>					 
</cfif>

<cfif not structKeyExists(session,"stUser") or structKeyExists(URL,"sessReload")>
		
	<cflock type="EXCLUSIVE" scope="SESSION" timeout="10">
		<cfset SESSION.stUser.IsAuthenticated = FALSE>
		<cfset SESSION.stUser.IsLoggedIn = FALSE>
		<cfset SESSION.stUser.popMessage = FALSE>
		<cfset session.stUser.Id = "0">
		<cfset session.stUser.Alias = "">
		<cfset session.stUser.Roles = "basic">
		<cfset session.stUser.Features = "orders_myorders_listing">
		<cfset session.stUser.Email = "">
		<cfset session.stUser.Username = "web">
		<cfset session.stUser.langID = "RO">
		
		<cfif not IsDefined("Cookie.User.langChoice")>
			<cfif not structKeyExists(URL,"langID")>
				<cfset session.stUser.langID = "RO">
				<cfcookie name="User.langChoice" value="RO" expires="never" />
			<cfelse>
				<cfset session.stUser.langID = URL.langID>
				<cfcookie name="User.langChoice" value="#URL.langID#" expires="never" />
			</cfif>			
		<cfelse>
			<cfset session.stUser.langID = Cookie.User.langChoice />
		</cfif>		
	</cflock>
		
	<!--- log this hit if no url instruction to do otherwise --->
				<!--- <cfif not (isDefined("url.notLog") and url.notLog is true)>
					<cfset application.utils.logHit("#CGI.REMOTE_ADDR#","#CGI.REMOTE_HOST#","#CGI.HTTP_REFERER#","#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#","#application.stApp.GMT#")>
				</cfif> --->
<cfelse>
	<!--- If during a session user changes the language --->
	<cfif structKeyExists(URL,"langID") and listFind("EN,RO",URL.langID)>
		<cflock type="EXCLUSIVE" scope="SESSION" timeout="10">
			<cfset session.stUser.langID = URL.langID>
		</cflock>
		<!--- Update cookie --->
		<cfcookie name="User.langChoice" value="#URL.langID#" expires="never" />
	</cfif>
</cfif>

<cfif not structKeyExists(session,"stOrder")>
	<cflock type="EXCLUSIVE" scope="SESSION" timeout="10">
		<cfset session.stOrder.begin = False />
		<!--- Customer ID.Used in the order form.By default is set to the logged in user id --->
					<cfset session.stOrder.cid = "" />
		<!--- Order ID. --->
					<cfset session.stOrder.oid = "" />
	</cflock>
</cfif>

<!--- Copy shared scope vars into request scope. --->
<cflock type="readonly" scope="session" timeout="5">
	<cfset Request.stUser = Session.stUser />
</cflock>


<!--- <script type="text/jscript" language="JavaScript1.2" src="AgentSniffer.js"></script> --->
<!--- <script language="JavaScript1.2">
	//window.alert(s_user_browser);
</script> --->
