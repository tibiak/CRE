<cfcomponent hint="I am responsibl for Address object" extends="cfc.base">	
		
		<cfset variables.const_tableName = "address">
		
		<cffunction name="init" returntype="Address" hint="">
				<cfargument name="id" type="numeric" required="false" default="0">				
				<cfargument name="fullname" type="string">
				<cfargument name="door_no" type="string">
				<cfargument name="entrance_no" type="string">
				<cfargument name="building_no" type="string">
				<cfargument name="street" type="string">
				<cfargument name="city" type="string">
				<cfargument name="district" type="string">
				<cfargument name="postcode" type="string">
				<cfargument name="country" type="string">
				<cfargument name="country_code" type="string">
				<cfargument name="telephone" type="string">
				<cfargument name="mobile" type="string">
				<cfargument name="email" type="string">
				<cfargument name="type" type="string">
				
				<cfset setId(arguments.id) />
				<cfset setFullname(arguments.fullname) />
				<cfset setDoorNo(arguments.door_no) />
				<cfset setEntranceNo(arguments.entrance_no) />
				<cfset setBuildingNo(arguments.building_no) />
				<cfset setStreet(arguments.street) />
				<cfset setCity(arguments.city) />
				<cfset setDistrict(arguments.district) />
				<cfset setPostcode(arguments.postcode) />
				<cfset setCountry(arguments.country) />
				<cfset setCountryCode(arguments.country_code) />
				<cfset setTelephone(arguments.telephone) />
				<cfset setMobile(arguments.mobile) />
				<cfset setEmail(arguments.email) />
				<cfset setType(arguments.type) />
				
				<cfreturn this>
		</cffunction>
		
		<cffunction name="setId" access="public" returntype="void">
				<cfargument name="id" type="numeric" required="true" />
				<cfset variables.id = arguments.id />				
		</cffunction>
		<cffunction name="setFullname" access="public" returntype="void">
				<cfargument name="fullname" type="string" required="true" />
				<cfset variables.fullname = arguments.fullname />				
		</cffunction>
		<cffunction name="setDoorNo" access="public" returntype="void">
				<cfargument name="door_no" type="string" required="true" />
				<cfset variables.door_no = arguments.door_no />				
		</cffunction>
		<cffunction name="setEntranceNo" access="public" returntype="void">
				<cfargument name="entrance_no" type="string" required="true" />
				<cfset variables.entrance_no = arguments.entrance_no />				
		</cffunction>
		<cffunction name="setBuildingNo" access="public" returntype="void">
				<cfargument name="building_no" type="string" required="true" />
				<cfset variables.building_no = arguments.building_no />				
		</cffunction>
		<cffunction name="setStreet" access="public" returntype="void">
				<cfargument name="street" type="string" required="true" />
				<cfset variables.street = arguments.street />				
		</cffunction>
		<cffunction name="setCity" access="public" returntype="void">
				<cfargument name="city" type="string" required="true" />
				<cfset variables.city = arguments.city />				
		</cffunction>
		<cffunction name="setDistrict" access="public" returntype="void">
				<cfargument name="district" type="string" required="true" />
				<cfset variables.district = arguments.district />				
		</cffunction>
		<cffunction name="setPostcode" access="public" returntype="void">
				<cfargument name="postcode" type="string" required="true" />
				<cfset variables.postcode = arguments.postcode />				
		</cffunction>
		<cffunction name="setCountry" access="public" returntype="void">
				<cfargument name="country" type="string" required="true" />
				<cfset variables.country = arguments.country />				
		</cffunction>
		<cffunction name="setCountryCode" access="public" returntype="void">
				<cfargument name="country_code" type="string" required="true" />
				<cfset variables.country_code = arguments.country_code />				
		</cffunction>
		<cffunction name="setTelephone" access="public" returntype="void">
				<cfargument name="telephone" type="string" required="true" />
				<cfset variables.telephone = arguments.telephone />				
		</cffunction>
		<cffunction name="setMobile" access="public" returntype="void">
				<cfargument name="mobile" type="string" required="true" />
				<cfset variables.mobile = arguments.mobile />				
		</cffunction>		
		<cffunction name="setEmail" access="public" returntype="void">
				<cfargument name="email" type="string" required="true" />
				<cfset variables.email = arguments.email />				
		</cffunction>
		<cffunction name="setType" access="public" returntype="void">
				<cfargument name="type" type="string" required="true" />
				<cfset variables.type = arguments.type />				
		</cffunction>
		
		<cffunction name="getId" access="public" returntype="string">
				<cfreturn variables.id />				
		</cffunction>
		<cffunction name="getDoorNo" access="public" returntype="string">
				<cfreturn variables.door_no />				
		</cffunction>
		<cffunction name="getFullname" access="public" returntype="string">
				<cfreturn variables.fullname />				
		</cffunction>
		<cffunction name="getEntranceNo" access="public" returntype="string">
				<cfreturn variables.entrance_no />				
		</cffunction>
		<cffunction name="getBuildingNo" access="public" returntype="string">
				<cfreturn variables.building_no />				
		</cffunction>
		<cffunction name="getStreet" access="public" returntype="string">
				<cfreturn variables.street />				
		</cffunction>
		<cffunction name="getCity" access="public" returntype="string">
				<cfreturn variables.city />				
		</cffunction>
		<cffunction name="getDistrict" access="public" returntype="string">
				<cfreturn variables.district />				
		</cffunction>
		<cffunction name="getPostcode" access="public" returntype="string">
				<cfreturn variables.postcode />				
		</cffunction>
		<cffunction name="getCountry" access="public" returntype="string">
				<cfreturn variables.country />				
		</cffunction>
		<cffunction name="getCountryCode" access="public" returntype="string">
				<cfreturn variables.country_code />				
		</cffunction>
		<cffunction name="getTelephone" access="public" returntype="string">
				<cfreturn variables.telephone />				
		</cffunction>
		<cffunction name="getMobile" access="public" returntype="string">
				<cfreturn variables.mobile />				
		</cffunction>
		<cffunction name="getEmail" access="public" returntype="string">
				<cfreturn variables.email />				
		</cffunction>	
		<cffunction name="getType" access="public" returntype="string">
				<cfreturn variables.type />				
		</cffunction>
		
</cfcomponent>
