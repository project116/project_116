//
//  UITableViewCell_ContainRemover_116Item.m
//  116
//
//  Created by baidu on 14/12/23.
//  Copyright (c) 2014年 baidu. All rights reserved.
//

#import "UITableViewCell_ContainRemover_116Item.h"
#import "DataCenter116.h"
@implementation UITableViewCell_ContainRemover_116Item


- (void)awakeFromNib :(CGFloat)realwidth {
    // Initialization code
    [super awakeFromNib:realwidth];
    _textfield = [[UITextField alloc]initWithFrame:CGRectMake(40, 0,self.forgroundView.bounds.size.width - 40, self.forgroundView.bounds.size.height)];
    [self.forgroundView addSubview:_textfield];
    _textfield.placeholder = @"添加选项";
    _textfield.delegate = self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)ondeleteItem:(id)sender
{
    Project116 * curproj = [[DataCenter116 GetInstance]GetCurrentProject];
    [[DataCenter116 GetInstance] RemoveItem:_item116 atProject:curproj];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (_item116 == nil) {
        [[DataCenter116 GetInstance]AddItem:_textfield.text atProject:[[DataCenter116 GetInstance]GetCurrentProject]];
    }
    else
    {
        [[DataCenter116 GetInstance]ChangeItemName:_textfield.text atItem:_item116 atProject:[[DataCenter116 GetInstance]GetCurrentProject]];
    }
    
    return YES;
}



@end
