package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
#if polymod
import polymod.format.ParseRules.TargetSignatureElement;
#end

using StringTools;

class Note extends FlxSprite
{
	public var strumTime:Float = 0;

	public var mustPress:Bool = false;
	public var noteData:Int = 0;
	public var canBeHit:Bool = false;
	public var tooLate:Bool = false;
	public var wasGoodHit:Bool = false;
	public var prevNote:Note;

	public var sustainLength:Float = 0;
	public var isSustainNote:Bool = false;
	public var display:String = "None";
	public var defaultX:Float = 0;

	public var noteScore:Float = 1;

	public static var swagWidth:Float = 160 * 0.7;
	public static var PURP_NOTE:Int = 0;
	public static var GREEN_NOTE:Int = 2;
	public static var BLUE_NOTE:Int = 1;
	public static var RED_NOTE:Int = 3;


	public function new(strumTime:Float, noteData:Int, ?prevNote:Note, ?sustainNote:Bool = false, ?d:String="None")
	{
		super();

		if (prevNote == null)
			prevNote = this;

		this.prevNote = prevNote;
		isSustainNote = sustainNote;

		x += 50;
		// MAKE SURE ITS DEFINITELY OFF SCREEN?
		y -= 2000;
		this.strumTime = strumTime + FlxG.save.data.offset;

		this.noteData = noteData;

		var daStage:String = PlayState.curStage;

		switch (daStage)
		{
			case 'school' | 'schoolEvil':
				loadGraphic(Paths.image('weeb/pixelUI/arrows-pixels'), true, 17, 17);

				animation.add('greenScroll', [6]);
				animation.add('redScroll', [7]);
				animation.add('blueScroll', [5]);
				animation.add('purpleScroll', [4]);

				if (isSustainNote)
				{
					loadGraphic(Paths.image('weeb/pixelUI/arrowEnds'), true, 7, 6);

					animation.add('purpleholdend', [4]);
					animation.add('greenholdend', [6]);
					animation.add('redholdend', [7]);
					animation.add('blueholdend', [5]);

					animation.add('purplehold', [0]);
					animation.add('greenhold', [2]);
					animation.add('redhold', [3]);
					animation.add('bluehold', [1]);
				}

				setGraphicSize(Std.int(width * PlayState.daPixelZoom));
				updateHitbox();

			default:
				if(PlayState.SONG.song.toLowerCase()=='personal-space-invasion'){
					frames = Paths.getSparrowAtlas('PARASITENOTE_assets');
				}else{
					frames = Paths.getSparrowAtlas('NOTE_assets');
				}
				if(display!="None" && !isSustainNote){
					frames = Paths.getSparrowAtlas('NOTE_assets_FOOLISH');

					animation.addByPrefix('I','arrowI0');
					animation.addByPrefix('AM','arrowAM0');
					animation.addByPrefix('A','arrowA0');
					animation.addByPrefix('FOOL','arrowFOOL0');
					animation.addByPrefix('YOU','arrowYOU0');
					animation.addByPrefix('ARE','arrowARE0');
					animation.addByPrefix('FO','arrowFO0');
					animation.addByPrefix('OL','arrowOL0');

				}else{
					animation.addByPrefix('greenScroll', 'green0');
					animation.addByPrefix('redScroll', 'red0');
					animation.addByPrefix('blueScroll', 'blue0');
					animation.addByPrefix('purpleScroll', 'purple0');

					animation.addByPrefix('purpleholdend', 'pruple end hold');
					animation.addByPrefix('greenholdend', 'green hold end');
					animation.addByPrefix('redholdend', 'red hold end');
					animation.addByPrefix('blueholdend', 'blue hold end');
					animation.addByPrefix('grayholdend', 'grey hold end');

					animation.addByPrefix('purplehold', 'purple hold piece');
					animation.addByPrefix('greenhold', 'green hold piece');
					animation.addByPrefix('redhold', 'red hold piece');
					animation.addByPrefix('bluehold', 'blue hold piece');
					animation.addByPrefix('grayhold', 'grey hold piece');
				}


				setGraphicSize(Std.int(width * 0.7));
				updateHitbox();
				antialiasing = true;
		}

		if(display=="None"){
			switch (noteData)
			{
				case 0:
					x += swagWidth * 0;
					animation.play('purpleScroll');
				case 1:
					x += swagWidth * 1;
					animation.play('blueScroll');
				case 2:
					x += swagWidth * 2;
					animation.play('greenScroll');
				case 3:
					x += swagWidth * 3;
					animation.play('redScroll');
			}
		}else{
			animation.play(display);
			switch (noteData)
			{
				case 0:
					x += swagWidth * 0;
				case 1:
					x += swagWidth * 1;
				case 2:
					x += swagWidth * 2;
				case 3:
					x += swagWidth * 3;
			}
		}

		// we make sure its downscroll and its a SUSTAIN NOTE (aka a trail, not a note)
		// and flip it so it doesn't look weird.
		// THIS DOESN'T FUCKING FLIP THE NOTE, CONTRIBUTERS DON'T JUST COMMENT THIS OUT JESUS
		if (FlxG.save.data.downscroll && sustainNote)
			flipY = true;


		if (isSustainNote && prevNote != null)
			{
				noteScore * 0.2;
				alpha = 0.6;

				x += width / 2;

				if(display=="None"){
					switch (noteData)
					{
						case 2:
							animation.play('greenholdend');
						case 3:
							animation.play('redholdend');
						case 1:
							animation.play('blueholdend');
						case 0:
							animation.play('purpleholdend');
					}
				}else{
					animation.play('grayholdend');
				}


				updateHitbox();

				x -= width / 2;

				if (PlayState.curStage.startsWith('school'))
					x += 30;

				if (prevNote.isSustainNote)
				{
					if(display=="None"){
						switch (prevNote.noteData)
						{
							case 0:
								prevNote.animation.play('purplehold');
							case 1:
								prevNote.animation.play('bluehold');
							case 2:
								prevNote.animation.play('greenhold');
							case 3:
								prevNote.animation.play('redhold');
						}
					}else{
						prevNote.animation.play('grayhold');
					}

					prevNote.scale.y *= Conductor.stepCrochet / 100 * 1.5 * PlayState.SONG.speed;
					prevNote.updateHitbox();
					// prevNote.setGraphicSize();
				}
			}
	}

	var oneTime:Bool = false;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (mustPress)
		{
			// The * 0.5 is so that it's easier to hit them too late, instead of too early
			if (strumTime > Conductor.songPosition - Conductor.safeZoneOffset
				&& strumTime < Conductor.songPosition + (Conductor.safeZoneOffset * 0.5))
				canBeHit = true;
			else
				canBeHit = false;
			if (strumTime < Conductor.songPosition - Conductor.safeZoneOffset && !wasGoodHit)
			{
				tooLate = true;
			}
		}
		else
		{
			canBeHit = false;

			if (strumTime <= Conductor.songPosition)
				wasGoodHit = true;
		}

		if (tooLate)
		{
			if (alpha > 0.3)
				alpha = 0.3;
		}
	}
}
