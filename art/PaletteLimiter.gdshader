shader_type canvas_item;

uniform sampler2D palette : hint_black;

void fragment() 
{
	int size = textureSize(palette, 0)[0];
	vec4 col = texture(SCREEN_TEXTURE, SCREEN_UV);
	int final = 0;
	float record_dist = 1000.0;
	for (int i = 0; i <= size; i++)
	{
		vec4 texture_col = texture(palette, vec2(float(i)/float(size), 0.0));
		float dist = distance(col, texture_col);
		if (dist < record_dist)
		{
			final = i;
			record_dist = dist;
		}
	}
	
	col = texture(palette, vec2(float(final)/float(size), 0.0));
	COLOR = col;
}
