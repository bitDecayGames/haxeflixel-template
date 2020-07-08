package config;

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

		if (!Assets.exists(analyticsTokenPath)) {
			trace("No auth token found. Production metrics will not work.");
			analyticsToken = "";
		} else {
			analyticsToken = Assets.getBytes(analyticsTokenPath).toString();
		}
	}
}