package states;

import haxefmod.flixel.FmodFlxUtilities;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.addons.ui.FlxUIState;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import helpers.UiHelpers;

class VictoryState extends FlxUIState {
    var _btnDone:FlxButton;

    var _txtTitle:FlxText;

    override public function create():Void {
        super.create();
        bgColor = FlxColor.TRANSPARENT;

        _txtTitle = new FlxText();
        _txtTitle.setPosition(FlxG.width/2, FlxG.height/4);
        _txtTitle.size = 40;
        _txtTitle.alignment = FlxTextAlign.CENTER;
        _txtTitle.text = "Game Over";
        
        add(_txtTitle);

        _btnDone = UiHelpers.CreateMenuButton("Main Menu", clickMainMenu);
        _btnDone.setPosition(FlxG.width/2 - _btnDone.width/2, FlxG.height - _btnDone.height - 40);
        _btnDone.updateHitbox();
        add(_btnDone);
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);
        FmodManager.Update();

        _txtTitle.x = FlxG.width/2 - _txtTitle.width/2;
    }

    function clickMainMenu():Void {
		FmodFlxUtilities.TransitionToState(new MainMenuState());
    }
}