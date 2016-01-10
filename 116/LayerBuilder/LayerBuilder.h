//
//  LayerBuilder.h
//  116
//
//  Created by JayGuo on 15/12/21.
//  Copyright © 2015年 baidu. All rights reserved.
//

#ifndef LayerBuilder_h
#define LayerBuilder_h

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

@interface LayerBuilder : NSObject
- (instancetype)initWithView:(UIView*)parent;
- (void)build:(NSArray*)items;
- (void)stopAndClear;
- (void)resumePlay;
- (void)pausePlay;
@end //LayerBuilder

#endif /* LayerBuilder_h */
