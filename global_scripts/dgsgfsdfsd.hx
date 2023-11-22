import flixel.text.FlxText;
import flixel.FlxSprite;
import flixel.text.FlxTextBorderStyle;
function create()
{
    var credit:String = '';
    switch (PlayState.curSong) {
        case 'March 31st': 
            credit = 'Song By Smash Bandicoot';
            
    }
    creditsWatermark = new FlxText(4, 0 + 50, 0, credit, 16);
		creditsWatermark.setFormat(Paths.font("vcr.ttf"), 16, 0xFFFFFFFF, "center", FlxTextBorderStyle.OUTLINE, 0xFF000000);
		creditsWatermark.scrollFactor.set();
		creditsWatermark.borderSize = 1.25;
		add(creditsWatermark);
		creditsWatermark.cameras = [PlayState.camHUD];
}