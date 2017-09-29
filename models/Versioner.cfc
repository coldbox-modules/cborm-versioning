component singleton{

    property name="wirebox" inject="wirebox";
    property name="BaseORMService" inject="BaseORMService@cborm";
    property name="Mementoizer" inject="Mementoizer@cborm-versioning";
    property name="versionService" inject="entityService:Version";

    /**
    * Create a version for `versioned` entites on insert.
    *
    * @event The ColdBox Request Context.
    * @interceptData Intercept data including the entity being inserted.
    */
    function ORMPreInsert( event, interceptData ) {
        if ( shouldVersion( interceptData.entity ) ) {
            version( interceptData.entity );
        }
    }

    /**
    * Create a version for `versioned` entites on update.
    *
    * @event The ColdBox Request Context.
    * @interceptData Intercept data including the entity being updated.
    */
    function ORMPreUpdate( event, interceptData ) {
        if ( shouldVersion( interceptData.entity ) ) {
            version( interceptData.entity );
        }
    }

    /**
    * Returns whether a entity should be versioned based on the
    * existance of a `versioned` attribute on the entity.
    *
    * @entity The entity to check if it should be versioned.
    *
    * @returns Whether the entity should be versioned.
    */
    public boolean function shouldVersion( required any entity ) {
        var md = getMetadata( entity );
        return structKeyExists( md, "versioned" );
    }

    /**
    * Creates a version for an entity.
    *
    * This function creates a version for an entity using that entity's name,
    * primary key value, and generated memento.
    *
    * If the `versioned` attribute has a numeric value, it also deletes any
    * versions past `n` where `n` is the value of `versioned`.
    *
    * @entity The entity to version.
    * @createdTime The time the version was created.  Default: `now()`.
    * @save Whether to save the version right away.  Default: true.
    *
    * @returns The newly created version.
    */
    public Version function version(
        required any entity,
        date createdTime = now(),
        boolean save = true
    ) {
        var version = versionService.new();
        version.setModelName( BaseORMService.getEntityGivenName( entity ) );
        version.setModelId( getPrimaryKeyValue( entity ) );
        version.setModelMemento( Mementoizer.generate( entity ) );
        version.setCreatedTime( createdTime );

        if ( save ) {
            version.save();
        }

        if ( shouldTrimVersions( entity ) ) {
            trimVersions( entity );
        }

        return version;
    }

    /**
    * Returns the primary key value for a given entity.
    *
    * @entity The entity for which to retrieve the primary key value.
    *
    * @returns The primary key value for the given entity.
    */
    private any function getPrimaryKeyValue( required any entity ) {
        var relationshipKeyName = BaseORMService.getKey(
            BaseORMService.getEntityGivenName( entity )
        );
        return invoke( entity, "get#relationshipKeyName#" );
    }

    /**
    * Returns whether an entity has its versions trimmed enabled.
    *
    * @entity The entity to check for version trimming.
    *
    * @returns Whether the entity has versions trimmed enabled.
    */
    private boolean function shouldTrimVersions( required any entity ) {
        var md = getMetadata( entity );
        return ( ! isNull( md.versioned ) && isNumeric( md.versioned ) );
    }

    /**
    * Trims versions for a given entity to the value specified in
    * the `versioned` component attribute.
    *
    * @entity The entity for which to trim versions.
    */
    private void function trimVersions( required any entity ) {
        BaseORMService.deleteByQuery(
            query = "
                FROM Version as v
                WHERE v.modelName = ?
                AND v.modelId = ?
                ORDER BY v.createdTime DESC
            ",
            params = [
                BaseORMService.getEntityGivenName( entity ),
                getPrimaryKeyValue( entity )
            ],
            offset = getMetadata( entity ).versioned
        );
    }

}
