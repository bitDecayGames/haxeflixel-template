package debug.events;

import openfl.Assets;
import bitdecay.flixel.debug.DebugToolWindow;
#if FLX_DEBUG
import openfl.events.MouseEvent;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.display.BitmapData;
import events.IEvent;
import flixel.math.FlxMath;
import flixel.system.debug.log.LogStyle;
#end

/**
 * A simple trace output window for use in the debugger overlay.
 */
class EventLogWindow extends DebugToolWindow {
	#if FLX_DEBUG
	public static inline var MAX_LOG_LINES:Int = 200;
	static inline var LINE_BREAK:String = #if js "\n" #else "<br>" #end;

	var skipFields = ['id', 'type', 'reducers'];
	var longestEventName = 10;

	var eventStyle = new LogStyle();

	var _text:TextField;
	var _lines:Array<String>;

	// counter for events
	public var eventNum = 0;

	/**
	 * Creates a log window object
	 */
	public function new(icon:BitmapData) {
		super("Event Log", icon);

		_text = new TextField();
		_text.x = 2;
		_text.y = 15;
		_text.multiline = true;
		_text.wordWrap = true;
		_text.selectable = true;
		_text.embedFonts = true;
		var fnt = Assets.getFont(AssetPaths.NeomatrixCode__ttf);
		var textFormat = new TextFormat(fnt.fontName, 10, 0xffffff);
		// textFormat.kerning = true;
		_text.defaultTextFormat = textFormat;
		addChild(_text);

		_lines = new Array<String>();

		minSize.setTo(100, 50);

		// Default scroll handling of text fields is way too aggressive. We'll just handle it ourselves
		_text.mouseWheelEnabled = false;
		addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
	}

	function onMouseWheel(e:MouseEvent):Void {
		if (e.delta > 0) {
			_text.scrollV = FlxMath.maxInt(1, _text.scrollV - 3);
		} else {
			_text.scrollV = FlxMath.minInt(_text.maxScrollV, _text.scrollV + 3);
		}
	};

	public function addEvent(event:IEvent) {
		add([formatEvent(event)]);
	}

	public function formatEvent(e:IEvent):String {
		var id = e.id;
		var type = e.type;

		longestEventName = FlxMath.maxInt(longestEventName, type.length);

		var fieldPairs = [];
		var fields = Reflect.fields(e);
		for (field in fields) {
			if (!skipFields.contains(field)) {
				var fieldStr = field;
				var value = Reflect.field(e, field);
				// Format Float to 3 decimal places
				if (Std.isOfType(value, Float)) {
					var formatted = Std.string(Math.round(value * 1000) / 1000);
					fieldPairs.push(StringTools.rpad('$fieldStr: ${formatted}', " ", 20));
				} else {
					fieldPairs.push(StringTools.rpad('$fieldStr: ${value}', " ", 20));
				}
			}
		}

		return StringTools.lpad(Std.string(id), "0", 4)
			+ ": "
			+ StringTools.rpad(type, " ", longestEventName)
			+ " - "
			+ fieldPairs.join("| ");
	}

	/**
	 * Clean up memory
	 */
	override public function destroy():Void {
		if (_text != null) {
			removeChild(_text);
			_text = null;
		}

		_lines = null;
		super.destroy();
	}

	/**
	 * Adds a new line to the log window.
	 * 
	 * @param   data      The data being logged
	 * @param   style     The LogStyle to be used
	 * @param   fireOnce  If true, the log history is checked for matching logs
	 */
	public function add(data:Array<Dynamic>):Bool {
		if (data == null) {
			return false;
		}

		// Apply text formatting
		#if (!js && !lime_console)
		final text = eventStyle.toHtmlString(data);
		#else
		final text = eventStyle.toLogString(data);
		#end

		// Actually add it to the textfield
		if (_lines.length <= 0) {
			_text.text = "";
		}

		_lines.push(text);

		if (_lines.length > MAX_LOG_LINES) {
			_lines.shift();
			var newText:String = "";
			for (i in 0..._lines.length) {
				newText += _lines[i] + LINE_BREAK;
			}
			// TODO: Make htmlText work on HTML5 target
			#if (!js && !lime_console)
			_text.htmlText = newText;
			#else
			_text.text = newText;
			#end
		} else {
			// TODO: Make htmlText work on HTML5 target
			#if (!js && !lime_console)
			_text.htmlText += (text + LINE_BREAK);
			#else
			_text.text += text + LINE_BREAK;
			#end
		}

		_text.scrollV = Std.int(_text.maxScrollV);
		return true;
	}

	public function clear():Void {
		_text.text = "";
		_lines.splice(0, _lines.length);
		#if !js
		_text.scrollV = 0;
		#end
	}

	/**
	 * Adjusts the width and height of the text field accordingly.
	 */
	override function updateSize():Void {
		super.updateSize();

		_text.width = _width - 10;
		_text.height = _height - 15;
	}
	#end
}
