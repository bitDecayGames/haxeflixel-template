package ui;

import haxe.ui.containers.VBox;

@:build(haxe.ui.macros.ComponentMacros.build("assets/xml/return_to_main.xml"))
class ReturnToMain extends VBox {
	public function new(clicked:Void->Void) {
		super();

		mainMenuButton.onClick = _ -> {
			clicked();
		}
	}
}
