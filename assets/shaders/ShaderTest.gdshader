shader_type canvas_item;

uniform sampler2D noise;
uniform float scale = 1.0;
uniform float peak_radius = 0.0;
uniform float cutoff = 1.0;


void fragment() {
	float x = UV.x - 0.5;
	float y = UV.y - 0.5;
	float r_sq = x*x + y*y;
	float r = pow(r_sq, 0.5) - peak_radius;
	float f = pow((1.0/(1.0 + 20.0*r*r)), 3.0);
	//vec4 sample = texture(noise, (UV-vec2(0.5, 0.5))*(1.0-f) + vec2(0.5, 0.5));
	vec4 sample = texture(noise, vec2(0.5, 0.5) + scale*(UV - vec2(0.5, 0.5)) * (1.0-0.8*f)) + 0.8*f;
	
	
	float fac = 1.0;
	if (sample.x > cutoff){
		fac = 0.0;
	}
	
	COLOR = vec4(fac, fac, fac, 1.0);
}
