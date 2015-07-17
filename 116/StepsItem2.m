//
//  StepsItem2.m
//  116
//
//  Created by baidu on 15/4/9.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import "StepsItem2.h"

@implementation StepsItem2
+(NSMutableArray*)getSteps
{
    NSMutableArray* stepArray = [[NSMutableArray alloc] init];
    GLKMatrix4 matrixstep1 = GLKMatrix4MakeScale(0.5, 0.5, 0.5);
    _116TextDrawingStep * step1 = [[_116TextDrawingStep alloc]init:0 CanbeDraw:YES Matrix:GLKMatrix4Identity HasRipple:YES];
    _116TextDrawingStep * step2 = [[_116TextDrawingStep alloc]init:1 CanbeDraw:YES Matrix:matrixstep1 HasRipple:NO];
    _116TextDrawingStep * step3 = [[_116TextDrawingStep alloc]init:2 CanbeDraw:YES Matrix:matrixstep1 HasRipple:NO];
    _116TextDrawingStep * step4 = [[_116TextDrawingStep alloc]init:3 CanbeDraw:YES Matrix:matrixstep1 HasRipple:NO];
    _116TextDrawingStep * step5 = [[_116TextDrawingStep alloc]init:4 CanbeDraw:YES Matrix:matrixstep1 HasRipple:NO];
    [stepArray addObject:step1];
    [stepArray addObject:step2];
    [stepArray addObject:step3];
    [stepArray addObject:step4];
    [stepArray addObject:step5];
    return stepArray;
}
@end
