component persistent="true" accessors="true" {
    property name="id" fieldtype="id";
    property name="propertyA";
    property name="relationshipB" fieldtype="many-to-one" cfc="OneToManyModel" fkcolumn="oneToManyId";
}