<cfcomponent hint="I am responsibl for C R U D a customer object">
			<cfset variables.dsn = "" />
			
			<cffunction name="init" returntype="AddressDAO" hint="">
					<cfargument name="dsn" type="string" required="false" default="#Request.sDSN#">
					<cfset variables.dsn = arguments.dsn/>	
					<cfreturn this>
			</cffunction>
			
			<cffunction name="create" access="public" returntype="numeric">
					<cfargument name="obAddress" type="address" required="true" />
					<cfargument name="customerID" type="numeric" required="true" />				
					
						<cfset var stAddress = structNew() />
						<cfset stAddress.id 					= obAddress.getId() />
						<cfset stAddress.fullname			= obAddress.getFullname() />
						<cfset stAddress.door_no 			= obAddress.getDoorNo() />
						<cfset stAddress.entrance_no 	= obAddress.getEntranceNo() />
						<cfset stAddress.building_no 	= obAddress.getBuildingNo() />
						<cfset stAddress.street 			= obAddress.getStreet() />
						<cfset stAddress.city 				= obAddress.getCity() />
						<cfset stAddress.district 		= obAddress.getDistrict() />
						<cfset stAddress.postcode 		= obAddress.getPostcode() />
						<cfset stAddress.country 			= obAddress.getCountry() />
						<cfset stAddress.country_code	= obAddress.getCountryCode() />
						<cfset stAddress.telephone		= obAddress.getTelephone() />
						<cfset stAddress.mobile				= obAddress.getMobile() />
						<cfset stAddress.email 				= obAddress.getEmail() />
						<cfset stAddress.type					= obAddress.getType() />
										
						<cfquery name="qCreate" datasource="#variables.dsn#">
							INSERT INTO Address ( id,
																		fullname,
																		door_no,
																		entrance_no,
																		building_no,
																		street,
																		city,
																		district,
																		postcode,
																		country,
																		country_code,
																		telephone,
																		mobile,
																		email,
																		type,
																		creation_date,
																		created_by)
											VALUES (
																		 #stAddress.id#,
																		'#trim(stAddress.fullname)#',
																		'#trim(stAddress.door_no)#',
																		'#trim(stAddress.entrance_no)#',
																		'#trim(stAddress.building_no)#',
																		'#trim(stAddress.street)#',
																		'#trim(stAddress.city)#',
																		'#trim(stAddress.district)#',
																		'#trim(stAddress.postcode)#',
																		'#trim(stAddress.country)#',
																		'#trim(stAddress.country_code)#',
																		'#trim(stAddress.telephone)#',
																		'#trim(stAddress.mobile)#',
																		'#trim(stAddress.email)#',
																		'#trim(stAddress.type)#',																		
																		'#Application.stApp.GMT#',
																		'#session.stUser.Username#')																	
						</cfquery>	
						<cfquery name="qCreateLKP" datasource="#variables.dsn#">
							INSERT INTO customer_address(customer_id,address_id)
								VALUES(#arguments.customerID#,#obAddress.getId()#)
						</cfquery>
																	
					<cfreturn obAddress.getId() />
			</cffunction>
			
			<cffunction name="update" access="public" returntype="void">
					<cfargument name="obAddress" type="cfc.address" required="true" />
					
						<cfset var stAddress = structNew() />
						<cfset stAddress.id 					= arguments.obAddress.getId() />
						<cfset stAddress.fullname			= arguments.obAddress.getFullname() />
						<cfset stAddress.door_no 			= arguments.obAddress.getDoorNo() />
						<cfset stAddress.entrance_no 	= arguments.obAddress.getEntranceNo() />
						<cfset stAddress.building_no 	= arguments.obAddress.getBuildingNo() />
						<cfset stAddress.street 			= arguments.obAddress.getStreet() />
						<cfset stAddress.city 				= arguments.obAddress.getCity() />
						<cfset stAddress.district 		= arguments.obAddress.getDistrict() />
						<cfset stAddress.postcode 		= arguments.obAddress.getPostcode() />
						<cfset stAddress.country 			= arguments.obAddress.getCountry() />
						<cfset stAddress.country_code	= arguments.obAddress.getCountryCode() />
						<cfset stAddress.telephone		= arguments.obAddress.getTelephone() />
						<cfset stAddress.mobile				= arguments.obAddress.getMobile() />
						<cfset stAddress.email 				= arguments.obAddress.getEmail() />
						<cfset stAddress.type					= arguments.obAddress.getType() />		
					
					<cfquery name="qUpdate" datasource="#variables.dsn#">
							UPDATE Address  
								SET												
												fullname			= '#stAddress.fullname#',
												door_no				= '#stAddress.door_no#',
												entrance_no		= '#stAddress.entrance_no#',
												building_no 	= '#stAddress.building_no#',
												street				= '#stAddress.street#',
												city					= '#stAddress.city#',
												district			= '#stAddress.district#',
												postcode			= '#stAddress.postcode#',
												country				= '#stAddress.country#',
												country_code	=	'#stAddress.country_code#',
												telephone			= '#stAddress.telephone#',
												mobile				= '#stAddress.mobile#',
												email					= '#stAddress.email#',
												<!--- type					= '#arguments.obAddress.#', --->
												modify_date		= '#application.stApp.GMT#',
												modified_by		= '#session.stUser.Username#'
							WHERE
												id						=  #stAddress.id#
																		
					</cfquery>
			</cffunction>
			
			<cffunction name="delete" access="public" returntype="void">
				<!--- <cfargument name="obAddress" type="cfc.address" required="true" />
					<cfquery name="qDelete" datasource="#variables.dsn#">
						DELETE FROM address WEHRE id = #obAddress.getId()#
					</cfquery> --->
					<cfargument name="id" type="numeric" required="true" />
					
					<cfquery name="qDelete" datasource="#variables.dsn#">
						DELETE FROM address WHERE id = #arguments.id#
					</cfquery>
			</cffunction>
</cfcomponent>