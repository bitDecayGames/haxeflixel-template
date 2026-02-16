package ui;

import FmodEnums.FmodSFXE;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;

using FmodEnums;

class MenuBuilder {
	/**
	 * Creates a simple button with a label, a callback, and a SFX on click
	 *
	 * @param   Text           The text to display on the button
	 * @param   cb             Function to be called when the button is clicked
	 * @param   clickSFX Optional SFX to play when the button is clicked
	 * @param   hoverSFX Optional SFX to play when the button is hovered
	 */
	public static function createTextButton(Text:String, cb:Void->Void, ?clickSFX:FmodSFXE = MenuSelect, ?hoverSFX:FmodSFXE = MenuHover):FlxButton {
		var button = new FlxButton(0, 0, Text);
		button.allowSwiping = false;
		button.onOver.callback = function() {
			if (hoverSFX != null) {
				FmodManager.PlaySoundOneShot(hoverSFX.path());
			}
			button.color = FlxColor.GRAY;
		};
		button.onOut.callback = function() {
			button.color = FlxColor.WHITE;
		};
		button.onUp.callback = function() {
			if (clickSFX != null) {
				FmodManager.PlaySoundOneShot(clickSFX.path());
			}
			cb();
		};

		return button;
	}
}
