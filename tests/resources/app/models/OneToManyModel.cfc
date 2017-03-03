component persistent="true" accessors="true" {
    property name="id" fieldtype="id";
    property name="propertyA";
    property name="relationshipA" fieldtype="one-to-many" cfc="ManyToOneModel" type="array" fkcolumn="oneToManyId";
}