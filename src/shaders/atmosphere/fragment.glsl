uniform vec3 uSunDirection;
uniform vec3 uAtmosphereDayColor;
uniform vec3 uAtmosphereTwilightColor;

varying vec3 vNormal;
varying vec3 vPosition;

void main()
{
    vec3 viewDirection = normalize(vPosition - cameraPosition);
    vec3 normal = normalize(vNormal);
    vec3 color = vec3(0.0);

    float sunOriantation = dot(uSunDirection,normal);

    float atmosphereDayMix = smoothstep(- 0.5, 1.0, sunOriantation);
    vec3 atmosphereColor = mix(uAtmosphereTwilightColor, uAtmosphereDayColor, atmosphereDayMix);
    color += atmosphereColor;

    float edgeAlpa = dot(viewDirection,normal);
    edgeAlpa = smoothstep(0.0,0.5,edgeAlpa);

    float dayAlpa = smoothstep(-0.5,0.0,sunOriantation);

    float alpha = edgeAlpa * dayAlpa;



    // Final color
    gl_FragColor = vec4(color, alpha);
    #include <tonemapping_fragment>
    #include <colorspace_fragment>
}