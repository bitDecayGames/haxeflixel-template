package behavior;

import flixel.FlxG;
import flixel.math.FlxPoint;
import bitdecay.behavior.tree.BTContext;
import bitdecay.behavior.tree.NodeStatus;
import bitdecay.behavior.tree.leaf.LeafNode;

class PickRandomLocation extends LeafNode {
    public function new() {}

    override public function doProcess(delta:Float):NodeStatus {
		context.set("target", FlxPoint.get(FlxG.random.float(0, FlxG.width), FlxG.random.float(0, FlxG.height)));
        return SUCCESS;
    }
}