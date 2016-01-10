//
//  Observer.m
//  KVX
//
//  Created by JayGuo on 15/10/9.
//  Copyright (c) 2015年 JayGuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Observer.h"

@interface Observer ()
@property (nonatomic, copy) NSString* keyPath;
@property (nonatomic) SEL selector;
@property (nonatomic, weak) id target;              // weak
@property (nonatomic, weak) id observedObject;      // weak
@end

@implementation Observer

+ (instancetype)observerWithObject:(id)object
                           keyPath:(NSString*)keyPath
                            target:(id)target
                          selector:(SEL)selector {
    
    return [[Observer alloc]initWithObject:object keyPath:keyPath target:target seletor:selector];
}

- (id)initWithObject:(id)object
               keyPath:(NSString*)keyPath
                target:(id)target
               seletor:(SEL)selector {
    
    self = [super init];
    
    if (self) {
        self.target = target;
        self.keyPath = keyPath;
        self.selector = selector;
        self.observedObject = object;
        
        [object addObserver:self forKeyPath:keyPath options:0 context:(__bridge void*)self];
    }
    
    return self;
    
}

- (void)dealloc {
    id strongObservedObject = self.observedObject;
    if (strongObservedObject) {
        [strongObservedObject removeObserver:self forKeyPath:self.keyPath];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    
    if ((__bridge id)context == self) {
        id strongTarget = self.target;
        if ([strongTarget respondsToSelector:self.selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [strongTarget performSelector:self.selector withObject:keyPath];
#pragma clang diagnostic pop
        }
    }
}

@end
