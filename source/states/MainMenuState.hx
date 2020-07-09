package states;

import haxefmod.flixel.FmodFlxUtilities;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.addons.ui.FlxUIState;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import helpers.UiHelpers;
import lime.system.System;

class MainMenuState extends FlxUIState {
    var _btnPlay:FlxButton;
    var _btnCredits:FlxButton;
    var _btnExit:FlxButton;

    var _txtTitle:FlxText;

    override public function create():Void {
        super.create();
        FmodManager.PlaySong(FmodSongs.LetsGo);
        FlxG.log.notice("loaded scene");
        bgColor = FlxColor.TRANSPARENT;

        _txtTitle = new FlxText();
        _txtTitle.setPosition(FlxG.width/2, FlxG.height/4);
        _txtTitle.size = 40;
        _txtTitle.alignment = FlxTextAlign.CENTER;
        _txtTitle.text = "Game Title";
        
        add(_txtTitle);

        _btnPlay = UiHelpers.CreateMenuButton("Play", clickPlay);
        _btnPlay.setPosition(FlxG.width/2 - _btnPlay.width/2, FlxG.height - _btnPlay.height - 100);
        _btnPlay.updateHitbox();
        add(_btnPlay);

        _btnCredits = UiHelpers.CreateMenuButton("Credits", clickCredits);
        _btnCredits.setPosition(FlxG.width/2 - _btnCredits.width/2, FlxG.height - _btnCredits.height - 70);
        _btnCredits.updateHitbox();
        add(_btnCredits);

        #if windows
        _btnExit = UiHelpers.CreateMenuButton("Exit", clickExit);
        _btnExit.setPosition(FlxG.width/2 - _btnExit.width/2, FlxG.height - _btnExit.height - 40);
        _btnExit.updateHitbox();
        add(_btnExit);
        #end
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);
        FmodManager.Update();

        _txtTitle.x = FlxG.width/2 - _txtTitle.width/2;
    }

    function clickPlay():Void {
        FmodFlxUtilities.TransitionToStateAndStopMusic(new VictoryState());
    }

    function clickCredits():Void {
        FmodFlxUtilities.TransitionToState(new CreditsState());
    }

    #if windows
    function clickExit():Void {
        System.exit(0);
    }
    #end
}