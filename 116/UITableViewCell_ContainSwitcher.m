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
        
        g_switcher.frame = CGRectMake(self.bounds.size.width - 10, 10, 0,self.bounds.size.height);
        self.textLabel.text = @"去除重复选项";
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
