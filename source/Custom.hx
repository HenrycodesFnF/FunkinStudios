package;

typedef PermissionOptions = {
    var editSourceFiles:Bool;
    var editGithubPermissions:Bool;
    var editmods:Bool;
}

class Custom {
    public static var funkinstudios:PermissionOptions = {
        editSourceFiles: true,
        editGithubPermissions: true,
        editmods: true,
    };

    public static var mainStates:Map<String, Bool> = [
        "MenuState" => true,
        "PlayState" => true,
        "OptionsState" => true,
        "CreditsState" => true,
        "ResultsState" => true
    ];

    // Add or edit states
    public static function setState(state:String, enabled:Bool):Void {
        mainStates.set(state, enabled);
    }

    public static function isStateEnabled(state:String):Bool {
        return mainStates.exists(state) ? mainStates.get(state) : false;
    }
}