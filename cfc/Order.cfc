<cfcomponent hint="I am responsibl for Order object" extends="cfc.base">	
		<cfset variables.const_tableName = "orders">
		
		<!--- <cfset variables.id
		
		<cfproperty name="this." default="" >
		<cfproperty name="this.reference" default="" >
		<cfproperty name="this.customer_id" default="0" />
		<cfproperty name="this.pickup_address_id" default="" />
		<cfproperty name="this.dropoff_address_id" default="" />
		<cfproperty name="this.pickup_req_date" default="" />
		<cfproperty name="this.pickup_req_time" default="" />
		<cfproperty name="this.no_of_items" default="0" />
		<cfproperty name="this.weight" default="0" />
		<cfproperty name="this.content" default="" />
		<cfproperty name="this.cost_gbp" default="0.0" />
		<cfproperty name="this.cost_ron" default="0.0" />
		<cfproperty name="this.lot_no" default="0" />
		<cfproperty name="this.status" default="" />
		<cfproperty name="this.comment" default="" />
		<cfproperty name="this.creation_datetime" default="#application.stApp.GMT#" /> --->
		
		
			
		<cffunction name="init" returntype="Order" hint="">
				<cfargument name="id" type="numeric" required="false" default="0">
				<cfargument name="reference" type="string" required="false" default="">
				<cfargument name="customer_id" type="numeric" required="false" default="0">
				<cfargument name="pickup_address_id" type="numeric" required="false" default="0">
				<cfargument name="dropoff_address_id" type="numeric" required="false" default="0">
				<cfargument name="pickup_req_date" type="date" required="false" default="#DateFormat(now(),'dd/mm/yyyy')#">
				<cfargument name="pickup_req_time" type="string" required="false" default="">
				<cfargument name="no_of_items" type="numeric" required="false" default="0">
				<cfargument name="weight" type="numeric" required="false" default="0">
				<cfargument name="content" type="string" required="false" default="">
				<cfargument name="cost_gbp" type="numeric" required="false" default="0.0">
				<cfargument name="cost_ron" type="numeric" required="false" default="0.0">
				<cfargument name="lot_no" type="numeric" required="false" default="0">
				<cfargument name="status" type="string" required="false" default="">
				<cfargument name="comment" type="string" required="false" default="">
				<cfargument name="creation_datetime" type="date" required="false" default="#application.stApp.GMT#">
				<cfargument name="modify_datetime" type="date" required="false" default="#application.stApp.GMT#">
				<cfargument name="created_by" type="string" required="false" default="">
				<cfargument name="modified_by" type="string" required="false" default="">
				
				
				<cfset setId(arguments.id) />
				<cfset setReference(arguments.reference) />
				<cfset setCustomerId(arguments.customer_id) />
				<cfset setPickupAddressId(arguments.pickup_address_id) />				
				<cfset setDropOffAddressId(arguments.dropoff_address_id) />
				<cfset setPickupRequiredDate(arguments.pickup_req_date) />
				<cfset setPickupRequiredTime(arguments.pickup_req_time) />
				<cfset setNoOfItems(arguments.no_of_items) />
				<cfset setWeight(arguments.weight) />
				<cfset setContent(arguments.content) />
				<cfset setCostGBP(arguments.cost_gbp) />
				<cfset setCostRON(arguments.cost_ron) />
				<cfset setLotNo(arguments.lot_no) />
				<cfset setStatus(arguments.status) />
				<cfset setComment(arguments.comment) />
				<cfset setCreationDateTime(arguments.creation_datetime) />
				<cfset setCreatedBy(arguments.created_by) />
				<cfset setModifyDateTime(arguments.modify_datetime) />
				<cfset setModifiedBy(arguments.modified_by) />
				<cfreturn this>
		</cffunction>
		
		<cffunction name="setId" access="public" returntype="void">
				<cfargument name="id" type="numeric" required="true" />
				<cfset variables.id = arguments.id />				
		</cffunction>		
		<cffunction name="setReference" access="public" returntype="void">
				<cfargument name="reference" type="string" required="true" />
				<cfset variables.reference = arguments.reference />				
		</cffunction>
		<cffunction name="setCustomerId" access="public" returntype="void">
				<cfargument name="customer_id" type="numeric" required="true" />
				<cfset variables.customer_id = arguments.customer_id />				
		</cffunction>
		<cffunction name="setPickupAddressId" access="public" returntype="void">
				<cfargument name="pickup_address_id" type="numeric" required="true" />
				<cfset variables.pickup_address_id = arguments.pickup_address_id />				
		</cffunction>
		<cffunction name="setDropOffAddressId" access="public" returntype="void">
				<cfargument name="dropoff_address_id" type="numeric" required="true" />
				<cfset variables.dropoff_address_id = arguments.dropoff_address_id />				
		</cffunction>
		<cffunction name="setPickupRequiredDate" access="public" returntype="void">
				<cfargument name="pickup_req_date" type="date" required="true" />
				<cfset variables.pickup_req_date = arguments.pickup_req_date />				
		</cffunction>
		<cffunction name="setPickupRequiredTime" access="public" returntype="void">
				<cfargument name="pickup_req_time" type="string" required="true" />
				<cfset variables.pickup_req_time = arguments.pickup_req_time />				
		</cffunction>	
		<cffunction name="setNoOfItems" access="public" returntype="void">
				<cfargument name="no_of_items" type="numeric" required="true" />
				<cfset variables.no_of_items = arguments.no_of_items />				
		</cffunction>	
		<cffunction name="setWeight" access="public" returntype="void">
				<cfargument name="weight" type="numeric" required="true" />
				<cfset variables.weight = arguments.weight />				
		</cffunction>	
		<cffunction name="setContent" access="public" returntype="void">
				<cfargument name="content" type="string" required="true" />
				<cfset variables.content = arguments.content />				
		</cffunction>	
		<cffunction name="setCostGBP" access="public" returntype="void">
				<cfargument name="cost_gbp" type="numeric" required="true" />
				<cfset variables.cost_gbp = arguments.cost_gbp />				
		</cffunction>	
		<cffunction name="setCostRON" access="public" returntype="void">
				<cfargument name="cost_ron" type="numeric" required="true" />
				<cfset variables.cost_ron = arguments.cost_ron />				
		</cffunction>	
		<cffunction name="setLotNo" access="public" returntype="void">
				<cfargument name="lot_no" type="numeric" required="true" />
				<cfset variables.lot_no = arguments.lot_no />				
		</cffunction>
		<cffunction name="setStatus" access="public" returntype="void">
				<cfargument name="status" type="string" required="true" />
				<cfset variables.status = arguments.status />				
		</cffunction>			
		<cffunction name="setComment" access="public" returntype="void">
				<cfargument name="comment" type="string" required="true" />
				<cfset variables.comment = arguments.comment />				
		</cffunction>
		<cffunction name="setCreationDateTime" access="public" returntype="void">
				<cfargument name="creation_datetime" type="date" required="true" />
				<cfset variables.creation_datetime = arguments.creation_datetime />				
		</cffunction>	
		<cffunction name="setCreatedBy" access="public" returntype="void">
				<cfargument name="created_by" type="string" required="true" />
				<cfset variables.created_by = arguments.created_by />				
		</cffunction>
		<cffunction name="setModifyDateTime" access="public" returntype="void">
				<cfargument name="modify_datetime" type="date" required="true" />
				<cfset variables.modify_datetime = arguments.modify_datetime />				
		</cffunction>	
		<cffunction name="setModifiedBy" access="public" returntype="void">
				<cfargument name="modified_by" type="string" required="true" />
				<cfset variables.modified_by = arguments.modified_by />				
		</cffunction>
			
		
		<cffunction name="getId" access="public" returntype="numeric">
				<cfreturn variables.id />				
		</cffunction>		
		<cffunction name="getReference" access="public">
				<cfreturn variables.reference />				
		</cffunction>
		<cffunction name="getCustomerId" access="public">
				<cfreturn variables.customer_id />				
		</cffunction>
		<cffunction name="getPickupAddressId" access="public">
				<cfreturn variables.pickup_address_id />				
		</cffunction>
		<cffunction name="getDropOffAddressId" access="public">
				<cfreturn variables.dropoff_address_id />				
		</cffunction>
		<cffunction name="getPickupRequiredDate" access="public">
				<cfreturn variables.pickup_req_date />				
		</cffunction>
		<cffunction name="getPickupRequiredTime" access="public">
				<cfreturn variables.pickup_req_time />				
		</cffunction>	
		<cffunction name="getNoOfItems" access="public">
				<cfreturn variables.no_of_items />				
		</cffunction>	
		<cffunction name="getWeight" access="public">
				<cfreturn variables.weight />				
		</cffunction>	
		<cffunction name="getContent" access="public">
				<cfreturn variables.content />				
		</cffunction>	
		<cffunction name="getCostGBP" access="public">
				<cfreturn variables.cost_gbp />				
		</cffunction>	
		<cffunction name="getCostRON" access="public">
				<cfreturn variables.cost_ron />				
		</cffunction>	
		<cffunction name="getLotNo" access="public">
				<cfreturn variables.lot_no />				
		</cffunction>	
		<cffunction name="getStatus" access="public">
				<cfreturn variables.status />				
		</cffunction>	
		<cffunction name="getComment" access="public">
				<cfreturn variables.comment />				
		</cffunction>
		<cffunction name="getCreationDateTime" access="public">
				<cfreturn variables.creation_datetime />				
		</cffunction>	
		<cffunction name="getCreatedBy" access="public">
				<cfreturn variables.created_by />				
		</cffunction>
		<cffunction name="getModifyDateTime" access="public">
				<cfreturn variables.modify_datetime />				
		</cffunction>	
		<cffunction name="getModifiedBy" access="public">
				<cfreturn variables.modified_by />				
		</cffunction>
		
</cfcomponent>
