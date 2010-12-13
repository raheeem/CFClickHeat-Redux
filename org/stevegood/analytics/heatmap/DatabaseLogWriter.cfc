<cfcomponent extends="org.stevegood.Base" output="false" implements="ILogWriter">
    
	<cffunction name="init" access="public" returntype="any" output="false">
		<cfreturn this />
    </cffunction>
    
    <cffunction name="writeLog" access="public" returntype="void" output="false">
        <cfargument name="x" type="numeric" required="true" />
        <cfargument name="y" type="numeric" required="true" />
        <cfargument name="width" type="numeric" required="true" />
        <cfargument name="height" type="numeric" required="true" />
        <cfargument name="site" type="string" required="true" />
        <cfargument name="browser" type="string" required="true" />
        <cfargument name="group" type="string" required="false" default="" />
    </cffunction>
    
    <cffunction name="getLogs" access="public" returntype="query" output="false">
       <cfargument name="start" type="date" required="false" default="#dateAdd("d",-7,now())#" />
       <cfargument name="end" type="date" required="false" default="#now()#" />
    </cffunction>
    
    <cffunction name="deleteLogs" access="public" returntype="void" output="false">
    </cffunction>
	
</cfcomponent>