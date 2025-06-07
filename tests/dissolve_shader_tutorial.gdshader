shader_type spatial;
render_mode cull_disabled, depth_prepass_alpha;

uniform sampler2D base_texture : hint_default_black;
uniform sampler2D inside_texture : hint_default_white;

uniform float dissolve_threshold : hint_range(0, 1);
uniform sampler2D dissolve_texture;

void vertex() {

}

void fragment() {

	float dissolve_sample = texture(dissolve_texture, UV).r;
	if (dissolve_sample < dissolve_threshold)
		discard;

	vec4 base = texture(base_texture, UV);
	vec4 inside = texture(inside_texture, UV);

	if (FRONT_FACING)
		ALBEDO = base.rgb;
	else
		ALBEDO = inside.rgb;

	ALPHA = base.a;


}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
