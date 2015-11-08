<cfif not isDefined("session.stUser.Roles") or session.stUser.Roles eq "basic">
    Session expired.
    <cfabort/>
</cfif>
<cfsilent>
<cfapplication name="sqlsurfer" clientmanagement="Yes">
<cfsavecontent variable="variables.notes">
============================================================================
File:       SqlSurfer.cfm
Title:      SQLSurfer
Author:     Nathan Strutz | mrnate@hotmail.com
Date:       July 20, 2004
Version:    0.90

Purpose:    It's a ColdFusion web-based sql query tool. Use it to test 
            database connections and queries, or to work on your database.

Legal:      The CF Mail Surfer is � 2002 Nathan Strutz, All Rights Reserved.
            Nathan Strutz is not responsible anything anyone does with it.

Info:       SqlSurfer is 100% self-contained. There are no
            external pages or graphics. It's easy to upload, install
            and upgrade. Cleans up with no mess. Totally biodegradable!

History:    04/20/04 - Upgraded status from a self-use tool to a release.

Bugs:       Probably lots

Future:     Email future feature requests to mrnate@dopefly.com

Help:       Anything you see that needs fixing! Mail me code or
            suggestions. Thanks!
============================================================================
</cfsavecontent>



<cfif IsDefined("client.sqlsurfer") and IsWDDX(client.sqlsurfer)>
	<!--- read wddx to variables --->
	<cfwddx action="WDDX2CFML" input="#client.sqlsurfer#" output="variables.sqlsurfer">
<cfelse>
	<cfset variables.sqlsurfer = StructNew()>
</cfif>
<cfscript>
	// create history array if not defined
	if (not IsDefined("variables.sqlsurfer.arrHistory")) {
		variables.sqlsurfer.arrHistory = ArrayNew(1);
	}

	// add currently submitted sql statement to history (if original)
	if (IsDefined("form.SqlStatement")) {
	    variables.addToArray = true;
	    for (i=1;i lte arrayLen(variables.sqlsurfer.arrHistory);i=i+1) {
	        if (variables.sqlsurfer.arrHistory[i] EQ form.SqlStatement) {
				// move current sql to top of list
				arrayDeleteAt(variables.sqlsurfer.arrHistory,i);
				ArrayPrepend(variables.sqlsurfer.arrHistory,form.SqlStatement);
				//arraySwap(variables.sqlsurfer.arrHistory,i,1);
	            variables.addToArray = false;
	            break;
	        }
	    }
	    if (variables.addToArray) {
	        ArrayPrepend(variables.sqlsurfer.arrHistory,form.SqlStatement);
	    }
	}

	// keep history array short
	if (ArrayLen(variables.sqlsurfer.arrHistory) GT 25) {
		ArrayDeleteAt(variables.sqlsurfer.arrHistory,26);
	}

	// default the dsn
	if (IsDefined("form.DatasourceName")) {
		variables.sqlsurfer.dsn = form.DatasourceName;
	} else {
		variables.sqlsurfer.dsn = "";
	}
	
</cfscript>
<!--- write variables back to wddx --->
<cfwddx action="CFML2WDDX" input="#variables.sqlsurfer#" output="client.sqlsurfer">

</cfsilent><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<html>
<head>
	<title>SQL Surfer</title>
	<style type="text/css">
		body { font-family:arial,helvetica; font-size: 11pt; margin-top:0; background-color:#D6D6D6; }
		table { font-family:arial,helvetica; font-size: 9pt; }
		input { border-width:1px; }
		textarea { border-width:1px; }
		.head { color:#FFFFFF; }
		.title { font-family:arial,helvetica; font-size: 15pt; font-weight:lighter; }
		.formfield { background-color:#EEEEEE; border-color:#CCCCCC; }
		.formbutton { background-color:#EEEEEE; border-color:#CCCCCC; }
		table thead tr { background-color:#EEEEEE; }
		table thead tr td { background-color:#666; padding-right:8px; }
	</style>
	<script type="text/javascript">
		function SelectHistory(id) {
			if (document.all) {
				oSQL = document.all.SqlStatement;
				oHis = document.all.history;
			} else if (document.getElementById) {
				oSQL = document.getElementById('SqlStatement');
				oHis = document.getElementById('history');
			} else {
				oSQL = window.SqlStatement;
				oHis = window.history;
			}
			oSQL.value = oHis[id].value;
		}
		function body_onload() {
			if (document.form.history) {
				document.form.history.selectedIndex=0;
			}
			if(document.form.SqlStatement.value.length) {
				document.form.SqlStatement.focus();
			}
			fieldBlur(document.form.DatasourceName,'DSN');
			fieldBlur(document.form.SqlStatement,'Query');
		}
		function fieldFocus(field,txt) {
			if (field.value==txt) {
				field.value = '';
			}
		}
		function fieldBlur(field,txt) {
			if (field.value == '') {
				field.value = txt;
			}
		}
	</script>
</head>

<cfparam name="form.SqlStatement" default="">
<cfparam name="form.DatasourceName" default="#variables.sqlsurfer.dsn#">

<body onload="body_onload();">
<cfoutput>
<table cellpadding="3" cellspacing="0">
  <tr>
	<td class="title" colspan="3">sql surfer</td>
  </tr>
<form action="" method="post" name="form">
  <tr>
	<td><input type="text" name="DatasourceName" size="40" value="#form.DatasourceName#" title="Data Source Name" onfocus="fieldFocus(this,'DSN');" onblur="fieldBlur(this,'DSN');"></td>
	<td><input type="submit"></td>
	<td></td>
  </tr>
  <tr>
	<td colspan="2"><textarea cols="60" rows="8" name="SqlStatement" id="SqlStatement" wrap="soft" onfocus="fieldFocus(this,'Query');" onblur="fieldBlur(this,'Query');">#PreserveSingleQuotes(form.SqlStatement)#</textarea></td>
	<td valign="top"><cfif ArrayLen(variables.sqlsurfer.arrHistory)>
	<select name="history" id="history" size="8" onclick="SelectHistory(this.selectedIndex);">
		<cfloop from="1" to="#ArrayLen(variables.sqlsurfer.arrHistory)#" index="i">
			<option value="#variables.sqlsurfer.arrHistory[i]#">#Left(variables.sqlsurfer.arrHistory[i],40)#</option>
		</cfloop>
	</select>
	</cfif></td>
  </tr>
</form>
</table>

<cfif form.SqlStatement IS NOT "">
	<!--- Run Query --->
	<cfquery name="RunSql" datasource="#form.DatasourceName#">
	    #PreserveSingleQuotes(form.SqlStatement)#
	</cfquery>
	<!--- Display Results --->
	<cfif isDefined("RunSql") and isQuery(RunSql)>
		<table cellpadding="2" cellspacing="1" bgcolor="##666666">
		  <thead>
		  <tr class="head" bgcolor="##666666">
		<cfloop index="i" list="#RunSql.ColumnList#">
			<td nowrap>#LCase(i)#</td>
		</cfloop>
		  </tr>
		  </thead>
	  <cfif RunSql.recordcount GT 0>
		<cfloop query="RunSql">
		  <tr bgcolor="###IIF(currentrow MOD 2,de('FFFFFF'),de('EEEEEE'))#">
		  <cfloop index="i" list="#RunSql.ColumnList#">
			<td>#Evaluate("RunSql." & i)#</td>
		  </cfloop>
		  </tr>
		</cfloop>
	  <cfelse>
		  <tr>
		    <td colspan="#listLen(RunSql.ColumnList)#" bgcolor="##EEEEEE">No records were returned.</td>
		  </tr>
	  </cfif>
		</table>
		#RunSql.recordcount# Records.
	<cfelse>
		<table cellpadding="2" cellspacing="1" bgcolor="##666666">
		  <tr>
			<td  bgcolor="##EEEEEE">SQL Statement Executed Successfully.</td>
		  </tr>
		</table>
	</cfif>
</cfif>

</cfoutput>


</body>
</html>
