package extensions;

import com.bitdecay.analytics.Bitlytics;
import flixel.FlxState;

class FlxStateExt {
    public static function handleFocusLost(state:FlxState) {
        #if debug
        trace("lost focus: ignoring due to debug");
        #else
        Bitlytics.Instance().Pause();
        FmodManager.PauseSong();
        #end
    }

    public static function handleFocus(state:FlxState) {
        #if debug
        trace("regain focus: ignoring due to debug");
        #else
        Bitlytics.Instance().Resume();
        FmodManager.UnpauseSong();
        #end
    }
}