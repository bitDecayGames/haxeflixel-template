package ui;

import haxe.ui.containers.VBox;

@:build(haxe.ui.macros.ComponentMacros.build("assets/xml/main_menu.xml"))
class MainMenu extends VBox {
	public function new(playClicked:Void->Void, creditsClicked:Void->Void) {
		super();

		playButton.onClick = _ -> {
			playClicked();
		}
		creditsButton.onClick = _ -> {
			creditsClicked();
		}
	}
}
