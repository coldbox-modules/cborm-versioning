component {

    property name="BaseORMService" inject="BaseORMService@cborm";

    public struct function generate( required any entity ) {
        var md = getMetadata( entity );

        guardAgainstNonOrmEntities( md );

        return getBaseMemento( entity );
    }

    private function guardAgainstNonOrmEntities( required struct metadata ) {
        if ( ! structKeyExists( metadata, "persistent" ) ) {
            throw(
                type = "InvalidEntityType",
                message = "Cannot mementoize a non-ORM entity"
            );
        }
    }

    /**
    * Build out property mementos from simple properties only.
    */
    private struct function getBaseMemento( required any entity ) {
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

    private array function generateProperties( required string entityName ) {
        var properties = getIdentifierColumnNames( entityName );
        var inherentProperties = BaseORMService.getPropertyNames( entityName );

        // merge our latter in to the former because
        // of the javatype returned by getPropertyNames()
        arrayAppend( properties, inherentProperties, true );

        return properties;
    }

    /**
    * Returns an array of properties that make up the identifier - convenience facade for `getKey()` to ensure consistent data type
    **/
    private array function getIdentifierColumnNames( required string entityName ) {
        var identifiers = BaseORMService.getKey( entityName );

        if( isSimpleValue( identifiers ) ) {
            identifiers = [ identifiers ];
        } 

        return identifiers;
    }

    private any function getPrimaryKeyValue( required any entity ) {
        var relationshipKeyName = BaseORMService.getKey(
            BaseORMService.getEntityGivenName( entity )
        );
        return invoke( entity, "get#relationshipKeyName#" );
    }

}