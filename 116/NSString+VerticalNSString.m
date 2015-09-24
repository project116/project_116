//
//  NSString+VerticalNSString.m
//  116
//
//  Created by JayGuo on 15/9/16.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import "NSString+VerticalNSString.h"

@implementation NSString (VerticalNSString)

-(NSString*) makeVerticalOutString {
    NSMutableString *result = nil;
    
    NSString *src = self;
    if (src.length > 0) {
        result = [[NSMutableString alloc] initWithString:src];
        NSUInteger length = src.length;
        for (NSUInteger i = length-1; i > 0; i--) {
            [result insertString:@"\n" atIndex:i];
        }
    }
    
    return result;
}

@end
