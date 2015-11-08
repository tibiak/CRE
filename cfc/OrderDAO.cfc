<cfcomponent displayname="OrderDAO">
			<cfset variables.dsn = "" />
			
			<cfset init() />
			
			<cffunction name="init" returntype="OrderDAO" hint="">
					<cfargument name="dsn" type="string" required="false" default="#Request.sDSN#">
					<cfset variables.dsn = arguments.dsn/>	
					<cfreturn this />
			</cffunction>
			
			<cffunction name="create" access="public" returntype="void">
					<cfargument name="obOrder" type="cfc.order" required="true" />						
										
					<cfset var stOrder = structNew() />
					<cfset stOrder.id 								= trim(arguments.obOrder.getId())>
					<cfset stOrder.reference 					= trim(arguments.obOrder.getReference())>
					<cfset stOrder.customer_id 				= trim(arguments.obOrder.getCustomerId())>
					<cfset stOrder.pickup_address_id 	= trim(arguments.obOrder.getPickupAddressId())>
					<cfset stOrder.dropoff_address_id = trim(arguments.obOrder.getDropOffAddressId())>
					<cfset stOrder.pickup_req_date 		= trim(arguments.obOrder.getPickupRequiredDate())>		
					<cfset stOrder.pickup_req_time 		= trim(arguments.obOrder.getPickupRequiredTime())>
					<cfset stOrder.no_of_items 				= trim(arguments.obOrder.getNoOfItems())>
					<cfset stOrder.weight 						= trim(arguments.obOrder.getWeight())>
					<cfset stOrder.content 						= trim(arguments.obOrder.getContent())>
					<cfset stOrder.cost_gbp						= trim(arguments.obOrder.getCostGBP())>
					<cfset stOrder.cost_ron 					= trim(arguments.obOrder.getCostRON())>
					<cfset stOrder.lot_no 						= trim(arguments.obOrder.getLotNo())>
					<cfset stOrder.status 						= trim(arguments.obOrder.getStatus())>
					<cfset stOrder.comment 						= trim(arguments.obOrder.getComment())>
					<cfset stOrder.creation_datetime 	= trim(arguments.obOrder.getCreationDateTime())>	
					<cfset stOrder.created_by				 	= trim(arguments.obOrder.getCreatedBy())>		
									
					<cfquery name="qCreate" datasource="#variables.dsn#">
						INSERT INTO Orders	(	id,
																	reference,
																	customer_id,
																	pickup_address_id,
																	dropoff_address_id,
																	pickup_req_date,
																	pickup_req_time,
																	no_of_items,
																	weight_kg,
																	content,
																	cost_gbp,
																	cost_ron,
																	lot_no,
																	status,
																	comment,
																	creation_date,
																	created_by)
																	
										VALUES ( #stOrder.id#,
														'#uCase(stOrder.reference)#',
														 #stOrder.customer_id#,
														 #stOrder.pickup_address_id#,
														 #stOrder.dropoff_address_id#,
														'#stOrder.pickup_req_date#',
														'#stOrder.pickup_req_time#',
														 #stOrder.no_of_items#,
														 #stOrder.weight#,
														'#stOrder.content#',
														 #stOrder.cost_gbp#,
														 #stOrder.cost_ron#,
														 #stOrder.lot_no#,
														'#stOrder.status#',
														'#stOrder.comment#',
														'#stOrder.creation_datetime#',
														'#stOrder.created_by#');
																																	
					</cfquery>					
			</cffunction>
			
			
			<cffunction name="update" access="public" returntype="void">
					<cfargument name="obOrder" type="cfc.order" required="true" />						
										
					<cfset var stOrder = structNew() />
					<cfset stOrder.id 								= trim(arguments.obOrder.getId())>
					<cfset stOrder.reference 					= trim(arguments.obOrder.getReference())>
					<cfset stOrder.customer_id 				= trim(arguments.obOrder.getCustomerId())>
					<cfset stOrder.pickup_address_id 	= trim(arguments.obOrder.getPickupAddressId())>
					<cfset stOrder.dropoff_address_id = trim(arguments.obOrder.getDropOffAddressId())><!---  --->
					<cfset stOrder.pickup_req_date 		= trim(arguments.obOrder.getPickupRequiredDate())>		
					<cfset stOrder.pickup_req_time 		= trim(arguments.obOrder.getPickupRequiredTime())>
					<cfset stOrder.no_of_items 				= trim(arguments.obOrder.getNoOfItems())>
					<cfset stOrder.weight 						= trim(arguments.obOrder.getWeight())>
					<cfset stOrder.content 						= trim(arguments.obOrder.getContent())>
					<!--- <cfset stOrder.cost_gbp						= trim(arguments.obOrder.getCostGBP())>
					<cfset stOrder.cost_ron 					= trim(arguments.obOrder.getCostRON())>
					<cfset stOrder.lot_no 						= trim(arguments.obOrder.getLotNo())> --->
					<cfset stOrder.status 						= trim(arguments.obOrder.getStatus())>
					<cfset stOrder.comment 						= trim(arguments.obOrder.getComment())>
					<!--- <cfset stOrder.creation_datetime 	= trim(arguments.obOrder.getCreationDateTime())> --->	
					<cfset stOrder.modify_datetime 		= trim(arguments.obOrder.getModifyDateTime())>
					<cfset stOrder.modified_by				= trim(arguments.obOrder.getModifiedBy())>		
									
					<cfquery name="qCreate" datasource="#variables.dsn#">
						UPDATE Orders
							SET reference						=	'#stOrder.reference#',
									customer_id					=  #stOrder.customer_id#,
									pickup_address_id		=	 #stOrder.pickup_address_id#,
									dropoff_address_id	=	 #stOrder.dropoff_address_id#,
									pickup_req_date			=	'#stOrder.pickup_req_date#',
									pickup_req_time			=	'#stOrder.pickup_req_time#',
									no_of_items					=	 #stOrder.no_of_items#,
									weight_kg						=	 #stOrder.weight#,
									content							=	'#stOrder.content#',
									<!--- cost_gbp			=	 #stOrder.cost_gbp#,
									cost_ron						=	 #stOrder.cost_ron#,
									lot_no							=	 #stOrder.#, --->
									status							=	'#stOrder.status#',
									comment							=	'#stOrder.comment#',
									modify_date					=	'#stOrder.modify_datetime#',
									modified_by					= '#stOrder.modified_by#'
						WHERE
									id		=	#stOrder.id#																																
					</cfquery>					
			</cffunction>			
			
			
			<cffunction name="read" access="public" returntype="query">
				<cfargument name="id" type="numeric" required="true">
				<cfquery name="qRead" datasource="#variables.dsn#">
						SELECT * FROM orders WHERE id = #arguments.id#
					</cfquery>
				<cfreturn qRead />
			</cffunction>
			
			<cffunction name="delete" access="public" returntype="void">
				<cfargument name="id" type="numeric" required="true">
					<cfquery name="qDelete" datasource="#variables.dsn#">
						DELETE FROM orders WHERE id = #arguments.id#
					</cfquery>
			</cffunction>
</cfcomponent>
