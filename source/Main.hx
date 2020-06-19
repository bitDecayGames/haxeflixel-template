package;

import flixel.util.FlxColor;
import flixel.addons.transition.TransitionData;
import flixel.addons.transition.FlxTransitionableState;
import flixel.FlxG;
import flixel.FlxGame;
import openfl.display.Sprite;
import states.LoadFmodState;

class Main extends Sprite
{
	public function new()
	{
		super();
		FlxG.fixedTimestep = false;
		FlxTransitionableState.defaultTransIn = new TransitionData(FADE, FlxColor.BLACK, 0.35);
		FlxTransitionableState.defaultTransOut = new TransitionData(FADE, FlxColor.BLACK, 0.35);
		addChild(new FlxGame(0, 0, LoadFmodState, 1, 60, 60, true, false));
	}
}
