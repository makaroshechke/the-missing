shader_type canvas_item;

uniform vec2 light_center = vec2(0.5, 0.45);
uniform float radius = 0.55;
uniform float softness = 0.45;
uniform float darkness = 0.65;
uniform vec4 warm_color : source_color = vec4(1.0, 0.78, 0.45, 0.18);

void fragment() {
	vec2 uv = UV;
	float dist = distance(uv, light_center);
	float vignette = smoothstep(radius, radius - softness, dist);
	vec4 dark = vec4(0.0, 0.0, 0.0, darkness);
	vec4 warm = warm_color * vignette;
	COLOR = mix(dark, warm, vignette);
}