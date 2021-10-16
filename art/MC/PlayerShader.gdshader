shader_type canvas_item;

uniform bool hit;

void fragment()
{
	vec4 col = texture(TEXTURE, UV);
	if (hit)
	{
		COLOR.a = col.a * texture(TEXTURE, UV).a;
	}
	else
	{
		COLOR = col;
	}
}