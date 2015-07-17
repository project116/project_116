attribute vec2 position;
attribute vec2 texCoord;
uniform mat4 ModelViewMatirx;

varying vec2 texCoordVarying;


void main()
{
    //mat2 ModelViewMatirx = mat2(2,0,0,2);
    gl_Position =   vec4(ModelViewMatirx*vec4(position,1.0,1.0));
    texCoordVarying = texCoord;
}