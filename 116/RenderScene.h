//
//  RenderScene.h
//  116
//
//  Created by baidu on 15/4/2.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "116TextDrawelement.h"

@interface RenderScene : NSObject
{
    NSMutableArray * Objects;
    int stepnumber;
    EAGLContext * context;
    GLuint _program;
}

-(RenderScene*) initWithContext:(EAGLContext *)context;
-(void) render;
-(void) AddObject:(_116TextDrawelement *) object;
@end
