component persistent="true" accessors="true" {
    property name="id" fieldtype="id";
    property name="propertyA";
    property name="relationshipA" fieldtype="many-to-many" cfc="ManyToManyA" linktable="many_to_many" fkcolumn="b_id" type="array";
}