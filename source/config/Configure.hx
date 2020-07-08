package config;

import haxe.Json;
import com.bitdecay.analytics.Bitlytics;
import openfl.Assets;
import com.bitdecay.net.influx.InfluxDB;

class Configure {
	private static var config:Dynamic;

	public static function initAnalytics() {
		if (config == null) {
			loadConfig();
		}
		
		Bitlytics.Init(config.analytics.name, InfluxDB.load(config.analytics.influx));
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
	}
}