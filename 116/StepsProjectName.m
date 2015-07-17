//
//  StepsProjectName.m
//  116
//
//  Created by baidu on 15/4/9.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import "StepsProjectName.h"

@implementation StepsProjectName
+(NSMutableArray*)getSteps
{
    NSMutableArray* stepArray = [[NSMutableArray alloc] init];
    GLKMatrix4 matrixstep1 = GLKMatrix4MakeScale(0.9, 0.9, 0.9);
    _116TextDrawingStep * step1 = [[_116TextDrawingStep alloc]init:0 CanbeDraw:YES Matrix:GLKMatrix4Identity HasRipple:YES];
    _116TextDrawingStep * step2 = [[_116TextDrawingStep alloc]init:1 CanbeDraw:YES Matrix:GLKMatrix4Identity HasRipple:NO];
    _116TextDrawingStep * step3 = [[_116TextDrawingStep alloc]init:2 CanbeDraw:YES Matrix:GLKMatrix4Identity HasRipple:NO];
    _116TextDrawingStep * step4 = [[_116TextDrawingStep alloc]init:3 CanbeDraw:YES Matrix:GLKMatrix4Identity HasRipple:NO];
    _116TextDrawingStep * step5 = [[_116TextDrawingStep alloc]init:4 CanbeDraw:NO Matrix:GLKMatrix4Identity HasRipple:NO];
    _116TextDrawingStep * step6 = [[_116TextDrawingStep alloc]init:4 CanbeDraw:NO Matrix:GLKMatrix4Multiply(GLKMatrix4Multiply(GLKMatrix4Multiply(matrixstep1, matrixstep1),matrixstep1),matrixstep1) HasRipple:NO];
    _116TextDrawingStep * step7 = [[_116TextDrawingStep alloc]init:4 CanbeDraw:NO Matrix:GLKMatrix4Multiply(GLKMatrix4Multiply(GLKMatrix4Multiply(matrixstep1, matrixstep1),matrixstep1),matrixstep1) HasRipple:NO];
    _116TextDrawingStep * step8 = [[_116TextDrawingStep alloc]init:4 CanbeDraw:NO Matrix:GLKMatrix4Multiply(GLKMatrix4Multiply(GLKMatrix4Multiply(matrixstep1, matrixstep1),matrixstep1),matrixstep1) HasRipple:NO];
    _116TextDrawingStep * step9 = [[_116TextDrawingStep alloc]init:4 CanbeDraw:NO Matrix:GLKMatrix4Multiply(GLKMatrix4Multiply(GLKMatrix4Multiply(matrixstep1, matrixstep1),matrixstep1),matrixstep1) HasRipple:NO];
    _116TextDrawingStep * step10 = [[_116TextDrawingStep alloc]init:4 CanbeDraw:NO Matrix:GLKMatrix4Multiply(GLKMatrix4Multiply(GLKMatrix4Multiply(matrixstep1, matrixstep1),matrixstep1),matrixstep1) HasRipple:NO];
    [stepArray addObject:step1];
    [stepArray addObject:step2];
    [stepArray addObject:step3];
    [stepArray addObject:step4];
    [stepArray addObject:step5];
    [stepArray addObject:step6];
    [stepArray addObject:step7];
    [stepArray addObject:step8];
    [stepArray addObject:step9];
    [stepArray addObject:step10];

    return stepArray;
}
@end
