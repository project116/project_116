//
//  ItemLayerEx.m
//  116
//
//  Created by JayGuo on 15/12/7.
//  Copyright © 2015年 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ItemLayerEx.h"

@interface CItemLayerEx()
{
    NSMutableArray* imageArray;
}

- (NSUInteger)getImageCount;
- (UIImage*)getImageAtIndex:(NSUInteger)idx;
- (void)resetState;
@end

@implementation CItemLayerEx

- (id)initWithImages:(NSArray*)images {
    self = [super init];
    if (self) {
        self->imageArray = [[NSMutableArray alloc] initWithArray:images];
        [self resetState];
    }
    
    return self;
}


- (id)initWithImages:(NSArray*)images
              Radius:(NSUInteger)radius
               StartAngle:(float)angle {
    self = [super init];
    if (self) {
        self->imageArray = [[NSMutableArray alloc] initWithArray:images];
        [self resetState];
        self.radius = radius;
        self.startAngle = angle;
    }
    
    return self;
}

- (void)animationDidStart:(CAAnimation *)anim {
    
}

/* Called when the animation either completes its active duration or
 * is removed from the object it is attached to (i.e. the layer). 'flag'
 * is true if the animation reached the end of its active duration
 * without being removed. */

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
}

CATransform3D CATransform3DMakePerspective(CGPoint center, float disZ)
{
    CATransform3D transToCenter = CATransform3DMakeTranslation(-center.x, -center.y, 0);
    CATransform3D transBack = CATransform3DMakeTranslation(center.x, center.y, 0);
    CATransform3D scale = CATransform3DIdentity;
    scale.m34 = 1.0f/disZ;
    return CATransform3DConcat(CATransform3DConcat(transToCenter, scale), transBack);
}

CATransform3D CATransform3DPerspect(CATransform3D t, CGPoint center, float disZ)
{
    return CATransform3DConcat(t, CATransform3DMakePerspective(center, disZ));
}

- (double)angle2Radian:(float)angle {
    return M_PI * angle / 180;
}

- (void)startPlayEx {
    {
        CAKeyframeAnimation* kfAnimation = [CAKeyframeAnimation animation];
        CGPoint center = self.position;
/*        CGAffineTransform t1 = CGAffineTransformConcat(CGAffineTransformMakeTranslation(-center.x, -center.y), CGAffineTransformMakeScale(self.yRadius/self.xRadius, 1.f));
        CGAffineTransform t2 = CGAffineTransformConcat(t1, CGAffineTransformMakeTranslation(center.x, center.y));
 */
        CGMutablePathRef path = CGPathCreateMutable();
        float startRidian = [self angle2Radian:self.startAngle] + -1*M_PI_2;
        CGPathAddArc(path, nil, center.x, center.y, self.radius, startRidian, startRidian+2*M_PI, 0);
        
        kfAnimation.path = path;
        kfAnimation.duration = self.fDuration;
        
        NSArray<NSNumber*> *array = [NSArray arrayWithObjects:
                                     [NSNumber numberWithFloat:0.0f],
                                     [NSNumber numberWithFloat:0.25f],
                                     [NSNumber numberWithFloat:0.5f],
                                     [NSNumber numberWithFloat:0.75],
                                     [NSNumber numberWithFloat:1.0f], nil];
        
        kfAnimation.keyTimes = array;
        kfAnimation.calculationMode = kCAAnimationLinear;
        kfAnimation.repeatCount = HUGE_VAL;
        kfAnimation.delegate = self;
        [self addAnimation:kfAnimation forKey:@"position.x"];
    }
    
    {
        CAKeyframeAnimation* kfAnimation = [CAKeyframeAnimation animation];
        /*
         -180表示从原始位置向z轴内部运动，这里的Y坐标0没有任何作用，你可以改成120等，都没有变化.我理解可能是这样的，animation的作用目标是zPosition，
         zPosition是个float，那么它非常智能只取path中每个point的x值即可！
         */
        
        // use (0,0) as center point of z-ellipse
        CGPoint center = CGPointZero;
        center.x -= self.xRadius;
 /*       CGAffineTransform t1 = CGAffineTransformConcat(CGAffineTransformMakeTranslation(-center.x, -center.y), CGAffineTransformMakeScale(1.f, self.yRadius/self.xRadius));
        CGAffineTransform t2 = CGAffineTransformConcat(t1, CGAffineTransformMakeTranslation(center.x, center.y));
  */
        CGMutablePathRef path = CGPathCreateMutable();
        float startRidian = [self angle2Radian:self.startAngle];
        CGPathAddArc(path, nil, center.x, center.y, self.radius, startRidian, 2*M_PI+startRidian, 0);
        kfAnimation.path = path;
        
        NSArray<NSNumber*> *array = [NSArray arrayWithObjects:
                                     [NSNumber numberWithFloat:0.0f],
                                     [NSNumber numberWithFloat:0.25f],
                                     [NSNumber numberWithFloat:0.5f],
                                     [NSNumber numberWithFloat:0.75],
                                     [NSNumber numberWithFloat:1.0f], nil];
        
        kfAnimation.keyTimes = array;
        
        kfAnimation.duration = self.fDuration;
        kfAnimation.repeatCount = HUGE_VALF;
        kfAnimation.calculationMode = kCAAnimationLinear;
        kfAnimation.delegate = self;
        [self addAnimation:kfAnimation forKey:@"zPosition"];
    }
    
    CAKeyframeAnimation* kfAnimationOfContent = [CAKeyframeAnimation animation];
    
    NSArray<NSNumber*> *keyTimes = nil;
    if (self.startAngle > 180 && self.clockWise) {
        kfAnimationOfContent.values = [NSArray arrayWithObjects:
                                       (id)[[self getImageAtIndex:2]CGImage],
                                       (id)[[self getImageAtIndex:0]CGImage],
                                       (id)[[self getImageAtIndex:1]CGImage],
                                       (id)[[self getImageAtIndex:2]CGImage],
                                       nil];
        
        float percent = 0.5*(360.f - self.startAngle) / 180.f;
        
        keyTimes = [NSArray arrayWithObjects:
                    [NSNumber numberWithFloat:0.0f],
                    [NSNumber numberWithFloat:percent],
                    [NSNumber numberWithFloat:0.5f+percent],
                    [NSNumber numberWithFloat:1.f],
                    nil];

    }
    else {
        kfAnimationOfContent.values = [NSArray arrayWithObjects:
                                       (id)[[self getImageAtIndex:2]CGImage],
                                       (id)[[self getImageAtIndex:1]CGImage],
                                       (id)[[self getImageAtIndex:0]CGImage],
                                       (id)[[self getImageAtIndex:2]CGImage],
                                       nil];
        
        float percent = 0.5*(180.f - self.startAngle)/180;
        
        keyTimes = [NSArray arrayWithObjects:
                 [NSNumber numberWithFloat:0.0f],
                 [NSNumber numberWithFloat:percent],
                 [NSNumber numberWithFloat:percent+0.5f],
                 [NSNumber numberWithFloat:1.0f],
                 nil];
    }
    
    kfAnimationOfContent.keyTimes = keyTimes;
    kfAnimationOfContent.duration = self.fDuration;
    kfAnimationOfContent.repeatCount = HUGE_VALF;
    
    kfAnimationOfContent.calculationMode = kCAAnimationLinear;
    
    [self addAnimation:kfAnimationOfContent forKey:@"contents"];
}

- (void)startPlay {
    {
        CAKeyframeAnimation* kfAnimation = [CAKeyframeAnimation animation];
        CGPoint center = self.position;
        CGAffineTransform t1 = CGAffineTransformConcat(CGAffineTransformMakeTranslation(-center.x, -center.y), CGAffineTransformMakeScale(self.yRadius/self.xRadius, 1.f));
        CGAffineTransform t2 = CGAffineTransformConcat(t1, CGAffineTransformMakeTranslation(center.x, center.y));
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddArc(path, &t2, center.x, center.y, self.xRadius, M_PI_2, 2.5*M_PI, 0);
        
        kfAnimation.path = path;
        kfAnimation.duration = self.fDuration;
        
        NSArray<NSNumber*> *array = [NSArray arrayWithObjects:
                                     [NSNumber numberWithFloat:0.0f],
                                     [NSNumber numberWithFloat:0.25f],
                                     [NSNumber numberWithFloat:0.5f],
                                     [NSNumber numberWithFloat:0.75],
                                     [NSNumber numberWithFloat:1.0f], nil];
        
        kfAnimation.keyTimes = array;
        kfAnimation.calculationMode = kCAAnimationLinear;
        kfAnimation.repeatCount = HUGE_VAL;
        [self addAnimation:kfAnimation forKey:@"position.x"];
    }
    
    {
        CAKeyframeAnimation* kfAnimation = [CAKeyframeAnimation animation];
        /*
         -180表示从原始位置向z轴内部运动，这里的Y坐标0没有任何作用，你可以改成120等，都没有变化.我理解可能是这样的，animation的作用目标是zPosition，
         zPosition是个float，那么它非常智能只取path中每个point的x值即可！
         */
        
        // use (0,0) as center point of z-ellipse
        CGPoint center = CGPointZero;
        center.x -= self.xRadius;
        CGAffineTransform t1 = CGAffineTransformConcat(CGAffineTransformMakeTranslation(-center.x, -center.y), CGAffineTransformMakeScale(1.f, self.yRadius/self.xRadius));
        CGAffineTransform t2 = CGAffineTransformConcat(t1, CGAffineTransformMakeTranslation(center.x, center.y));
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddArc(path, &t2, center.x, center.y, self.xRadius, 0, 2*M_PI, 0);
        kfAnimation.path = path;
        
        NSArray<NSNumber*> *array = [NSArray arrayWithObjects:
                                     [NSNumber numberWithFloat:0.0f],
                                     [NSNumber numberWithFloat:0.25f],
                                     [NSNumber numberWithFloat:0.5f],
                                     [NSNumber numberWithFloat:0.75],
                                     [NSNumber numberWithFloat:1.0f], nil];
        
        kfAnimation.keyTimes = array;
        
        kfAnimation.duration = self.fDuration;
        kfAnimation.repeatCount = HUGE_VALF;
        kfAnimation.calculationMode = kCAAnimationLinear;
        [self addAnimation:kfAnimation forKey:@"zPosition"];
    }

    CAKeyframeAnimation* kfAnimationOfContent = [CAKeyframeAnimation animation];
    kfAnimationOfContent.values = [NSArray arrayWithObjects:
                                   (id)[[self getImageAtIndex:0]CGImage],
                                   (id)[[self getImageAtIndex:1]CGImage],
                                   (id)[[self getImageAtIndex:0]CGImage],
                                   nil];
    
    kfAnimationOfContent.duration = self.fDuration;
    kfAnimationOfContent.repeatCount = HUGE_VALF;
    
    NSArray<NSNumber*> *array = [NSArray arrayWithObjects:
                                 [NSNumber numberWithFloat:0.0f],
                                 [NSNumber numberWithFloat:0.5f],
                                 [NSNumber numberWithFloat:1.0f], nil];

    kfAnimationOfContent.keyTimes = array;
    kfAnimationOfContent.calculationMode = kCAAnimationLinear;
    [kfAnimationOfContent setDelegate:self];
    
    [self addAnimation:kfAnimationOfContent forKey:@"contents"];
}

- (void)pausePlay {
    CFTimeInterval pausedTime = [self convertTime:CACurrentMediaTime() fromLayer:nil];
    self.speed = 0.0;
    self.timeOffset = pausedTime;
}

- (void)resumePlay {
    self.speed = 1.f;
}

- (void)stopPlay {
    [self removeAnimationForKey:@"position.x"];
    [self removeAnimationForKey:@"zPosition"];
    [self removeAnimationForKey:@"contents"];
    [self resetState];
}

- (NSUInteger)getImageCount {
    return [self->imageArray count];
}

- (UIImage*)getImageAtIndex:(NSUInteger)idx {
    NSUInteger cnt = [self getImageCount];
    if (idx < cnt) {
        return [self->imageArray objectAtIndex:idx];
    }
    
    return nil;
}

- (void)resetState {
    self.radius = 90;
    self.startAngle = 0.f;
    self.clockWise = NO;
    self.fDuration = 3.f;
    id obj = [self getImageAtIndex:0];
    [self setContents:(id)[obj CGImage]];
}

@end