package behavior;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.math.FlxPoint;
import bitdecay.behavior.tree.BTContext;
import bitdecay.behavior.tree.NodeStatus;
import bitdecay.behavior.tree.leaf.LeafNode;

class CloseToMouse extends LeafNode {
    public function new() {}

    override public function doProcess(delta:Float):NodeStatus {
		if (context.has("self")) {
			var self:FlxSprite = context.get("self");
			var mpos = FlxG.mouse.getPosition();
			if (mpos.distanceTo(self.getMidpoint()) < 100) {
				trace("close to mouse triggered!");
				return SUCCESS;
			}
		} else {
			trace('no self to measure against');
		}

        return FAIL;
    }
}