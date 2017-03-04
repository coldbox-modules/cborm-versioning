component extends="tests.resources.ModuleIntegrationSpec" appMapping="/app" {
    function run() {
        describe( "Versioning ORM Entities", function() {
            beforeEach( function () {
                variables.versioner = prepareMock(
                    application.wirebox.getInstance( "Versioner@cborm-versioning" )
                );
            } );
            it( "listens for the ORMPreUpdate and ORMPreInsert interception points", function() {
                expect( versioner ).toHaveKey( "ORMPreInsert" );
                expect( versioner.ORMPreInsert ).toBeTypeOf( "function" );

                expect( versioner ).toHaveKey( "ORMPreUpdate" );
                expect( versioner.ORMPreUpdate ).toBeTypeOf( "function" );
            } );

            it( "only versions entities with a 'versioned' attribute on the component", function() {
                versioner.$( "version" );

                var entity = application.wirebox.getInstance( "NonVersionedModel" );

                var mockEvent = createMock( "coldbox.system.web.context.RequestContext" );
                var mockInterceptData = { entity = entity };

                versioner.ORMPreInsert( mockEvent, mockInterceptData );

                expect( versioner.$never( "version" ) ).toBeTrue( "[version] should not have been called." );
            } );

            describe( "it handles different types of primary keys", function() {
                it( "can handle string primary keys", function() {
                    var entityName = "StringVersionedModel";
                    var id = createUUID();
                    
                    var entity = application.wirebox.getInstance( entityName );
                    entity.setId( id );

                    var mockEvent = createMock( "coldbox.system.web.context.RequestContext" );
                    var mockInterceptData = { entity = entity };

                    versioner.ORMPreInsert( mockEvent, mockInterceptData );

                    var versions = application.wirebox.getInstance( "Version@cborm-versioning" )
                        .findAllWhere(
                            criteria = { modelName = entityName, modelId = id },
                            sortOrder = "createdTime"
                        );

                    expect( isNull( versions ) )
                        .toBeFalse( "A version for entity [#entityName#] and id [#id#] should have been found." );
                    expect( versions ).toBeArray();
                    expect( versions ).notToBeEmpty( "A version for entity [#entityName#] and id [#id#] should have been found." );
                } );

                it( "can handle integer primary keys", function() {
                    var entityName = "IntegerVersionedModel";
                    var id = 500;
                    
                    var entity = application.wirebox.getInstance( entityName );
                    entity.setId( id );

                    var mockEvent = createMock( "coldbox.system.web.context.RequestContext" );
                    var mockInterceptData = { entity = entity };

                    versioner.ORMPreInsert( mockEvent, mockInterceptData );

                    var versions = application.wirebox.getInstance( "Version@cborm-versioning" )
                        .findAllWhere(
                            criteria = { modelName = entityName, modelId = id },
                            sortOrder = "createdTime"
                        );

                    expect( isNull( versions ) )
                        .toBeFalse( "A version for entity [#entityName#] and id [#id#] should have been found." );
                    expect( versions ).toBeArray();
                    expect( versions ).notToBeEmpty( "A version for entity [#entityName#] and id [#id#] should have been found." );
                } );

                xit( "can handle composite primary keys", function() {
                    fail( "test not implemented yet" );
                } );
            } );
        } );
    }
}