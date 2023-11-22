// Made with Raf's StageToHX
var bg:FlxSprite;
var water:FlxSprite;
var zoomin:Bool = false;
var dance:Bool = false;

function create() {

	PlayState.add(PlayState.gf);

	bg = new FlxSprite(-366, -192);
	bg.loadGraphic(Paths.image('stages/lisreal2401/Untitled'));
	bg.antialiasing = true;
	bg.scale.set(2.4, 2.4);
	bg.updateHitbox();
	PlayState.add(bg);

	PlayState.add(PlayState.dad);

	PlayState.add(PlayState.boyfriend);

	water = new FlxSprite(-425, -120);
	water.loadGraphic(Paths.image('stages/lisreal2401/Untitled - Copy'));
	water.alpha = 0;
	water.antialiasing = true;
	water.scale.set(2.6, 2.6);
	water.updateHitbox();
	PlayState.add(water);
}

function stepHit() {
	switch (curStep) {
		case 302, 560, 624, 688, 762, 560, 1328:
			FlxG.camera.flash();
		case 560:
			zoomin = true;
		case 816:
			zoomin = false;
		case 1328:
			FlxTween.tween(water, {y: -100, alpha:0.3}, 0.5, {ease:FlxEase.quadInOut, type:PINGPONG});
			for(e in [gf, bg, dad, boyfriend, scoreTxt, camHUD])
				FlxTween.tween(e, {y: -100, alpha:0}, 5, {ease:FlxEase.quadInOut});
	}
}
function beatHit() {
	if (zoomin) {
		dance = !dance;
		switch (dance) {
			case pattern: 
				FlxG.camera.zoom += 0.1;
			default:
				FlxG.camera.zoom -= 0.1;
		}
		
	}
}