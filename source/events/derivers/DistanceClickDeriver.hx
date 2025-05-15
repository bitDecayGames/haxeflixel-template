package events.derivers;

import events.gen.Event.DistanceClick;
import flixel.math.FlxPoint;
import events.gen.Event.Click;

class DistanceClickDeriver implements EventDeriver {
	var threshold:Float = 0;
	var lastClick:FlxPoint = FlxPoint.get();

	var tmp = FlxPoint.get();

	public function new(thresholdDist:Int) {
		this.threshold = thresholdDist;
	}

	function handleClick(e:Click) {
		tmp.set(e.posX, e.posY);
		var dist = tmp.dist(lastClick);
		if (tmp.dist(lastClick) >= threshold) {
			EventBus.fire(new DistanceClick(dist));
		}

		lastClick.copyFrom(tmp);
	}

	public function init() {
		EventBus.subscribe(Click, handleClick);
	}

	public function destroy() {
		EventBus.unsubscribe(Click, handleClick);
	}
}
