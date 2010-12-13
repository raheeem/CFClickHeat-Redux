<cfcomponent extends="org.stevegood.Base" output="false" implements="ILogWriter">
    
	<cffunction name="init" access="public" returntype="any" output="false">
		<cfset var local = {} />
        
		<cfset super.init(ArgumentCollection=arguments) />
        <cfif NOT directoryExists(super.getLogFile().path)>
            <cfdirectory action="create" directory="#super.getLogFile().path#" />
        </cfif>
		
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
        
        <cfset var local = {} />
        <cfset local.logFile = super.getLogFile().path & '/' & fileName() />
        
        <cflock name="clicks-#DateFormat(Now(), 'yyyy-mm-dd')#" timeout="20">
            <!--- If the logfile doesn't exist --->
            <cfif not FileExists(local.logFile)>
                <!--- Initialize it --->
                <cffile action="write" file="#local.logFile#" output="" addnewline="No">
            </cfif>

            <!--- Write the click to the logfile --->
            <cffile action="append" file="#local.logFile#" output="#arguments.x#|#arguments.y#|#arguments.width#|#ReReplace(LCase(arguments.browser), '/[^a-z]+/', '', 'ALL')#|#createUUID()#|#arguments.site#|#arguments.group#" addnewline="Yes">
        </cflock>
    </cffunction>
    
    <cffunction name="getLogs" access="public" returntype="query" output="false">
       <cfargument name="start" type="date" required="false" default="#dateAdd("d",-7,now())#" />
       <cfargument name="end" type="date" required="false" default="#now()#" />
    </cffunction>
    
    <cffunction name="deleteLogs" access="public" returntype="void" output="false">
		<cfset var local = {} />
        <cfdirectory directory="#super.getLogFile().path#" action="list" name="local.logs" filter="*.log" />
        
        <cfloop query="local.logs">
            <cffile action="delete" file="#super.getLogFile().path#/#name#" />
        </cfloop>
    </cffunction>
	
	<cffunction name="fileName" access="private" returnType="string" output="false">
        <cfset var local = {} />
        <cfset local.now = now() />
        <cfset local.fileName = super.getLogFile().name />
        
        <!--- template replace engine stuff --->
        <cfset local.dateFormats = ['yy','yyy','yyyy','d','dd','ddd','dddd','m','mm','mmm','mmmm'] />
        <cfloop array="#local.dateFormats#" index="local.format">
            <cfset local.fileName = replace(local.fileName,'[#local.format#]',dateFormat(local.now,local.format),'all') />
        </cfloop>
        
        <cfreturn local.fileName />
    </cffunction>
	
</cfcomponent>