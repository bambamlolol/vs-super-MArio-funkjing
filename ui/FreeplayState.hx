import('flixel.text.FlxTextBorderStyle');

function createPost() {
  var label = new FlxText(FlxG.width-256, FlxG.height-32, 0, 'Press C to Open Credits', 16);
  label.setBorderStyle(FlxTextBorderStyle.OUTLINE, 0xFF000000, 2);
  label.scrollFactor.set();
  state.add(label);
}

function update(elapsed) {
  if (FlxG.keys.justPressed.C) {
    FlxG.switchState(new CreditsState());
  }
} 