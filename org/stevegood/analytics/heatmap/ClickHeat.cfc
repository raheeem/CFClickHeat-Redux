<cfcomponent output="false" extends="org.stevegood.Base">
	
	<cffunction name="init" access="public" returnType="any" output="false">
		
		<cfset super.init(ArgumentCollection=arguments) />
		
		<cfswitch expression="#super.getStorageType()#">
		    <cfcase value="database">
			    <cfset variables.logWriter = CreateObject("component","DatabaseLogWriter").init(datasource=super.getDatasource()) />
			</cfcase>
			<cfdefaultcase>
			     <cfset variables.logWriter = CreateObject("component","FileLogWriter").init(logFile=super.getLogFile()) />
			</cfdefaultcase>
		</cfswitch>
				
		<cfreturn this />
	</cffunction>
	
	<cffunction name="recordClick" access="public" returnType="void" output="false">
        <cfargument name="x" type="numeric" required="true" />
        <cfargument name="y" type="numeric" required="true" />
        <cfargument name="width" type="numeric" required="true" />
        <cfargument name="height" type="numeric" required="true" />
        <cfargument name="site" type="string" required="true" />
        <cfargument name="browser" type="string" required="true" />
        <cfargument name="group" type="string" required="false" default="" />
        		
        <cfset variables.logWriter.writeLog(ArgumentCollection=arguments) />
    </cffunction>
	
	<cffunction name="getLogs" access="public" returntype="query" output="false">
	   <cfargument name="start" type="date" required="false" default="#dateAdd("d",-7,now())#" />
       <cfargument name="end" type="date" required="false" default="#now()#" />
	   
	   <cfreturn variables.logWriter.getLogs(ArgumentCollection=arguments) />
	</cffunction>
	
	<cffunction name="deleteLogs" access="public" returntype="void" output="false">
	   <cfset varaibles.logWriter.deleteLogs() />
	</cffunction>
		
	<cffunction name="renderHeatMap" access="public" returnType="string" output="false">
		<cfset var local = {} />
		<cfset initLogs() />
		
		<cfsavecontent variable="local.output">
		</cfsavecontent>
		
		<cfreturn local.output />
	</cffunction>
	
</cfcomponent>