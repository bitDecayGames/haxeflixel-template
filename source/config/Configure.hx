package config;

import misc.Macros;
import haxe.Json;
import com.bitdecay.analytics.Bitlytics;
import openfl.Assets;
import com.bitdecay.net.influx.InfluxDB;

class Configure {
	public static var analyticsTokenPath:String = "assets/data/analytics_token.txt";

	private static var config:Dynamic;
	private static var analyticsToken:String;

	public static function initAnalytics() {
		if (config == null) {
			loadConfig();
		}

		Bitlytics.Init(config.analytics.name, InfluxDB.load(config.analytics.influx, analyticsToken));
		Bitlytics.Instance().NewSession();
	}

	public static function getCredits():Array<CreditEntry> {
		if (config == null) {
			loadConfig();
		}

		var creditSections:Array<CreditEntry> = config.credits.sections;
		return creditSections;
	}

	private static function loadConfig() {
		var configBytes = Assets.getBytes(AssetPaths.config__json).toString();
		config = Json.parse(configBytes);

		// Check compile defines first
		if (Macros.isDefined("API_KEY")) {
			var define = Macros.getDefine("API_KEY");
			analyticsToken = define.split("=")[0];
			return;
		} else {
			trace("No API_KEY compile flag found. Production metrics will not work.");
		}
	}
}