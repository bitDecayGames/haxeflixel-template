package events.derivers;

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
			EventBus.fire(new SpeedClick(timing));
		}

		lastClick = FlxG.game.ticks;
	}

	public function init() {
		EventBus.subscribe(Click, handleClick);
	}

	public function destroy() {
		EventBus.unsubscribe(Click, handleClick);
	}
}
