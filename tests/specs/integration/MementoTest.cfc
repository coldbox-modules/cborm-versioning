component extends="tests.resources.ModuleIntegrationSpec" appMapping="/app" {
    function run() {
        describe( "Memento-izing ORM Entities", function() {
            beforeEach( function() {
                variables.mementoizer = application.wirebox.getInstance( "Mementoizer@cborm-versioning" );
            } );

            it( "throws an exception on a non-orm entity", function() {
                var nonOrmModel = application.wirebox.getInstance( "NonOrmModel" );

                try {
                    mementoizer.generate( nonOrmModel );
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
                    
                    var memento = mementoizer.generate( noRelationshipsModel );

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
                    oneToManyModel.setId( 1 );
                    oneToManyModel.setPropertyA( "foo" );

                    var memento = mementoizer.generate( oneToManyModel );

                    expect( memento ).toBe( {
                        "id" = 1,
                        "propertyA" = "foo",
                        "relationshipA" = ""
                    } );
                } );

                it( "can convert when there is one one-to-many relationship added", function() {
                    var oneToManyModel = application.wirebox.getInstance( "OneToManyModel" );
                    oneToManyModel.setId( 1 );
                    oneToManyModel.setPropertyA( "foo" );
                    
                    var manyToOneModel = application.wirebox.getInstance( "ManyToOneModel" );
                    manyToOneModel.setId( 1 );
                    oneToManyModel.addRelationshipA( manyToOneModel );

                    var memento = mementoizer.generate( oneToManyModel );

                    expect( memento ).toBe( {
                        "id" = 1,
                        "propertyA" = "foo",
                        "relationshipA" = [ 1 ]
                    } );
                } );

                it( "can convert when there is more than one one-to-many relationships added", function() {
                    var oneToManyModel = application.wirebox.getInstance( "OneToManyModel" );
                    oneToManyModel.setId( 1 );
                    oneToManyModel.setPropertyA( "foo" );
                    
                    var manyToOneModelA = application.wirebox.getInstance( "ManyToOneModel" );
                    manyToOneModelA.setId( 1 );
                    oneToManyModel.addRelationshipA( manyToOneModelA );

                    var manyToOneModelB = application.wirebox.getInstance( "ManyToOneModel" );
                    manyToOneModelB.setId( 3 );
                    oneToManyModel.addRelationshipA( manyToOneModelB );

                    var memento = mementoizer.generate( oneToManyModel );

                    expect( memento ).toBe( {
                        "id" = 1,
                        "propertyA" = "foo",
                        "relationshipA" = [ 1, 3 ]
                    } );
                } );
            } );

            describe( "many-to-one relationships", function() {
                it( "can convert when there are no many-to-one relationships added", function() {
                    var manyToOneModel = application.wirebox.getInstance( "manyToOneModel" );
                    manyToOneModel.setId( 1 );
                    manyToOneModel.setPropertyB( "bar" );

                    var memento = mementoizer.generate( manyToOneModel );

                    expect( memento ).toBe( {
                        "id" = 1,
                        "propertyB" = "bar",
                        "relationshipB" = ""
                    } );
                } );

                it( "can convert when there is a many-to-one relationship added", function() {
                    var manyToOneModel = application.wirebox.getInstance( "manyToOneModel" );
                    manyToOneModel.setId( 1 );
                    manyToOneModel.setPropertyB( "baz" );
                    
                    var oneToManyModel = application.wirebox.getInstance( "OneToManyModel" );
                    oneToManyModel.setId( 1 );
                    manyToOneModel.setRelationshipB( oneToManyModel );

                    var memento = mementoizer.generate( manyToOneModel );

                    expect( memento ).toBe( {
                        "id" = 1,
                        "propertyB" = "baz",
                        "relationshipB" = 1
                    } );
                } );
            } );

            describe( "many-to-many relationships", function() {
                it( "can convert when there are no many-to-many relationships added", function() {
                    var manyToManyA = application.wirebox.getInstance( "manyToManyA" );
                    manyToManyA.setId( 1 );
                    manyToManyA.setPropertyA( "bar" );

                    var memento = mementoizer.generate( manyToManyA );

                    expect( memento ).toBe( {
                        "id" = 1,
                        "propertyA" = "bar",
                        "relationshipA" = ""
                    } );
                } );

                it( "can convert when there is a many-to-many relationship added", function() {
                    var manyToManyA = application.wirebox.getInstance( "manyToManyA" );
                    manyToManyA.setId( 1 );
                    manyToManyA.setPropertyA( "bar" );

                    var manyToManyB = application.wirebox.getInstance( "manyToManyB" );
                    manyToManyB.setId( 1 );
                    manyToManyA.addRelationshipA( manyToManyB );

                    var memento = mementoizer.generate( manyToManyA );

                    expect( memento ).toBe( {
                        "id" = 1,
                        "propertyA" = "bar",
                        "relationshipA" = [ 1 ]
                    } );
                } );

                it( "can convert when there are many many-to-many relationships added", function() {
                    var manyToManyA = application.wirebox.getInstance( "manyToManyA" );
                    manyToManyA.setId( 1 );
                    manyToManyA.setPropertyA( "bar" );

                    var manyToManyB1 = application.wirebox.getInstance( "manyToManyB" );
                    manyToManyB1.setId( 1 );
                    manyToManyA.addRelationshipA( manyToManyB1 );

                    var manyToManyB2 = application.wirebox.getInstance( "manyToManyB" );
                    manyToManyB2.setId( 3 );
                    manyToManyA.addRelationshipA( manyToManyB2 );

                    var memento = mementoizer.generate( manyToManyA );

                    expect( memento ).toBe( {
                        "id" = 1,
                        "propertyA" = "bar",
                        "relationshipA" = [ 1, 3 ]
                    } );
                } );
            } );

            describe( "one-to-one relationships", function() {
                it( "can convert when there is no one-to-one relationship added", function() {
                    var oneToOneA = application.wirebox.getInstance( "oneToOneA" );
                    oneToOneA.setId( 1 );
                    oneToOneA.setPropertyA( "bar" );

                    var memento = mementoizer.generate( oneToOneA );

                    expect( memento ).toBe( {
                        "id" = 1,
                        "propertyA" = "bar",
                        "relationshipA" = ""
                    } );
                } );

                it( "can convert when there is a one-to-one relationship added", function() {
                    var oneToOneA = application.wirebox.getInstance( "oneToOneA" );
                    oneToOneA.setId( 1 );
                    oneToOneA.setPropertyA( "bar" );

                    var oneToOneB = application.wirebox.getInstance( "oneToOneB" );
                    oneToOneB.setId( 1 );
                    oneToOneA.setRelationshipA( oneToOneB );

                    var memento = mementoizer.generate( oneToOneA );

                    expect( memento ).toBe( {
                        "id" = 1,
                        "propertyA" = "bar",
                        "relationshipA" = 1
                    } );
                } );
            } );
        } );
    }
}