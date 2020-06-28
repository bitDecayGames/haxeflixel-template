package helpers;

import flixel.ui.FlxButton;
import flixel.util.FlxColor;

class UiHelpers {
    public static function CreateMenuButton(Text:String, Callback:Void->Void, ?ClickSoundPath:String = FmodSFX.MenuSelect):FlxButton {
    
        var button = new FlxButton(0, 0, Text);
        button.allowSwiping = false;
        button.onOver.callback = function () {
            FmodManager.PlaySoundOneShot(FmodSFX.MenuHover);
            button.color = FlxColor.GRAY;
        };
        button.onOut.callback = function () {
            button.color = FlxColor.WHITE;
        };
        button.onUp.callback = function () {
            FmodManager.PlaySoundOneShot(ClickSoundPath);
            Callback();
        };

        return button;
    }
}