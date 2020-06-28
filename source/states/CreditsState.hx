package states;

import haxefmod.flixel.FmodFlxUtilities;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.addons.ui.FlxUIState;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import components.BitDecayHelpers;

class CreditsState extends FlxUIState {
    var _btnMainMenu:FlxButton;

    var _txtCredits:FlxText;

    override public function create():Void {
        super.create();
        bgColor = FlxColor.TRANSPARENT;

        _txtCredits = new FlxText();
        _txtCredits.setPosition(FlxG.width/2, FlxG.height/4);
        _txtCredits.size = 40;
        _txtCredits.alignment = FlxTextAlign.CENTER;
        _txtCredits.text = "Credits";
        
        add(_txtCredits);

        _btnMainMenu = BitDecayHelpers.CreateMenuButton("Main Menu", clickMainMenu);
        _btnMainMenu.setPosition(FlxG.width - _btnMainMenu.width, FlxG.height - _btnMainMenu.height);
        _btnMainMenu.updateHitbox();
        add(_btnMainMenu);
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);

        _txtCredits.x = FlxG.width/2 - _txtCredits.width/2;
    }

    function clickMainMenu():Void {
        FmodFlxUtilities.TransitionToState(new MainMenuState());
    }
}