component {
    
    this.name = "cborm-versioning";
    this.author = "Eric Peterson";
    this.webUrl = "https://github.com/elpete/cborm-versioning";
    this.dependencies = [ "cborm" ];

    function configure() {
        interceptors = [
            { class = "#moduleMapping#.models.Versioner" }
        ];
    }
}