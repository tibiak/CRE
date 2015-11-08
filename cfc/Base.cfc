<cfcomponent hint="">
			<cfset variables.dsn = "" />
			<cfset variables.const_tableName = "">
			
			<cfset init(Request.sDSN) />
			<cffunction name="init" access="public" returntype="void">
				<cfargument name="dsn" required="true" default="">
				<cfset variables.dsn="#arguments.dsn#" />
			</cffunction>
			
			<cffunction name="getTableName" access="public" returntype="string">
				<cfreturn variables.const_tableName />
			</cffunction>
			
			<cffunction name="getMaxId" access="public" returntype="void">
					<cfargument name="obCustomer" type="cfc.customer" required="true" />
					
					<cfquery name="qRead" datasource="#variables.dsn#">
						select max(id) as maxid from #arguments.tableName#
					</cfquery>
					<cfreturn qRead.maxid />
			</cffunction>
			
			<cffunction name="setNewId" access="public" returntype="void">
					<!--- <cfargument name="tableName" type="string" required="true" /> --->
					
					<cfset var tableName = getTableName() />
					
					<cfset var id = 0>
					<cfquery name="qRead" datasource="#variables.dsn#">
						select max(id) as maxid from #tableName#
					</cfquery>
					<cfset variables.id = iif(isNumeric(qRead.maxid),de(evaluate("#qRead.maxid#+1")),"1") />					
			</cffunction>
			<cffunction name="getNewId" access="public" returntype="numeric">
				<cfreturn variables.id />
			</cffunction>
			
			<cffunction name="getVariablesData" access="public" returntype="any">
					<cfreturn variables/>
			</cffunction>
</cfcomponent>
