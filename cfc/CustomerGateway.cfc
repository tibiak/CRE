<cfcomponent hint="I am responsibl for customer object" extends="cfc.base">
		
		<cfset init() />
	
		<cffunction name="init" returntype="CustomerGateway" hint="">
				<cfargument name="dsn" type="string" required="false" default="#Request.sDSN#">				
				<cfset variables.dsn = arguments.dsn />
				<cfreturn this>
		</cffunction>
		
		<cffunction name="getAddressByType" access="public" returntype="query">
				<cfargument name="addressType" type="string" required="true" />
				<cfargument name="customerID" type="numeric" required="true" />
				
				<cfquery name="qSel" datasource="#variables.dsn#">	
					SELECT 	a.id,
									a.title,
									a.fullname,
									a.door_no,
									a.entrance_no,
									a.building_no,
									a.street,
									a.city,
									a.district,
									a.postcode,
									a.country,
									a.country_code,
									a.telephone,
									a.mobile,
									a.email
									<!--- a.type,
									a.creation_date,
									a.created_by --->
						FROM 	address a LEFT JOIN customer_address ca ON a.id = ca.address_id
						WHERE a.type = '#arguments.addressType#'
						AND 	ca.customer_id = #arguments.customerID#					
				</cfquery>
			<cfreturn qSel />
		</cffunction>
		
		<cffunction name="setCustomerAddressIDs" access="public" returntype="string">
				<cfargument name="obCustomer" type="cfc.customer" required="true" />
		
				<cfquery name="qSel" datasource="#variables.dsn#">
					SELECT 	address_id 
					FROM 		customer_address
					WHERE 	customer_id = #obCustomer.getId()#
				</cfquery>
				
				<cfset obCustomer.setAddresses(valueList(qSel.address_id)) />
		</cffunction>
		
		<cffunction name="setCustomerOrderIDs" access="public" returntype="string">
				<cfargument name="obCustomer" type="cfc.customer" required="true" />		
				<cfquery name="qSel" datasource="#variables.dsn#">
					SELECT 	id 
					FROM 		orders
					WHERE 	customer_id = #obCustomer.getId()#
				</cfquery>
				
				<cfset obCustomer.setOrders(valueList(qSel.id)) />
		</cffunction>
		
		
		<cffunction name="matchCustomerUUID" access="public" returntype="numeric">
				<cfargument name="uuid" type="string">
				<cfset var retId = 0 />
				
				<cfquery name="qSel" datasource="#variables.dsn#">
					SELECT id FROM Customer WHERE uuid = '#arguments.uuid#'
				</cfquery>
					
				<cfif qSel.recordCount eq 1>
					<cfset retID = qSel.id />
				</cfif>
				
			<cfreturn retId />
		</cffunction>
		
		<cffunction name="enableLogin" access="public" returntype="void">
				<cfargument name="id" type="numeric">
				
				<cfquery name="qUpd" datasource="#variables.dsn#">
					UPDATE Customer SET blocked = 0 
					WHERE id = #arguments.id#
				</cfquery>
		</cffunction>
		
		<cffunction name="emailRegistrationUUID" access="public" returntype="void" output="Yes">
				<cfargument name="oCustomer" type="customer"/>
				
				<cfset var subjMsg = "">
				<cfif Request.stUser.langID eq "RO">
					<cfset subjMsg = " - Confirmare cont" />
				</cfif>
				<cfif Request.stUser.langID eq "EN">
					<cfset subjMsg = " - Account Confirmation" />
				</cfif>
				<cfmail from="#application.stApp.OfficeEmail#"
						to="#arguments.oCustomer.getEmail()#"
						subject="CrespoCom Ltd.#subjMsg#" 
						type="HTML">
						<cfif Request.stUser.langID eq "RO">Buna ziua,<br><br>Acesta este un raspuns automat la cererea dumneavoastra de inregistrare la serviciile de coletarie online.<br><br>Pentru activarea contului si accesarea acestor servicii, click acest link:</cfif>
						<cfif Request.stUser.langID eq "EN">Dear Customer,<br><br>This is an automated response to your request to join our site. You need not reply to this message.<br><br>To activate your account and complete the registration process you need to click (or copy-paste in the browser) the link provided below:</cfif>
						<br><a href='#htmlEditFormat("#application.stApp.url#?do=security.completeRegistration&link=#arguments.oCustomer.getUUID()#")#'>#htmlEditFormat('#application.stApp.url#/#arguments.oCustomer.getUUID()#')#</a><br><hr size="1px" width="400">CrespoCom Ltd.</cfmail>
		</cffunction>
		
		<cffunction name="getAllCustomers" access="public" returntype="query">
				<cfquery name="qRS" datasource="#variables.dsn#">
					SELECT * FROM Customer ORDER BY creation_date DESC
				</cfquery>
			<cfreturn qRS>
		</cffunction>	
		
		<cffunction name="getCustomersByEmail" access="public" returntype="query">
				<cfargument name="email" type="string"/>
				
		</cffunction>
		
		<cffunction name="getCustomersByMobile" access="public" returntype="query">
				<cfargument name="mobile" type="string"/>
				
		</cffunction>
		
		<cffunction name="getCustomersByPostCode" access="public" returntype="query">
				<cfargument name="postcode" type="string"/>
				
		</cffunction>
		
		<cffunction name="getCustomerDetails" access="public" returntype="query"
								hint="Retrieve all details for a particular customer">
				<cfargument name="cid" type="numeric" required="True"/>								
				<cfquery name="qRS" datasource="#variables.dsn#">
					SELECT * FROM Customer c, Address a, customer_address ca
					WHERE c.id = ca.customer_id AND a.id = ca.address_id
					AND c.id = #arguments.cid#
					AND (a.type = 'DOMICILE')
				</cfquery>				
			<cfreturn qRS />
		</cffunction>
		
		<cffunction name="searchCustomerByName" access="public" returntype="query"
								hint="Retrieve customer data">
				<cfargument name="customername" type="string" required="True"/>
								
				<!--- obtain the name/s --->
				<cfif listLen(arguments.customername," ") gt 1>
					<cfset sFname = "#listGetAt(arguments.customername,1,' ')#" />
					<cfset sSname = "#listGetAt(arguments.customername,2,' ')#" />
					<cfquery name="qRS" datasource="#variables.dsn#">
						SELECT * FROM Customer c, Address a, customer_address ca				
						WHERE c.id = ca.customer_id AND a.id = ca.address_id
						AND ((c.fname like '#sFname#%' AND c.sname like '#sSname#%') OR (c.fname like '#sSname#%' AND c.sname like '#sFname#%'))
						AND a.type = 'DOMICILE'					
						<!--- SELECT id,fname,sname FROM Customer c
						WHERE c.fname = '#sFname#' 
						AND c.sname = '#sSname#' --->	
					</cfquery>		
				<cfelse>
					<cfset sName = "#trim(customername)#" />
					<cfquery name="qRS" datasource="#variables.dsn#">
						SELECT * FROM ((customer c LEFT JOIN customer_address ca
						ON c.id = ca.customer_id) LEFT JOIN Address a 
						ON ca.address_id = a.id)
						WHERE 
							(c.fname = '#sName#' OR c.sname = '#sName#')
						AND a.type = 'DOMICILE'
						<!--- SELECT * FROM Customer c, Address a, customer_address ca
						WHERE c.id = ca.customer_id AND a.id = ca.address_id
						AND c.fname = '#sName#' OR c.sname = '#sName#' --->
						<!--- SELECT id,fname,sname FROM Customer c
						WHERE c.fname = '#sName#' OR c.sname = '#sName#' --->
					</cfquery>
					
					<!--- <cfif not qRS.recordCount>					
						<cfquery name="qRS" datasource="#variables.dsn#">
							SELECT * FROM Customer c, Address a, customer_address ca
							WHERE c.id = ca.customer_id AND a.id = ca.address_id
							AND c.sname = '#sName#'
						</cfquery>						
					</cfif> --->						
				</cfif>
										
			<cfreturn qRS />
		</cffunction>
		
		
		<cffunction name="deleteCustomerPermanently" access="public" returntype="string">
				<cfargument name="obCustomer" type="cfc.customer" required="true" />
				
				<cfset var bolSuccess = True />
				<cfset var iCid = obCustomer.getId() />
				<!--- <cfset variables.lsAddresses = "0" />
				<cfset variables.lsOrders = "0" /> --->
				
				<!--- <cftry> --->
				
					<cfset variables.lsAddresses = obCustomer.getAddresses() />
					<cfset variables.lsOrders = obCustomer.getOrders() />
					
					<cftransaction>
			
					<!--- 1. remove the addreeses & 2. the address lookup--->						
								<cfset oAddressDAO = createObject("component","cfc.AddressDAO").init() />							
								<cfif listLen(variables.lsAddresses)>
									<cfloop list="#variables.lsAddresses#" index="aid">
										<cfset oAddressDAO.delete(aid) />
									</cfloop>	
										
									<cfset oAddressGW = createObject("component","cfc.AddressGateway").init() />
									<cfset oAddressGW.deleteCustomerAddressLookups(iCid,variables.lsAddresses) />					
								</cfif>													
					
					<!--- 3. remove the orders --->
								<cfif listLen(variables.lsOrders)>
									<cfset oOrderDAO = createObject("component","cfc.OrderDAO").init() />
									<cfloop list="#variables.lsOrders#" index="oid">
										<cfset oOrderDAO.delete(oid)>
									</cfloop>
								</cfif>
								
					<!--- 4. remove the customer --->
								<cfset oCustomerDAO = createObject("component","cfc.CustomerDAO").init() />
								<cfset oCustomerDAO.delete(iCid) />
								
					</cftransaction>
					
					<!--- <cfcatch>
						<cfset bolSuccess = False />
					</cfcatch>
				</cftry> --->
				
				<cfreturn bolSuccess />
		</cffunction>
		
</cfcomponent>