<cfcomponent displayname="Utils">

			<cffunction name="init" returntype="Utils">
					<cfargument name="sD" default="crespo" type="string" required="No">
					<cfset this.sDSN = arguments.sD>	
					<cfreturn this />
			</cffunction>
			
			<cffunction name="getCategoryName" returntype="string">
				<cfargument name="iCat" type="numeric">
				
				<cfset var retCategory = "none">
				
				<cfquery name="qCat" datasource="#this.sDSN#">
						select name from anunt_categorie where id = #arguments.iCat#
				</cfquery>
				
				<cfif qCat.RecordCount>
					<cfset retCategory = trim(qCat.name)>
				</cfif>				
									
				<cfreturn retCategory />
			</cffunction>		
			
			
			<cffunction name="isValidEmail" returntype="boolean">
					<cfargument name="sEmail" type="string" required="True">
					<cfset var regExp = "^[a-zA-Z]([.]?([[:alnum:]_-]+)*)?@([[:alnum:]\-_]+\.)+[a-zA-Z]{2,4}$">
					<cfset var stMatch = REFind(regExp,arguments.sEmail,1,"True")>
		
					<cfif not stMatch.len[1] gt 0>
						<cfreturn false/>
					<cfelse>
						<cfreturn true/>
					</cfif>
			</cffunction>
			
			<cffunction name="sendEmail" access="public">					
					<cfargument name="stEmail" type="struct">
					
					<cfmail to="#stEmail.lsTo#" 
									cc="#stEmail.lsCC#" 
									from="#stEmail.From#" 
									subject="#stEmail.Subject#" type="html">#arguments.stEmail.Body#</cfmail>
			</cffunction>
			
			<cffunction name="emailCrespoNewCustomerRegistration" access="public">					
					<cfargument name="oCustomer" type="Customer">
					
					<cfset var tmpFromEmail = "noreply@crespocom.com">
					
					<!--- <cfif len(trim(arguments.oCustomer.getEmail()))>
						<cfset tmpFromEmail = trim(arguments.oCustomer.getEmail())>
					</cfif> --->
					
					<cfmail to="#application.stApp.EmailAllStaff#" 
									<!--- cc="#application.stApp.EmailAllStaff#" ---> 
									from="#tmpFromEmail#" 
									subject="CrespoCom - New customer registration" 
									type="HTML">NEW CUSTOMER REGISTRATION<BR><BR>#application.stApp.GMT#<BR><BR>This email has been sent by the website to inform you that a new customer has just registered for service. Below you can find the details submitted by the client<hr><table cellpadding="1" cellspacing="1">
						<tr>
							<td>System ID</td>
							<td>#oCustomer.getID()#</td>
						</tr>
						<tr>
							<td>Name</td>
							<td>#oCustomer.getTitle()# #oCustomer.getFname()# #oCustomer.getSname()#</td>
						</tr>
						<tr>
							<td>Email</td>
							<td>#oCustomer.getEmail()#</td>
						</tr>
						<tr>
							<td>Username</td>
							<td>#oCustomer.getUsername()#</td>
						</tr>
						<!--- <tr>
							<td>Password</td>
							<td>#oCustomer.getPassword()#</td>
						</tr> --->						
						</table></cfmail>

			</cffunction>
			
			<cffunction name="emailNewOrder" access="public">					
					<cfargument name="oOrder" type="Order">
					
					<cfset var tmpFromEmail = "office@crespocom.com">
										
					<cfmail to="#application.stApp.EmailAllStaff#" 
									<!--- cc="#application.stApp.EmailAllStaff#" ---> 
									from="#tmpFromEmail#" 
									subject="CrespoCom - New Order" 
									type="HTML">
						<p>NEW ORDER RECEIVED<BR><BR>#application.stApp.GMT#<BR><BR>This email has been sent by the website to inform you that a new order has been registered on the website. Below you can find the order details submitted by the customer.</p>
						
						<table cellpadding="1" cellspacing="1">
						<tr>
							<td>Order ID</td>
							<td>#oOrder.getID()#</td>
						</tr>
						<tr>
							<td>Order Date/Time</td>
							<td>#oOrder.getCreationDateTime()#</td>
						</tr>
						<tr>
							<td>For Customer (username)</td>
							<td>#oOrder.getCreatedBy()#</td>
						</tr>						
						</table></cfmail>
			</cffunction>
			
			<cffunction name="setFeedbackMessage" access="public" returntype="void">
					<cfargument name="sStyleId" type="string" required="true" default="successMessage"><!--- errorMessage --->
					<cfargument name="sMessage" type="string" required="true" default="">
				
					<cfset session.stFeedback.Message = "<br><div id='feedbackMessage'><div id='#arguments.sStyleId#'>#arguments.sMessage#</div></div>" />
			</cffunction>
			
			
			
			
			<cffunction name="deleteFile" access="public">
					<cfargument name="sFilePath" type="string">
				
					
					<cffile action="DELETE" file="#arguments.sFilePath#" />
			</cffunction>
			
					
			<!--- Db jobs --->
			<cffunction name="storeFile" access="public" >
					<cfargument name="catId" type="numeric">
					<cfargument name="anuntId" type="numeric">
					<cfargument name="originalFileName" type="string">
					<cfargument name="systemFileName" type="string">
					<cfargument name="sCreatedby" type="string">					
				
					<cftransaction>
							<cfquery name="qInsert" datasource="#this.sDSN#">
								insert into image(original_filename,
																	system_filename,
																	creation_date,
																	created_by)
										values('#arguments.originalFileName#',
													 '#arguments.systemFileName#',
													 '#dateFormat(now(),"dd-mmm-yyyy")# #timeFormat(Now(),"hh:mm:ss")#',
													 '#arguments.sCreatedby#')
							</cfquery>
							<cfquery name="qI" datasource="#this.sDSN#">
								select max(id) as maxid from image
							</cfquery>
							<cfquery name="insertAI" datasource="#this.sDSN#">
								insert into anunt_image_lkp (anunt_id,image_id,category_id,default)
								values(#arguments.anuntId#,#qI.maxid#,#arguments.catId#,1)
							</cfquery>
							<!--- Make default value of other images of this anunt = 0 --->
							<cfquery name="updateAI" datasource="#this.sDSN#">
								update anunt_image_lkp set default = 0
								where  anunt_id = #arguments.anuntId#
								  and	 category_id = #arguments.catId#
									and  image_id <> #qI.maxid#
							</cfquery>							
						<cftransaction>
			</cffunction>		
			
			
			<cffunction name="uploadFile" access="public" returntype="struct">
					<cfargument name="sFormfieldName" type="string">
					<cfargument name="sFormfieldValue" type="string">
					<cfargument name="sUploadDirpath" type="string">				
					
					
					<cfset var stFile = structNew() />					
					
					<cfset stFile.retCode = "0">
					<cfset stFile.Message = "">
					<cfset stFile.FileSize  = "">
					<cfset stFile.originalFileExt  = "">
					<cfset stFile.originalFileName = "">
					<cfset stFile.systemFileName   = "">		
					
					<!--- <cftry> --->
						<cffile action="UPLOAD" accept="image/*"
										filefield="#arguments.sFormfieldName#"
										destination="#arguments.sUploadDirpath#"
										nameconflict="OVERWRITE">
										
						
						<cfset stFile.FileExt  = cffile.clientFileExt>
						<cfset stFile.originalFileName = cffile.clientFileName &"."& stFile.FileExt>
						<cfset stFile.FileSize = cffile.fileSize>
						
						<!--- if the file is too big abort any processing --->
						<cfif stFile.FileSize gt 1024000><!--- 1mb --->
							<!--- <cfoutput>too big #stFile.FileSize#</cfoutput> --->
							<cfset deleteFile("#arguments.sUploadDirpath#\#stFile.originalFileName#") />
							<cfset stFile.retCode = "1">
							<cfset stFile.Message = "Eroare! - Imaginea pe care incercati sa o trimiteti depaseste dimensiunea maxima acceptata de 1Mb. Va rugam reduceti dimensiunile pozei si incercati sa o trimiteti din nou.">
							
						<cfelse>
							<!--- file size ok! --->
							<cfset stFile.systemFileName = makeFileName()>
							<cfset stFile.systemFileName = stFile.systemFileName &"."& stFile.FileExt>
							
							<!--- Rename file --->
							<cffile action="RENAME" 
											source="#arguments.sUploadDirpath#\#stFile.originalFileName#" 
											destination="#arguments.sUploadDirpath#\#stFile.systemFileName#" 
											nameconflict="OVERWRITE" >								
						</cfif>
						
						<!--- <cfcatch> --->
							<!--- <cfset stFile.retCode = "2">
							<cfset stFile.Message = "Eroare! - Anuntul nu a fost salvat!<br>Imaginea pe care incercati sa o trimiteti nu a fost acceptata de system. Dimensiunea ei este prea mare sau nu este un document de tip JPEG, JPG sau GIF.<br>Va rugam incercati din nou.<br><br><a href='index.cfm?do=h.loadAnuntForm'>Formular</a>"> --->
						<!--- </cfcatch>
					</cftry>	 --->			
										
				<cfreturn stFile />
			</cffunction>
			
			<cffunction name="removeFile" access="public" >
					<cfargument name="anuntId" type="numeric">
					<cfargument name="catId" type="numeric">
					<cfargument name="fileId" type="numeric">
					<cfargument name="dataDirPath" type="string">
					
					<cfquery name="qSel" datasource="#this.sDSN#">
						select system_filename from image where id = #arguments.fileId#
					</cfquery>
					
					<cftransaction>
						<cfquery name="qDel1" datasource="#this.sDSN#">
							delete from anunt_image_lkp where
							anunt_id = #arguments.anuntId# and
							category_id = #arguments.catId# and
							image_id = #arguments.fileId#
						</cfquery>
						<cfquery name="qDel2" datasource="#this.sDSN#">
							delete from image where id = #arguments.anuntId#
						</cfquery>
						<cfset deleteFile("#arguments.dataDirPath##trim(qSel.system_filename)#")>
					</cftransaction>
			</cffunction>
			
			
			<cffunction name="makeFileName" access="public" returntype="string">
					
					<cfset var retFilename = "">
					
					<!--- get last file name --->
					<cfquery name="qImg" datasource="#this.sDSN#">
						select max(id) as maxId from image
					</cfquery>
					
					<cfif not isNumeric(qImg.maxId)>
						<cfset retFilename = "000001">
					<cfelse>
						<cfset retFilename = toString(incrementValue(qImg.maxId))>
					</cfif>
					
					
					<!--- prepend zeroes to the anunt id to make filename --->
					<cfloop condition="len(retFilename) lt 6">
						<cfset retFilename = "0" & retFilename>
					</cfloop>				
					
				<cfreturn retFilename>
			</cffunction>
			
			<cffunction name="getFileCount" access="public" returntype="numeric">
				<cfargument name="sDirpath" type="string">
				
				<cfdirectory action="LIST" directory="#arguments.sDirpath#" name="qDir">
				
				<cfreturn qDir.RecordCount>
			</cffunction>
			
			
			<cffunction name="logSearch" access="public" returntype="string">
					<cfargument name="schTxt" type="string">					
					<cfargument name="catId" type="numeric">
					<cfargument name="iCnt" type="numeric">
					<cfargument name="schTime" type="string">
					<cfargument name="schBy" type="string">
					
					<cfset var schDate = createODBCDateTime(arguments.schTime)>
					
					<cfquery name="qLog" datasource="#this.sDSN#">
						insert into log_search(search_text,
																		search_category_id,
																		generated_results,
																		creation_date,
																		created_by)
						values('#arguments.schTxt#',
										#arguments.catId#,
									  #arguments.iCnt#,
									  #schDate#,
									 '#arguments.schBy#') 
					</cfquery>
			</cffunction>
			
			
			
			<cffunction name="logHit" access="public" returntype="string">
					<cfargument name="agentIP" type="string">
					<cfargument name="agentURL" type="string">
					<cfargument name="agentURLReferer" type="string">
					<cfargument name="reqURL" type="string">
					<cfargument name="reqTime" type="string">
					
					<cfset var hitTime = createODBCDateTime(arguments.reqTime)>
					
					<cfquery name="qLog" datasource="#this.sDSN#">
						insert into log_hits(agent_ip,
																	agent_url,
																	agent_url_referer,
																	requested_url,
																	creation_date)
						values('#arguments.agentIP#',
									 '#arguments.agentURL#',
									 '#arguments.agentURLReferer#',
									 '#arguments.reqURL#',
									  #hitTime#) 
					</cfquery>			
					
			</cffunction>
			
			<cffunction name="logAccessIn" access="public" returntype="string">
					<cfargument name="userId" type="string">
					<cfargument name="loginTime" type="date">
					
					<cfset var accessDateTime = createODBCDateTime(arguments.loginTime)>
					
					<!--- <cfquery name="qLog" datasource="#this.sDSN#">
						insert into log_access(user_id,login_time)
						values( #arguments.userId#,
									  #accessTime#) 
					</cfquery>		 --->	
					
					<cfdump var="sDSN=#this.sDSN#; accessDateTime=#accessDateTime#; arguments.userId=#arguments.userId#">
					
					 <cfquery name="qUpdate" datasource="#this.sDSN#">
						update 	customer 
							 set 	login_datetime = #accessDateTime#			
						 where 	id = #arguments.userId# 
					 </cfquery>				
					
			</cffunction>
			
			<cffunction name="logAccessOut" access="public" returntype="string">
					<cfargument name="userId" type="string">
					<cfargument name="logoutTime" type="date">
					
					<!--- rework this qry so it logs out the user of this session
								
					
					<cfquery name="qLog" datasource="#this.sDSN#">
						update log_access
						set logout_time = '#arguments.logoutTime#'
						where
						
					</cfquery>			
					 --->
			</cffunction>
			
			<cffunction name="hideFile" access="public">
					<cfargument name="fileId" type="numeric">
					
					<cfquery name="insertAI" datasource="#this.sDSN#">
						update image 
						   set hidden = 1
						 where id = #arguments.fileId#
					</cfquery>
			</cffunction> 
			
			<cffunction name="showFile" access="public">
					<cfargument name="fileId" type="numeric">
					
					<cfquery name="insertAI" datasource="#this.sDSN#">
						update image
						   set hidden = 0
						 where id = #arguments.fileId#
					</cfquery>
			</cffunction> 
			
			<cffunction name="savePublicFeedback" access="public" returntype="struct">
					<cfargument name="stForm" type="struct">
					
					<cfset var stReturn = structNew()>
					
					<cfquery name="qInsPf" datasource="#this.sDSN#">
						insert into public_feedback (title,message,fname,email,creation_date)
						values(	'#arguments.stForm.title#',
										'#arguments.stForm.message#',
										'#arguments.stForm.fname#',
										'#arguments.stForm.email#',
										 #createODBCDateTime(application.stApp.GMT)#)
					</cfquery>
					
					<cfset stReturn.Message="Mesajul a fost trimis. Va multumim pentru aceasta contributie!">
					
				<cfreturn stReturn />
			</cffunction> 
			
			
			<cffunction name="getImageProperties" access="public" returntype="struct">
					<cfargument name="sFilePath" type="string">					
					
					<cfscript>   
						stImage = structNew();
						
						image = CreateObject("java", "javax.swing.ImageIcon");   
						image.init("#arguments.sFilePath#");   
						stImage.width = image.getIconWidth();   
						stImage.height = image.getIconHeight();   
						
						//get the size   
						imageFile = CreateObject("java", "java.io.File");   
						imageFile.init("#arguments.sFilePath#");   
						stImage.size = imageFile.length(); 
					</cfscript>
				<cfreturn stImage />
			</cffunction> 
			
			<!--- <cffunction name="insertAnuntPhotoLookup" access="public" returntype="string">
					<cfargument name="imageId" type="numeric">
					<cfargument name="anuntId" type="numeric">
					<cfargument name="catId" type="numeric">
					
					<cfquery name="insertAI" datasource="#this.sDSN#">
						insert into anunt_image_lkp (anunt_id,image_id,category_id)
						values(#anuntId#,#imageId#,#catId#)
					</cfquery>
			</cffunction> --->
			
</cfcomponent>
