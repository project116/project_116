//
//  Utils116.h
//  116
//
//  Created by baidu on 15/4/2.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Utils116 : NSObject

+(UIImage*) GetgaussianBlurImage:(UIImage*)inputImgae;

+(CGImageRef)CGImageRotatedByAngle:(CGImageRef)imgRef angle:(CGFloat)angle;
@end
