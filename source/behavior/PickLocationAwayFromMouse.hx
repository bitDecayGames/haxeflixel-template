package behavior;

import flixel.math.FlxVector;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.math.FlxPoint;
import bitdecay.behavior.tree.BTContext;
import bitdecay.behavior.tree.NodeStatus;
import bitdecay.behavior.tree.leaf.LeafNode;

class PickLocationAwayFromMouse extends LeafNode {
	var target:FlxPoint;

    public function new() {}

    override public function doProcess(delta:Float):NodeStatus {
		if (context.has("self")) {
			var self:FlxSprite = context.get("self");
			var dir = FlxG.mouse.getPosition().subtractPoint(self.getMidpoint()).normalize().scale(-1);

			target = FlxPoint.get(FlxG.mouse.x, FlxG.mouse.y).addPoint(dir.scale(200));
			context.set("target", target);
			return SUCCESS;
		}

		return FAIL;
    }
}