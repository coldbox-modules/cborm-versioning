component extends="tests.resources.ModuleIntegrationSpec" appMapping="/app" {
    function run() {
        describe( "Memento-izing ORM Entities", function() {
            beforeEach( function() {
                variables.mementoizer = application.wirebox.getInstance( "Mementoizer@cborm-versioning" );
            } );

            it( "throws an exception on a non-orm entity", function() {
                var nonOrmModel = application.wirebox.getInstance( "NonOrmModel" );

                try {
                    mementoizer.generateMemento( nonOrmModel );
                }
                catch ( InvalidEntityType e ) {
                    expect( e.message ).toBe( "Cannot mementoize a non-ORM entity" );
                    return;
                }

                fail( "Should not be able to generate a memento on a non-ORM model." );
            } );

            describe( "no relationships", function() {
                it( "can convert a an entity with no relationships", function() {
                    var noRelationshipsModel = application.wirebox.getInstance( "NoRelationshipsModel" );
                    noRelationshipsModel.setId( 1 );
                    noRelationshipsModel.setPropertyA( "foo" );
                    noRelationshipsModel.setPropertyB( "bar" );
                    
                    var memento = mementoizer.generateMemento( noRelationshipsModel );

                    expect( memento ).toBe( {
                        "id" = 1,
                        "propertyA" = "foo",
                        "propertyB" = "bar",
                        "propertyC" = ""
                    } );
                } );
            } );

            describe( "one-to-many relationships", function() {
                it( "can convert when there are no one-to-many relationships added", function() {
                    var oneToManyModel = application.wirebox.getInstance( "OneToManyModel" );
                    // var manyToOneModel = application.wirebox.getInstance( "ManyToOneModel" );
                    oneToManyModel.setId( 1 );
                    oneToManyModel.setPropertyA( "foo" );
                    // oneToManyModel.setRelationshipA( manyToOneModel );

                    var memento = mementoizer.generateMemento( oneToManyModel );

                    expect( memento ).toBe( {
                        "id" = 1,
                        "propertyA" = "foo",
                        "relationshipA" = ""
                    } );
                } );

                it( "can convert when there are some one-to-many relationships added", function() {
                    var oneToManyModel = application.wirebox.getInstance( "OneToManyModel" );
                    oneToManyModel.setId( 1 );
                    oneToManyModel.setPropertyA( "foo" );
                    
                    var manyToOneModel = application.wirebox.getInstance( "ManyToOneModel" );
                    manyToOneModel.setId( 1 );
                    oneToManyModel.addRelationshipA( manyToOneModel );

                    var memento = mementoizer.generateMemento( oneToManyModel );

                    expect( memento ).toBe( {
                        "id" = 1,
                        "propertyA" = "foo",
                        "relationshipA" = [ 1 ]
                    } );
                } );
            } );

            describe( "many-to-one relationships", function() {
                it( "can convert an entity with many-to-one relationships", function() {
                    fail( "test not implemented yet" );
                } );
            } );

            describe( "many-to-many relationships", function() {
                it( "can convert an entity with many-to-many relationships", function() {
                    fail( "test not implemented yet" );
                } );
            } );

            describe( "one-to-one relationships", function() {
                it( "can convert an entity with one-to-one relationships", function() {
                    fail( "test not implemented yet" );
                } );
            } );
        } );
    }
}