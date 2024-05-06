package shaders;

import flixel.util.FlxColor;
import openfl.display.ShaderParameter;
import flixel.system.FlxAssets.FlxShader;

// Allows setting a sprite to be a solid color, such as blinking white while taking damage
class SolidColorShader extends FlxShader {
	@:glFragmentSource('
        #pragma header

		uniform vec4 color;
        uniform bool isShaderActive;

        void main()
        {
            vec4 pixel = texture2D(bitmap, openfl_TextureCoordv);

			if (!isShaderActive)
			{
				gl_FragColor = pixel;
				return;
            } 

            if (pixel.a != 0.0) {
                gl_FragColor = color;
            }
        }')
	public function new(color:FlxColor) {
		super();

		this.color.value = [color.red, color.green, color.blue, color.alpha];
	}
}
