<cfcomponent hint="I am AddressGateway : access to address business objects" extends="cfc.base">	
			<cffunction name="init" returntype="AddressGateway" hint="">
					<cfargument name="dsn" type="string" required="false" default="#Request.sDSN#">
					<cfset variables.dsn = arguments.dsn/>	
					<cfreturn this>
			</cffunction>
			
			<cffunction name="deleteCustomerAddressLookups" access="public" returntype="void">
				<cfargument name="cid" type="numeric" required="true">
				<cfargument name="lsAddressIds" type="string" required="true">
					<cfquery name="qDeleteCustAddr" datasource="#variables.dsn#">
						DELETE FROM customer_address 
						WHERE customer_id = #arguments.cid#
						AND address_id IN (#arguments.lsAddressIds#)
					</cfquery>
			</cffunction>
			
			<!--- <cffunction name="" access="public" returntype="query">
					<cfargument name="" type="string" required="true">
					<cfargument name="" type="string" required="true">
					
					<cfquery name="qSel" datasource="#variables.dsn#">
							
											
					</cfquery>
					
				<cfreturn >
			</cffunction> --->

</cfcomponent>