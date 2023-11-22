import openfl.filters.ShaderFilter;
import flixel.FlxCamera;
import openfl.Lib;
import WindowsAPI;
var shader;
function createPost() {

	shader = new CustomShader(mod + ":gitchy funni");
	shader.shaderData.offset.value = [0.85];
	shader.shaderData.iTime.value = [1];
	shader.shaderData.iResolution.value = [69, 420];

	dad.shader = [shader];
}