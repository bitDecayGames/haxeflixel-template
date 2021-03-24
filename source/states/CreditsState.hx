package states;

import config.Configure;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.ui.FlxUIState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import haxefmod.flixel.FmodFlxUtilities;
import helpers.UiHelpers;
import misc.FlxTextFactory;

using extensions.FlxStateExt;

class CreditsState extends FlxUIState {
	var _allCreditElements:Array<FlxSprite>;

	var _btnMainMenu:FlxButton;

	var _txtCreditsTitle:FlxText;
	var _txtThankYou:FlxText;
	var _txtRole:Array<FlxText>;
	var _txtCreator:Array<FlxText>;

	// Quick appearance variables
	private var backgroundColor = FlxColor.BLACK;

	static inline var entryLeftMargin = 50;
	static inline var entryRightMargin = 50;
	static inline var entryVerticalSpacing = 25;

	var toolingImages = [
		AssetPaths.FLStudioLogo__png,
		AssetPaths.FmodLogoWhite__png,
		AssetPaths.HaxeFlixelLogo__png,
		AssetPaths.pyxel_edit__png
	];

	override public function create():Void {
		super.create();
		bgColor = backgroundColor;
		camera.pixelPerfectRender = true;

		// Button

		_btnMainMenu = UiHelpers.createMenuButton("Main Menu", clickMainMenu);
		_btnMainMenu.setPosition(FlxG.width - _btnMainMenu.width, FlxG.height - _btnMainMenu.height);
		_btnMainMenu.updateHitbox();
		add(_btnMainMenu);

		// Credits

		_allCreditElements = new Array<FlxSprite>();

		_txtCreditsTitle = FlxTextFactory.make("Credits", FlxG.width / 4, FlxG.height / 2, 40, FlxTextAlign.CENTER);
		center(_txtCreditsTitle);
		add(_txtCreditsTitle);

		_txtRole = new Array<FlxText>();
		_txtCreator = new Array<FlxText>();

		_allCreditElements.push(_txtCreditsTitle);

		for (entry in Configure.getCredits()) {
			AddSectionToCreditsTextArrays(entry.sectionName, entry.names, _txtRole, _txtCreator);
		}

		var creditsVerticalOffset = FlxG.height;

		for (flxText in _txtRole) {
			flxText.setPosition(entryLeftMargin, creditsVerticalOffset);
			creditsVerticalOffset += entryVerticalSpacing;
		}

		creditsVerticalOffset = FlxG.height;

		for (flxText in _txtCreator) {
			flxText.setPosition(FlxG.width - flxText.width - entryRightMargin, creditsVerticalOffset);
			creditsVerticalOffset += entryVerticalSpacing;
		}

		for (toolImg in toolingImages) {
			var display = new FlxSprite();
			display.loadGraphic(toolImg);
			// scale them to be about 1/4 of the height of the screen
			var scale = (FlxG.height / 4) / display.height;
			if (display.width * scale > FlxG.width) {
				// in case that's too wide, adjust accordingly
				scale = FlxG.width / display.width;
			}
			display.scale.set(scale, scale);
			display.updateHitbox();
			display.setPosition(0, creditsVerticalOffset);
			center(display);
			add(display);
			creditsVerticalOffset += Math.ceil(display.height) + entryVerticalSpacing;
			_allCreditElements.push(display);
		}

		_txtThankYou = FlxTextFactory.make("Thank you!", FlxG.width / 2, creditsVerticalOffset + FlxG.height / 2, 40, FlxTextAlign.CENTER);
		_txtThankYou.alignment = FlxTextAlign.CENTER;
		center(_txtThankYou);
		add(_txtThankYou);
		_allCreditElements.push(_txtThankYou);
	}

	private function AddSectionToCreditsTextArrays(role:String, creators:Array<String>, finalRoleArray:Array<FlxText>, finalCreatorsArray:Array<FlxText>) {
		var roleText = FlxTextFactory.make(role, 0, 0, 15);
		add(roleText);
		finalRoleArray.push(roleText);
		_allCreditElements.push(roleText);

		if (finalCreatorsArray.length != 0) {
			finalCreatorsArray.push(new FlxText());
		}

		for (creator in creators) {
			// Make an offset entry for the roles array
			finalRoleArray.push(new FlxText());

			var creatorText = FlxTextFactory.make(creator, 0, 0, 15, FlxTextAlign.RIGHT);
			add(creatorText);
			finalCreatorsArray.push(creatorText);
			_allCreditElements.push(creatorText);
		}
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);

		// Stop scrolling when "Thank You" text is in the center of the screen
		if (_txtThankYou.y + _txtThankYou.height / 2 < FlxG.height / 2) {
			return;
		}

		for (element in _allCreditElements) {
			if (FlxG.keys.pressed.SPACE || FlxG.mouse.pressed) {
				element.y -= 2;
			} else {
				element.y -= .5;
			}
		}
	}

	private function center(o:FlxObject) {
		o.x = (FlxG.width - o.width) / 2;
	}

	function clickMainMenu():Void {
		FmodFlxUtilities.TransitionToState(new MainMenuState());
	}

	override public function onFocusLost() {
		super.onFocusLost();
		this.handleFocusLost();
	}

	override public function onFocus() {
		super.onFocus();
		this.handleFocus();
	}
}

/**
 * A section to be displayed in the credits screen.
 */
class CreditEntry {
	public var sectionName:String;
	public var names:Array<String>;

	public function new(section:String, names:Array<String>) {
		this.sectionName = section;
		this.names = names;
	}
}
