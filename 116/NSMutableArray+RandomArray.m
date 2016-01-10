//
//  NSArray+RandomArray.m
//  116
//
//  Created by JayGuo on 15/12/9.
//  Copyright © 2015年 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSMutableArray+RandomArray.h"

@implementation NSMutableArray (RandomArray)

- (void)randomElements {
    NSUInteger reserverIdx = self.count - 1;
    
    while (reserverIdx > 0) {
        [self exchangeObjectAtIndex:reserverIdx withObjectAtIndex:arc4random_uniform((u_int32_t)reserverIdx+1)];
        reserverIdx--;
    }
}

@end


