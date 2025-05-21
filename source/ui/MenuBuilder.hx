package ui;

import FmodConstants.FmodSFX;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;

class MenuBuilder {
	/**
	 * Creates a simple button with a label, a callback, and a SFX on click
	 *
	 * @param   Text           The text to display on the button
	 * @param   Callback       Function to be called when the button is clicked
	 * @param   ClickSoundPath Optional custom SFX to play when the button is clicked
	 */
	public static function createTextButton(Text:String, Callback:Void->Void, ?ClickSoundPath:FmodSFX = MenuSelect):FlxButton {
		var button = new FlxButton(0, 0, Text);
		button.allowSwiping = false;
		button.onOver.callback = function() {
			FmodManager.PlaySoundOneShot(Fmod.sfx(MenuHover));
			button.color = FlxColor.GRAY;
		};
		button.onOut.callback = function() {
			button.color = FlxColor.WHITE;
		};
		button.onUp.callback = function() {
			FmodManager.PlaySoundOneShot(Fmod.sfx(ClickSoundPath));
			Callback();
		};

		return button;
	}
}
