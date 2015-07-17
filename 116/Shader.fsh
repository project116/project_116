


uniform sampler2D SamplerRGB;


varying highp vec2 texCoordVarying;

void main()
{
    gl_FragColor = texture2D(SamplerRGB, texCoordVarying);
    //gl_FragColor = vec4(1,1,1,1);
}

