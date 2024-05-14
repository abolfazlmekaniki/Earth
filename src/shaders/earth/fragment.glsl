uniform sampler2D uDayTexture;
uniform sampler2D uNightTexture;
uniform sampler2D uSpecularClourdsTexture;
uniform vec3 uSunDirection;
uniform vec3 uAtmosphereDayColor;
uniform vec3 uAtmosphereTwilightColor;
varying vec2 vUv;
varying vec3 vNormal;
varying vec3 vPosition;

void main()
{
    vec3 viewDirection = normalize(vPosition - cameraPosition);
    vec3 normal = normalize(vNormal);
    vec3 color = vec3(0.0);

    float sunOriantation = dot(uSunDirection,normal);


    float dayMix = smoothstep(-0.25,0.5,sunOriantation);
    vec3 dayColor = texture(uDayTexture,vUv).rgb;
    vec3 nightColor = texture(uNightTexture,vUv).rgb;
    color = mix(nightColor,dayColor,dayMix);

    vec2 specularCloudsColor = texture(uSpecularClourdsTexture,vUv).rg;

    float cloudMix = smoothstep(0.5,1.0,specularCloudsColor.g);
    cloudMix *= dayMix;
    color = mix(color,vec3(1.0),cloudMix);

    float fresel = dot(viewDirection,normal) + 1.0;
    fresel = pow(fresel,2.0);

    float atmosphereDayMix = smoothstep(- 0.5, 1.0, sunOriantation);
    vec3 atmosphereColor = mix(uAtmosphereTwilightColor, uAtmosphereDayColor, atmosphereDayMix);
    color = mix(color,atmosphereColor,fresel*atmosphereDayMix);


    vec3 reflection = reflect(- uSunDirection, normal);
    float specular = - dot(reflection, viewDirection);
    specular = max(specular, 0.0);
    specular = pow(specular, 32.0);
    specular *= specularCloudsColor.r;
    vec3 specularColor = mix(vec3(1.0),atmosphereColor,fresel);
    color += specular * specularColor;


    // Final color
    gl_FragColor = vec4(color, 1.0);
    #include <tonemapping_fragment>
    #include <colorspace_fragment>
}