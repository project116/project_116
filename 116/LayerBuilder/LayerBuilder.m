//
//  LayerBuilder.m
//  116
//
//  Created by JayGuo on 15/12/21.
//  Copyright © 2015年 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LayerBuilder.h"
#import "ItemLayerEx.h"
#import "VerticalWriteLabel.h"
#import "Utils116.h"
#import "../NSString+VerticalNSString.h"
#import "EventDefine.h"

@interface LayerBuilder ()
{
}
@property (nonatomic) NSUInteger circleCounts;
@property (nonatomic) NSUInteger objCountsPerCircle;
@property (nonatomic) NSArray* circleRadius;
@property (nonatomic) NSArray* circleFontSize;
@property (nonatomic) float startLayoutAngle;
@property (nonatomic) NSUInteger createIndex;
@property (nonatomic) float maxBlurRadius;
@property (nonatomic) CGPoint center;
@property (nonatomic) UIView* parentView;
@property (nonatomic) NSUInteger actualCount;
@property (nonatomic) NSMutableArray* objArray;
@property (nonatomic) NSDate* animationStartTime;
@property (nonatomic) NSUInteger targetIndex;
@end

@implementation LayerBuilder

- (instancetype)initWithView:(UIView*)parent {
    self = [super init];
    if (self) {
        self.circleCounts = 3;
        self.objCountsPerCircle = 3;
        self.startLayoutAngle = 40.f;
        self.createIndex = 0;
        self.maxBlurRadius = 8.f;
        self.actualCount = 0;
        self.center = CGPointMake(parent.bounds.size.width/2, parent.bounds.size.height/2);
        self.parentView = parent;
        self.targetIndex = 0;
    }
    
    return self;
}

- (void)build:(NSArray*)items {
    self.actualCount = items.count;
    
    CGRect bounds = [[UIScreen mainScreen] bounds];
    float maxRadius = 0.f;
    float kRaito = bounds.size.width / bounds.size.height;
    
    if (self.actualCount <= self.circleCounts) {
        maxRadius = bounds.size.width/2 - 30.f;
    }
    else if (self.actualCount < self.circleCounts*2) {
        maxRadius = bounds.size.width/2 - 15.f;
    }
    else {
        maxRadius = bounds.size.width/2 + 10.f;
    }

    self.circleRadius = [NSArray arrayWithObjects:
                         [NSNumber numberWithFloat:maxRadius-50.f],
                         [NSNumber numberWithFloat:maxRadius],
                         [NSNumber numberWithFloat:maxRadius-100.f], nil];
    
    self.circleFontSize = [NSArray arrayWithObjects:
                           [NSNumber numberWithFloat:28.f],
                           [NSNumber numberWithFloat:34.f],
                           [NSNumber numberWithFloat:22.f], nil];
    
    [self.parentView.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        self.objArray = [NSMutableArray arrayWithCapacity:items.count];
        for (id obj in items) {
            [self.objArray addObject:[self createItemLayer:(NSString*)obj]];
            self.createIndex++;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSUInteger cnt1 = self.parentView.layer.sublayers.count;
            for (id obj in self.objArray) {
                [self.parentView.layer addSublayer:obj];
            }
            
            [self setPauseTrigger];
        });
    });
}

- (void)setPauseTrigger {
    self.targetIndex = arc4random() % self.actualCount;
    
    float animationTime = 0.f;
    NSUInteger idx = 0;
    for (id obj in self.objArray) {
        [obj startPlayEx];
        CItemLayerEx* item = obj;
        if (idx == self.targetIndex) {
            animationTime = ((360.f - item.startAngle)/360.f + 2.f) * item.fDuration;
        }
        idx++;
    }
    
    self.animationStartTime = [NSDate dateWithTimeIntervalSinceNow:0];
    [NSTimer scheduledTimerWithTimeInterval:animationTime target:self selector:@selector(onTimer:) userInfo:nil repeats:NO];
}

- (void)stopAndClear {
    for (id obj in self.objArray) {
        [obj stopPlay];
    }
    
    if (self.parentView) {
        [self.parentView.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    }
}

- (void)resumePlay {
    for (id obj in self.objArray) {
        [obj resumePlay];
    }
    
    [self setPauseTrigger];
}

- (void)pausePlay {
    for (id obj in self.objArray) {
        [obj pausePlay];
    }
}

- (void)onTimer:(NSTimer*)timer {
    for (id obj in self.objArray) {
        [obj pausePlay];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_PROJECT_ANIMATION_STOP object:nil];
}

- (void)stopAnimationAndPickOneItem {
    NSDate* currentTime = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval delta = currentTime.timeIntervalSinceNow - self.animationStartTime.timeIntervalSinceNow;
    
}

- (float)getCurrentRadius {
    NSUInteger idx = self.createIndex % self.circleCounts;
    
    if (idx < self.circleRadius.count) {
         return [[self.circleRadius objectAtIndex:idx] floatValue];
    }
    
    return 0;
}

- (float)getCurrentFontSize {
    NSUInteger idx = self.createIndex % self.circleCounts;
    
    if (idx < self.circleFontSize.count) {
        return [[self.circleFontSize objectAtIndex:idx] floatValue];
    }
    
    return 24.f;
}

- (float)getCurrentAngle {
    //min angle
    //return self.startLayoutAngle + self.createIndex * ((360/self.objCountsPerCircle)/self.circleCounts);
    return self.startLayoutAngle + self.createIndex * ((360/self.actualCount));
}

- (float)getBlurRadiusByStartAngle:(float)angle {
    return self.maxBlurRadius * (angle / 180.f);
}

- (CItemLayerEx*)createItemLayer:(NSString*)item {
    CItemLayerEx* result = nil;
    
    do
    {
        float fontSize = [self getCurrentFontSize];
        float startAngle = [self getCurrentAngle];
        float radius = [self getCurrentRadius];
        float startBlurRadius = [self getBlurRadiusByStartAngle:startAngle];
        
        
        if (!item) break;
        
        VerticalWriteLabel* vLabel = [[VerticalWriteLabel alloc]init];
        vLabel.font = [UIFont systemFontOfSize:fontSize];
        NSArray* array = [item spliteChineseEnglish:item];
        [vLabel setVerticalTextGroup:array];
        
        UIImage* origImage = [Utils116 GetSnapshot:vLabel];
        UIImage* maxBlurImage = [Utils116 GetgaussianBlurImage:origImage Radius:self.maxBlurRadius];
        UIImage* startBlurImage = [Utils116 GetgaussianBlurImage:origImage Radius:startBlurRadius];
        
        NSMutableArray* imageArray = [NSMutableArray arrayWithObjects:
                                      origImage,
                                      maxBlurImage,
                                      startBlurImage,
                                      nil];
        
        result = [[CItemLayerEx alloc] initWithImages:imageArray Radius:radius StartAngle:startAngle];
        [result  setFrame:CGRectMake(self.center.x-vLabel.frame.size.width/2, self.center.y-vLabel.frame.size.height/2+arc4random()%40, vLabel.frame.size.width, vLabel.frame.size.height)];

    } while(false);
    
    return  result;
}


@end
