package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.app.Application;
import lime.utils.Assets;

class RewardSubstate extends MusicBeatState
{
	public static var leftState:Bool = false;

	public static var needVer:String = "IDFK LOL";

	override function create()
	{
		super.create();
		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);
		var txt:FlxText = new FlxText(250, 0, FlxG.width-250,
			Assets.getText(Paths.txt("thank"))+"\n\n"+"Press Enter or Space to continue.",
			32);
		txt.setFormat("VCR OSD Mono", 24, FlxColor.WHITE, CENTER);
		txt.screenCenter();
		txt.x += 250;
		var logoBl = new FlxSprite(0, 0).loadGraphic(Paths.image('welcometothecircus'));
		logoBl.setGraphicSize(Std.int(logoBl.width*.2));
		logoBl.updateHitbox();
		add(logoBl);
		add(txt);
	}

	override function update(elapsed:Float)
	{
		if (controls.ACCEPT)
		{
			leftState = true;
			FlxG.switchState(new MainMenuState());
		}
		super.update(elapsed);
	}
}
