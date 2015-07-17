//
//  UITableViewCell_ContainRemover2.h
//  116
//
//  Created by baidu on 14/12/26.
//  Copyright (c) 2014年 baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Project116.h"

@interface UITableViewCell_ContainRemover2 : UITableViewCell<UITextFieldDelegate>
- (void)awakeFromNib :(CGFloat)realwidth;
@property (weak, nonatomic) Project116 * project116;
@property (strong, nonatomic) UITextField * textfield;
@property (strong, nonatomic) UIButton * textlable;
@end
