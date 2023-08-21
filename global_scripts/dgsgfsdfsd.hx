import flixel.text.FlxText;
import flixel.FlxSprite;
var text:FlxText;
function create()
{
    // Create a white graphic with 50% alpha
    var whiteGraphic:FlxSprite = new FlxSprite();
    whiteGraphic.makeGraphic(300, 100, 0xFFFF0000);
    whiteGraphic.alpha = 0.5;
    whiteGraphic.x = -400;
    whiteGraphic.y = (FlxG.height - whiteGraphic.height) / 7;
    add(whiteGraphic);
    whiteGraphic.cameras = [PlayState.camHUD];
    
    // Create text
    text = new FlxText(whiteGraphic.x, whiteGraphic.y, whiteGraphic.width, "Hello, HaxeFlixel!");
    text.setFormat(Paths.font("vcr.ttf"), 32, 0xFF000000, "left");
    add(text);
    text.cameras = [PlayState.camHUD];
}

function onPreSongStart() {
    FlxTween.tween(text, {x: 0}, 0.3, {ease: FlxEase.quintInOut});
}

function onSongStart() {
    FlxTween.tween(text, {x: -500}, 0.3, {ease: FlxEase.quintInOut});
}