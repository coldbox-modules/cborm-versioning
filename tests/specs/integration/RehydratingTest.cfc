component extends="tests.resources.ModuleIntegrationSpec" appMapping="/app" {
    function run() {
        describe( "Rehydrating Versions", function() {
            it( "can rehydrate an ORM entity from a version", function() {
                var entity = createEntity();
                var version = application.wirebox
                    .getInstance( "Versioner@cborm-versioning" )
                    .version( entity );

                var restoredEntity = version.restore();

                expect( restoredEntity.getId() ).toBe( entity.getId() );
                expect( restoredEntity.getPropertyA() )
                    .toBe( entity.getPropertyA() );
                expect( restoredEntity.getRelationshipA() ).toBeArray();
                expect( restoredEntity.getRelationshipA() ).toHaveLength( 1 );
                expect( restoredEntity.getRelationshipA()[ 1 ] ).notToBeNull();
                expect( restoredEntity.getRelationshipA()[ 1 ] )
                    .toBeInstanceOf( "ManyToOneModel" );
                expect( restoredEntity.getRelationshipA()[ 1 ].getId() )
                    .toBe( entity.getRelationshipA()[ 1 ].getId() );
                expect( restoredEntity.getRelationshipA()[ 1 ].getPropertyB() )
                    .toBe( entity.getRelationshipA()[ 1 ].getPropertyB() );
                expect( restoredEntity.getRelationshipA()[ 1 ].getRelationshipB() )
                    .toBe( entity.getRelationshipA()[ 1 ].getRelationshipB() );
            } );
        } );
    }

    private any function createEntity() {
        var oneToManyModel = application.wirebox.getInstance( "OneToManyModel" );
        oneToManyModel.setId( 1 );
        oneToManyModel.setPropertyA( "foo" );
        
        var manyToOneModel = application.wirebox.getInstance( "ManyToOneModel" );
        manyToOneModel.setId( 1 );
        manyToOneModel.setPropertyB( "bar" );

        oneToManyModel.addRelationshipA( manyToOneModel );
        manyToOneModel.setRelationshipB( oneToManyModel );

        var BaseORMService = application.wirebox.getInstance( "BaseORMService@cborm" );
        BaseORMService.save( oneToManyModel );
        BaseORMService.save( manyToOneModel );

        return oneToManyModel;
    }
}