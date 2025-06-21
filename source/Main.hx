package;

import flixel.FlxGame;
import flixel.FlxState;
import haxe.Json;
import haxe.io.Path;
import openfl.Assets;
import openfl.Lib;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.display.StageScaleMode;

import debug.FPSCounter;
import states.TitleState;

// Configuration structure
typedef GameConfig = {
	public var width:Int;
	public var height:Int;
	public var initialState:Class<FlxState>;
	public var framerate:Int;
	public var skipSplash:Bool;
	public var startFullscreen:Bool;
}

// Defaults for the engine
class DefaultConfig {
	public static inline var width:Int = 1280;
	public static inline var height:Int = 720;
	public static inline var initialState:Class<FlxState> = TitleState;
	public static inline var framerate:Int = 60;
	public static inline var skipSplash:Bool = true;
	public static inline var startFullscreen:Bool = false;
}

// Entry point
class Main extends Sprite {
	public static var config:GameConfig;
	public static var fpsCounter:FPSCounter;

	public static function main():Void {
		Lib.current.addChild(new Main());
	}

	public function new() {
		super();

		// Apply basic stage config
		stage.scaleMode = StageScaleMode.NO_SCALE;

		// Load configuration before initializing
		loadConfig();

		addEventListener(Event.ADDED_TO_STAGE, init);
	}

	/**
	 * Loads the config from assets/config.json or applies defaults.
	 */
	function loadConfig():Void {
		var configPath = "assets/config.json";
		if (Assets.exists(configPath)) {
			try {
				var json = Assets.getText(configPath);
				var parsed = Json.parse(json);

				config = {
					width: parsed.width ?? DefaultConfig.width,
					height: parsed.height ?? DefaultConfig.height,
					initialState: Type.resolveClass(parsed.initialState) != null
						? cast Type.resolveClass(parsed.initialState)
						: DefaultConfig.initialState,
					framerate: parsed.framerate ?? DefaultConfig.framerate,
					skipSplash: parsed.skipSplash ?? DefaultConfig.skipSplash,
					startFullscreen: parsed.startFullscreen ?? DefaultConfig.startFullscreen
				};
			} catch (e) {
				trace('[ERROR] Failed to parse config.json: ' + e);
				applyDefaultConfig();
			}
		} else {
			applyDefaultConfig();
		}
	}

	inline function applyDefaultConfig():Void {
		config = {
			width: DefaultConfig.width,
			height: DefaultConfig.height,
			initialState: DefaultConfig.initialState,
			framerate: DefaultConfig.framerate,
			skipSplash: DefaultConfig.skipSplash,
			startFullscreen: DefaultConfig.startFullscreen
		};
	}

	/**
	 * Initialization after stage is ready.
	 */
	function init(e:Event):Void {
		removeEventListener(Event.ADDED_TO_STAGE, init);

		// Call mod hook if present
		#if mod_init
		ModHooks.onMainInit();
		#end

		// Launch FlxGame
		addChild(new FlxGame(
			config.width,
			config.height,
			config.initialState,
			config.framerate,
			config.skipSplash,
			config.startFullscreen
		));
	}
}
