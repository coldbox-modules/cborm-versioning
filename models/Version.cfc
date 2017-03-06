component
    accessors="true"
    persistent="true"
    table="cborm_versions"
    extends="cborm.models.ActiveEntity"
{
    // Dependency Injection
    property name="populator"
                inject="wirebox:populator"
                persistent="false"
                getter="false"
                setter="false";

    // Primary Key
    property name="id"
                fieldtype="id"
                column="id"
                ormtype="string"
                generator="guid";
    
    // Properties
    property name="modelName"
                ormtype="string"
                length="50";

    property name="modelId"
                ormtype="string"
                length="50";
    
    property name="modelMemento"
                ormtype="string"
                length="4000";
    
    property name="createdTime"  
                ormtype="timestamp";

    public any function restore() {
        return populator.populateFromStruct(
            target = entityNew( getModelName() ),
            memento = getModelMemento(),
            ignoreEmpty = true,
            composeRelationships = true
        );
    }

    public Version function setModelMemento( memento ) {
        if( ! isSimpleValue( memento ) ){
            memento = serializeJSON( memento );
        }

        variables.modelMemento = memento;

        return this;
    }

    public any function getModelMemento() {
        if ( isJSON( variables.modelMemento ) ) {
            return deserializeJSON( variables.modelMemento );
        }
        return variables.modelMemento;
    }
}