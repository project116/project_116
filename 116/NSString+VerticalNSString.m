//
//  NSString+VerticalNSString.m
//  116
//
//  Created by JayGuo on 15/9/16.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import "NSString+VerticalNSString.h"

@implementation NSString (VerticalNSString)

- (NSString*) makeVerticalOutString {
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

+ (BOOL)isChinese:(NSString*)character {
    BOOL result = NO;
    
    do{
        if (character == nil) {
            break;
        }
        
        const char* utf8 = [character UTF8String];
        if (strlen(utf8) > 2) {
            result = YES;
        }
        else {
            result = NO;
        }
    } while(false);
    
    return result;
}

- (NSArray*)spliteChineseEnglish:(NSString*)string {
    NSMutableArray* array = [[NSMutableArray alloc]init];
    
    BOOL lastChineseFlag = NO;
    NSUInteger wordBegin = 0;
    for (NSUInteger i = 0; i < string.length; i++) {
        BOOL isLastCharacter = (string.length == i+1) ? YES:NO;
        NSRange range = NSMakeRange(i, 1);
        BOOL chineseFlag = [NSString isChinese:[string substringWithRange:range]];
        
        if (chineseFlag != lastChineseFlag && i!= 0) {
            [array addObject:[string substringWithRange:NSMakeRange(wordBegin, i-wordBegin)]];
            wordBegin = i;
        }
        else if (isLastCharacter){
            [array addObject:[string substringWithRange:NSMakeRange(wordBegin, string.length - wordBegin)]];
        }
        
        lastChineseFlag = chineseFlag;
    }

    for (id obj in array) {
        NSLog(@"%@\n", obj);
    }
    
    return array;
}

@end
