<cfcomponent>
	
	<cfscript>
		this.name = hash(expandPath('.'));
		this.mappings['org'] = expandPath('./org');
	</cfscript>
	
	<cffunction name="onApplicationStart">
		<cfset initApp() />
	</cffunction>
	
	<cffunction name="onRequestStart">
		<cfif structKeyExists(url,'reinit')>
			<cfset initApp() />
		</cfif>
	</cffunction>
	
	<cffunction name="initApp" access="private" output="false" returntype="void">
		
		<cfset var local = {} />
		
		<cfset local.settings = {} />
		<cfset local.settings['logFile'] = {} />
		<cfset local.settings.logFile['name'] = "clicks-[yyyy]-[mm]-[dd].log" />
		<cfset local.settings.logFile['path'] = "#expandPath('.')#/click_logs" />
		<cfset local.settings['screenSizes'] = [640,800,1024,1280,1440,1600,1800] />
		<cfset local.settings['colorScale'] = ['979DF7','787EF8','5A60FB','3B42FC','284DFE','289EFE','28EFFE','28FAB6','28FA65','47FA33','98FA33','EAFA33','F3A633','F34633','FF6644'] />
		<cfset local.settings['dotWidth'] = 10 />
		<cfset local.settings['width'] = 1024 />
		<cfset local.settings['height'] = 768 />
		<cfset local.settings['bgColor'] = 'E4E9F2' />
		<cfset local.settings['titleBarColor'] = 'A6C9FF' />
		<cfset local.settings['titleColor'] = '333333' />
		<cfset local.settings['bottomColor'] = '666666' />
		<cfset local.settings['titleBarFont'] = 'Lucida Sans Regular' />
		
		<cfset application.clickheat = CreateObject("component","org.stevegood.analytics.heatmap.ClickHeat").init(ArgumentCollection=duplicate(local.settings)) />
	</cffunction>
	
</cfcomponent>