//
//  UITableViewCell_AddItemCell.m
//  116
//
//  Created by baidu on 15/8/18.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import "UITableViewCell_AddItemCell.h"
#import "DataCenter116.h"

@implementation UITableViewCell_AddItemCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    _addbutton = [[UIButton alloc]initWithFrame:CGRectMake(50, 0,self.bounds.size.width - 50, self.bounds.size.height)];
    [_addbutton setFont: [UIFont fontWithName:@"fangsong" size: 17.0f]] ;
    [self addSubview:_addbutton];
    [_addbutton setTitle:@"添加选项" forState:(UIControlState) UIControlStateNormal];
    [_addbutton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    _addbutton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
     [_addbutton addTarget:self action:@selector(editClicked:) forControlEvents:UIControlEventTouchDown];
    
    
    _bottomLine = [[UILabel alloc]initWithFrame:CGRectMake(self.bounds.origin.x + 50, self.bounds.origin.y + self.bounds.size.height - 1, self.bounds.size.width, 1)];
    _bottomLine.backgroundColor = [UIColor lightGrayColor];
    
    [self addSubview:_bottomLine];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)editClicked:(id)sender
{
        [[DataCenter116 GetInstance]AddItem:@"" atProject:[[DataCenter116 GetInstance]GetCurrentProject]];
}

@end
