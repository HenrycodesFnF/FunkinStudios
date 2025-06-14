package;

import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.EventDispatcher;
import openfl.Lib;
import openfl.utils.AssetLibrary;
import openfl.utils.AssetCache;
import openfl.Assets;
import openfl.display.StageAlign;
import openfl.display.StageScaleMode;
import haxe.Log;
import haxe.Timer;
import sys.thread.Thread;
import sys.thread.Mutex;
import sys.thread.Event as ThreadEvent;

import openfl.media.Sound;
import openfl.net.URLLoader;
import openfl.net.URLRequest;

typedef InitCallback = Void -> Void;

/**
 * Main entry point for the game application.
 * Implements a robust, modular startup process with async loading, error handling, and event-driven lifecycle.
 */
class Main extends Sprite {

    // Singleton instance for global access
    public static var instance:Main;

    // Initialization state tracking
    private var _initialized:Bool = false;
    private var _resourcesLoaded:Bool = false;

    // Logger verbosity: 0=none,1=error,2=warning,3=info,4=debug
    public static inline var LOG_LEVEL:Int = 4;

    // Custom event dispatcher for app lifecycle events
    public var events:EventDispatcher;

    // Example subsystems (simplified)
    public var audioManager:AudioManager;
    public var inputManager:InputManager;
    public var networkManager:NetworkManager;

    // Loading progress tracker
    private var _loadingProgress:Float = 0.0;

    // Mutex for thread safety (if multithreading is used)
    private var _mutex:Mutex;

    public function new() {
        super();

        instance = this;
        events = new EventDispatcher();
        _mutex = new Mutex();

        configureStage();

        log("Main constructor called", 4);

        // Start async init process
        initialize(initComplete);
    }

    /**
     * Configures the stage with recommended settings for pixel-perfect rendering.
     */
    private function configureStage():Void {
        stage.align = StageAlign.TOP_LEFT;
        stage.scaleMode = StageScaleMode.NO_SCALE;
        stage.color = 0x000000;
    }

    /**
     * Entry point for async initialization.
     * Loads config, assets, and subsystems, then calls the callback.
     */
    public function initialize(onComplete:InitCallback):Void {
        log("Initializing subsystems...", 3);

        try {
            // Initialize subsystems synchronously or async if needed
            audioManager = new AudioManager();
            inputManager = new InputManager(stage);
            networkManager = new NetworkManager();

            // Simulate async resource loading (replace with actual)
            loadResources(() -> {
                _resourcesLoaded = true;
                log("Resources loaded successfully", 3);
                _initialized = true;
                onComplete();
                events.dispatchEvent(new Event("initialized"));
            });

        } catch (error:Dynamic) {
            log("Initialization error: " + Std.string(error), 1);
            // Fallback or shutdown
            showFatalError("Initialization failed: " + Std.string(error));
        }
    }

    /**
     * Simulate async resource loading with progress updates.
     * Replace this with real asset loading using AssetLibrary or similar.
     */
    private function loadResources(onComplete:Void->Void):Void {
        log("Starting resource loading...", 3);

        // For demo, load 5 assets asynchronously
        var totalAssets = 5;
        var loadedAssets = 0;

        for (i in 0...totalAssets) {
            // Simulate async load with timer
            Timer.delay(() -> {
                loadedAssets++;
                _loadingProgress = loadedAssets / totalAssets;
                events.dispatchEvent(new LoadingProgressEvent(_loadingProgress));

                log('Loaded asset ' + loadedAssets + ' of ' + totalAssets, 4);

                if (loadedAssets == totalAssets) {
                    onComplete();
                }
            }, 300 * i);
        }
    }

    /**
     * Called when initialization completes, starts main game loop.
     */
    private function initComplete():Void {
        log("Initialization complete. Starting main game loop...", 3);

        // Setup main loop
        addEventListener(Event.ENTER_FRAME, onEnterFrame);

        // Dispatch event for listeners
        events.dispatchEvent(new Event("gameStarted"));
    }

    /**
     * Main game loop tick.
     */
    private function onEnterFrame(event:Event):Void {
        if (!_initialized) return;

        // Process input
        inputManager.update();

        // Update game logic here, e.g.:
        // StateManager.instance.update();

        // Update audio subsystem if needed
        audioManager.update();

        // Render updates are automatic in OpenFL

        // Example logging every second (avoid spamming logs)
        if (Timer.stamp() % 1 < 0.016) {
            log("Main loop tick at " + Timer.stamp(), 4);
        }
    }

    /**
     * Logs messages based on verbosity level.
     */
    public static function log(message:String, level:Int = 3):Void {
        if (level <= LOG_LEVEL) {
            switch (level) {
                case 1: haxe.Log.trace("[ERROR] " + message, { fileName: "Main.hx" }); break;
                case 2: haxe.Log.trace("[WARN] " + message, { fileName: "Main.hx" }); break;
                case 3: haxe.Log.trace("[INFO] " + message, { fileName: "Main.hx" }); break;
                case 4: haxe.Log.trace("[DEBUG] " + message, { fileName: "Main.hx" }); break;
                default: haxe.Log.trace("[LOG] " + message, { fileName: "Main.hx" });
            }
        }
    }

    /**
     * Displays a fatal error message and halts the app.
     */
    private function showFatalError(message:String):Void {
        log("Fatal Error: " + message, 1);
        // For now, just throw an error to halt execution
        throw "Fatal Error: " + message;
    }
}

/**
 * Stub class for audio management.
 */
class AudioManager {
    public function new() {
        Main.log("AudioManager initialized", 3);
    }
    public function update():Void {
        // Update audio system (placeholder)
    }
}

/**
 * Stub class for input management.
 */
class InputManager {
    private var _stage:openfl.display.Stage;

    public function new(stage:openfl.display.Stage) {
        _stage = stage;
        Main.log("InputManager initialized", 3);
    }

    public function update():Void {
        // Poll input states, update controllers, etc.
    }
}

/**
 * Stub class for network management.
 */
class NetworkManager {
    public function new() {
        Main.log("NetworkManager initialized", 3);
    }
}

/**
 * Custom loading progress event.
 */
class LoadingProgressEvent extends Event {
    public var progress:Float;

    public function new(progress:Float) {
        super("loadingProgress");
        this.progress = progress;
    }
}