#version 150
#define WIDTH 2 // int
uniform sampler2D InSampler;

in vec2 texCoord;
in vec2 oneTexel;

out vec4 fragColor;

void main() {
    vec4 center = texture(InSampler, texCoord);

    // Early exit for fully transparent pixels
    if (center == vec4(0)) {
        fragColor = vec4(0);
        return;
    }

    bool edge = false;

    // Edge detection
    for (int i = -WIDTH; i <= WIDTH; i++) {
        if (i == 0) continue; // Skip the center pixel

        // Check horizontal and vertical neighbors
        vec4 right = texture(InSampler, texCoord + vec2(oneTexel.x * i, 0.0));
        vec4 down = texture(InSampler, texCoord + vec2(0.0, oneTexel.y * i));

        // Check diagonal neighbors
        vec4 diag1 = texture(InSampler, texCoord + vec2(oneTexel.x * i, oneTexel.y * i));
        vec4 diag2 = texture(InSampler, texCoord + vec2(oneTexel.x * i, oneTexel.y * -i));

        // Check for differences in any direction
        if (any(notEqual(center, right)) || any(notEqual(center, down)) ||
            any(notEqual(center, diag1)) || any(notEqual(center, diag2))) {
            edge = true;
            break; // Exit early if an edge is detected
        }
    }

    // Output color logic
    vec4 outColor = vec4(center.rgb, 0.3); // Default alpha = 0.3

    // Special case for black pixels
    if (center == vec4(0, 0, 0, 1)) {
        outColor.rgb = vec3(0.01);
    }

    // Apply edge detection result
    if (edge) {
        outColor = vec4(center.rgb, 1.0); // Full alpha for edges
    }

    // Final output
    fragColor = outColor;

    // Code by @argent.blade optimized with DeepSeek
}