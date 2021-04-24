package;

// STOLEN FROM HAXEFLIXEL DEMO LOL
import flixel.system.FlxAssets.FlxShader;

class BlurEffect
{
	public var shader(default, null):BlurShader = new BlurShader();
  public var quality(default, set):Float = 6;
	public var size(default, set):Float = 8;
	public var directions(default, set):Float = 16;

	public function new(width:Float,height:Float):Void
	{
		shader.uWidth.value = [width];
		shader.uHeight.value = [height];
	}

  function set_quality(v:Float):Float
	{
		quality = v;
		shader.uQuality.value = [v];
		return v;
	}

	function set_directions(v:Float):Float
	{
    directions = v;
		shader.uDirections.value = [v];
		return v;
	}

	function set_size(v:Float):Float
	{
    size = v;
		shader.uSize.value = [v];
		return v;
	}

}

class BlurShader extends FlxShader
{
	@:glFragmentSource('
  uniform float uWidth;
	uniform float uHeight;
  uniform float uDirections = 16.0; // BLUR DIRECTIONS (Default 16.0 - More is better but slower)
  uniform float uQuality = 6.0; // BLUR QUALITY (Default 4.0 - More is better but slower)
  uniform float uSize = 8.0; // BLUR SIZE (Radius)
	#pragma header
  void main()
  {
      float Pi = 6.28318530718; // Pi*2


      vec2 Radius = uSize/vec2(uWidth,uHeight).xy;

      // Normalized pixel coordinates (from 0 to 1)
      vec2 uv = openfl_TextureCoordv;
      // Pixel colour
      vec4 Color = texture2D(bitmap, uv);

      // Blur calculations
      for( float d=0.0; d<Pi; d+=Pi/uDirections)
      {
  		for(float i=1.0/uQuality; i<=1.0; i+=1.0/uQuality)
          {
  			Color += texture2D( bitmap, uv+vec2(cos(d),sin(d))*Radius*i);
          }
      }

      // Output to screen
      Color /= uQuality * uDirections - 15.0;
      gl_FragColor =  Color;
  }')
	public function new()
	{
		super();
	}
}
