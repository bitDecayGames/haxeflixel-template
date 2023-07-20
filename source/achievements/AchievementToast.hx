package achievements;

import flixel.tweens.FlxTween;
import flixel.text.FlxText;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.FlxSprite;

import achievements.Achievements;
import achievements.Achievements.AchievementDef;

class AchievementToast extends FlxTypedSpriteGroup<FlxSprite> {
	private static var TIME_TO_TRANSITION:Float = .25;
	private static var TIME_TO_VIEW:Float = 7;

	private static var TITLE_TEXT_SIZE:Int = 18;
	private static var DESCRIPTION_TEXT_SIZE:Int = 15;
	private static var PADDING:Float = 10;
	private static var TEXT_COLOR:FlxColor = 0x5b4f37;
	private static var ICON_SIZE:Int = 70;
	private static var DIM_COLOR:FlxColor = 0x99aeaeae;

	private var title:FlxText;
	private var description:FlxText;
	private var background:FlxSprite;
	private var icon:FlxSprite;
	private var tint:FlxSprite;
	private var TOAST_X:Float;
	private var TOAST_Y:Float;
	private var def:AchievementDef;

	public function new(def:AchievementDef) {
		super();
		this.def = def;

		background = new FlxSprite(0, 0, AssetPaths.achievement_background__png);
		add(background);
		background.setPosition(0, 0);

		TOAST_X = FlxG.width - background.width - PADDING;
		TOAST_Y = FlxG.height + background.height;

		icon = new FlxSprite(0, 0);
		icon.loadGraphic(AssetPaths.achievement_icons__png, true, ICON_SIZE, ICON_SIZE);
		icon.animation.add("default", [def.iconIndex]);
		icon.animation.play("default");
		add(icon);
		icon.setPosition(PADDING, PADDING);

		var startTextX = PADDING * 2 + icon.width;
		title = new FlxText(0, 0, background.width - startTextX, def.title, TITLE_TEXT_SIZE);
		title.color = TEXT_COLOR;
		add(title);
		title.setPosition(startTextX, PADDING);

		description = new FlxText(0, 0, background.width - startTextX, def.description, DESCRIPTION_TEXT_SIZE);
		description.color = TEXT_COLOR;
		add(description);
		description.setPosition(startTextX, title.height + PADDING);

		x = TOAST_X;
		y = TOAST_Y;
	}

	public function show(num:Int):AchievementToast {
		var targetHeight = FlxG.height - background.height * num;
		var _in = FlxTween.linearMotion(this, TOAST_X, TOAST_Y, TOAST_X, targetHeight, TIME_TO_TRANSITION);
		_in.onComplete = waitThenClose;
		return this;
	}

	private function waitThenClose(_:FlxTween) {
		var _wait = FlxTween.linearMotion(this, TOAST_X, y, TOAST_X, y, TIME_TO_VIEW);
		_wait.onComplete = (_) -> {
			Achievements.ACHIEVEMENTS_DISPLAYED--;
			var _out = FlxTween.linearMotion(this, TOAST_X, y, TOAST_X, TOAST_Y, TIME_TO_TRANSITION);
			_out.onComplete = (_) -> {
				this.kill();
			}
		};
	}

	public function dim():AchievementToast {
		tint = new FlxSprite(x, y);
		tint.makeGraphic(background.graphic.width, background.graphic.height, DIM_COLOR);
		add(tint);
		tint.setPosition(x, y);
		return this;
	}
}
