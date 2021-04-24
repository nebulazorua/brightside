package;

import Controls.KeyboardScheme;
import Controls.Control;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;

class OptionsMenu extends MusicBeatState
{
	var selector:FlxText;
	var curSelected:Int = 0;

	var controlsStrings:Array<String> = [];

	private var grpControls:FlxTypedGroup<Alphabet>;
	var versionShit:FlxText;
	override function create()
	{
		var menuBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		var FUCKSHITCUNT:String = (FlxG.save.data.binds==null ? "DFJK" : FlxG.save.data.binds) + "\n" + (FlxG.save.data.newInput ? "New scoring" : "Old scoring") + "\n" + (FlxG.save.data.inputSystem==null ? "Old KadeEngine" : FlxG.save.data.inputSystem) + "\n" + (FlxG.save.data.downscroll ? 'Downscroll' : 'Upscroll') + "\nAccuracy " + (!FlxG.save.data.accuracyDisplay ? "off" : "on") + "\nLoad replays";

		if(FlxG.save.data.yaaf){
			FUCKSHITCUNT=FUCKSHITCUNT+"\n"+(FlxG.save.data.moveNotes ? "Drunk Notes" : "Regular Notes")+"\n"+(FlxG.save.data.opponent ? "Opponent Mode" : "BF Mode");
		}else{
			if(FlxG.save.data.opponent==true){
				FUCKSHITCUNT=FUCKSHITCUNT+"\n"+(FlxG.save.data.opponent ? "Opponent Mode" : "BF Mode");
			}
			if(FlxG.save.data.moveNotes==true){
				FUCKSHITCUNT=FUCKSHITCUNT+"\n"+(FlxG.save.data.moveNotes ? "Drunk Notes" : "Regular Notes");
			}
		}
		controlsStrings = CoolUtil.coolStringFile(FUCKSHITCUNT);

		trace(controlsStrings);

		menuBG.color = 0xFFea71fd;
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = true;
		add(menuBG);

		grpControls = new FlxTypedGroup<Alphabet>();
		add(grpControls);

		for (i in 0...controlsStrings.length)
		{
				var controlLabel:Alphabet = new Alphabet(0, (70 * i) + 30, controlsStrings[i], true, false);
				controlLabel.isMenuItem = true;
				controlLabel.targetY = i;
				grpControls.add(controlLabel);
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
		}


		versionShit = new FlxText(5, FlxG.height - 18, 0, "Offset (Left, Right): " + FlxG.save.data.offset, 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

			if (controls.BACK)
				FlxG.switchState(new MainMenuState());
			if (controls.UP_P)
				changeSelection(-1);
			if (controls.DOWN_P)
				changeSelection(1);

			if (controls.RIGHT_R)
			{
				FlxG.save.data.offset++;
				versionShit.text = "Offset (Left, Right): " + FlxG.save.data.offset;
			}

			if (controls.LEFT_R)
				{
					FlxG.save.data.offset--;
					versionShit.text = "Offset (Left, Right): " + FlxG.save.data.offset;
				}


			if (controls.ACCEPT)
			{
				if (curSelected != 5)
					grpControls.remove(grpControls.members[curSelected]);
				switch(curSelected)
				{
					case 0:
						switch (FlxG.save.data.binds){
							case 'WASD':
								FlxG.save.data.binds = 'DFJK';
							case 'DFJK':
								FlxG.save.data.binds = 'ASKL';
							case 'ASKL':
								FlxG.save.data.binds = 'SDKL';
							case 'SDKL':
								FlxG.save.data.binds = 'WASD';
							default:
								FlxG.save.data.binds = 'DFJK';
						}

						var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, FlxG.save.data.binds, true, false);
						ctrl.isMenuItem = true;
						ctrl.targetY = curSelected;
						grpControls.add(ctrl);
						if (FlxG.save.data.binds == 'WASD')
							controls.setKeyboardScheme(KeyboardScheme.WASD, true);
						else if (FlxG.save.data.binds == 'DFJK')
							controls.setKeyboardScheme(KeyboardScheme.DFJK, true);
						else if (FlxG.save.data.binds == 'ASKL')
							controls.setKeyboardScheme(KeyboardScheme.ASKL, true);
						else if (FlxG.save.data.binds == 'SDKL')
							controls.setKeyboardScheme(KeyboardScheme.SDKL, true);

					case 1:
						FlxG.save.data.newInput = !FlxG.save.data.newInput;
						var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, (FlxG.save.data.newInput ? "New Scoring" : "Old Scoring"), true, false);
						ctrl.isMenuItem = true;
						ctrl.targetY = curSelected - 1;
						grpControls.add(ctrl);
					case 2:
						switch (FlxG.save.data.inputSystem){
							case 'Old KadeEngine':
								FlxG.save.data.inputSystem = "New KadeEngine";
							case 'New KadeEngine':
								FlxG.save.data.inputSystem = "Vanilla";
							case 'Vanilla':
								FlxG.save.data.inputSystem = "Old KadeEngine";
							default:
								FlxG.save.data.inputSystem = "New KadeEngine";
						}
						var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, FlxG.save.data.inputSystem, true, false);
						ctrl.isMenuItem = true;
						ctrl.targetY = curSelected - 2;
						grpControls.add(ctrl);
					case 3:
						FlxG.save.data.downscroll = !FlxG.save.data.downscroll;
						var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, (FlxG.save.data.downscroll ? 'Downscroll' : 'Upscroll'), true, false);
						ctrl.isMenuItem = true;
						ctrl.targetY = curSelected - 3;
						grpControls.add(ctrl);
					case 4:
						FlxG.save.data.accuracyDisplay = !FlxG.save.data.accuracyDisplay;
						var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, "Accuracy " + (!FlxG.save.data.accuracyDisplay ? "off" : "on"), true, false);
						ctrl.isMenuItem = true;
						ctrl.targetY = curSelected - 4;
						grpControls.add(ctrl);
					case 5:
						trace('switch');
						FlxG.switchState(new LoadReplayState());
					case 6:
						FlxG.save.data.moveNotes = !FlxG.save.data.moveNotes;
						var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, (FlxG.save.data.moveNotes ? "Drunk Notes" : "Regular Notes"), true, false);
						ctrl.isMenuItem = true;
						ctrl.targetY = curSelected - 6;
						grpControls.add(ctrl);
					case 7:
						FlxG.save.data.opponent = !FlxG.save.data.opponent;
						var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, (FlxG.save.data.opponent ? "Opponent Mode" : "BF Mode"), true, false);
						ctrl.isMenuItem = true;
						ctrl.targetY = curSelected - 7;
						grpControls.add(ctrl);
				}
			}
	}

	var isSettingControl:Bool = false;

	function changeSelection(change:Int = 0)
	{
		#if !switch
		// NGio.logEvent('Fresh');
		#end

		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = grpControls.length - 1;
		if (curSelected >= grpControls.length)
			curSelected = 0;

		// selector.y = (70 * curSelected) + 30;

		var bullShit:Int = 0;

		for (item in grpControls.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
	}
}
