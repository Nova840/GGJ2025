shader_type canvas_item;

uniform float speed : hint_range(0.0, 5.0) = 0.5;
uniform float amplitude : hint_range(0.0, 1.0) = 0.06;
uniform float frequency : hint_range(0.0, 10.0) = 2.0;
uniform float color_ripple_strength : hint_range(0.0, 1.0) = 0.2;
uniform vec4 color_shift : source_color = vec4(1.0, 1.0, 1.0, 1.0);

void fragment() {
    float t = TIME * speed;

    vec2 distorted_uv = UV;
    distorted_uv.x += sin(distorted_uv.y * frequency + t) * amplitude;
    distorted_uv.y += cos(distorted_uv.x * frequency + t * 0.7) * amplitude;

    vec4 base_color = texture(TEXTURE, distorted_uv);

    // Simple color ripple
    float ripple = sin((UV.x + UV.y) * 10.0 + t * 2.0) * color_ripple_strength;

    // Multiply base by color_shift
    // (If you want to add ripple to e.g. the green channel, do so below)
    base_color.r *= color_shift.r;
    base_color.g *= color_shift.g + ripple;
    base_color.b *= color_shift.b;
    base_color.a *= color_shift.a;

    COLOR = base_color;
}
