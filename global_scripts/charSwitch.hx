//a

/**
* So, i might re-use this script for optimisations so yipee !!
* it does lag a bit but thats fine if your name is swordcube and your i7 laptop can't handle
* 2gb of ram from YoshiCrafterEngine :troll:
* 
* But anyways still a good idea to have this as an option, if your stage quality is high or smth
* with an option that exists alr, then it will toggle ljPreload or ycePreload
* 
* ALSO PRELOAD ASYNC IS BROKEN IT CRASHES YOUR GAME DO NOT USE IT !!!!
* 
* After looking through source, i guess i will have to make my own mod save state, so yay !!
*/

var ljCharPreload:Array<Character> = [];
var defaultDad:Dynamic;
var defaultBF:Dynamic;
var defaultGF:Dynamic;
function createPost() {
    defaultDad = PlayState.dad;
    defaultBF = PlayState.boyfriend;
    defaultGF = PlayState.gf;
    for (char in [PlayState.dad, PlayState.boyfriend, PlayState.gf]) ljCharPreload.push(char);
    for (event in PlayState.SONG.events) {
    switch(event.name) {
        case "characterSwitch", "switchCharacter", "changeCharacter":
            var switchWho; var switchTo; var charAlpha; var loadingWay; var xVal; var yVal;
            var parameters = event.parameters;
            for (i in 4...6) {
            switch(parameters[i]) {
                case "PlayState.dad.x", "dad.x": (i == 5)?xVal = PlayState.dad.x : yVal = PlayState.dad.x;
                case "PlayState.dad.y", "dad.y": (i == 5)?xVal = PlayState.dad.y : yVal = PlayState.dad.y;
                case "defaultDad.x": (i == 5)?xVal = defaultDad.x : yVal = defaultDad.x;
                case "defaultDad.y": (i == 5)?xVal = defaultDad.y : yVal = defaultDad.y;
                
                case "PlayState.boyfriend.x", "boyfriend.x", "bf.x": (i == 5)?xVal = PlayState.boyfriend.x : yVal = PlayState.boyfriend.x;
                case "PlayState.boyfriend.y", "boyfriend.y", "bf.y": (i == 5)?xVal = PlayState.boyfriend.y : yVal = PlayState.boyfriend.y;
                case "defaultBF.x": (i == 5)?xVal = defaultBF.x : yVal = defaultBF.x;
                case "defaultBF.y": (i == 5)?xVal = defaultBF.y : yVal = defaultBF.y;
                
                case "PlayState.gf.x", "gf.x": (i == 5)?xVal = PlayState.gf.x : yVal = PlayState.gf.x;
                case "PlayState.gf.y", "gf.y": (i == 5)?xVal = PlayState.gf.y : yVal = PlayState.gf.y;
                case "defaultGF.x": (i == 5)?xVal = defaultGF.x : yVal = defaultGF.x;
                case "defaultGF.y": (i == 5)?xVal = defaultGF.y : yVal = defaultGF.y;

                default: (i == 5)?xVal = Std.parseFloat(parameters[i]) : yVal = Std.parseFloat(parameters[i]);
                }
            }
            var switchSplit = parameters[1].split(":");
            if (switchSplit[1] == null) switchTo = mod+":"+parameters[1];
            else switchTo = mod+parameters[1];
            charAlpha = Std.parseFloat(parameters[2]);
            loadingWay = Std.string(parameters[3]);
            switchWho = Std.string(parameters[0]);
            switch(loadingWay) {
                case "preloadCharacter", "ycePreload":
                    switch(switchWho.toLowerCase()) {
                        case "dad","playstate.dad","opponent","0": 
                            PlayState.dad.preloadCharacter(switchTo);
                        case "boyfriend","playstate.boyfriend","bf","1": 
                            PlayState.boyfriend.preloadCharacter(switchTo);
                        case "gf","playstate.gf","2":
                            PlayState.gf.preloadCharacter(switchTo);
                    }
                case "preloadCharacterAsync", "ycePreloadAsync":
                    switch(switchWho.toLowerCase()) {
                        case "dad","playstate.dad","opponent","0": 
                            PlayState.dad.preloadCharacterAsync(switchTo);
                        case "boyfriend","playstate.boyfriend","bf","1": 
                            PlayState.boyfriend.preloadCharacterAsync(switchTo);
                        case "gf","playstate.gf","2":
                            PlayState.gf.preloadCharacterAsync(switchTo);
                    }
                case "ljPreload", "lj":
                    for (char in ljCharPreload) if (char.curCharacter == switchTo) continue;
                    var newChar = new Character(xVal,yVal, switchTo);
                    newChar.updateHitbox();
                    newChar.visible = false;
                    if (alpha != "" || !Math.isNaN(alpha)) newChar.alpha = alpha;
                    add(newChar);
                    ljCharPreload.push(newChar);
            }
        case "onPsychEvent":
            var name = event.parameters[0];
            switch(name) {
                case "characterSwitch", "switchCharacter", "changeCharacter", "Character Change", "Change Character":
                    switch(event.parameters[1].toLowerCase()) {
                        case "dad","playstate.dad","opponent","0": 
                            PlayState.dad.preloadCharacter(event.parameters[2]);
                        case "boyfriend","playstate.boyfriend","bf","1": 
                            PlayState.boyfriend.preloadCharacter(event.parameters[2]);
                        case "gf","playstate.gf","2":
                            PlayState.gf.preloadCharacter(event.parameters[2]);
                    }
                default: continue;
            }
        }
    }
}

/**
 * [Switches Character duh]
 * @param switchWho - The Targeted Character To Change (dad = Opponent Side | bf = Players Side | gf = Gf (duh)) [String]
 * @param switchTo - The Character You Want the Target Character to transform into [String]
 * @param charAlpha - The Alpha of the new character [Float / Int]
 * @param loadingWay - How you want to load the Character (Reccomend "ljPreload") [String]
 * @param xVal - X POS of Character (you can also set to ex: dad.x) [Float / Int]
 * @param yVal - Y POS of Character (you can also set to ex: boyfriend.y) [Float / Int] 
 */
function characterSwitch(switchWho:String,switchTo:String,?charAlpha,?loadingWay:String,?xVal,?yVal) {
    // REMINDER !!! ALL INPUTS WILL BE A STRING !!!!!
    // IF YOU WANT TO MAKE IT A INT OR FLOAT DO: `Std.parseInt(value)` OR `Std.parseFloat(value)`
    var characterSwitchTo;
    var switchSplit = switchTo.split(":");
    if (switchSplit[1] == null) characterSwitchTo = mod+":"+switchTo;
    else characterSwitchTo = mod+switchTo;
    switch(loadingWay) {
        case "preloadCharacter", "ycePreload":
            switch(switchWho.toLowerCase()) {
                case "dad","playstate.dad","opponent","0": 
                    PlayState.dad.switchCharacter(switchTo);
                    switchHealthbar(PlayState.dad, PlayState.iconP2);
                case "boyfriend","playstate.boyfriend","bf","1": 
                    PlayState.boyfriend.switchCharacter(switchTo);
                    switchHealthbar(PlayState.boyfriend, PlayState.iconP1);
                case "gf","playstate.gf","2":
                    PlayState.gf.switchCharacter(switchTo);
            }
        case "preloadCharacterAsync", "ycePreloadAsync":
            switch(switchWho.toLowerCase()) {
                case "dad","playstate.dad","opponent","0": 
                    PlayState.dad.switchCharacterAsync(switchTo);
                    switchHealthbar(PlayState.dad, PlayState.iconP2);
                case "boyfriend","playstate.boyfriend","bf","1": 
                    PlayState.boyfriend.switchCharacterAsync(switchTo);
                    switchHealthbar(PlayState.boyfriend, PlayState.iconP1);
                case "gf","playstate.gf","2":
                    PlayState.gf.switchCharacterAsync(switchTo);
            }
        case "ljPreload", "lj":
            for (char in ljCharPreload) {
                if (char.curCharacter != characterSwitchTo) continue;
                remove(char);
                switch(switchWho.toLowerCase()) {
                    case "dad","playstate.dad","opponent","0":
                        insert(members.indexOf(PlayState.dad), char);
                        remove(PlayState.dad);
                        dads[0] = char;
                        switchHealthbar(dads[0], PlayState.iconP2);
                    case "boyfriend","playstate.boyfriend","bf","1":
                        insert(members.indexOf(PlayState.boyfriend), char);
                        remove(PlayState.boyfriend);
                        boyfriends[0] = char;
                        switchHealthbar(boyfriends[0], PlayState.iconP1);
                    case "gf","playstate.gf","2":
                        insert(members.indexOf(PlayState.gf), char);
                        remove(PlayState.gf);
                        PlayState.gf = char;
                }
                char.visible = true;
                return;
            }
        trace("somehow the character doesn't exist, crazy");
    }
}

function onPsychEvent(event:String, ?value1, ?value2) {
    switch(event) {
        case "characterSwitch", "switchCharacter", "changeCharacter", "Character Change", "Change Character":
            switch(value1.toLowerCase()) {
                case "dad","playstate.dad","opponent","0": 
                    PlayState.dad.switchCharacter(value2);
                    switchHealthbar(PlayState.dad, PlayState.iconP2);
                case "boyfriend","playstate.boyfriend","bf","1": 
                    PlayState.boyfriend.switchCharacter(value2);
                    switchHealthbar(PlayState.boyfriend, PlayState.iconP1);
                case "gf","playstate.gf","2":
                    PlayState.gf.switchCharacter(value2);
            }
    }
}

function switchCharacter(switchWho:String,switchTo:String,?charAlpha,?loadingWay:String,?xVal,?yVal)
characterSwitch(switchWho,switchTo,charAlpha,loadingWay,xVal,yVal);
function changeCharacter(switchWho:String,switchTo:String,?charAlpha,?loadingWay:String,?xVal,?yVal)
characterSwitch(switchWho,switchTo,charAlpha,loadingWay,xVal,yVal);

function switchHealthbar(changeTo:Character, icon) {
	if (icon.curCharacter == changeTo.curCharacter) return;
	icon.changeCharacter(changeTo.curCharacter, mod);
    PlayState.healthBar.createFilledBar(changeTo.getColors()[0], boyfriends[0].getColors()[0]);
    PlayState.health -= 0.0001;
    PlayState.health += 0.0001;
}