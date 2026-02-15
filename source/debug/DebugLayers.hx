package debug;

// The different layers that have buttons to be toggled in the UI. Adjust/Add/Remove
// as needed
enum abstract DebugLayers(String) from String to String {
	var GENERAL = "General";
	var RAYCAST = "Raycast";
	var AUDIO = "Audio";
}
