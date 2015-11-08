<cfcomponent output="false">
	<cfset variables.validationRule_NotEmpty 	= "eq 0" />
	<cfset variables.validationRule_Min3 		= "lt 3" />
		
	<cffunction name="init" access="public" returntype="inputValidator">
		<cfargument name="stData" type="struct" required="true" />
		<cfset variables.stDataToValidate = arguments.stData />
		<cfreturn this />
	</cffunction>
	
	<!--- Public members --->	
	<cffunction name="checkEmpty" access="public" returntype="string">
		<cfargument name="lsKeyNames" required="true" type="string" />		
		<cfset local.arrErrorKeys = arrayNew(1) />
		<cfset local.stDataToValidate = duplicate(getDataStructToValidate()) />
		
		<cfloop list="#arguments.lsKeyNames#" index="keyname">
			<cfif structKeyExists(local.stDataToValidate,keyname)>
				<cfset keyvalue = trim(evaluate("local.stDataToValidate.#keyname#")) />			
				<cfif not len(keyvalue)>
					<cfset arrayAppend(local.arrErrorKeys,keyname) />
				</cfif>
			</cfif>
		</cfloop>
		
		<cfreturn arrayToList(local.arrErrorKeys) />
	</cffunction>
	
	<cffunction name="checkDate" access="public" returntype="string">
		<cfargument name="lsKeyNames" required="true" type="string" />	
		<cfset local.arrErrorKeys = arrayNew(1) />
		<cfset local.stDataToValidate = duplicate(getDataStructToValidate()) />
		
		<cfloop list="#arguments.lsKeyNames#" index="keyname">
			<cfif structKeyExists(local.stDataToValidate,keyname)>
				<cfset keyvalue = trim(evaluate("local.stDataToValidate.#keyname#")) />			
				<cfif not isDate(keyvalue)>
					<cfset arrayAppend(local.arrErrorKeys,keyname) />
				</cfif>
			</cfif>
		</cfloop>
		
		<cfreturn arrayToList(local.arrErrorKeys) />
	</cffunction>

	
	<cffunction name="checkLength" access="public" returntype="string">
		<cfargument name="lsKeyNames" required="true" type="string" />
		<cfargument name="iMinLength" required="true" type="numeric" />
		<cfset local.arrErrorKeys = arrayNew(1) />
		<cfset local.stDataToValidate = duplicate(getDataStructToValidate()) />
		
		<cfloop list="#arguments.lsKeyNames#" index="keyname">
			<cfif structKeyExists(local.stDataToValidate,keyname)>
				<cfset keyvalue = trim(evaluate("local.stDataToValidate.#keyname#")) />				
				<cfif not len(keyvalue) gte arguments.iMinLength>
					<cfset arrayAppend(local.arrErrorKeys,keyname) />
				</cfif>
			</cfif>
		</cfloop>
		
		<cfreturn arrayToList(local.arrErrorKeys) />
	</cffunction>
	
	<cffunction name="checkEmail" access="public" returntype="boolean">
		<cfargument name="str" required="true" type="string" />
		<cfreturn (REFindNoCase("^['_a-z0-9-\+]+(\.['_a-z0-9-\+]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*\.(([a-z]{2,3})|(aero|asia|biz|cat|coop|info|museum|name|jobs|post|pro|tel|travel|mobi))$",
				arguments.str) AND len(listGetAt(arguments.str, 1, "@")) LTE 64 AND
				len(listGetAt(arguments.str, 2, "@")) LTE 255) IS 1>
	</cffunction>	
	
	<cffunction name="checkPassword" access="public" returntype="numeric" hint="Returns 0 for success">
		<cfargument name="sKeyName" required="true" type="string" hint="The name of the key in the structure for which the value is to be validated" />
	
		<cfset var iret = 0 />
		<cfset local.stDataToValidate = duplicate(getDataStructToValidate()) />		
		<cfset keyname = arguments.sKeyName />
		
		<cfif structKeyExists(local.stDataToValidate,keyname)>
			<cfset keyvalue = trim(evaluate("local.stDataToValidate.#keyname#")) />				
			
			<cfif len(trim(keyvalue)) gt 10>
				<cfset iret = 1 />
			</cfif>
			
			<cfset regex = "^.*(?=.{7,})((?=.*\d)(?=.*[a-z])(?=.*[A-Z])|(?=.*\d)(?=.*[a-z])(?=.*[^a-zA-Z0-9])|(?=.*\d)(?=.*[A-Z])(?=.*[^a-zA-Z0-9])|(?=.*[a-z])(?=.*[A-Z])(?=.*[^a-zA-Z0-9])).*$" />
		
			<cfif not refind(regex,keyvalue)>
				<cfset iret = -1 />
			</cfif>		
		</cfif>	
		
		<cfreturn iret />
	</cffunction>
	
	<cffunction name="illegalChars" access="public" returntype="string">
		<cfargument name="lsKeyNames" required="true" type="string" />		
		<!--- //replace invalid character with empty string (other than alpanumeric,.,@ and -) --->

		<cfset var regex = "[^\w\.@-]" />
		<cfset local.arrErrorKeys = arrayNew(1) />
		<cfset local.stDataToValidate = duplicate(getDataStructToValidate()) />
		
		
		<cfloop list="#arguments.lsKeyNames#" index="keyname">
			<cfif structKeyExists(local.stDataToValidate,keyname)>
				<cfset keyvalue = trim(evaluate("local.stDataToValidate.#keyname#")) />			
				<cfif refind(regex,keyvalue)>
					<cfset arrayAppend(local.arrErrorKeys,keyname) />
				</cfif>
			</cfif>
		</cfloop>
		
		<cfreturn arrayToList(local.arrErrorKeys) />
	</cffunction>
	
	<cffunction name="checkNumeric" access="public" returntype="string">
		<cfargument name="lsKeyNames" required="true" type="string" />		
		<!--- //return false if numeric chars found --->

		<cfset var regex = "=\d" />
		<cfset local.arrErrorKeys = arrayNew(1) />
		<cfset local.stDataToValidate = duplicate(getDataStructToValidate()) />
		
		
		<cfloop list="#arguments.lsKeyNames#" index="keyname">
			<cfif structKeyExists(local.stDataToValidate,keyname)>
				<cfset keyvalue = trim(evaluate("local.stDataToValidate.#keyname#")) />			
				<cfif refind(regex,keyvalue)>
					<cfset arrayAppend(local.arrErrorKeys,keyname) />
				</cfif>
			</cfif>
		</cfloop>
		
		<cfreturn arrayToList(local.arrErrorKeys) />
	</cffunction>
	
	
	
	<!--- Private members --->
	<cffunction name="getDataStructToValidate" access="private" returntype="struct">
		<cfreturn variables.stDataToValidate />
	</cffunction>
		
</cfcomponent>