//
//  VerticalWriteLabel.m
//  116
//
//  Created by JayGuo on 15/11/16.
//  Copyright © 2015年 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VerticalWriteLabel.h"
#import "NSString+VerticalNSString.h"

@implementation VerticalWriteLabel

// Thanks to http://humin.me/archives/68

/**
 sample code of simple vertical write label:
 
 VerticalWriteLabel *verticalLabel =
 [[VerticalWriteLabel alloc]init];
 
 NSString *str = @"ABCDEFG";
 UIFont *font = [UIFont systemFontOfSize:24.f];
 [verticalLabel setBackgroundColor:[UIColor yellowColor]];
 [verticalLabel setText:str];
 [verticalLabel setNumberOfLines:0];
 [verticalLabel setFont:font];
 CGSize size = [verticalLabel getSize:str font:font width:24];
 verticalLabel.frame = CGRectMake(100, 100, size.width, size.height);
 
 [self.view addSubview:verticalLabel];

*/
- (CGSize)getSize:(NSString*)string font:(UIFont*)font width:(float)width {
    CGSize constraint = CGSizeMake(width, 2000.f);
    
    NSMutableParagraphStyle* style = [[NSMutableParagraphStyle alloc]init];
    style.paragraphSpacing = 20.f;
    style.paragraphSpacingBefore = 0.f;
    style.lineBreakMode = NSLineBreakByWordWrapping;

    NSDictionary *attrDict =
        [NSDictionary dictionaryWithObjectsAndKeys: font, NSFontAttributeName,
                                                    style, NSParagraphStyleAttributeName,
                                                    nil];
    
    NSStringDrawingOptions opt = NSStringDrawingUsesLineFragmentOrigin;
    
    CGRect rect = [string boundingRectWithSize:constraint options:opt attributes:attrDict context:nil];
    
    return rect.size;
}

- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {
    CGRect textBounds = [super textRectForBounds:bounds limitedToNumberOfLines:numberOfLines];
    switch (self.verticalAlign) {
        case VerticalAlignmentTop:
            textBounds.origin.y = bounds.origin.y;
            break;
        case VerticalAlignmentBottom:
            textBounds.origin.y = bounds.origin.y + bounds.size.height - textBounds.size.height;
            break;
        case VerticalAlignmentMiddle:
            textBounds.origin.y = bounds.origin.y + (bounds.size.height - textBounds.size.height) / 2;
            break;
        default:
            break;
    }
    
    return textBounds;
}

- (void)drawTextInRect:(CGRect)rect {
    CGRect textRect = [self textRectForBounds:rect limitedToNumberOfLines:self.numberOfLines];
    [super drawTextInRect:textRect];
}

- (void)setVerticalTextGroup:(NSArray*)array {
    
    NSUInteger height = 10;
    NSUInteger maxWidth = 0;
    
    for (id obj in array) {
        NSString* sub = [obj substringWithRange:NSMakeRange(0, 1)];
        if ([NSString isChinese:sub]) {
            VerticalWriteLabel* label = [[VerticalWriteLabel alloc]init];
            label.font = self.font;
            CGSize size = [label getSize:obj font:self.font width:label.font.pointSize];
            [label setFrame:CGRectMake(0, height, size.width, size.height)];
            label.text = obj;
            label.numberOfLines = 0;
            [label setTextAlignment:NSTextAlignmentRight];
            label.backgroundColor = [UIColor clearColor];
            height += size.height;
            
            maxWidth = MAX(maxWidth, size.width);
            
            [self addSubview:label];
        }
        else {
            VerticalWriteLabel* label = [[VerticalWriteLabel alloc]init];
            label.font = self.font;
            
            CGSize constraint = CGSizeMake(2000.f, CGFLOAT_MAX);
            NSMutableParagraphStyle* style = [[NSMutableParagraphStyle alloc]init];
            style.paragraphSpacing = 0.f;
            style.paragraphSpacingBefore = 0.f;
            style.headIndent = 0.f;
            style.lineSpacing = 0.f;
            style.lineHeightMultiple = 1.f;
            style.maximumLineHeight = label.font.pointSize;
            style.lineBreakMode = NSLineBreakByTruncatingTail;

            NSDictionary *dic = @{NSFontAttributeName:self.font, NSParagraphStyleAttributeName:style.copy};

            NSStringDrawingOptions opt =
                        NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading;
            
            CGRect rect = [obj boundingRectWithSize:constraint options:opt attributes:dic context:nil];
            [label setFrame:CGRectMake(0, height, rect.size.width, ceil(rect.size.height))];
            label.transform = CGAffineTransformMakeRotation(M_PI_2);
            [label setFrame:CGRectMake(0, height, label.frame.size.width, label.frame.size.height)];
            label.text = obj;
            label.backgroundColor = [UIColor clearColor];
            
            height += rect.size.width;
            maxWidth = MAX(maxWidth, rect.size.height);
            
            [self addSubview:label];
        }
    }
    
    [self setFrame:CGRectMake(0, 100, maxWidth, height+10)];
}

@end