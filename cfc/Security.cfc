<cfcomponent name="Security">

	<cfset sDSN = "">
	<cfset this.UserGroup = "">
	<cfset this.Username = "">
	<cfset this.Password = "">
	
	<cffunction name="init" returntype="Security">
							<cfargument name="sDSN" required="No" default="anunt">		
							<cfset this.sDSN = Arguments.sDSN>		
					<cfreturn this>		
	</cffunction>	
	
	<cffunction name="authenticateUser" output="Yes" returntype="query">
						<cfargument name="sUsername">
						<cfargument name="sPwd">
												
						<cfset SESSION.stUser.IsAuthenticated = FALSE>
						<cfset SESSION.stUser.IsLoggedIn = FALSE>					
						
						<cfquery name="qRS" datasource="#this.sDSN#">				
								SELECT  c.id,
												c.fname,
												c.sname,
												c.email,
												c.username,
												c.roles,
												c.features
								FROM 		
												customer c
								WHERE 
											c.username = '#trim(arguments.sUsername)#' 
									AND 
											c.password = '#trim(arguments.sPwd)#'	
									AND
											c.blocked <> 1	
						</cfquery>	
						
					<cfreturn qRS>
			</cffunction>
	
	<cffunction name="logoutUser">
			<!--- <cflock type="EXCLUSIVE" scope="SESSION" timeout="10">
				<cfset structClear(Session.stUser)>
				<cfset structClear(Session.stAnunt)>
			</cflock>--->
			
			<cflock type="EXCLUSIVE" scope="SESSION" timeout="10">
				<cfset SESSION.stUser.IsAuthenticated = FALSE>
				<cfset SESSION.stUser.IsLoggedIn = FALSE>
				<cfset SESSION.stUser.Id				= 0>
				<cfset SESSION.stUser.Fname 		= "">
				<cfset SESSION.stUser.Sname 		= "">
				<cfset SESSION.stUser.Email 		= "">
				<cfset SESSION.stUser.Username 	= "">
				<cfset SESSION.stUser.Roles 		= "">
				<cfset SESSION.stUser.Features 	= "">
				
				<cfset SESSION.stOrder.oid 			= "">
				<cfset SESSION.stOrder.cid 			= "">
			</cflock> 			
	</cffunction>
	
	<cffunction name="loginUser">
			<cfargument name="qAccount" type="query">
				
						
				<!--- create User session structure --->
				<cflock type="EXCLUSIVE" scope="SESSION" timeout="10">
					<cfset SESSION.stUser.IsAuthenticated = TRUE>
					<cfset SESSION.stUser.IsLoggedIn 	= TRUE>
					<cfset session.stUser.Id 					= arguments.qAccount.id>
					<cfset session.stUser.Fname 			= arguments.qAccount.fname>
					<cfset session.stUser.Sname 			= arguments.qAccount.sname>		
					<cfset session.stUser.Username 		= arguments.qAccount.username>			
					<cfset SESSION.stUser.Email 			= arguments.qAccount.email>
					<cfset SESSION.stUser.Roles 			= trim(arguments.qAccount.roles)>
					<cfset SESSION.stUser.Features 		= trim(arguments.qAccount.features)>
					
					<!--- Session user for order users to populate the order form --->
					<cfset session.stOrderUser.id = arguments.qAccount.id />
										
					<!--- <cfset SESSION.stUser.Roles 	= arguments.qAccount.Roles> --->				
					<!--- <cfif len(trim(arguments.qAccount.telephone))>
						<cfset session.stUser.Alias = arguments.qAccount.telephone>
					</cfif> --->
					<!--- <cfif len(trim(arguments.qAccount.email))>
						<cfset session.stUser.Alias = arguments.qAccount.email>
					</cfif>			
					</cfif> --->	
				</cflock>
				
				<!--- <cfquery name="qLogonAccess" datasource="#this.sDSN#">
					INSERT INTO LogUserAccess( userId,
																  	loginDateTime)
					VALUES(	#SESSION.user.ID#,
							 		'#lsDateFormat(Now(),"dd-mmm-yyyy")# #lsTimeFormat(Now(),"hh:mm")#')
				</cfquery>
				<cfquery name="qGetLogonId" datasource="#Request.dsn#">
					SELECT Max(id) AS maxLogId FROM LogUserAccess
				</cfquery> --->
				
				<!--- <cfset SESSION.user.logAccessId = trim(qGetLogonId.maxLogId)> --->
							
	</cffunction>
	
	
	<cffunction name="getUsername">
			<cfargument name="sUn">
			<cfargument name="lsGrp" default="staff,admin,super">
			
			<cfquery name="qUsername" datasource="#this.sDSN#">
					SELECT id FROM User
					WHERE username = '#Arguments.sUn#'
					<!--- AND groups IN '#Arguments.lsGrp#' --->
			</cfquery>
			<cfif qUsername.RecordCount>
				<cfreturn 1>
			<cfelse>
				<cfreturn 0>
			</cfif>
	</cffunction>
	
	<cffunction name="getPasswordByEmail">
			<cfargument name="sE">			
			<cfquery name="qPw" datasource="#this.sDSN#">
					SELECT password FROM User
					WHERE email = '#Arguments.sE#'
			</cfquery>
			<cfreturn trim(qPw.password)>
	</cffunction>
	
	<!--- <cffunction name="getPasswordByPhoneNo">
			<cfargument name="sPh">			
			<cfquery name="qPw" datasource="#this.sDSN#">
					SELECT password FROM User
					WHERE telephone = '#Arguments.sPh#'
			</cfquery>
			<cfreturn trim(qPw.password)>
	</cffunction> --->
	
	<cffunction name="makeRandomPassword" returntype="string">		
			<cfset var randString = "" />
			<cfset var tmpString = "" />
						
			<!--- make a random 8 chars string (alphaNumericALPHA) --->
			<cfloop condition="len(randString) Lt 8">
				<cfset randString = randString & Chr(randRange(97,122)) & Chr(randRange(65,90)) & Chr(randRange(48,57))>
			</cfloop>
			
			<!--- verify pwd --->
			<cfif verifyPassword(randString) Eq 0>
				<cfreturn randString />
			<cfelse>
				<cfset makeRandomPassword() />
			</cfif>
			
			<!--- ensure this password does not exists --->
			<!--- <cfloop condition="verifyPassword(randString) Eq 0">	
				<cfset randString = makeRandomPassword()>
				<cfexit>
			</cfloop> --->
			
		
	</cffunction>
	
	<cffunction name="passwordExists" returntype="numeric">
			<cfargument name="sPw">			
			<cfquery name="qPassword" datasource="#this.sDSN#">
					SELECT id 
					FROM 	customer
					WHERE password = '#Arguments.sPw#'
			</cfquery>
		<cfreturn qPassword.RecordCount />
	</cffunction>
	<cffunction name="usernameExists" returntype="numeric">
			<cfargument name="sUsr">			
			<cfquery name="qUsr" datasource="#this.sDSN#">
					SELECT id 
					FROM 	customer
					WHERE username = '#htmlEditFormat(Arguments.sUsr)#'
			</cfquery>
		<cfreturn qUsr.RecordCount />
	</cffunction>
	
	<cffunction name="setUsername">
			<cfargument name="sFn" type="string">
			<cfargument name="sLn" type="string">
					
			<cfset var tmpNumBit = "">
			<cfset var tmpAlpBit = "">
			<cfset var tmpLogin  = "">
			<cfset var tmpReturn = "0">
			<!--- 
			<cfoutput>#Arguments.sFn#
			#Arguments.sLn#</cfoutput><cfabort> --->
			
			<!--- loop through numeric values --->
			<cfloop from="0" to="9" index="i">
			
				<cfset tmpNumBit = "0" & i>
				<cfset tmpAlpBit = "#lCase(Left(Arguments.sFn,1))##lCase(Left(Arguments.sLn,1))#">
				<cfset tmpLogin  = "#tmpAlpBit##tmpNumBit#">
				
				
				
				<!--- Verify this login --->
				<cfset usrExists = getUsername(tmpLogin)>
				<cfif usrExists EQ 0>						
						<cfreturn tmpLogin>
						<cfexit>
				</cfif>				
			</cfloop>
						
	</cffunction>
	
	<cffunction name="setPassword">
			<cfargument name="sString1" type="string">
			<cfargument name="sString2" type="string">
			
			<cfset var tmpNumBit = "">
			<cfset var tmpAlpBit = "">
			<cfset var tmpPwd    = "">
			
			<cfloop from="0" to="9" index="i">
					<cfset tmpNumBit = "0" & i>
					<cfset tmpAlpBit = "#lCase(Left(Arguments.sString1,1))##lCase(Arguments.sString2)#">
					<cfset tmpPwd		 = "#tmpAlpBit##tmpNumBit#">
					
					<!--- Does this password exist? --->
					<cfset pwdExists = getPassword(tmpPwd)>
					<cfif pwdExists EQ 0>
							<cfreturn tmpPwd>
							<cfexit>
					</cfif>
			</cfloop>
			
	</cffunction>
	
	<cffunction name="setLogin" returntype="struct">
			<cfargument name="Id">
			<cfargument name="S1">
			<cfargument name="S2">			
			
			<cfset stAccount = StructNew()>
			<cfset stAccount.Username = "#setUsername(Arguments.S1,Arguments.S2)#">
			<cfset stAccount.Password = "#setPassword(Arguments.S1,Arguments.S2)#">
			
			<cfquery name="qUpdateUser" datasource="#this.sDSN#">
					UPDATE User
					SET	username = '#stAccount.Username#',
							password = '#stAccount.Password#'
					WHERE
							id = #Arguments.Id#
			</cfquery>
			
			<cfreturn stAccount>
	</cffunction>
	
	
	<cffunction name="verifyPermission" returntype="boolean">
			<cfargument name="uId">
			<cfargument name="uRoles">		
			
			<cfset var retCode = false>	
			
			<cfquery name="qU" datasource="#this.sDSN#">
					SELECT roles FROM User
					WHERE id = #arguments.uId#
			</cfquery>
			
			<cfset lsDBRoles = valueList(qU.roles,",")>
			<cfset lsArgRoles = arguments.uRoles>
			
			<cfif listLen(lsDBRoles,",") Gte listLen(lsArgRoles,",")>
				
				<cfloop list="#lsDBRoles#" index="role">
					<cfif listFindNoCase(trim(lsArgRoles),trim(role))>
						<cfset retCode = 0>
						<cfbreak>
					</cfif>
				</cfloop>
				
			<cfelseif listLen(lsDBRoles,",") Lt listLen(lsArgRoles,",")>	
			
				<!--- <cfoutput>
				loop list is lsArgRoles. (#lsArgRoles#)<br>
				sch list is lsDBRoles. (#lsDBRoles#)<br>
				</cfoutput> --->
				
				<!--- looping..<br> --->
					<cfloop list="#lsArgRoles#" index="role">
						<!--- <cfoutput>find #role# in #lsDBRoles#<br></cfoutput> --->
						<cfif listFindNoCase(trim(lsDBRoles),trim(role))>
							<cfset retCode = true>
							<!--- <cfoutput>found!</cfoutput> --->
							<cfbreak>
						</cfif>
					</cfloop>				
				</cfif>						
			
			<!--- <cfoutput>retCode: #retCode#</cfoutput> --->
			<!--- <cfabort> --->
			
		<cfreturn retCode />
		
	</cffunction>
	
	
	
</cfcomponent>

