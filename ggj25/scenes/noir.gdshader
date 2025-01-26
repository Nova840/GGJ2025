shader_type canvas_item;

// How much to desaturate the base image: 0.0 = no change, 1.0 = full grayscale
uniform float desaturation : hint_range(0.0, 1.0) = 0.8;

// How much to darken edges for a vignette effect
uniform float vignette_strength : hint_range(0.0, 2.0) = 1.0;
// How far from the center the vignette starts (smaller = heavier dark corners)
uniform float vignette_radius : hint_range(0.0, 2.0) = 1.0;

// Subtle color tint you might want to apply overall (e.g., a faint bluish cast)
uniform vec4 color_tint : source_color = vec4(1.0, 1.0, 1.0, 1.0);

// Strength of film-like grain/flicker
uniform float grain_strength : hint_range(0.0, 0.5) = 0.1;
// Speed at which the noise changes over time (flicker)
uniform float grain_speed : hint_range(0.0, 5.0) = 1.0;

void fragment()
{
    // SAMPLE BASE TEXTURE
    vec4 base_color = texture(TEXTURE, UV);

    // DESATURATION
    // Convert color to grayscale, then interpolate between original and grayscale
    float gray = dot(base_color.rgb, vec3(0.299, 0.587, 0.114));
    vec3 desat_color = mix(base_color.rgb, vec3(gray), desaturation);

    // VIGNETTE
    // Distance of this pixel from screen center in UV space ([0..1, 0..1])
    vec2 center = vec2(0.5, 0.5);
    float dist = distance(UV, center);
    // The vignette factor: near center = 1.0, far from center = < 1.0
    // We can adjust how quickly it drops off with `vignette_radius`
    float vignette = 1.0 - smoothstep(vignette_radius * 0.0, vignette_radius, dist);
    // The final factor is reduced by vignette_strength
    vignette = mix(1.0, vignette, vignette_strength);

    // NOISE / GRAIN
    // We'll generate pseudo-random noise using time, UV, and a simple function
    // This is not true random but enough for a grainy flicker
    float t = TIME * grain_speed;
    // Combine UV + time in a hash-like expression
    float noise = fract(sin(dot(UV * vec2(100.0,100.0), vec2(12.9898,78.233)) + t) * 43758.5453);
    // Center the noise around 0: from -0.5 to +0.5
    noise -= 0.5;
    // Mix the noise into our color based on grain_strength
    vec3 grain_color = desat_color + noise * grain_strength;

    // APPLY COLOR TINT
    vec3 final_rgb = grain_color * color_tint.rgb;
    float final_a  = base_color.a * color_tint.a;

    // APPLY VIGNETTE to final output
    final_rgb *= vignette;

    COLOR = vec4(final_rgb, final_a);
}
