//
//  VerticalWriteLabel.h
//  116
//
//  Created by JayGuo on 15/11/16.
//  Copyright © 2015年 baidu. All rights reserved.
//

#ifndef VerticalWriteLabel_h
#define VerticalWriteLabel_h

#import <UIKit/UIKit.h>

enum VerticalAlignment{
    VerticalAlignmentTop = 0,
    VerticalAlignmentBottom,
    VerticalAlignmentMiddle
};


@interface VerticalWriteLabel : UILabel

@property (nonatomic) enum VerticalAlignment verticalAlign;

- (CGSize)getSize:(NSString*)string font:(UIFont*)font width:(float)width;

- (void)setVerticalTextGroup:(NSArray*)array;

@end //VerticalWriteLabel

#endif /* VerticalWriteLabel_h */
