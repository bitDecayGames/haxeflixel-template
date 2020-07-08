package analytics;

import com.bitdecay.analytics.Bitlytics;
import openfl.Assets;
import com.bitdecay.net.influx.InfluxDB;

class Configure {
	private static var name:String = "<GAME NAME>";

	public static function initAnalytics() {
		var influxBytes = Assets.getBytes(AssetPaths.influx__json).toString();
		Bitlytics.Init(name, InfluxDB.load(influxBytes));
		Bitlytics.Instance().NewSession();
	}
}