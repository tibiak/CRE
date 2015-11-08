<cfcomponent hint="I am responsibl for customer object" extends="cfc.base">	
			<cfset variables.const_tableName = "customer">
			<!--- <cfset variables.newID = 0> --->
			<!--- <cfset setNewId(const_tableName) />for a new entry --->
			
		<cffunction name="init" returntype="Customer" hint="">
				<cfargument name="id" type="numeric" required="false" default="0">				
				<cfargument name="title" type="string" required="false" default="">
				<cfargument name="fname" type="string" required="false" default="">
				<cfargument name="sname" type="string" required="false" default="">
				<cfargument name="username" type="string" required="false" default="">
				<cfargument name="password" type="string" required="false" default="ii">
				<cfargument name="email" type="string" required="false" default="">
				<cfargument name="blocked" type="numeric" required="false" default="1">
				<cfargument name="roles" type="string" required="false" default="">
				<cfargument name="features" type="string" required="false" default="">
				<cfargument name="orders" type="string" required="false" default="">	
				<cfargument name="addresses" type="string" required="false" default="">			
				
				<cfset setId(arguments.id) />
				<cfset setUUID() />
				<cfset setTitle(arguments.title) />
				<cfset setFname(arguments.fname) />
				<cfset setSname(arguments.sname) />
				<cfset setUsername(arguments.username) />				
				<cfset setPassword(arguments.password) />
				<cfset setEmail(arguments.email) />
				<cfset setBlocked(arguments.blocked) />
				<cfset setRoles(arguments.roles) />
				<cfset setFeatures(arguments.features) />
				<cfset setOrders(arguments.orders) />
				<cfset setAddresses(arguments.addresses) />
								
			<cfreturn this>
		</cffunction>
		
		<cffunction name="setId" access="public" returntype="void">
				<cfargument name="id" type="string" required="true" />
				<cfset variables.id = arguments.id />				
		</cffunction>		
		<cffunction name="setUUID" access="public" returntype="void">
				<cfset variables.uuid = createUUID() />				
		</cffunction>	
		<cffunction name="setTitle" access="public" returntype="void">
				<cfargument name="title" type="string" required="true" />
				<cfset variables.title = arguments.title />				
		</cffunction>
		<cffunction name="setFname" access="public" returntype="void">
				<cfargument name="fname" type="string" required="true" />
				<cfset variables.fname = arguments.fname />				
		</cffunction>
		<cffunction name="setSname" access="public" returntype="void">
				<cfargument name="sname" type="string" required="true" />
				<cfset variables.sname = arguments.sname />				
		</cffunction>
		<cffunction name="setUsername" access="public" returntype="void">
				<cfargument name="username" type="string" required="true" />
				<cfset variables.username = arguments.username />				
		</cffunction>
		<cffunction name="setPassword" access="public" returntype="void">
				<cfargument name="password" type="string" required="true" />
				<cfset variables.password = arguments.password />				
		</cffunction>
		<cffunction name="setEmail" access="public" returntype="void">
				<cfargument name="email" type="string" required="true" />
				<cfset variables.email = arguments.email />				
		</cffunction>	
		<cffunction name="setBlocked" access="public" returntype="void">
				<cfargument name="blocked" type="numeric" required="true" />
				<cfset variables.blocked = arguments.blocked />				
		</cffunction>
		<cffunction name="setRoles" access="public" returntype="void">
				<cfargument name="roles" type="string" required="false" />
				<cfset variables.roles = arguments.roles />				
		</cffunction>	
		<cffunction name="setFeatures" access="public" returntype="void">
				<cfargument name="features" type="string" required="true" />
				<cfset variables.features = arguments.features />				
		</cffunction>
		<cffunction name="setOrders" access="public" returntype="void">
				<cfargument name="lsOrdersIDs" type="string" required="true" />
				<cfset variables.lsOrderIDs = arguments.lsOrdersIDs />				
		</cffunction>
		<cffunction name="setAddresses" access="public" returntype="void">
				<cfargument name="lsAddressIDs" type="string" required="true" />
				<cfset variables.lsAddressIDs = arguments.lsAddressIDs />				
		</cffunction>
		
		<cffunction name="getId" access="public" returntype="string">
				<cfreturn variables.id />				
		</cffunction>	
		<cffunction name="getUUID" access="public" returntype="string">
				<cfreturn variables.uuid />				
		</cffunction>
		<cffunction name="getTitle" access="public" returntype="string">
				<cfreturn variables.title />				
		</cffunction>
		<cffunction name="getFname" access="public" returntype="string">
				<cfreturn variables.fname />				
		</cffunction>
		<cffunction name="getSname" access="public" returntype="string">
				<cfreturn variables.sname />				
		</cffunction>
		<cffunction name="getUsername" access="public" returntype="string">
				<cfreturn variables.username />				
		</cffunction>
		<cffunction name="getPassword" access="public" returntype="string">
				<cfreturn variables.password />				
		</cffunction>
		<cffunction name="getEmail" access="public" returntype="string">
				<cfreturn variables.email />				
		</cffunction>
		<cffunction name="getBlocked" access="public" returntype="string">
				<cfreturn variables.blocked />				
		</cffunction>
		<cffunction name="getRoles" access="public" returntype="string">
				<cfreturn variables.roles />				
		</cffunction>
		<cffunction name="getFeatures" access="public" returntype="string">
				<cfreturn variables.features />				
		</cffunction>
		<cffunction name="getOrders" access="public" returntype="string">
				<cfreturn variables.lsOrderIDs />				
		</cffunction>
		<cffunction name="getAddresses" access="public" returntype="string">
				<cfreturn variables.lsAddressIDs />				
		</cffunction>
		
</cfcomponent>