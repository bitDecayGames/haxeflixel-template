package states;

import config.Configure;
import flixel.FlxSprite;
import haxefmod.flixel.FmodFlxUtilities;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.addons.ui.FlxUIState;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
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

	override public function create():Void {
		super.create();
		bgColor = FlxColor.TRANSPARENT;

		// Button

		_btnMainMenu = UiHelpers.createMenuButton("Main Menu", clickMainMenu);
		_btnMainMenu.setPosition(FlxG.width - _btnMainMenu.width, FlxG.height - _btnMainMenu.height);
		_btnMainMenu.updateHitbox();
		add(_btnMainMenu);

		// Credits

		_allCreditElements = new Array<FlxSprite>();

		_txtCreditsTitle = FlxTextFactory.make("Credits", FlxG.width / 2 - _txtCreditsTitle.width / 2, FlxG.height / 2, 40);
		_txtCreditsTitle.alignment = FlxTextAlign.CENTER;
		add(_txtCreditsTitle);

		_txtRole = new Array<FlxText>();
		_txtCreator = new Array<FlxText>();

		_allCreditElements.push(_txtCreditsTitle);

		for (entry in Configure.getCredits()) {
			AddSectionToCreditsTextArrays(entry.sectionName, entry.names, _txtRole, _txtCreator);
		}

		var creditsTextVerticalOffset = FlxG.height;

		for (flxText in _txtRole) {
			flxText.setPosition(0, creditsTextVerticalOffset);
			creditsTextVerticalOffset += 25;
		}

		creditsTextVerticalOffset = FlxG.height;

		for (flxText in _txtCreator) {
			flxText.setPosition(FlxG.width - 250, creditsTextVerticalOffset);
			creditsTextVerticalOffset += 25;
		}

		var flStudioLogo = new FlxSprite();
		flStudioLogo.loadGraphic(AssetPaths.FLStudioLogo__png);
		flStudioLogo.scale.set(.25, .25);
		flStudioLogo.updateHitbox();
		flStudioLogo.setPosition(-35, creditsTextVerticalOffset);
		add(flStudioLogo);
		_allCreditElements.push(flStudioLogo);

		var fmodLogo = new FlxSprite();
		fmodLogo.loadGraphic(AssetPaths.FmodLogoWhite__png);
		fmodLogo.scale.set(.4, .4);
		fmodLogo.updateHitbox();
		fmodLogo.setPosition(5, creditsTextVerticalOffset + flStudioLogo.height);
		add(fmodLogo);
		_allCreditElements.push(fmodLogo);

		var haxeFlixelLogo = new FlxSprite();
		haxeFlixelLogo.loadGraphic(AssetPaths.HaxeFlixelLogo__png);
		haxeFlixelLogo.scale.set(.5, .5);
		haxeFlixelLogo.updateHitbox();
		haxeFlixelLogo.setPosition(fmodLogo.width + 40, creditsTextVerticalOffset + flStudioLogo.height + 10);
		add(haxeFlixelLogo);
		_allCreditElements.push(haxeFlixelLogo);

		_txtThankYou = FlxTextFactory.make("Thank you!", FlxG.width / 2 - _txtThankYou.width / 2, haxeFlixelLogo.y + 400, 40);
		_txtThankYou.alignment = FlxTextAlign.CENTER;
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

			var creatorText = FlxTextFactory.make(creator, 0, 0, 15);
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
