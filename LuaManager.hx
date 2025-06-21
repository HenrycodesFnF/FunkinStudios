// File: LuaManager.hx (or LuaManager.hua if your build system handles it)

class LuaManager {
    // Store Lua script strings
    private var luaScripts:Map<String, String>;

    public function new() {
        luaScripts = new Map();
    }

    // Add a Lua script by name
    public function addScript(name:String, script:String):Void {
        luaScripts.set(name, script);
    }

    // Get a Lua script by name
    public function getScript(name:String):Null<String> {
        return luaScripts.get(name);
    }

    // Execute a Lua script by name using untyped Lua interop
    public function executeScript(name:String):Void {
        var script = luaScripts.get(name);
        if (script != null) {
            try {
                untyped __lua__(script);
            } catch (e:Dynamic) {
                trace('Error executing Lua script: $name\n$e');
            }
        } else {
            trace('Script not found: $name');
        }
    }

    // List all stored Lua scripts
    public function listScripts():Array<String> {
        return [for (key in luaScripts.keys()) key];
    }
}
