//
//  ItemLayer.m
//  116
//
//  Created by JayGuo on 15/11/9.
//  Copyright © 2015年 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ItemLayer.h"
#import "NSString+VerticalNSString.h"

@interface CItemLayer ()
@property (nonatomic, strong) NSString* text;
@end

@implementation CItemLayer

- (instancetype)initWithText:(NSString*)text {
    if (self = [super init]) {
        self.frame = CGRectMake(100, 100, 30, 50);
        self.text = text;
        //self.text = [text makeVerticalOutString];
        [self setBackgroundColor:[[UIColor grayColor] CGColor]];
        [self update];
    }
    
    return self;
}

- (NSAttributedString*) createAttributedString:(NSString*)text {
    NSMutableParagraphStyle* paragraphStryle = [[NSMutableParagraphStyle alloc]init];
    NSMutableDictionary *dictionary = @{
                                        NSParagraphStyleAttributeName:paragraphStryle,
                                        NSVerticalGlyphFormAttributeName:[[NSNumber alloc]initWithInt:1]
                                        };
    [paragraphStryle setMaximumLineHeight:34];
    [paragraphStryle setMinimumLineHeight:28];
    [paragraphStryle setAlignment:NSTextAlignmentJustified];
    [paragraphStryle setParagraphSpacingBefore:0.0];
    [paragraphStryle setLineSpacing:0.0];
    [paragraphStryle setParagraphSpacing:0.0];

    return [[NSMutableAttributedString alloc]initWithString:text attributes:dictionary];
}

- (void)update {
    
    self.string = self.text;//[self createAttributedString:self.text];
    self.wrapped = YES;
    self.fontSize = 20.f;
    self.foregroundColor = [[UIColor blackColor]CGColor];
    self.alignmentMode = kCAAlignmentCenter;
    self.truncationMode = kCATruncationNone;
    self.contentsScale = [[UIScreen mainScreen]scale];
}

- (void)showLayerWithAnimation {
    self.zPosition += 20.f;
}

@end