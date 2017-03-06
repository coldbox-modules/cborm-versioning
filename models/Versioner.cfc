component {

    property name="wirebox" inject="wirebox";
    property name="BaseORMService" inject="BaseORMService@cborm";
    property name="Mementoizer" inject="Mementoizer@cborm-versioning";

    function ORMPreInsert( event, interceptData, buffer, rc, prc ) {
        if ( shouldVersion( interceptData.entity ) ) {
            version( interceptData.entity );
        }
    }

    function ORMPreUpdate( event, interceptData, buffer, rc, prc ) {
        if ( shouldVersion( interceptData.entity ) ) {
            version( interceptData.entity );
        }
    }

    public function shouldVersion( required any entity ) {
        var md = getMetadata( entity );
        return structKeyExists( md, "versioned" );
    }

    public any function version( required any entity, boolean save = true ) {

        var modelName = BaseORMService.getEntityGivenName( entity );
        var modelId = getPrimaryKeyValue( entity );

        var version = wirebox.getInstance( "Version@cborm-versioning" );
        version.setModelName( modelName );
        version.setModelId( modelId );
        version.setModelMemento( Mementoizer.generateMemento( entity ) );
        version.setCreatedTime( now() );
        if ( save ) {
            version.save();
        }

        var md = getMetadata( entity );
        if ( ! isNull( md.versioned ) && isNumeric( md.versioned ) ) {
            BaseORMService.deleteByQuery(
                query = "
                    FROM Version as v
                    WHERE v.modelName = ?
                    AND v.modelId = ?
                    ORDER BY v.createdTime DESC
                ",
                params = [ modelName, modelId ],
                offset = md.versioned,
                flush = true
            );
        }

        return version;
    }

    private any function getPrimaryKeyValue( required any entity ) {
        var relationshipKeyName = BaseORMService.getKey(
            BaseORMService.getEntityGivenName( entity )
        );
        return invoke( entity, "get#relationshipKeyName#" );
    }

}