//
//  116TextDrawingStep.h
//  116
//
//  Created by baidu on 15/4/2.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface _116TextDrawingStep : NSObject
{
    int sampleIndex;//从第几个sample采样
    
    
}
@property ( nonatomic) GLKMatrix4 model2ImageMatrix;
@property(nonatomic) BOOL Hhasripple;
@property(nonatomic) BOOL canbeDraw;
-(_116TextDrawingStep*) init:(int)index CanbeDraw:(BOOL)canbedraw Matrix:(GLKMatrix4)matrix HasRipple:(BOOL)hasripple;

-(int) getSampleIndex;
@end
