//
//  NSString+VerticalNSString.h
//  116
//
//  Created by JayGuo on 15/9/16.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (VerticalNSString)

- (NSString*) makeVerticalOutString;

+ (BOOL)isChinese:(NSString*)character;

- (NSArray*)spliteChineseEnglish:(NSString*)string;


@end
