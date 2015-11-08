<cfcomponent hint="I am responsibl for C R U D a customer object">
			<cfset variables.dsn = "" />
			
			<cffunction name="init" returntype="CustomerDAO" hint="">
					<cfargument name="dsn" type="string" required="False" default="#Request.sDSN#">
					<cfset variables.dsn = arguments.dsn/>	
					<cfreturn this />
			</cffunction>
			
			<cffunction name="create" access="public" returntype="numeric">
					<cfargument name="obCustomer" type="customer" required="true" />
					
					<cfset var stCustomer = structNew() />
					<cfset stCustomer.id  = trim(obCustomer.getID())>
					<cfset stCustomer.uuid  = trim(obCustomer.getUUID())>
					<cfset stCustomer.title = trim(obCustomer.getTitle())>
					<cfset stCustomer.fname = trim(obCustomer.getFName())>
					<cfset stCustomer.sname = trim(obCustomer.getSName())>
					<cfset stCustomer.username = trim(obCustomer.getUsername())>
					<cfset stCustomer.password = trim(obCustomer.getPassword())>
					<cfset stCustomer.email = trim(obCustomer.getEmail())>		
					<cfset stCustomer.blocked = trim(obCustomer.getBlocked())>	
					<cfset stCustomer.roles = trim(obCustomer.getRoles())>	
					<cfset stCustomer.features = trim(obCustomer.getFeatures())>			
									
					<cfquery name="qCreate" datasource="#variables.dsn#">
						INSERT INTO Customer (id,
												uuid,
												title,
												fname,
												sname,
												username,
												password,
												email,
												blocked,
												roles,
												features,
												creation_date,
												created_by)
										VALUES ( #stCustomer.id#,
												'#stCustomer.uuid#',
												'#stCustomer.title#',
												'#stCustomer.fname#',
												'#stCustomer.sname#',
												'#stCustomer.username#',
												'#stCustomer.password#',
												'#stCustomer.email#',
												 #stCustomer.blocked#,
												'#stCustomer.roles#',
												'#stCustomer.features#',
												'#Application.stApp.GMT#',
												'#trim(session.stUser.Username)#'
												);
																																	
					</cfquery>					
					<cfreturn obCustomer.getId() />
			</cffunction>
			
			<cffunction name="update" access="public" returntype="numeric">
					<cfargument name="obCustomer" type="cfc.customer" required="true" />
					
					<cfset var stCustomer = structNew() />
					<cfset stCustomer.id  = trim(obCustomer.getID())>
					<!--- <cfset stCustomer.uuid  = trim(obCustomer.getUUID())> --->
					<cfset stCustomer.title = trim(obCustomer.getTitle())>
					<cfset stCustomer.fname = trim(obCustomer.getFName())>
					<cfset stCustomer.sname = trim(obCustomer.getSName())>
					<cfset stCustomer.username = trim(obCustomer.getUsername())>
					<cfset stCustomer.password = trim(obCustomer.getPassword())>
					<cfset stCustomer.email = trim(obCustomer.getEmail())>		
					<cfset stCustomer.blocked = trim(obCustomer.getBlocked())>	
					<cfset stCustomer.roles = trim(obCustomer.getRoles())>	
					<cfset stCustomer.features = trim(obCustomer.getFeatures())>
					
					<cfquery name="qUpdate" datasource="#variables.dsn#">
						UPDATE customer
							 SET 	title			=	'#stCustomer.title#',
										fname			= '#stCustomer.fname#',
										sname			= '#stCustomer.sname#',
										username	= '#stCustomer.username#',
										password	= '#stCustomer.password#',
										email			= '#stCustomer.email#',
										blocked		=  #stCustomer.blocked#,
										roles			= '#stCustomer.roles#',
										features	= '#stCustomer.features#'
						 WHERE 
						 				id = #stCustomer.id#
					</cfquery>
					
					
					<cfreturn stCustomer.id />
			</cffunction>
						
			<cffunction name="delete" access="public" returntype="void">
					<cfargument name="cid" type="numeric" required="true" />
					<cfquery name="qDelete" datasource="#variables.dsn#">
						DELETE FROM customer WHERE id = #arguments.cid#
					</cfquery>
			</cffunction>
</cfcomponent>
