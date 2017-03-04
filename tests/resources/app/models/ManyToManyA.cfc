component persistent="true" accessors="true" {
    property name="id" fieldtype="id";
    property name="propertyA";
    property name="relationshipA" fieldtype="many-to-many" cfc="ManyToManyB" linktable="many_to_many" fkcolumn="a_id" type="array";
}