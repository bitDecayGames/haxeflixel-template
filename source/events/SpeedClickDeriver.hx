package events;

import events.gen.Event.SpeedClick;
import flixel.FlxG;
import events.gen.Event.Click;

class SpeedClickDeriver implements EventDeriver {
	var threshold:Int = 0;
	var lastClick:Int = 0;

	public function new(thresholdMS:Int) {
		this.threshold = thresholdMS;
	}

	function handleClick(e:Click) {
		var timing = FlxG.game.ticks - lastClick;
		if (timing <= threshold) {
			GameEvents.fire(new SpeedClick(timing));
		}

		lastClick = FlxG.game.ticks;
	}

	public function init() {
		GameEvents.subscribe(Click, handleClick);
	}

	public function destroy() {
		GameEvents.unsubscribe(Click, handleClick);
	}
}
