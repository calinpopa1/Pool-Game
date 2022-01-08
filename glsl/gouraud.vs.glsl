/*
Uniforms already defined by THREE.js
------------------------------------------------------
uniform mat4 modelMatrix; = object.matrixWorld
uniform mat4 modelViewMatrix; = camera.matrixWorldInverse * object.matrixWorld
uniform mat4 projectionMatrix; = camera.projectionMatrix
uniform mat4 viewMatrix; = camera.matrixWorldInverse
uniform mat3 normalMatrix; = inverse transpose of modelViewMatrix
uniform vec3 cameraPosition; = camera position in world space
attribute vec3 position; = position of vertex in local space
attribute vec3 normal; = direction of normal in local space
attribute vec2 uv; = uv coordinates of current vertex relative to texture coordinates
------------------------------------------------------
*/

//Custom defined Uniforms for TP3
//attribute vec3 position;
//attribute vec3 normal;
//uniform mat4 projectionMatrix,modelViewMatrix,modelMatrix;
out vec3 normalInterp;
out vec3 vertPos;


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

out vec4 couleur;
out vec3 kd;
out vec3 ks;
out vec3 ka;
out vec3 lambertianLight;
out vec3 specularLight;
out vec2 uv2;


void main() {
	uv2=uv;
	//TODO: GOURAUD SHADING
	//Use Phong reflection model
	//Hint: Compute shading in vertex shader, then pass it to the fragment shader for interpolation
	
	//Before applying textures, assume that materialDiffuseColor/materialSpecularColor/materialAmbientColor are the default diffuse/specular/ambient color.
	//For textures, you can first use texture2D(textureMask, uv) as the billard balls' color to verify correctness, then use mix(...) to re-introduce color.
	//Finally, mix textureNumberMask too so numbers appear on the billard balls and are black.
	
    // Multiply each vertex by the model-view matrix and the projection matrix to get final vertex position

	
	vec4 relativeVertexPosition = modelViewMatrix * vec4(position, 1.0);
	vertPos= vec3(relativeVertexPosition)/relativeVertexPosition.w;
	normalInterp=vec3(normalMatrix*normal);
    gl_Position = projectionMatrix * relativeVertexPosition ;

	vec3 N= normalize(normalInterp);
	vec3 L= -normalize(viewMatrix*vec4(lightDirection,0.0)).xyz;
	float lambertian =max(dot(N,L),0.0);
	float specular=0.0;
	if(lambertian > 0.0) {
    vec3 R = reflect(-L, N);      
    vec3 V = normalize(-vertPos); 
    // Compute the specular term
    float specAngle = max(dot(R, V), 0.0);
    specular = pow(specAngle, shininess);
  	}

	lambertianLight= lambertian*lightColor;
	specularLight= specular*lightColor;

	couleur = vec4( materialAmbientColor*ambientLightColor+
               lambertian * materialDiffuseColor*lightColor +
               specular * materialSpecularColor*lightColor, 1.0);
	
}
