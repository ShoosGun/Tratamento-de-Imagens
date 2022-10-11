#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

void main() {
	float radius = 100.0;
	if(pow(gl_FragCoord.x - u_mouse.x, 2.0) + pow(gl_FragCoord.y - u_mouse.y, 2.0)
	 < radius)
		gl_FragColor = vec4(0.0,0.0,0.0,0.0);
	else
		gl_FragColor = vec4(1.0, 0.0,1.0,1.0);
	
}

vec4 red()
{
	return vec4(1.0, 0.0, 0.0, 1.0);
}
