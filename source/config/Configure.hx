package config;

import states.CreditsState.CreditEntry;
import com.bitdecay.analytics.Bitlytics;
import com.bitdecay.net.influx.InfluxDB;
import haxe.Json;
import misc.Macros;
import openfl.Assets;

/**
 * Provides access to the configuration json for the project. Helper functions
 * for computing more complex types can go in here, or you can use `get()` to
 * just get the whole config to process it any way you wish
 */
class Configure {
	private static var config:Dynamic;
	private static var analyticsToken:String;
	private static var devMode:Bool = false;

	/**
	 * Returns the whole config option. Useful for getting basic type values (bool, string, int, etc)
	 *
	 * @returns a Dyanmic object representing all configuration as loaded
	 */
	public static function get():Dynamic {
		if (config == null) {
			loadConfig();
		}

		return config;
	}

	/**
	 * Initializes analytics based on the values loaded from config.json
	 *
	 * @param dev control if analytics should be started in dev mode
	 */
	public static function initAnalytics(dev:Bool = false) {
		devMode = dev;

		if (config == null) {
			loadConfig();
		}

		Bitlytics.Init(config.analytics.name, InfluxDB.load(config.analytics.influx, analyticsToken), devMode);
		Bitlytics.Instance().NewSession();
	}

	/**
	 * Helper to load credits entries from config.json
	 *
	 * @returns Array of CreditEntry objects
	 */
	public static function getCredits():Array<CreditEntry> {
		if (config == null) {
			loadConfig();
		}

		var creditSections:Array<CreditEntry> = config.credits.sections;
		return creditSections;
	}

	/**
	 * Loads all configuration from config.json
	 */
	private static function loadConfig() {
		#if !display
		// Only run this validation if we aren't running in display mode (aka auto-complete)
		Validator.validateJson("assets/data/config.json");
		#end

		var loadSuccessful = false;

		var configBytes = Assets.getBytes("assets/data/config.json").toString();
		config = Json.parse(configBytes);

		// Check compile defines first
		if (Macros.isDefined("API_KEY")) {
			var define = Macros.getDefine("API_KEY");
			// our define comes back as <val>=<val>
			// Take the first half explicitly, as splitting on '=' might have unexpected
			// behavior if the token has '=' characters in it
			analyticsToken = define.substr(0, Std.int(define.length / 2));
			loadSuccessful = analyticsToken.length > 0;
		} else {
			trace('No API_KEY compile flag found. Production metrics will not work.');
			loadSuccessful = false;
		}

		if (!devMode && !loadSuccessful) {
			// go into dev mode if we didn't load successfully
			devMode = true;
		}
	}
}
