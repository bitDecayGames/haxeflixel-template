package behavior;

import flixel.util.FlxColor;
import bitdecay.flixel.debug.DebugDraw;
import flixel.math.FlxVector;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.math.FlxPoint;
import bitdecay.behavior.tree.BTContext;
import bitdecay.behavior.tree.NodeStatus;
import bitdecay.behavior.tree.leaf.LeafNode;

class MoveToLocation extends LeafNode {
	var target:FlxPoint;

    public function new() {}

	override function init(context:BTContext) {
		super.init(context);
		if (context.has("target")) {
			target = context.get("target");
		} else {
			trace('target required for MoveToLocation');
		}
	}

    override public function doProcess(delta:Float):NodeStatus {
		if (context.has("self") && target != null) {
			var self:FlxSprite = context.get("self");
			if (self.getMidpoint().distanceTo(target) < 3) {
				trace("move to location complete!");
				self.velocity.set();
				return SUCCESS;
			}

			var dir = target.copyTo().subtractPoint(self.getMidpoint()).normalize();
			self.velocity.copyFrom(dir.scale(100));
			DebugDraw.ME.drawWorldCircle(target.x, target.y, 5, null, FlxColor.GREEN);
			return RUNNING;
		} else {
			trace('require both self and target');
		}
        return FAIL;
    }
}