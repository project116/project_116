//
//  116TextDrawingStep.m
//  116
//
//  Created by baidu on 15/4/2.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import "116TextDrawingStep.h"

@implementation _116TextDrawingStep

-(_116TextDrawingStep*) init:(int)index CanbeDraw:(BOOL)canbedraw Matrix:(GLKMatrix4)matrix HasRipple:(BOOL)hasripple
{
    self = [super init];
    sampleIndex = index;
    _canbeDraw = canbedraw;
    _model2ImageMatrix = matrix;
    _Hhasripple = hasripple;
    return self;
}
-(int) getSampleIndex
{
    return sampleIndex;
}
@end
