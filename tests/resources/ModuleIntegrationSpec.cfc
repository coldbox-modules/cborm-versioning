component extends="coldbox.system.testing.BaseTestCase" {
    this.loadColdbox=true;
    this.unloadColdbox=false;
    /**
    * @beforeAll
    */
    function registerModuleUnderTest() {
        getController().getModuleService()
            .registerAndActivateModule( "cborm-versioning", "testingModuleRoot" );
    }

    /**
    * @beforeEach
    */
    function setupIntegrationTest() {
        setup();
    }

}