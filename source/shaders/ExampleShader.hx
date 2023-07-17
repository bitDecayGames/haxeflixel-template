package shaders;

/**
 * Basic shader that shows how to pass uniforms into shaders
**/
class ExampleShader extends flixel.system.FlxAssets.FlxShader
{
    var totalElapsed = 0.0;

    @:glFragmentSource('
        #pragma header

        uniform float iTime;

        void main()
        {
            // vec2 iResolution = openfl_TextureSize;
            // vec2 uv = openfl_TextureCoordv;
            // vec2 fragCoord = uv * iResolution;

            // vec4 col = texture2D(bitmap, openfl_TextureCoordv);

            // if (uv.x > (sin(iTime * 3.14) + 1.0) / 2.0)
            //     col = vec4(1.0 - col.rgb, 1.0);

            // gl_FragColor = col;
            gl_FragColor = vec4(1., 1., 1., 1.);
        }
    ')

    public function update(elapsed:Float)
    {
        totalElapsed += elapsed;
        this.iTime.value = [totalElapsed];
    }
}