//
//  116TextDrawelement.h
//  116
//
//  Created by baidu on 15/4/2.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "116TextDrawingStep.h"
#import "RippleModel.h"
enum
{
    ATTRIB_VERTEX,
    ATTRIB_TEXCOORD,
    ATTRIB_COLOR,
    NUM_ATTRIBUTES
};
@interface _116TextDrawelement : NSObject
{
    NSString * stringTobeDraw;
    UIFont * stringfont;
    CGRect  elementRect;
    CGRect  insideRect;
    unsigned int textureNumStart;
    GLuint program;
    
    NSMutableArray * textureArray;//<int, GLenum>
    NSMutableArray * ImageArray;//<int, UIImage*>
    
    // data passed to GL
    GLfloat * vertexbuffer;
    GLfloat * texturebuffer;
    GLushort *Indicies;
    
    unsigned int vertexCount;
    unsigned int textureCount;
    unsigned int poolHeight;
    unsigned int poolWidth;
    float texCoordFactorS;
    float texCoordOffsetS;
    float texCoordFactorT;
    float texCoordOffsetT;
    GLuint _positionVBO;
    GLuint _texcoordVBO;
    GLuint _indexVBO;
    GLuint _locationposition;
    GLuint _localtiontextrue;
    
    UIImage * stringImageBackUp;
    GLKMatrix4 model2ImageMatrix;
    NSMutableArray * stepArray;//116TextDrawingStep.h
    
    RippleModel * _ripple;
}

-(void) DrawStep:(int)stepIndex;
-(_116TextDrawelement*) initWithText:(NSString*) text ElementRect:(CGRect)rect1 TextRect:(CGRect)rect2 UIFont:(UIFont*)font TextureNumStart:(unsigned int)number Program:(GLuint)_program Matrix:(GLKMatrix4)matrix;

-(void) AddStep:(_116TextDrawingStep*)step;
-(void) SetStepArray:(NSMutableArray*)array;
@end
