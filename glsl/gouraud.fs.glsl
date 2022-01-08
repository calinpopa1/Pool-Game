/*
Uniforms already defined by THREE.js
------------------------------------------------------
uniform mat4 viewMatrix; = camera.matrixWorldInverse
uniform vec3 cameraPosition; = camera position in world space
------------------------------------------------------
*/

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
in vec3 lambertianLight;
in vec3 specularLight;
in vec4 couleur;

void main() {
	//TODO: GOURAUD SHADING
	//Use Phong reflection model
	//Hint: Compute shading in vertex shader, then pass it to the fragment shader for interpolation
	
	//Before applying textures, assume that materialDiffuseColor/materialSpecularColor/materialAmbientColor are the default diffuse/specular/ambient color.
	//For textures, you can first use texture2D(textureMask, uv) as the billard balls' color to verify correctness, then use mix(...) to re-introduce color.
	//Finally, mix textureNumberMask too so numbers appear on the billard balls and are black.
	
	//Placeholder color
	vec3 kd= mix(materialDiffuseColor,maskLightColor,texture2D(textureMask,uv2).xyz);
	vec3 ks= mix(materialSpecularColor,maskLightColor,texture2D(textureMask,uv2).xyz);
	vec3 ka= mix(materialAmbientColor,maskLightColor,texture2D(textureMask,uv2).xyz);
	
	//couleur= (texture2D(textureNumberMask,uv))*couleur;
	//gl_FragColor = couleur*(texture2D(textureNumberMask,uv));
	gl_FragColor = vec4(ka*ambientLightColor+ks*specularLight+kd*lambertianLight,1.0)*(texture2D(textureNumberMask,uv2));
}