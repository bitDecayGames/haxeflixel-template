package shaders;

import flixel.system.FlxAssets.FlxShader;

/**
 * A classic mosaic effect, just like in the old days!
 */
class MosaicShader extends FlxShader {
	@:glFragmentSource('
		#pragma header
		uniform vec2 uBlocksize;

		void main()
		{
			vec2 blockCount = openfl_TextureSize / uBlocksize;
			gl_FragColor = flixel_texture2D(bitmap, clamp(floor(openfl_TextureCoordv * blockCount) / blockCount, 0.0, 1.0));
		}')
	public function new() {
		super();
	}

	// sets the size of the mosaic tiles the x/y axes for the texture
	public function setBlockSize(x:Float, y:Float = 0) {
		if (x <= 0) {
			x = 1;
		}

		if (y <= 0) {
			y = x;
		}

		this.uBlocksize.value = [x, y];
	}
}
