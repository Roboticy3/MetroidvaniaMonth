shader_type spatial;

uniform vec4 color : source_color;
uniform sampler2D bayer;

void fragment() {
	if (texture(bayer, FRAGCOORD.xy / 4.0).r > color.a) {
		ALPHA = 0.0;
	}
	else {
		ALPHA = 1.0;
	}
}