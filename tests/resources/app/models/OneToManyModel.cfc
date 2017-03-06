component persistent="true" accessors="true" table="one_to_many" {
    property name="id" fieldtype="id";
    property name="propertyA";
    property name="relationshipA" fieldtype="one-to-many" cfc="ManyToOneModel" type="array" fkcolumn="oneToManyId" inverse="true";
}