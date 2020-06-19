package states;

import flixel.FlxG;
import flixel.addons.ui.FlxUIState;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;

class MainMenuState extends FlxUIState {
    var _btnPlay:FlxButton;
    var _btnTiles:FlxButton;
    var _btnEditor:FlxButton;
    var _btnDoob:FlxButton;

    override public function create():Void {
        super.create();
        FlxG.log.notice("loaded scene");
        bgColor = FlxColor.TRANSPARENT;

        _btnPlay = new FlxButton(0, 0, "Play", clickPlay);
        _btnPlay.updateHitbox();
        _btnPlay.screenCenter();
        add(_btnPlay);
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);
    }

    function clickPlay():Void {
        FmodManager.PlaySoundOneShot(FmodSFX.MenuSelect);
        FlxG.switchState(new MainMenuState());
    }
}