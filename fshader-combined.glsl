#version 300 es
precision mediump float;
precision lowp int;

in vec4 materialColor;
in float fShininess;
in vec3 normal;
in vec4 eyepos;

uniform vec4 ambLight;

uniform vec4 spotlightPos;
uniform vec4 spotlightColor;
uniform vec4 spotlightDirection;

uniform vec4 redLightPos;
uniform vec4 redLightColor;

uniform vec4 greenLightPos;
uniform vec4 greenLightColor;

uniform vec4 whiteLightPos;
uniform vec4 whiteLightColor;

uniform vec4 orangeLight1Pos;
uniform vec4 orangeLight1Color;
uniform vec4 orangeLight1Direction;

uniform vec4 orangeLight2Pos;
uniform vec4 orangeLight2Color;
uniform vec4 orangeLight2Direction;

uniform int SPOTLIGHT;
uniform int FLASHING;
uniform float time;  // Assuming a time uniform for flashing lights

out vec4 fragColor;

vec4 addLight(vec3 pos, vec3 color) {
    vec4 light = vec4(0.0);

    vec3 toLight = normalize(pos - eyepos.xyz);
    vec3 normalDir = normalize(normal);
    vec3 viewDir = normalize(-eyepos.xyz);
    vec3 reflectDir = reflect(-toLight, normalDir);

    float diff = max(dot(normalDir, toLight), 0.0);
    float spec = pow(max(dot(reflectDir, viewDir), 0.0), fShininess);

    light.rgb = (ambLight.rgb + diff + spec) * color;
    light.a = 1.0;

    return light;
}

vec4 addSpotlight(vec3 pos, vec3 dir, vec3 color, float cosTheta) {
    vec4 light = vec4(0.0);

    vec3 toLight = normalize(pos - eyepos.xyz);
    float angle = dot(toLight, normalize(dir));

    if(angle >= cosTheta) {
        light += addLight(pos, color);
    }

    return light;
}

void main() {
    vec4 color = vec4(0,0,0,1);

    // Directional and Point Lights
    color += addLight(redLightPos.xyz, redLightColor.rgb);
    color += addLight(greenLightPos.xyz, greenLightColor.rgb);
    color += addLight(whiteLightPos.xyz, whiteLightColor.rgb);

    // Spotlights
    if (SPOTLIGHT == 1) {
        // Two rotating orange lights above the boat, facing in opposite directions
        color += addSpotlight(orangeLight1Pos.xyz, orangeLight1Direction.xyz, orangeLight1Color.rgb, 0.707); // cos(45°) = 0.707
        color += addSpotlight(orangeLight2Pos.xyz, orangeLight2Direction.xyz, orangeLight2Color.rgb, 0.707); // cos(45°) = 0.707
    }

    // Spotlight
    color += addSpotlight(spotlightPos.xyz, spotlightDirection.xyz, spotlightColor.rgb, 0.766); // cos(40°) for example

    // Flashing Light (if needed)
    if (FLASHING == 1) {
        float flashingFactor = sin(time * 5.0); // Flashing based on time
        color *= flashingFactor;
    }

    fragColor = materialColor * color;
}
