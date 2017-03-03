component extends="tests.resources.ModuleIntegrationSpec" appMapping="/app" {
    function run() {
        describe( "Versioning ORM Entities", function() {
            it( "listens for the ORMPreUpdate and ORMPreInsert interception points", function() {
                fail( "test not implemented yet" );
            } );

            it( "only versions entities with a 'versioned' attribute on the component", function() {
                fail( "test not implemented yet" );
            } );

            it( "does not version entities if the value of the 'versioned' attribute is false", function() {
                fail( "test not implemented yet" );
            } );

            describe( "it handles different types of primary keys", function() {
                it( "can handle string primary keys", function() {
                    fail( "test not implemented yet" );
                } );

                it( "can handle integer primary keys", function() {
                    fail( "test not implemented yet" );
                } );

                it( "can handle composite primary keys", function() {
                    fail( "test not implemented yet" );
                } );
            } );
        } );
    }
}