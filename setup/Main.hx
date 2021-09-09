package;

import sys.io.File;
import haxe.Template;

// This is a simple helper to fill out some configuration needed when first configuring a new repo
class Main {
	static public function main():Void {

		var pattern = "^[A-Z0-9_-]+$";
		var regex = new EReg(pattern, "i");

		// List of substitutions we need to ask the user to provide
		var questions = [
			"game_name" => {
				description: "Game name as displayed in Project URL",
				validator: null
			},
			"influx_bucket_id" => {
				description: "InfluxDB Bucket ID",
				validator: null
			},
			"simple_game_name" => {
				description: 'Name used to tag metrics data. Should fit ${pattern} regex',
				validator: (a) -> {
					return regex.match(a);
				}
			}
		];

		// List of files we need to template out with new projects
		var files = [
			"../.github/workflows/auto-deploy.yml",
			"../.github/workflows/prod-deploy.yml",
			"../assets/data/config.json"
		];

		Sys.println("");
		Sys.println("");

		var responses:haxe.DynamicAccess<Dynamic> = {}
		for (name => data in questions) {
			while (true) {
				Sys.println("");
				Sys.print('${name} (${data.description}): ');
				var response = Sys.stdin().readLine();
				responses.set(name, response);
				if (data.validator != null) {
					if (!data.validator(response)) {
						Sys.println('"${response}" failed validation, try again');
						continue;
					}
				}
				break;
			}
		}

		for (file in files) {
			var content = File.getContent(file);
			var tpl = new Template(content);
			var output = tpl.execute(responses);
			File.write(file).writeString(output);
		}
	}
}