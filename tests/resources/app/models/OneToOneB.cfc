component persistent="true" accessors="true" {
    property name="id" fieldtype="id";
    property name="propertyA";
    property name="relationshipA" fieldtype="one-to-one" cfc="OneToOneA" fkcolumn="a_id";
}