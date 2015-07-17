//
//  UITableViewCell_ContainSwitcher.h
//  116
//
//  Created by baidu on 14/12/23.
//  Copyright (c) 2014年 baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

static UISwitch* g_switcher;

@interface UITableViewCell_ContainSwitcher : UITableViewCell
- (void)awakeFromNib :(CGFloat)realwidth;
@end
