<cfcomponent output="false" extends="org.stevegood.Base">
	
	<cffunction name="init" access="public" returnType="any" output="false">
		
		<cfset super.init(ArgumentCollection=arguments) />
		<cfset initLogs() />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="initLogs" access="public" returnType="void" output="false">
		<cfset var local = {} />
		
		<cfif NOT directoryExists(super.getLogFile().path)>
			<cfdirectory action="create" directory="#super.getLogFile().path#" />
		</cfif>
	</cffunction>
	
	<cffunction name="deleteLogs" access="public" returnType="void" output="false">
		<cfset var local = {} />
		<cfset initLogs() />
		<cfdirectory directory="#super.getLogFile().path#" action="list" name="local.logs" filter="*.log" />
		
		<cfloop query="local.logs">
			<cffile action="delete" file="#super.getLogFile().path#/#name#" />
		</cfloop>
	</cffunction>
	
	<cffunction name="recordClick" access="public" returnType="void" output="false">
		<cfset var local = {} />
		<cfset initLogs() />
	</cffunction>
	
	<cffunction name="renderHeatMap" access="public" returnType="string" output="false">
		<cfset var local = {} />
		<cfset initLogs() />
		
		<cfsavecontent variable="local.output">
		</cfsavecontent>
		
		<cfreturn local.output />
	</cffunction>
	
</cfcomponent>