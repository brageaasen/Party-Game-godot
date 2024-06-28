shader_type canvas_item;

uniform float circle_size : hint_range(0, 1) = 0.5;
uniform float gradient_strength : hint_range(0, 1) = 0.5;

vec4 dither(vec2 position, float intensity) {
    // Simple 2x2 Bayer matrix for dithering
    float x = float(mod(position.x, 2.0));
    float y = float(mod(position.y, 2.0));
    float threshold = (x + y * 2.0) / 4.0;
    return intensity < threshold ? vec4(0.0) : vec4(0.0, 0.0, 0.0, 1.0);
}

void fragment() {
    vec2 uv = UV;
    vec2 center = vec2(0.5, 0.5);
    float dist = distance(center, uv);

    // Calculate gradient intensity based on distance
    float intensity = smoothstep(circle_size, circle_size + gradient_strength, dist);

    if (dist < circle_size) {
        discard;
    } else {
        // Apply dithering based on intensity
        COLOR = dither(FRAGCOORD.xy, intensity);
    }
}
