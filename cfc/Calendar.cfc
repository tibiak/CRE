<cfcomponent displayname="Calendar">
	<cfset calendarYear = year(now()) />
	<cfset startMonth 	= month(now()) />
	<cfset endMonth 	= 12 />
	<cfset startWeek	= "Monday"><!--- Possible values: Monday or Sunday --->
		
	<cfif startWeek eq "Monday">
		<cfset subtractFactor = 2 />
	</cfif>
	<cfif startWeek eq "Sunday">
		<cfset subtractFactor = 1 />
	</cfif>
	
	<cffunction name="init" returntype="Calendar">
		<cfargument name="year" type="numeric" required="false" default="#year(now())#" />
		<cfargument name="startMonth" type="numeric" required="false" default="#month(now())#" />
		<cfargument name="endMonth" type="numeric" required="false" default="12" />
		
		<cfset calendarYear = arguments.year />
		<cfset startMonth = arguments.startMonth />
		<cfset endMonth = arguments.endMonth />
		<cfreturn this />
	</cffunction>
		
	<cffunction name="weekDayInRomanian" returntype="string">
		<cfargument name="iDay" type="numeric">
		
		<cfif startWeek eq "Monday">
			<cfset arDays = listToArray("Luni,Marti,Miercuri,Joi,Vineri,Sambata,Duminica") />
		</cfif>
		<cfif startWeek eq "Sunday">
			<cfset arDays = listToArray("Duminica,Luni,Marti,Miercuri,Joi,Vineri,Sambata") />
		</cfif>
		<cfreturn arDays[iDay] />
	</cffunction>
	
	<cffunction name="weekDayInEnglish" returntype="string">
		<cfargument name="iDay" type="numeric">
		
		<cfif startWeek eq "Monday">
			<cfset arDays = listToArray("Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday") />
		</cfif>
		<cfif startWeek eq "Sunday">
			<cfset arDays = listToArray("Sunday,Monday,Tuesday,Wednesday,Thursday,Friday,Saturday") />
		</cfif>
		<cfreturn arDays[iDay] />
	</cffunction>
	
	<cffunction name="monthAsStringInLang" returntype="string">
		<cfargument name="iMonth" type="numeric" />
		<cfargument name="lang" type="string" default="ro" />
		
		<cfswitch expression="#arguments.lang#">
			<cfcase value="ro">
				<cfset arrMonths = listToArray("Ianuarie,Februarie,Martie,Aprilie,Mai,Iunie,Iulie,August,Septembrie,Octombrie,Noiembrie,Decembrie") />
				<cfreturn arrMonths[arguments.iMonth]/>
			</cfcase>
			<cfdefaultcase>
				<cfreturn monthAsString(arguments.imonth) />
			</cfdefaultcase>
		</cfswitch>
	</cffunction>
	
	<cffunction name="getMonths" output="false" returntype="struct">
		<cfargument name="startMonth" type="numeric" default="1">
		<cfargument name="endMonth" type="numeric" default="12">
		<cfargument name="year" type="numeric" default="#calendarYear#">
		
		<cfloop from="#arguments.startMonth#" to="#arguments.endMonth#" index="i">
					
			<cfset daysInMonth = daysInMonth(createDate(arguments.year,i,1))>
			<cfset local.arrMonths[i] = queryNew("col1,col2,col3,col4,col5,col6,col7")/>
			<cfset queryAddRow(local.arrMonths[i],1) />
			<cfloop from="1" to="7" index="d">				
				<cfset querySetCell(local.arrMonths[i],"col#d#",left(weekDayInRomanian(d),2)) />
			</cfloop>
			
			<cfset cellCount=dayOfWeek(createDate(arguments.year,i,1))-subtractFactor />				
			<!--- Reset the empty cells count when displaying the first week. 
			Because the system time begins the week on Sunday the rendering of 
			the calendar gets confused for the months starting on Sundays 
			setting the beginning of the month on Sunday. --->
			<cfif cellCount eq -1>
				<cfset cellCount = 6/>
			</cfif>	
			
			<cfset tdCnt = 1>
			<cfset isFirstWeek = true />
			<cfset hasRun = false>
			
			<cfloop from="1" to="#daysInMonth#" index="d">
				
				<cfif tdCnt eq 1>
					<cfset queryAddRow(local.arrMonths[i],1) />
				</cfif>
				<cfif isFirstWeek and not hasRun>
					<cfloop from="1" to="#cellCount#" index="j">						
						<cfset querySetCell(local.arrMonths[i],"col#tdCnt#","") />
						<cfset tdCnt = tdCnt+1/>								
					</cfloop>
					<cfset hasRun = true />	
				</cfif>
								
				<cfset querySetCell(local.arrMonths[i],"col#tdCnt#",d) /><cfset tdCnt = tdCnt+1/>
				<cfif tdCnt gte 8>									
					<cfset isFirstWeek = false />
					<cfset tdCnt = 1>
				</cfif>
				
			</cfloop>
		</cfloop>
		<cfreturn local />
	</cffunction>
	
	<cffunction name="showMonths" output="false" returntype="string">
		<cfargument name="year" type="numeric" />
		<cfargument name="startMonth" type="numeric" />
		<cfargument name="endMonth" type="numeric" />
		<cfargument name="goURL" type="string" />
		<cfargument name="objCalendarCrespo" type="calendarCrespo" />
		<cfargument name="withLink" type="boolean" required="false" default="false" />
		
		<cfsavecontent variable="htmlContent">		
			<cfoutput>
				<cfloop from="#startMonth#" to="#endMonth#" index="i">
				
					<!--- if a database stores days, get them --->
					<cfset qMonthData = arguments.objCalendarCrespo.getMonth(arguments.year,i) />					
					
					<cfset daysInMonth = daysInMonth(createDate(calendarYear,i,1)) />
					<cfset cellCount=dayOfWeek(createDate(calendarYear,i,1))-subtractFactor />
					<!--- Reset the empty cells count when displaying the first week. 
					Because the system time begins the week on Sunday the rendering of 
					the calendar gets confused for the months starting on Sundays 
					setting the beginning of the month on Sunday. --->
					<cfif cellCount eq -1>
						<cfset cellCount = 6/>
					</cfif>				
					
					<!--- write calendar for i month --->
					<fieldset class="monthfieldset">
					<legend><cfif arguments.withLink><a href="#arguments.goURL#&month=#i#&year=#arguments.year#"></cfif>#uCase(monthAsStringInLang(i,Request.stUser.langID))#<cfif arguments.withLink></a></cfif>&nbsp;</legend>
					
					<table cellpadding="8" cellspacing="1" style="height:220px; width:150px;">
						<!--- Write week days --->
						<tr><!--- weekDayInRomanian(dayofWeek(createDate(year(now()),i,1))) --->
							<cfloop from="1" to="7" index="d">
								<td class="daycellheader"><strong><cfif Request.stUser.langID eq "RO">#left(weekDayInRomanian(d),2)#<cfelse>#left(weekDayInEnglish(d),2)#</cfif></strong></td>
							</cfloop>
						</tr>
						<cfset tdCnt = 0>
						<cfset isFirstWeek = true />
						<cfset run = false>
						<cfloop from="1" to="#daysInMonth#" index="d">
							
							<cfswitch expression="#arguments.objCalendarCrespo.getCountryByDayInMonth(d,qMonthData)#">
								<cfcase value="uk">
									<cfset bg = "ff0000"/>
								</cfcase>
								<cfcase value="ro">
									<cfset bg = "66ff66"/>
								</cfcase>
								<cfcase value="x">
									<cfset bg = "c0c0c0"/>
								</cfcase>
								<cfdefaultcase>
									<cfset bg = "ffffff"/>
								</cfdefaultcase>
							</cfswitch>
							
							<cfif tdCnt eq 0>
								<tr>
							</cfif>
							<cfif isFirstWeek and not run>
								<cfloop from="1" to="#cellCount#" index="j">
									<td>&nbsp;</td>
									<cfset tdCnt = tdCnt+1/>											
								</cfloop>	
								<cfset run = true />							
							</cfif>
										
							<td id="daycell_#d#" class="daycell" style="background-color:###bg#;">#d#</td>
							<cfset tdCnt = tdCnt+1/>
							<cfif tdCnt gte 7 or i eq daysInMonth>
								</tr>
								<cfset isFirstWeek = false />
								<cfset tdCnt = 0>
							</cfif>
						</cfloop>				
					</table>			
					</fieldset>
				</cfloop>
			</cfoutput>
		</cfsavecontent>
		<cfreturn htmlContent />
	</cffunction>

	<cffunction name="getMonth" returntype="query">
		<cfargument name="iMonth" type="numeric">
		<cfargument name="iYear" type="numeric">
		<cfset local = getMonths(arguments.iMonth,arguments.iMonth,arguments.iYear)/>
		<cfreturn  local.arrMonths[arguments.iMonth] />
	</cffunction>
</cfcomponent>