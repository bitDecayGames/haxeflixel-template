package extensions;

import com.bitdecay.analytics.Bitlytics;
import flixel.FlxState;

class FlxStateExt {
    public static function handleFocusLost(state:FlxState) {
        #if debug
        trace("lost focus: ignoring due to debug");
        #else
        Bitlytics.Instance().Pause();
        FmodManager.PauseAllSounds();
        #end
    }

    public static function handleFocus(state:FlxState) {
        #if debug
        trace("regain focus: ignoring due to debug");
        #else
        Bitlytics.Instance().Resume();
        FmodManager.UnpauseAllSounds();
        #end
    }
}