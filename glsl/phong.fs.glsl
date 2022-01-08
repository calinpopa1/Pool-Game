/*
Uniforms already defined by THREE.js
------------------------------------------------------
uniform mat4 viewMatrix; = camera.matrixWorldInverse
uniform vec3 cameraPosition; = camera position in world space
------------------------------------------------------
*/
in vec3 normalInterp;
in vec3 vertPos;
uniform sampler2D textureMask; //Texture mask, color is different depending on whether this mask is white or black.
uniform sampler2D textureNumberMask; //Texture containing the billard ball's number, the final color should be black when this mask is black.
uniform vec3 maskLightColor; //Ambient/Diffuse/Specular Color when textureMask is white
uniform vec3 materialDiffuseColor; //Diffuse color when textureMask is black (You can assume this is the default color when you are not using textures)
uniform vec3 materialSpecularColor; //Specular color when textureMask is black (You can assume this is the default color when you are not using textures)
uniform vec3 materialAmbientColor; //Ambient color when textureMask is black (You can assume this is the default color when you are not using textures)
uniform float shininess; //Shininess factor

uniform vec3 lightDirection; //Direction of directional light in world space
uniform vec3 lightColor; //Color of directional light
uniform vec3 ambientLightColor; //Color of ambient light
in vec2 uv2;
in vec3 kd;
in vec3 ks;
in vec3 ka;


void main() {
	//TODO: PHONG SHADING
	//Use Phong reflection model
	//Hint: Compute necessary vectors in vertex shader for interpolation, pass the vectors to fragment shader, then compute shading in fragment shader
	
	//Before applying textures, assume that materialDiffuseColor/materialSpecularColor/materialAmbientColor are the default diffuse/specular/ambient color.
	//For textures, you can first use texture2D(textureMask, uv) as the billard balls' color to verify correctness, then use mix(...) to re-introduce color.
	//Finally, mix textureNumberMask too so numbers appear on the billard balls and are black.
	
	//Placeholder color
	vec3 N=normalize(normalInterp);
	vec3 L=-normalize(viewMatrix*vec4(lightDirection,0.0)).xyz;

	float lambertian = max(dot(N, L), 0.0);
  	float specular = 0.0;

	if(lambertian > 0.0) {
    vec3 R = reflect(-L, N);      
    vec3 V = normalize(-vertPos); 
    
    float specAngle = max(dot(R, V), 0.0);
    specular = pow(specAngle, shininess);
  	}

	vec3 kd= mix(materialDiffuseColor,maskLightColor,texture2D(textureMask,uv2).xyz);
	vec3 ks= mix(materialSpecularColor,maskLightColor,texture2D(textureMask,uv2).xyz);
	vec3 ka= mix(materialAmbientColor,maskLightColor,texture2D(textureMask,uv2).xyz);
	

	vec4 color = vec4(ambientLightColor*ka +
                      lambertian * lightColor*kd +
                      specular * lightColor*ks, 1.0);

	gl_FragColor=color*(texture2D(textureNumberMask,uv2));
	
	

	
}