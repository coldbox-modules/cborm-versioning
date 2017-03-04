component
    accessors="true"
    persistent="true"
    table="cborm_versions"
    extends="cborm.models.ActiveEntity"
{
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
}