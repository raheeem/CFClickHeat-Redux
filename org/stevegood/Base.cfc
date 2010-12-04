<cfcomponent output="false">
	
	<cffunction name="init" access="public" returntype="any" output="false">
		<cfset var local = {} />
		<cfset variables.instance = {} />
		<cfloop list="#structKeyList(arguments)#" index="local.arg">
			<cfset variables.instance[local.arg] = arguments[local.arg] />
		</cfloop>
		<cfreturn this />
	</cffunction>
	
    <cffunction name="OnMissingMethod" returnType="any" access="public" output="true" hint="Handles getters and setters">
        <cfargument name="MissingMethodName" type="string" required="true" hint="The name of the missing method">
        <cfargument name="MissingMethodArguments" type="struct" required="true" hint="The arguments passed in to the missing method">
		
		<cfset var local = {} />
		<cfset local.op = lcase(left(arguments.MissingMethodName,3)) />
		<cfset local.key = lcase(right(arguments.MissingMethodName,(len(arguments.MissingMethodName)-3))) />
		
        <cfif local.op eq "get">
            <cfreturn getValue(local.key)/>
        <cfelseif local.op eq "set">
            <cfif not StructKeyExists(arguments.MissingMethodArguments, "2")>
				<cfset setValue(local.key, arguments.MissingMethodArguments) />
            </cfif>
        </cfif>
    </cffunction>

    <cffunction name="setValue" returnType="void" access="private" output="true" hint="internal setter method" >
        <cfargument name="name" type="string" required="true" hint="name of property to set">
        <cfargument name="value" type="any" required="true" hint="value of property">
            <cfset variables.instance[arguments.name] =  arguments.value.1 />
    </cffunction>

    <cffunction name="getValue" returnType="any" access="private" output="true" hint="internal getter method" >
        <cfargument name="name" type="string" required="true" hint="name of property to set">
            <cfif valueExists(arguments.name)>
                <cfreturn variables.instance[arguments.name] />
            <cfelse>
                <cfreturn ""/>
            </cfif>
    </cffunction>
	
	<cffunction name="valueExists" returntype="any" access="public" output="false">
		<cfargument name="property" type="string" required="true">
		<cfreturn structKeyExists(variables.instance,arguments.property) />
	</cffunction>
	
	<cffunction name="removeValue" access="public" output="false">
		<cfargument name="property" type="string" required="true"/>
		<cfset structDelete(variables.instance,arguments.property) />
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getMemento" access="public" returntype="struct" output="false">
		<cfreturn duplicate(variables.instance) />
	</cffunction>
	
</cfcomponent>