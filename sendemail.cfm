aborted.<cfabort>
<cfquery name="q" datasource="crespo">
	select email from customer
</cfquery>
<cfset ls = valuelist(q.email)>

<cfset stE.subject = "CrespoCom Ltd. Accesare website">

<cfset stE.lscc = "">
<cfset stE.from = "crespocom@yahoo.co.uk">
<cfset stE.body = "Buna ziua!<br><br>Va instiintam ca din motive de administrare, website-ul nostru poate fi accesat numai prin urmatorul link: <a href=""http://65.175.122.189"">http://65.175.122.189</a><br>Speram ca intr-o perioada scurta de timp sa puteti accesa website-ul la cunoscuta adresa www.crespocom.com.<br><br>Ne cerem scuze pentru orice inconvenienta si va multumim pentru intelegere!<br><br>CrespoCom Ltd.">

<cfset application.utils = CreateObject("component","cfc.utils").init()>

<cfoutput>
<cfloop list="#ls#" index="e">
	<cfset stE.lsto = "#trim(e)#">
	<cfset application.utils.sendemail(ste) />#e# - email sent!<br />
	<cfflush />
</cfloop></cfoutput>