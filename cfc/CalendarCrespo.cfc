<cfcomponent output="false" extends="cfc.Calendar">
	
	<cffunction name="getMonth" returntype="query">
		<cfargument name="year" type="numeric" />
		<cfargument name="month" type="numeric" />			
		<cfquery name="q" datasource="#request.sdsn#">
			select d,country from calendar where y = #arguments.year# and m = #arguments.month#
		</cfquery>
		<cfreturn q />
	</cffunction>
	
	<cffunction name="getDaysInMonthForCountry" returntype="string">
		<cfargument name="year" type="numeric" />
		<cfargument name="month" type="numeric" />
		<cfargument name="country" type="string" />
			
		<cfquery name="q" datasource="#request.sdsn#">
			select d from calendar where y = #arguments.year# and m = #arguments.month# and country = '#arguments.country#'
		</cfquery>
		<cfreturn valueList(q.d) />
	</cffunction>
	
	<cffunction name="getCountryByDayInMonth" returntype="string">
		<cfargument name="day" type="numeric" />
		<cfargument name="qMonth" type="query" />		
		<cfquery name="q" dbtype="query">
			select country from arguments.qMonth where d = #arguments.day#
		</cfquery>
		<cfreturn q.country />		
	</cffunction>
		
	<cffunction name="updateMonth" returntype="boolean">
		<cfargument name="year" type="numeric" />
		<cfargument name="month" type="numeric" />
		<cfargument name="daysUK" type="string" />
		<cfargument name="daysRO" type="string" />
		<cfargument name="daysOFF" type="string" />
		
		<cfset status = true />
		<!--- <cfdump var="#arguments#"/> --->
		
		<!--- uk days --->
		<cfset arrUKDays = arrayNew(1) />
		<cfset arrRODays = arrayNew(1) />
		<cfset arrOFFDays = arrayNew(1) />
		
		<cftry>
			<!--- clean the list of values --->
			<cfloop list="#arguments.daysUK#" index="day" delimiters=",">
				<cfif isNumeric(day)>
					<cfset arrayAppend(arrUKDays,day)/>
				</cfif>
			</cfloop>
			<cfloop list="#arguments.daysRO#" index="day" delimiters=",">
				<cfif isNumeric(day)>
					<cfset arrayAppend(arrRODays,day)/>
				</cfif>
			</cfloop>
			<cfloop list="#arguments.daysOFF#" index="day" delimiters=",">
				<cfif isNumeric(day)>
					<cfset arrayAppend(arrOFFDays,day)/>
				</cfif>
			</cfloop>
			
			<!--- <cfdump var="#arrUKDays#">
			<cfdump var="#arrRODays#">
			<cfdump var="#arrOFFDays#"> --->
			
			<!--- clean given month records --->
			<cfquery datasource="#request.sdsn#">
				delete from calendar where
					y = #arguments.year# and m = #arguments.month#
			</cfquery>
			
			<cfloop from="1" to="#arrayLen(arrUKDays)#" index="i">
				<cfquery name="insertUKDays" datasource="#request.sdsn#">
					insert into calendar (d,m,y,country)
						values (#arrUKDays[i]#,#arguments.month#,#arguments.year#,'uk')
				</cfquery>
			</cfloop>
			
			<cfloop from="1" to="#arrayLen(arrRODays)#" index="i">
				<cfquery name="insertRODays" datasource="#request.sdsn#">
					insert into calendar (d,m,y,country)
						values (#arrRODays[i]#,#arguments.month#,#arguments.year#,'ro')
				</cfquery>
			</cfloop>
			
			<cfloop from="1" to="#arrayLen(arrOFFDays)#" index="i">
				<cfquery name="insertOFFDays" datasource="#request.sdsn#">
					insert into calendar (d,m,y,country)
						values (#arrOFFDays[i]#,#arguments.month#,#arguments.year#,'x')
				</cfquery>
			</cfloop>
			
			<cfcatch>
				<cfset status = false />
			</cfcatch>
		</cftry>
		<cfreturn status />
	</cffunction>



</cfcomponent>