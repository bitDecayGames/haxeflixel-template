package config;

/**
 * A section to be displayed in the credits screen.
 */
class CreditEntry {
	public var sectionName:String;
	public var names:Array<String>;

	public function new(section:String, names:Array<String>) {
		this.sectionName = section;
		this.names = names;
	}
}
