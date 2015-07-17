//
//  UITableViewCell_ContainRemover.h
//  116
//
//  Created by baidu on 14/12/23.
//  Copyright (c) 2014年 baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell_ContainRemover : UITableViewCell<UIGestureRecognizerDelegate>
{
    int swipeWidth;
    int firstX;
}
@property (strong,nonatomic) UILabel * textlabel;
@property (strong, nonatomic) UIView * forgroundView;
- (void)awakeFromNib :(CGFloat)realwidth;
@end
