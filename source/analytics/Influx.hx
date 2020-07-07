package analytics;

import com.bitdecay.net.influx.InfluxDB;
import com.bitdecay.net.DataSender;

class Influx {
	// TODO: Update these with the correct credentials
	private static inline var API:String = "https://us-west-2-1.aws.cloud2.influxdata.com/api/v2/write";
	private static inline var ORG:String = "13ecc65d2303c6d7";
	private static inline var BUCKET:String = "05f4043ec49f9000";
	private static inline var TOKEN:String = "sdtsiDLh01M3-BIx_YHq_66RSm0qwgu7GZVp2sIAhAx2gAYSjVg0uzKEa6yyTrZMRNvmhDVLsVh6nSB-HkcZ5w==";

	public static function getDataSender():DataSender {
		return new InfluxDB(
			Influx.API,
			Influx.ORG,
			Influx.BUCKET,
			Influx.TOKEN);
	}
}