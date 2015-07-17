//
//  RenderScene.m
//  116
//
//  Created by baidu on 15/4/2.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import "RenderScene.h"
#import "StepsItem1.h"
#import "StepsItem2.h"
#import "StepsItem3.h"
#import "StepsProjectName.h"
#import "DataCenter116.h"

@implementation RenderScene

-(RenderScene*) initWithContext:(EAGLContext *)_context
{
    self = [super init];
    Objects = [[NSMutableArray alloc]init];
    stepnumber = 0;
    context = _context;
    [self setUpContext];
    
    GLKMatrix4 matrix = GLKMatrix4MakeTranslation(-0.5, 0, 0);
    matrix = GLKMatrix4Multiply(matrix,  GLKMatrix4MakeScale(0.5, 0.5, 0.5));
    
    Project116 * curproj = [[DataCenter116 GetInstance]GetCurrentProject];
    _116TextDrawelement * projectitem = [[_116TextDrawelement alloc]initWithText:@"晚饭" ElementRect:CGRectMake(0, 0, 300, 600) TextRect:CGRectMake(50, 180, 200, 200) UIFont:[UIFont italicSystemFontOfSize:80] TextureNumStart:0 Program:_program Matrix:GLKMatrix4Identity];
    [self AddObject:projectitem];
    
    [projectitem SetStepArray:[StepsProjectName getSteps]];
    
    GLKMatrix4 matrixyy = GLKMatrix4MakeTranslation(0.5, 0, 0);
    matrixyy = GLKMatrix4Multiply(matrixyy,  GLKMatrix4MakeScale(0.5, 0.5, 0.5));
    _116TextDrawelement * yy = [[_116TextDrawelement alloc]initWithText:@"yyy" ElementRect:CGRectMake(0, 0, 300, 300) TextRect:CGRectMake(50, 50, 200, 200) UIFont:[UIFont italicSystemFontOfSize:80] TextureNumStart:0 Program:_program Matrix:matrixyy];
    [self AddObject:yy];
    
    [yy SetStepArray:[StepsItem1 getSteps]];
    
    return self;
}

-(void) AddObject:(_116TextDrawelement *) object
{
    [Objects addObject:object];
}

-(void) render
{
    glClearColor(1, 1, 1, 1);
    glClear(GL_COLOR_BUFFER_BIT);
    
    if (stepnumber == 100) {
        stepnumber = 99;
    }
    for (int i = 0; i < Objects.count; i++) {
        [(_116TextDrawelement*)[Objects objectAtIndex:i] DrawStep:stepnumber];
    }
    stepnumber ++;
}

- (void)setUpContext
{
    [EAGLContext setCurrentContext:context];
    
    [self loadShaders];
    
    glUseProgram(_program);
}

#pragma mark - OpenGL ES 2 shader compilation




- (BOOL)loadShaders
{
    GLuint vertShader, fragShader;
    NSString *vertShaderPathname, *fragShaderPathname;
    
    // Create shader program.
    _program = glCreateProgram();
    
    // Create and compile vertex shader.
    vertShaderPathname = [[NSBundle mainBundle] pathForResource:@"Shader" ofType:@"vsh"];
    if (![self compileShader:&vertShader type:GL_VERTEX_SHADER file:vertShaderPathname]) {
        NSLog(@"Failed to compile vertex shader");
        return NO;
    }
    
    // Create and compile fragment shader.
    fragShaderPathname = [[NSBundle mainBundle] pathForResource:@"Shader" ofType:@"fsh"];
    if (![self compileShader:&fragShader type:GL_FRAGMENT_SHADER file:fragShaderPathname]) {
        NSLog(@"Failed to compile fragment shader");
        return NO;
    }
    
    // Attach vertex shader to program.
    glAttachShader(_program, vertShader);
    
    // Attach fragment shader to program.
    glAttachShader(_program, fragShader);
    
    // Bind attribute locations.
    glBindAttribLocation(_program, ATTRIB_VERTEX, "position");
    glBindAttribLocation(_program, ATTRIB_TEXCOORD, "texCoord");
    
    // This needs to be done prior to linking.
    
    
    // Link program.
    if (![self linkProgram:_program]) {
        NSLog(@"Failed to link program: %d", _program);
        
        if (vertShader) {
            glDeleteShader(vertShader);
            vertShader = 0;
        }
        if (fragShader) {
            glDeleteShader(fragShader);
            fragShader = 0;
        }
        if (_program) {
            glDeleteProgram(_program);
            _program = 0;
        }
        
        return NO;
    }
        
    // Release vertex and fragment shaders.
    if (vertShader) {
        glDetachShader(_program, vertShader);
        glDeleteShader(vertShader);
    }
    if (fragShader) {
        glDetachShader(_program, fragShader);
        glDeleteShader(fragShader);
    }
    
    return YES;
}

- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file
{
    GLint status;
    const GLchar *source;
    
    source = (GLchar *)[[NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil] UTF8String];
    if (!source) {
        NSLog(@"Failed to load vertex shader");
        return NO;
    }
    
    *shader = glCreateShader(type);
    glShaderSource(*shader, 1, &source, NULL);
    glCompileShader(*shader);
    
#if defined(DEBUG)
    GLint logLength;
    glGetShaderiv(*shader, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetShaderInfoLog(*shader, logLength, &logLength, log);
        NSLog(@"Shader compile log:\n%s", log);
        free(log);
    }
#endif
    
    glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
    if (status == 0) {
        glDeleteShader(*shader);
        return NO;
    }
    
    return YES;
}

- (BOOL)linkProgram:(GLuint)prog
{
    GLint status;
    glLinkProgram(prog);
    
#if defined(DEBUG)
    GLint logLength;
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program link log:\n%s", log);
        free(log);
    }
#endif
    
    glGetProgramiv(prog, GL_LINK_STATUS, &status);
    if (status == 0) {
        return NO;
    }
    
    return YES;
}
@end
