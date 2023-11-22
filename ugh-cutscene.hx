var bgFight:FlxSprite;

var peppinoPortrait:FlxSprite;

var marioPortrait:FlxSprite;

var logo:FlxSprite;

var cutSceneDone = false;
function createPost() {
    trace("CurScene");
    FlxG.sound.play(Paths.sound('pizza'));
    bgFight = new FlxSprite();
    bgFight.cameras = [camHUD];
    bgFight.makeGraphic(1280, 720, FlxColor.WHITE);
    add(bgFight);

    peppinoPortrait = new FlxSprite(-900,380);
    peppinoPortrait.color = 0xFF000000;
    peppinoPortrait.loadGraphic(Paths.image("peppino/BossPeppino"));
    peppinoPortrait.cameras = [camHUD];
    add(peppinoPortrait);
    peppinoPortrait.scale.set(1.3, 1.3);

    marioPortrait = new FlxSprite(5050,270);
    marioPortrait.color = 0xFF000000;
    marioPortrait.loadGraphic(Paths.image("peppino/BossEnemy"));
    marioPortrait.cameras = [camHUD];
    add(marioPortrait);
    marioPortrait.scale.set(1.3, 1.3);

    FlxTween.tween(peppinoPortrait, { x:0}, 0.8, 
        { 
            ease:FlxEase.quadOut
        }
    );

    FlxTween.tween(marioPortrait, { x:800}, 1.4, 
        { 
            ease:FlxEase.quadOut
        }
    );


    new FlxTimer().start(1.5, function(tmr:FlxTimer)
    {
        camHUD.fade(0xFFFFFFFF, 1.2, false);
    });


    new FlxTimer().start(3, function(tmr:FlxTimer)
    {
        camHUD.fade(0xFFFFFFFF, 1.3, true);
        camHUD.shake();
        peppinoPortrait.color = 0xFFFFFFFF;
        marioPortrait.color = 0xFFFFFFFF;
        bgFight.loadGraphic(Paths.image("peppino/BossBG"));

        logo = new FlxSprite(200,290);
        logo.loadGraphic(Paths.image("peppino/BossName"));
        logo.cameras = [camHUD];
        add(logo);
        logo.scale.set(1.3, 1.3);
    });


    new FlxTimer().start(7, function(tmr:FlxTimer)
    {
        remove(bgFight);
        remove(peppinoPortrait);
        remove(marioPortrait);
        remove(logo);
        cutSceneDone = true;
        inCutscene = false;
        Conductor.songPosition = 0;
    });
}

function preUpdate(elapsed) {
    if (!cutSceneDone) {
        inCutscene = true;
        Conductor.songPosition = -6000;
    }
}

function onCountdown(val:Int) {
    return false;
    }