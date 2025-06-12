package states;
 
import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.group.FlxGroup;
import flixel.FlxSprite;
import flixel.input.keyboard.FlxKeyboard;
import flixel.input.keyboard.FlxKey;
import openfl.events.Event;
import openfl.Lib;

class TitleState extends FlxState {
    private var titleText:FlxText;
    private var subtitleText:FlxText;
    private var pressStartText:FlxText;
    private var logo:FlxSprite;
    private var timer:Float = 0;
    private var blink:Boolean = true;

    override public function create():Void {
        super.create();

        // Background color
        FlxG.bgColor = 0xFF1a1a1a;

        // Logo sprite (assumed assets/images/logo.png)
        logo = new FlxSprite(FlxG.width / 2 - 150, FlxG.height / 4);
        logo.loadGraphic("images/logo.png", true, false, 300, 150);
        add(logo);

        // Title Text
        titleText = new FlxText(0, FlxG.height / 2 + 50, FlxG.width, "Funkin Super Advanced");
        titleText.setFormat(null, 48, 0xFFFFFFFF, "center");
        add(titleText);

        // Subtitle Text
        subtitleText = new FlxText(0, FlxG.height / 2 + 110, FlxG.width, "Made by HenryCodesFnF");
        subtitleText.setFormat(null, 20, 0xFFAAAAAA, "center");
        add(subtitleText);

        // Press Start Text
        pressStartText = new FlxText(0, FlxG.height - 100, FlxG.width, "Press Enter to Start");
        pressStartText.setFormat(null, 24, 0xFFFFFFFF, "center");
        add(pressStartText);

        // Setup keyboard input listener for start
        Lib.current.stage.addEventListener(Event.ENTER_FRAME, updateLogic);
    }

    private function updateLogic(event:Event):Void {
        timer += FlxG.elapsed;
        if (timer >= 0.5) {
            blink = !blink;
            pressStartText.alpha = blink ? 1 : 0.25;
            timer = 0;
        }

        if (FlxG.keys.justPressed.ENTER) {
            Lib.current.stage.removeEventListener(Event.ENTER_FRAME, updateLogic);
            FlxG.sound.stopMusic();
            FlxG.switchState(new funkin.ui.mainmenu.MainMenuState());
        }
    }

    override public function destroy():Void {
        Lib.current.stage.removeEventListener(Event.ENTER_FRAME, updateLogic);
        super.destroy();
    }
}
