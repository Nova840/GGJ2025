shader_type canvas_item;

// Warp speed of the distortion animation
uniform float speed : hint_range(0.0, 10.0) = 2.0;

// Amplitude (strength) of the wavy distortion
uniform float amplitude : hint_range(0.0, 1.0) = 0.15;

// Frequency (number of waves across the texture)
uniform float frequency : hint_range(0.0, 10.0) = 4.0;

// Multiplier for overall color tint
uniform vec4 color_shift : source_color = vec4(1.0, 1.0, 1.0, 1.0);

// Strength of the color-separation glitch (chromatic aberration)
uniform float color_separation : hint_range(0.0, 1.0) = 0.05;

void fragment()
{
    // Time-based factor for animation
    float t = TIME * speed;

    // Start with the original UV
    vec2 uv = UV;

    // Distort the UVs using sine & cosine waves
    uv.x += sin(uv.y * frequency + t) * amplitude;
    uv.y += cos(uv.x * frequency + t * 0.7) * amplitude;

    // For a glitch effect, we'll sample the texture 3 times with slight offsets
    // that shift over time, creating a color-separation or "chromatic aberration."

    // Offsets for each color channel
    vec2 offset_r = vec2(
        color_separation * 0.5 * sin(t * 2.0),
        color_separation * 0.5 * cos(t * 2.0)
    );
    vec2 offset_g = vec2(
        -color_separation * 0.5 * cos(t * 1.5),
        color_separation * 0.5 * sin(t * 1.5)
    );
    vec2 offset_b = vec2(
        color_separation * 0.5 * sin(t * 1.2),
        -color_separation * 0.5 * cos(t * 1.2)
    );

    // Sample the texture separately for R, G, and B with offsets
    float r = texture(TEXTURE, uv + offset_r).r;
    float g = texture(TEXTURE, uv + offset_g).g;
    float b = texture(TEXTURE, uv + offset_b).b;

    vec4 final_color = vec4(r, g, b, 1.0);

    // Apply color tint or filter
    final_color *= color_shift;

    // Output the result
    COLOR = final_color;
}
