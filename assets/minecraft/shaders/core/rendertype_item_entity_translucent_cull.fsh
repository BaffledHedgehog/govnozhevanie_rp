#version 150

#moj_import <minecraft:fog.glsl>

uniform sampler2D Sampler0;

uniform vec4 ColorModulator;
uniform float FogStart;
uniform float FogEnd;
uniform vec4 FogColor;

in float vertexDistance;
in vec4 vertexColor;
in vec2 texCoord0;
in vec2 texCoord1;

out vec4 fragColor;

void main() {

    vec4 color;
    vec4 rawColor = texture(Sampler0, texCoord0);
    
    
    int checkAlpha = int(rawColor.a * 255);
    
    if (checkAlpha == 254) {
        color = rawColor;
    } else if (checkAlpha == 24) {
        color = vec4(rawColor.rgb,0.04);
    } else {
        color = rawColor * vertexColor * ColorModulator;
    }

    if ((color.a < 0.1 && color.a > 0.05) || color.a < 0.001) {
        discard;
    }
    fragColor = linear_fog(color, vertexDistance, FogStart, FogEnd, FogColor);
    
    
}
