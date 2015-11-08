<?xml version="1.0" encoding="UTF-8"?>
<fusebox>
	<circuits>
		<circuit alias="home" path="/circuits/home/" parent="" />
		<circuit alias="admin" path="/circuits/admin/" parent="" />
		<circuit alias="security" path="/circuits/security/" parent="" />
		<circuit alias="user" path="/circuits/user/" parent="" />
		<circuit alias="order" path="/circuits/order/" parent="" />	
		<circuit alias="customer" path="/circuits/customer/" parent="" />
		<circuit alias="common" path="/circuits/common/" parent="" />
		<circuit alias="utils" path="/circuits/utils/" parent="" />
		<circuit alias="calendar" path="/circuits/calendar/" parent="" />
		<circuit alias="m_calendar" path="/circuits/calendar/m/" parent="" />
		<circuit alias="v_calendar" path="/circuits/calendar/v/" parent="" />	
		<circuit alias="m_gui" path="/circuits/gui/m/" parent="" />	
	</circuits>

	<classes>
		<!-- Example: <class alias="MyClass" type="component" classpath="path.to.SomeCFC" constructor="init" /> -->
	</classes>

	<parameters>
		<parameter name="fuseactionVariable" value="do" />
		<parameter name="defaultFuseaction" value="home.main" />
		<parameter name="precedenceFormOrUrl" value="form" />
		<parameter name="mode" value="production"/><!-- development  -->
		<parameter name="password" value=""/>
		<parameter name="parseWithComments" value="false" />
		<parameter name="conditionalParse" value="false" />
		<parameter name="allowLexicon" value="true" />
		<parameter name="useAssertions" value="true" />
		<parameter name="ignoreBadGrammar" value="true" />
		<parameter name="scriptlanguage" value="cfmx" />
		<parameter name="scriptFileDelimiter" value="cfm" />
		<parameter name="maskedFileDelimiters" value="htm,cfm,cfml,php,php4,asp,aspx" />
		<parameter name="characterEncoding" value="utf-8" />
		<parameter name="errortemplatesPath" value="errortemplates" />
	</parameters>

	<globalfuseactions>
		<preprocess>
			<do action="m_gui.getViewContent" />			
		</preprocess>	
		
		<postprocess>
			<do action="common.renderpage" />
		</postprocess>
	</globalfuseactions>

	<plugins>
		<phase name="preProcess">
		</phase>
		<phase name="preFuseaction">
		</phase>
		<phase name="postFuseaction">
		</phase>
		<phase name="fuseactionException">
		</phase>
		<phase name="postProcess">
		</phase>
		<phase name="processError">
		</phase>
	</plugins>

</fusebox>