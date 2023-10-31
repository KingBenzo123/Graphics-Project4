#version 300 es
precision mediump float;
precision lowp int;

in vec4 vPosition;
in vec4 vColor;
in vec3 vNormal;
in float vShininess;

uniform mat4 model_view;
uniform mat4 projection;

out vec4 materialColor;
out vec3 normal;
out vec4 eyepos;
out float fShininess;

void main() {
    eyepos = model_view * vPosition; // Convert to eye space
    gl_Position = projection * eyepos;
    normal = normalize(mat3(model_view) * vNormal); // Convert normal to eye space
    materialColor = vColor;
    fShininess = vShininess;
}
