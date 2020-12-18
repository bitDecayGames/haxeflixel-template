package states;

import haxefmod.flixel.FmodFlxUtilities;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.addons.ui.FlxUIState;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import helpers.UiHelpers;
import misc.FlxTextFactory;

#if windows
import lime.system.System;
#end

using extensions.FlxStateExt;

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
        FlxG.camera.pixelPerfectRender = true;

        _txtTitle = FlxTextFactory.make(
            "Game Title",
            FlxG.width/2,
            FlxG.height/4,
            40,
            FlxTextAlign.CENTER,
            FlxColor.WHITE);
        add(_txtTitle);

        _btnPlay = UiHelpers.createMenuButton("Play", clickPlay);
        _btnPlay.setPosition(FlxG.width/2 - _btnPlay.width/2, FlxG.height - _btnPlay.height - 100);
        _btnPlay.updateHitbox();
        add(_btnPlay);

        _btnCredits = UiHelpers.createMenuButton("Credits", clickCredits);
        _btnCredits.setPosition(FlxG.width/2 - _btnCredits.width/2, FlxG.height - _btnCredits.height - 70);
        _btnCredits.updateHitbox();
        add(_btnCredits);

        #if windows
        _btnExit = UiHelpers.createMenuButton("Exit", clickExit);
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

    override public function onFocusLost() {
        super.onFocusLost();
        this.handleFocusLost();
    }

    override public function onFocus() {
        super.onFocus();
        this.handleFocus();
    }
}