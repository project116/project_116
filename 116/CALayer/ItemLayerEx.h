//
//  ItemLayerEx.h
//  116
//
//  Created by JayGuo on 15/12/7.
//  Copyright © 2015年 baidu. All rights reserved.
//

#ifndef ItemLayerEx_h
#define ItemLayerEx_h

#import <UIKit/UIKit.h>

@interface CItemLayerEx<CAAnimationDelegate> : CALayer

@property (nonatomic) float xRadius;
@property (nonatomic) float yRadius;
@property (nonatomic) float fDuration;

- (id)initWithImages:(NSArray*)images;
- (id)initWithImages:(NSArray*)images Radius:(NSUInteger)radius StartAngle:(float)angle;
- (void)startPlay;
- (void)startPlayEx;
- (void)pausePlay;
- (void)stopPlay;
- (void)resumePlay;
@property (nonatomic) NSUInteger radius;
@property (nonatomic) float startAngle;
@property (nonatomic) BOOL clockWise;

@end // CItemLayerEx

#endif /* ItemLayerEx_h */
