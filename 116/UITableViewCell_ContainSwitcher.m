//
//  UITableViewCell_ContainSwitcher.m
//  116
//
//  Created by baidu on 14/12/23.
//  Copyright (c) 2014年 baidu. All rights reserved.
//

#import "UITableViewCell_ContainSwitcher.h"

@interface UITableViewCell_ContainSwitcher()
@end

@implementation UITableViewCell_ContainSwitcher

- (void)awakeFromNib:(CGFloat)realwidth {
    // Initialization code
    
    if (g_switcher == nil) {
        g_switcher = [[UISwitch alloc]init];
        g_switcher.on = true;
    }
    if (![self.subviews containsObject:g_switcher]) {
        
        [self addSubview:g_switcher];
    
        self.textLabel.text = @"去除重复选项";

        [g_switcher setTranslatesAutoresizingMaskIntoConstraints:NO];
        NSLayoutConstraint *horConstraint = [NSLayoutConstraint constraintWithItem:g_switcher attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.f constant:-30.f];
        
        NSLayoutConstraint *verConstraint = [NSLayoutConstraint constraintWithItem:g_switcher attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.f];
        
        [self addConstraint:horConstraint];
        [self addConstraint:verConstraint];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
