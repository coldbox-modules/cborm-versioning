component {

    property name="BaseORMService" inject="BaseORMService@cborm";

    /**
    * Creates a memnto (struct version of the entity) from an ORM entity
    *
    * @entity The entity for which to create a memento.
    *
    * @returns A struct version of the entity. (A memento.)
    */
    public struct function generate( required any entity ) {
        guardAgainstNonOrmEntities( entity );
        return generateMemento( entity );
    }

    /**
    * Throws an exception if the component is not an ORM entity
    *
    * @entity The entity that should be an ORM entity
    *
    * @throws InvalidEntityType
    */
    private function guardAgainstNonOrmEntities( required any entity ) {
        if ( ! structKeyExists( getMetadata( entity ), "persistent" ) || !getMetadata( entity ).persistent ) {
            throw(
                type = "InvalidEntityType",
                message = "Cannot mementoize a non-ORM entity"
            );
        }
    }

    /**
    * Generate a struct version of an entity.
    *
    * @entity The entity for which to generate a memento.
    *
    * @returns A struct version of the entity. (A memento.)
    */
    private struct function generateMemento( required any entity ) {
        var entityName = BaseORMService.getEntityGivenName( entity );
        var properties = generateProperties( entityName );

        var result = {};
        for ( var prop in properties ) {
            var val = invoke( entity, "get#prop#" );

            if ( isNull( val ) ) {
                val = "";
            }

            else if ( isObject( val ) ) {
                val = getPrimaryKeyValue( val );
            }

            // if it is an array of entities
            else if ( isArray( val ) && ! arrayIsEmpty( val ) && isObject( val[ 1 ] ) ) {
                var ids = [];
                for ( var relationship in val ) {
                    arrayAppend( ids, getPrimaryKeyValue( relationship ) );
                }
                val = ids;
            }

            result[ prop ] = isNull( val ) ? "" : val;
        }

        return result;
    }

    /**
    * Get all the property names for an entity.
    *
    * @entityName The name of the entity for which to generate the property names.
    *
    * @returns An array of property names for the entity.
    */
    private array function generateProperties( required string entityName ) {
        var properties = getPrimaryKeyColumnNames( entityName );
        var inherentProperties = BaseORMService.getPropertyNames( entityName );

        // merge our latter in to the former because
        // of the javatype returned by getPropertyNames()
        arrayAppend( properties, inherentProperties, true );

        return properties;
    }

    /**
    * Returns an array of properties that make up the identifier.
    * A convenience facade for `getKey()` to ensure consistent data type.
    *
    * @entityName The entity name for which to retrieve the primary key column names.
    *
    * @returns An array of primary key column names
    */
    private array function getPrimaryKeyColumnNames( required string entityName ) {
        var identifiers = BaseORMService.getKey( entityName );

        if( isSimpleValue( identifiers ) ) {
            identifiers = [ identifiers ];
        } 

        return identifiers;
    }

    /**
    * Gets the value of an entity's primary key.
    *
    * @entity The entity for which to retrieve the primary key value.
    *
    * @returns The primary key value of the entity.
    */
    private any function getPrimaryKeyValue( required any entity ) {
        var relationshipKeyName = BaseORMService.getKey(
            BaseORMService.getEntityGivenName( entity )
        );
        return invoke( entity, "get#relationshipKeyName#" );
    }

}