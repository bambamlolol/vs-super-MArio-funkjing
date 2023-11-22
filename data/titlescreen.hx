// a
import Conductor;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.Lib;
import openfl.display.Sprite;
import flixel.graphics.frames.FlxAtlasFrames;

var continueNormal:Bool = false;
var daLogo:FlxSprite;
var madeWith:FlxText;
var beforeVol = FlxG.sound.volume;
var newBG:FlxSprite;

function createPost() {
	if (save.data.yceModJam == null) {
		save.data.yceModJam = false;
		save.flush();
	}
	daLogo = new FlxSprite(0, 0);
	daLogo.scale.set(0.35, 0.35);
	daLogo.frames = getModJam("images/yceJam", true);
	daLogo.animation.addByPrefix('idle', '', 24, true);
	daLogo.animation.play('idle', true);
	daLogo.antialiasing = EngineSettings.antialiasing;
	daLogo.scrollFactor.set();
	daLogo.updateHitbox();
	daLogo.screenCenter();

	newBG = new FlxSprite(0, 0, getModJam("images/coolModJamBG.png"));
	newBG.scrollFactor.set();
	newBG.setGraphicSize(FlxG.width, FlxG.height);
	newBG.updateHitbox();
	newBG.screenCenter();
	newBG.x = 0 - newBG.width - 15;

	madeWith = new FlxText(0, 0, 0, "Made during the YCE ModJam", 32);
	madeWith.font = getModJam("fonts/memphis.ttf");
	madeWith.scrollFactor.set();
	madeWith.updateHitbox();
	madeWith.screenCenter(FlxAxes.X);
	madeWith.y = daLogo.y + daLogo.height - madeWith.height;

	details = new FlxText(0, 0, 0, "Happy 3rd Birthday YCE", 32);
	details.font = getModJam("fonts/memphis.ttf");
	details.scrollFactor.set();
	details.updateHitbox();
	details.screenCenter(FlxAxes.X);
	details.y = madeWith.y + details.height + 5;

	credGroup.insert(credGroup.members.indexOf(state.blackScreen) + 1, madeWith);
	credGroup.insert(credGroup.members.indexOf(state.blackScreen) + 1, details);
	credGroup.insert(credGroup.members.indexOf(state.blackScreen) + 1, daLogo);
	credGroup.insert(credGroup.members.indexOf(madeWith) + 1, newBG);
	daLogo.alpha = 0.0001;
	madeWith.alpha = 0.0001;
	details.alpha = 0.0001;
    
	// why == false? it has a chance to not work when if (save.data.yceModJam)
	if (save.data.yceModJam == false)
		startVideoIntro();
	else {
		newBG.x = 0;
		continueNormal = true;
		Conductor.songPosition = 0;
		FlxG.sound.music.time = 0;
	}
	// if you don't want to play the video (i'd reccomend you do) just do:
	// doYceModJamIntro();

    if (save.data.haxeLogoStuff != null) {
        for (item in save.data.haxeLogoStuff) {
            var thing = FlxG.stage.getChildByName(item);
            if (thing == null) continue;
            FlxG.stage.removeChild(thing);
        }
    } else {
        save.data.haxeLogoStuff = [];
    }
}

function startVideoIntro() {
	FlxG.sound.music.stop();
	var mFolder = Paths_.modsPath;
	var path = mFolder + "\\" + mod + "\\yceModJam\\images\\" + "intro.mp4"; // intro
	FlxG.sound.volume = 1;
	videoSprite = MP4Video.playMP4(path, function() {
		state.remove(videoSprite);
		FlxG.sound.volume = beforeVol;
        new FlxTimer().start(0.25, function(tmr) {
            doSplash();
        });
	}, false, FlxG.width, FlxG.height);
	videoSprite.scrollFactor.set();
	state.add(videoSprite);
}

// YOU CAN EDIT THIS FUNCTION!!!
function doYceModJamIntro() {
	FlxG.sound.music.stop();
	new FlxTimer().start(1, function(timer:FlxTimer) {
		FlxTween.tween(daLogo, {alpha: 1}, 0.5, {ease: FlxEase.quintIn});
		FlxG.sound.play(Paths.sound('confirmMenu'), 1, false, null, true);
		new FlxTimer().start(1, function(timer:FlxTimer) {
			FlxTween.tween(daLogo, {y: daLogo.y - madeWith.height - 25}, 2, {ease: FlxEase.circInOut});
			madeWith.y += madeWith.height + 25;
			FlxTween.tween(madeWith, {alpha: 1, y: madeWith.y - madeWith.height - 25}, 2, {ease: FlxEase.circInOut, startDelay: 0.15});
			FlxTween.tween(details, {alpha: 1}, 1, {ease: FlxEase.quadIn, startDelay: 3});
			// EDIT HERE IF YOU WANT TO
			FlxTween.tween(newBG, {x: 0}, 1.25, {
				ease: FlxEase.quintOut,
				startDelay: 6,
				onComplete: function() {
					continueNormal = true;
					Conductor.songPosition = 0;
					FlxG.sound.music.time = 0;
					CoolUtil.playMenuMusic(true);
					save.data.yceModJam = true;
					save.flush();
				}
			});
		});
	});
}

/* YOU AT LEAST NEED THIS IN ORDER TO RESUME THE NORMAL TITLESTATE FUNCTION!!! vvvvvv
	FlxTween.tween(newBG, {x: 0}, 2, {ease: FlxEase.quintOut, onComplete: function() {
		continueNormal = true;
		Conductor.songPosition = 0;
		FlxG.sound.music.time = 0;
		CoolUtil.playMenuMusic(true);
		save.data.yceModJam = true;
		save.flush();
	}});
 */
function update(elapsed:Float) {
	if (!continueNormal) {
		Conductor.songPosition = 0;
		FlxG.sound.music.time = 0;
		return;
	}
	var lerp = FlxMath.lerp(1.05, 1, FlxEase.cubeOut(curDecBeat % 1));
	newBG.scale.set(lerp, lerp);
}

function textShit(beat:Int) {
	if (!continueNormal)
		return false; // prevent default behaviour
}

function onSkipIntro() {
	if (!continueNormal) {
		skippedIntro = true;
		return false;
	}
}

function onSkipIntroPost() {
	if (!continueNormal)
		skippedIntro = false;
}

// Base game stuff, edit here lol
var crafterEngineLogo:FlxSprite = null;
var gfDancing:FlxSprite = null;

function create() {
	gfDancing = new FlxSprite(FlxG.width * 0.4, FlxG.height * 0.07);
	gfDancing.frames = Paths.getSparrowAtlas('spritesheet');
	gfDancing.animation.addByPrefix('danceLeft', 'danceLeft', 24);
	gfDancing.animation.addByPrefix('danceRight', 'danceRight', 24);
	gfDancing.animation.play('danceLeft', true);
	gfDancing.antialiasing = true;
	add(gfDancing);

	crafterEngineLogo = new FlxSprite(-50, -35);
	crafterEngineLogo.frames = Paths.getSparrowAtlas('logoBumpin');
	crafterEngineLogo.antialiasing = true;
	crafterEngineLogo.animation.addByPrefix('bump', 'logo bumpin', 24);
	crafterEngineLogo.animation.play('bump');
	crafterEngineLogo.updateHitbox();
	crafterEngineLogo.scale.x = crafterEngineLogo.scale.y = 0.95;
	add(crafterEngineLogo);
}

function beatHit() {
	if (gfDancing != null)
		gfDancing.animation.play((gfDancing.animation.curAnim.name == "danceLeft") ? "danceRight" : "danceLeft");
}

function getModJam(path:String, ?sparrow:Bool) {
    if (sparrow == null) sparrow = false;
    if (sparrow) return FlxAtlasFrames.fromSparrow(Paths.getLibraryPathForce("yceModJam/" + path + ".png", "mods/"+mod), Paths.getLibraryPathForce("yceModJam/" + path + ".xml", "mods/"+mod));
    return Paths.getLibraryPathForce("yceModJam/" + path, "mods/"+mod);
}
/**
    This is the Haxe Logo shit, you can edit it if you know what the fuck im doing here lol

    do some funny shit I wanna see cool intros
**/
var _gfx = null;
function doSplash() {
	// This is required for sound and animation to synch up properly
	_times = [0.041, 0.184, 0.334, 0.495, 0.636];
	_colors = [0x00b922, 0xffc132, 0xf5274e, 0x3641ff, 0x04cdfb];
	yceColors = [0x290355, 0x641AB9, 0x641AB9, 0x43068A, 0x43068A];
	_functions = [drawMiddle, drawTopLeft, drawTopRight, drawBottomLeft, drawBottomRight];
	var stageWidth:Int = Lib.current.stage.stageWidth;
	var stageHeight:Int = Lib.current.stage.stageHeight;
	for (time in _times) new FlxTimer().start(time, function(tmr:FlxTimer) {
	    _functions[_curPart](_colors[_curPart]);
	    _text.textColor = _colors[_curPart];
	    _text.text = "HaxeFlixel";
	    _curPart++;

	    if (_curPart == 5) {
            new FlxTimer().start(2.5, function() {
                yce();
                new FlxTimer().start(0.5, function() {
                    haxe();
                });
                new FlxTimer().start(0.75, function() {
                    yce();
                    new FlxTimer().start(0.75, function() {
                        haxe();
                    });
                    new FlxTimer().start(1, function() {
                        yce();
                    });
                });
                new FlxTimer().start(3, function() {
                    FlxTween.tween(_sprite, {alpha: 0}, 2, {ease: FlxEase.quadOut, onComplete: doYceModJamIntro});
                    FlxTween.tween(_text, {alpha: 0}, 2, {ease: FlxEase.quadOut});
                });
            });
	    }
    });

	_sprite = new Sprite();
    FlxG.stage.addChild(_sprite);
	_gfx = _sprite.graphics;
	_text = new TextField();
	_text.selectable = false;
	_text.embedFonts = true;
	var dtf = new TextFormat("Nokia Cellphone FC Small", 16, 0xffffff);
	dtf.align = "center";
	_text.defaultTextFormat = dtf;
	_text.text = "HaxeFlixel";
    FlxG.stage.addChild(_text);
    save.data.haxeLogoStuff.push(_sprite.name);
    save.data.haxeLogoStuff.push(_text.name);
    save.flush();
	onResize(stageWidth, stageHeight);
	FlxG.sound.play(getModJam("sounds/flixel.ogg"));
}

function yce() {
    _text.text = "Yoshi Flixel"; onResize(Lib.current.stage.stageWidth, Lib.current.stage.stageHeight);
    for (i in 0..._functions.length) _functions[i](yceColors[i]);
    _text.textColor = yceColors[_curPart-1];
    FlxG.sound.play(Paths.sound("checkboxChecked"));
}
function haxe() {
    _text.text = "HaxeFlixel"; onResize(Lib.current.stage.stageWidth, Lib.current.stage.stageHeight);
    for (i in 0..._functions.length) _functions[i](_colors[i]);
    _text.textColor = _colors[_curPart-1];
    FlxG.sound.play(Paths.sound("checkboxUnchecked"));
}

function onResize(Width:Int, Height:Int):Void {
	// super.onResize(Width, Height);

	_sprite.x = (Width / 2);
	_sprite.y = (Height / 2) - 20 * FlxG.game.scaleY;

	_text.width = Width / FlxG.game.scaleX;
	_text.x = (Width / 2) - _text.textWidth/2;
	_text.y = _sprite.y + 80 * FlxG.game.scaleY;

	_sprite.scaleX = _text.scaleX = FlxG.game.scaleX;
	_sprite.scaleY = _text.scaleY = FlxG.game.scaleY;
}

var _curPart:Int = 0;
function drawMiddle(color) {
	_gfx.beginFill(color);
	_gfx.moveTo(0, -37);
	_gfx.lineTo(1, -37);
	_gfx.lineTo(37, 0);
	_gfx.lineTo(37, 1);
	_gfx.lineTo(1, 37);
	_gfx.lineTo(0, 37);
	_gfx.lineTo(-37, 1);
	_gfx.lineTo(-37, 0);
	_gfx.lineTo(0, -37);
	_gfx.endFill();
}

function drawTopLeft(color) {
	_gfx.beginFill(color);
	_gfx.moveTo(-50, -50);
	_gfx.lineTo(-25, -50);
	_gfx.lineTo(0, -37);
	_gfx.lineTo(-37, 0);
	_gfx.lineTo(-50, -25);
	_gfx.lineTo(-50, -50);
	_gfx.endFill();
}

function drawTopRight(color) {
	_gfx.beginFill(color);
	_gfx.moveTo(50, -50);
	_gfx.lineTo(25, -50);
	_gfx.lineTo(1, -37);
	_gfx.lineTo(37, 0);
	_gfx.lineTo(50, -25);
	_gfx.lineTo(50, -50);
	_gfx.endFill();
}

function drawBottomLeft(color) {
	_gfx.beginFill(color);
	_gfx.moveTo(-50, 50);
	_gfx.lineTo(-25, 50);
	_gfx.lineTo(0, 37);
	_gfx.lineTo(-37, 1);
	_gfx.lineTo(-50, 25);
	_gfx.lineTo(-50, 50);
	_gfx.endFill();
}

function drawBottomRight(color) {
	_gfx.beginFill(color);
	_gfx.moveTo(50, 50);
	_gfx.lineTo(25, 50);
	_gfx.lineTo(1, 37);
	_gfx.lineTo(37, 1);
	_gfx.lineTo(50, 25);
	_gfx.lineTo(50, 50);
	_gfx.endFill();
}