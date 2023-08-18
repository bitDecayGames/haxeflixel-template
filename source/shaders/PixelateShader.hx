package shaders;

import flixel.FlxG;

/**
 * Shader that will downsample the game to the specified resolution.
**/
class PixelateShader extends flixel.system.FlxAssets.FlxShader {
    var debug = false;
    var enabled = true;
    var sampleDistance = 0.125;

    @:glFragmentSource('
        #pragma header

        // effect enabled
        uniform bool iEnabled;

        // draw grid
        uniform bool iDebug;

        // size of pixels along x/y axes
        uniform vec2 iPixelSize;

        uniform float iSampleDistance;

        void main()
        {
            // Pixel size of the underlying texture
            vec2 iResolution = openfl_TextureSize;

            // downsample rate (ex: 512x512 / 64x64 = 8x8)
            vec2 iPixelateRes = iResolution * iPixelSize;

            vec2 sampleUV = floor(openfl_TextureCoordv / iPixelSize) * iPixelSize;

            // offset our coordinates by half of a pixel size so we sample from the center of our pixel area
            sampleUV += iPixelSize * 0.5;

            vec2 subPixel = iSampleDistance * iPixelSize;
            vec4 col = texture2D(bitmap, sampleUV);
            col = col + texture2D(bitmap, sampleUV + vec2(0., subPixel.y));
            col = col + texture2D(bitmap, sampleUV + vec2(0., -subPixel.y));
            col = col + texture2D(bitmap, sampleUV + vec2(subPixel.x, 0.));
            col = col + texture2D(bitmap, sampleUV + vec2(-subPixel.x, 0.));
            col = col / 5.;
            
            if (!iEnabled) {
                col = texture2D(bitmap, openfl_TextureCoordv);
            }

            if (iDebug) {
                vec2 uv = openfl_TextureCoordv;
                // original pixel coordinate on our texture
                vec2 fragPixelCoord = uv * iResolution.xy;
                
                // divide by our pixel size to get our downsampled pixel coordinate
                vec2 iPixelCoord = fragPixelCoord / iPixelateRes.xy;

                // Draw grid
                if (mod(iPixelCoord.x, 2.) < 1. && mod(iPixelCoord.y, 2.) < 1.) {
                    col.xyz *= .8;
                } else if (mod(iPixelCoord.x, 2.) >= 1. && mod(iPixelCoord.y, 2.) >= 1.) {
                    col.xyz *= .8;
                }
            };

            gl_FragColor = col;
        }
    ')

    public function new(pWide:Int, pHigh:Int) {
        super();
        this.iPixelSize.value = [1.0 / pWide, 1.0 / pHigh];
        this.iDebug.value = [debug];
        this.iEnabled.value = [enabled];
        this.iSampleDistance.value = [sampleDistance];
    }

    public function update(elapsed:Float)
    {
        if (FlxG.keys.justPressed.P) {
            enabled = !enabled;
            this.iEnabled.value = [enabled];
        } 

        if (FlxG.keys.justPressed.O) {
            debug = !debug;
            this.iDebug.value = [debug];
        }

        if (FlxG.keys.justPressed.I) {
            sampleDistance = Math.min(sampleDistance + .125, .875);
            this.iSampleDistance.value = [sampleDistance];
        }
        if (FlxG.keys.justPressed.K) {
            sampleDistance = Math.max(sampleDistance - .125, .0);
            this.iSampleDistance.value = [sampleDistance];
        }
    }
}