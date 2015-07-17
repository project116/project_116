//
//  Utils116.m
//  116
//
//  Created by baidu on 15/4/2.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import "Utils116.h"
#import <Accelerate/Accelerate.h>

@implementation Utils116

+(UIImage*) GetgaussianBlurImage:(UIImage*)inputImgae
{
    static int16_t gaussianblur_kernel[25] = {
        1, 4, 6, 4, 1,
        4, 16, 24, 16, 4,
        6, 24, 36, 24, 6,
        4, 16, 24, 16, 4,
        1, 4, 6, 4, 1
    };
    
    const size_t width = inputImgae.size.width;
    const size_t height = inputImgae.size.height;
    const size_t bytesPerRow = width * 4;
    
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    CGContextRef bmContext = CGBitmapContextCreate(NULL, width, height, 8, bytesPerRow, space, kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedFirst);
    CGColorSpaceRelease(space);
    if (!bmContext)
        return nil;
    
    CGContextDrawImage(bmContext, (CGRect){.origin.x = 0.0f, .origin.y = 0.0f, .size.width = width, .size.height = height}, inputImgae.CGImage);
    
    UInt8* data = (UInt8*)CGBitmapContextGetData(bmContext);
    if (!data)
    {
        CGContextRelease(bmContext);
        return nil;
    }
    
    const size_t n = sizeof(UInt8) * width * height * 4;
    void* outt = malloc(n);
    vImage_Buffer src = {data, height, width, bytesPerRow};
    vImage_Buffer dest = {outt, height, width, bytesPerRow};
    
    vImageConvolve_ARGB8888(&src, &dest, NULL, 0, 0, gaussianblur_kernel, 5, 5, 256, NULL, kvImageCopyInPlace);
    
    memcpy(data, outt, n);
    free(outt);
    
    CGImageRef blurredImageRef = CGBitmapContextCreateImage(bmContext);
    UIImage* blurred = [UIImage imageWithCGImage:blurredImageRef];
    
    CGImageRelease(blurredImageRef);
    CGContextRelease(bmContext);
    
    return blurred;
}

+ (CGImageRef)CGImageRotatedByAngle:(CGImageRef)imgRef angle:(CGFloat)angle
{
    CGFloat angleInRadians = angle * (M_PI / 180);
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGRect imgRect = CGRectMake(0, 0, width, height);
    CGAffineTransform transform = CGAffineTransformMakeRotation(angleInRadians);
    CGRect rotatedRect = CGRectApplyAffineTransform(imgRect, transform);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef bmContext = CGBitmapContextCreate(NULL,
                                                   rotatedRect.size.width,
                                                   rotatedRect.size.height,
                                                   8,
                                                   0,
                                                   colorSpace,
                                                   kCGImageAlphaPremultipliedFirst);
    CGContextSetAllowsAntialiasing(bmContext, YES);
    CGContextSetInterpolationQuality(bmContext, kCGInterpolationHigh);
    CGColorSpaceRelease(colorSpace);
    CGContextTranslateCTM(bmContext,
                          +(rotatedRect.size.width/2),
                          +(rotatedRect.size.height/2));
    CGContextRotateCTM(bmContext, angleInRadians);
    CGContextDrawImage(bmContext, CGRectMake(-width/2, -height/2, width, height),
                       imgRef);
    
    CGImageRef rotatedImage = CGBitmapContextCreateImage(bmContext);
    CFRelease(bmContext);
    
    return rotatedImage;
}

@end

