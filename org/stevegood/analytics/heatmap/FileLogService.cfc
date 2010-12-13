<cfcomponent extends="org.stevegood.Base" output="false" implements="ILogService">
    
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
	
	   <cfset var local = {} />
	   <cfset local.keyList = "id,x,y,width,logDate,browser,group,site" />
	   <cfset local.qLogs = QueryNew(local.keyList,"varchar,int,int,int,date,varchar,varchar,varchar") />
	   <cfset local.logFiles = readLogFiles(ArgumentCollection=arguments) />
	   <cfloop list="#structKeyList(local.logFiles)#" index="local.key">
		   <cfset local.log = parseLogFile(local.key,local.logFiles[local.key]) />
		   <cfloop array="#local.log#" index="local.record">
			   <cfset QueryAddRow(local.qLogs) />
			   <cfloop list="#local.keyList#" index="local.key">
				   <cfif local.key is 'logDate'>
					   <cfset QuerySetCell(local.qLogs,local.key,CreateODBCDate(local.record[local.key])) />
				   <cfelse>
			           <cfset QuerySetCell(local.qLogs,local.key,local.record[local.key]) />
			       </cfif>
	           </cfloop>
	       </cfloop>
	   </cfloop>
	   
	   <cfreturn local.qLogs />   
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
	
	<cffunction name="readLogFiles" access="private" returntype="struct" output="false">
	   <cfargument name="start" type="date" required="false" default="#dateAdd("d",-7,now())#" />
       <cfargument name="end" type="date" required="false" default="#now()#" />
	   
	   <cfset var local = {} />
	   <cfset local.logFileContent = {} />
	   
	   <cfdirectory action="list" directory="#super.getLogFile().path#" filter="*.log" type="file" name="local.logFiles" />
	   
	   <cfquery dbtype="query" name="local.logFiles">
	   select *
	   from local.logFiles
	   where dateLastModified >= #arguments.start#
	   and dateLastModified < #DateAdd("d",1,arguments.end)#
	   </cfquery>
	   
	   <cfloop query="local.logFiles">
		   <cffile action="read" file="#super.getLogFile().path#/#name#" variable="local.file" />
		   <cfset local.key = replace(name,'clicks-','','ALL') />
		   <cfset local.key = replace(local.key,'.log','','ALL') />
		   <cfset local.logFileContent[local.key] = local.file />
	   </cfloop>
	   
	   <cfreturn local.logFileContent />
	</cffunction>
    
	<cffunction name="parseLogFile" access="private" returntype="array" output="false">
	   <cfargument name="logDate" type="string" required="true" />
	   <cfargument name="logContent" type="string" required="true" />
	   
	   <cfset var local = {} />
	   <cfset local.logs = [] />
	   <cfset local.logList = ListToArray(arguments.logContent,chr(10)) />
	   
	   <cfloop array="#local.logList#" index="local.log">
		   <cfset local.stLog = {} />
		   <cfset local.stLog.logDate = arguments.logDate />
		   <cfset local.stLog.x = listGetAt(local.log,1,"|") />
		   <cfset local.stLog.y = listGetAt(local.log,2,"|") />
		   <cfset local.stLog.width = listGetAt(local.log,3,"|") />
		   <cfset local.stLog.browser = listGetAt(local.log,4,"|") />
		   <cfset local.stLog.id = listGetAt(local.log,5,"|") />
		   <cfset local.stLog.site = listGetAt(local.log,6,"|") />
		   <cfset local.stLog.group = listGetAt(local.log,7,"|") />
		   <cfset arrayAppend(local.logs,local.stLog) />
	   </cfloop>
	   
	   <cfreturn local.logs />	   
	</cffunction>
			
</cfcomponent>