component persistent="true" accessors="true" {
    property name="id" fieldtype="id";
    property name="propertyB";
    property name="relationshipB" fieldtype="many-to-one" cfc="OneToManyModel" fkcolumn="oneToManyId";
}