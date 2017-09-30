component {

    this.name = "ColdBoxTestingSuite" & hash(getCurrentTemplatePath());
    this.sessionManagement  = true;
    this.setClientCookies   = true;
    this.sessionTimeout     = createTimeSpan( 0, 0, 15, 0 );
    this.applicationTimeout = createTimeSpan( 0, 0, 15, 0 );

    testsPath = getDirectoryFromPath( getCurrentTemplatePath() );
    this.mappings[ "/tests" ] = testsPath;
    rootPath = REReplaceNoCase( this.mappings[ "/tests" ], "tests(\\|/)", "" );
    this.mappings[ "/root" ] = rootPath;
    this.mappings[ "/testingModuleRoot" ] = listDeleteAt( rootPath, listLen( rootPath, '\/' ), "\/" );
    this.mappings[ "/app" ] = testsPath & "resources/app";
    this.mappings[ "/coldbox" ] = testsPath & "resources/app/coldbox";
    this.mappings[ "/testbox" ] = rootPath & "/testbox";

    function upOneLevel( path ) {
        var p = expandPath( path );
        var pArray = listToArray( p, "/" );
        arrayDeleteAt( pArray, arrayLen( pArray ) );
        return "/" & arrayToList( pArray , "/" ) & "/";
    }

    	// Datasource definitions For Standalone mode/travis mode.
	if( directoryExists( "/home/travis" ) ){
		this.datasources[ "cborm_versioning" ] = {
			  class 			: 'org.gjt.mm.mysql.Driver',
			  connectionString	: 'jdbc:mysql://localhost:3306/cborm_versioning?useUnicode=true&characterEncoding=UTF-8&useLegacyDatetimeCode=true&',
			  username			: 'root'
		};
	}

    // created in cfadmin
    this.datasource = "cborm_versioning";
    this.mappings[ "/cborm" ] = rootPath & "modules/cborm";

    this.ormEnabled = true;
    this.ormSettings = {
        cfclocation = [ "/app/models", "/root/models" ],
        dbcreate = "dropcreate",
        logSQL = true,
        flushAtRequestEnd = false,
        autoManageSession = false,
        eventHandling = true,
        eventHandler = "cborm.models.EventHandler"
    };

    function onRequestStart() {
        structDelete( application, "cbController" );
		structDelete( application, "wirebox" );	
        ORMReload();
    }
}
