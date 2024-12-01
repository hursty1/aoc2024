shader_type canvas_item;
render_mode blend_mix;

uniform sampler2D Screen: source_color, filter_linear_mipmap, hint_screen_texture;

void fragment () {
	COLOR.rgb = textureLod(Screen, SCREEN_UV, 2.0).rgb;
}