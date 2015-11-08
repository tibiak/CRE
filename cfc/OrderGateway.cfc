<cfcomponent hint="I am responsibl for order object gateway" extends="cfc.base">	
		<cffunction name="init" returntype="OrderGateway" hint="">
				<cfargument name="dsn" type="string" required="false" default="crespo">				
				<cfset variables.dsn = arguments.dsn />
				<cfreturn this>
		</cffunction>
		
		<cffunction name="getOrdersByStatus" access="public" returntype="query">
				<cfargument name="orderStatus" type="string" required="true" />
				<cfargument name="cacheIt" type="boolean" required="false" default="false" />				
				<cfset var timeSpan =  createTimeSpan(0,0,0,0)/>				
				<cfif cacheIt>					
					<cfset timeSpan = createTimeSpan(0,0,0,59) />
				</cfif>				
				<cfquery name="qSel" datasource="#variables.dsn#" cachedwithin="#timeSpan#" >	
					SELECT 	
							o.id,
							o.reference,
							o.customer_id,
							<!--- o.pickup_address_id,
							o.dropoff_address_id, --->
							o.pickup_req_date,
							o.pickup_req_time,
							o.no_of_items,
							o.weight_kg,
							o.content,
							o.lot_no,
							o.status,
							o.comment,
							o.creation_date,
							c.fname,
							c.sname,
							c.email,
							<!--- pickup address --->
							pua.fullname as exp_name,
							pua.door_no as pu_door_no,
							pua.entrance_no as pu_entrance_no,
							pua.building_no as pu_building_no,
							pua.street as pu_street,
							pua.city as pu_city,
							pua.district as pu_district,
							pua.postcode as pu_postcode,
							pua.country as pu_country,
							pua.telephone as pu_telephone,
							pua.mobile as pu_mobile,
							pua.email as pu_email,
							pua.type,
							<!--- dropoff address --->
							doa.fullname as dest_name,
							doa.door_no as do_door_no,
							doa.entrance_no as do_entrance_no,
							doa.building_no as do_building_no,
							doa.street as do_street,
							doa.city as do_city,
							doa.district as do_district,
							doa.postcode as do_postcode,
							doa.country as do_country,
							doa.telephone as do_telephone,
							doa.mobile as do_mobile,
							doa.email as do_email,
							doa.type as do_type
							
						FROM 
								(((orders o LEFT JOIN customer c ON o.customer_id = c.id) 
										LEFT JOIN address pua ON o.pickup_address_id = pua.id) 
             				LEFT JOIN address doa ON o.dropoff_address_id = doa.id)
						WHERE 1=1
									<!--- o.status = '#arguments.orderStatus#' --->
									<cfif len(trim(arguments.orderStatus))>
									AND o.status = '#arguments.orderStatus#'
									</cfif>
						ORDER BY o.creation_date DESC;
				</cfquery>
			<cfreturn qSel />
		</cffunction>
		
		
		<cffunction name="getOrdersByCustomerId" access="public" returntype="query">
				<cfargument name="cid" type="numeric" required="true" />
				<cfargument name="orderStatus" type="string" required="true" />
				<cfargument name="cacheIt" type="boolean" required="false" default="false" />				
				<cfset var timeSpan =  createTimeSpan(0,0,0,0)/>				
				<cfif cacheIt>					
					<cfset timeSpan = createTimeSpan(0,0,0,59) />
				</cfif>				
				<cfquery name="qSel" datasource="#variables.dsn#" cachedwithin="#timeSpan#" >	
					SELECT 	
							o.id,
							o.reference,
							o.customer_id,
							<!--- o.pickup_address_id,
							o.dropoff_address_id, --->
							o.pickup_req_date,
							o.pickup_req_time,
							o.no_of_items,
							o.weight_kg,
							o.content,
							o.lot_no,
							o.status,
							o.comment,
							o.creation_date,
							c.fname,
							c.sname,
							c.email,
							<!--- pickup address --->
							pua.fullname as exp_name,
							pua.door_no as pu_door_no,
							pua.entrance_no as pu_entrance_no,
							pua.building_no as pu_building_no,
							pua.street as pu_street,
							pua.city as pu_city,
							pua.district as pu_district,
							pua.postcode as pu_postcode,
							pua.country as pu_country,
							pua.telephone as pu_telephone,
							pua.mobile as pu_mobile,
							pua.email as pu_email,
							pua.type,
							<!--- dropoff address --->
							doa.fullname as dest_name,
							doa.door_no as do_door_no,
							doa.entrance_no as do_entrance_no,
							doa.building_no as do_building_no,
							doa.street as do_street,
							doa.city as do_city,
							doa.district as do_district,
							doa.postcode as do_postcode,
							doa.country as do_country,
							doa.telephone as do_telephone,
							doa.mobile as do_mobile,
							doa.email as do_email,
							doa.type as do_type
							
						FROM 
								(((orders o LEFT JOIN customer c ON o.customer_id = c.id) 
										LEFT JOIN address pua ON o.pickup_address_id = pua.id) 
             				LEFT JOIN address doa ON o.dropoff_address_id = doa.id)
						WHERE 
									o.customer_id = #arguments.cid#
									<cfif len(trim(arguments.orderStatus))>
									AND o.status = '#arguments.orderStatus#'
									</cfif>
						ORDER BY o.creation_date DESC, o.status ASC;
				</cfquery>
			<cfreturn qSel />
		</cffunction>
		
		
		
		<cffunction name="searchOrdersByDateInterval" access="public" returntype="query">
				<cfargument name="startDate" type="date" required="true" />
				<cfargument name="endDate" type="date" required="true" />
				<cfargument name="status" type="string" required="false" />
				
				<cfquery name="qSel" datasource="#variables.dsn#">
					SELECT 	
							o.id,
							o.reference,
							<!--- o.customer_id,
							o.pickup_address_id,
							o.dropoff_address_id, --->
							o.pickup_req_date,
							o.pickup_req_time,
							o.no_of_items,
							o.weight_kg,
							o.content,
							o.lot_no,
							o.status,
							o.comment,
							o.creation_date,
							c.fname,
							c.sname,
							c.email,
							<!--- pickup address --->
							pua.fullname as exp_name,
							pua.door_no as pu_door_no,
							pua.entrance_no as pu_entrance_no,
							pua.building_no as pu_building_no,
							pua.street as pu_street,
							pua.city as pu_city,
							pua.district as pu_district,
							pua.postcode as pu_postcode,
							pua.country as pu_country,
							pua.telephone as pu_telephone,
							pua.mobile as pu_mobile,
							pua.email as pu_email,
							pua.type,
							<!--- dropoff address --->
							doa.fullname as dest_name,
							doa.door_no as do_door_no,
							doa.entrance_no as do_entrance_no,
							doa.building_no as do_building_no,
							doa.street as do_street,
							doa.city as do_city,
							doa.district as do_district,
							doa.postcode as do_postcode,
							doa.country as do_country,
							doa.telephone as do_telephone,
							doa.mobile as do_mobile,
							doa.email as do_email,
							doa.type as do_type
						FROM 
								(((orders o LEFT JOIN customer c ON o.customer_id = c.id) 
										LEFT JOIN address pua ON o.pickup_address_id = pua.id) 
             				LEFT JOIN address doa ON o.dropoff_address_id = doa.id)
						WHERE 1=1
						<cfif len(trim(arguments.status))>	
							AND o.status = '#arguments.status#'
						</cfif>								
						AND (o.creation_date > #dateAdd("d",-1,arguments.startDate)# AND o.creation_date < #dateAdd("d",1,arguments.endDate)#)
						ORDER BY o.creation_date DESC;
				</cfquery>
			<cfreturn qSel />
		</cffunction>
		
		<!--- CHECK ORDER REFERENCE UNIQUENESS --->
		<cffunction name="checkOrderReferenceUniqueness" access="public" returntype="numeric">
				<cfargument name="sOrderReference" type="string" required="true" />
				
				<cfquery name="qSel" datasource="#variables.dsn#">
					SELECT id FROM Orders WHERE reference = '#arguments.sOrderReference#'
				</cfquery>
				
			<cfreturn qSel.RecordCount />
		</cffunction>
		
		
		<cffunction name="closeOrders" access="public">
				<cfargument name="lsId" type="string" required="true" />
				
				<cfquery name="qSel" datasource="#variables.dsn#">
					UPDATE	orders
					SET 		status = 'CLOSED'
					WHERE		id IN (#arguments.lsId#)
				</cfquery>
		</cffunction>
		
</cfcomponent>