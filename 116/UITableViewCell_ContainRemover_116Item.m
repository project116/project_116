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
    _textfield = [[UITextField alloc]initWithFrame:CGRectMake(50, 0,self.forgroundView.bounds.size.width - 50, self.forgroundView.bounds.size.height)];
    [_textfield setFont: [UIFont fontWithName:@"fangsong" size: 17.0f]] ;
    [self.forgroundView addSubview:_textfield];
    _textfield.placeholder =  (_item116 == nil)? @"添加选项":@"";
    _textfield.delegate = self;
    [_textfield becomeFirstResponder];
    
    _removebutton1 = [[UIButton alloc]initWithFrame:CGRectMake(16, (self.bounds.size.height - 17)/2, 17, 17)];
    [self addSubview:_removebutton1];
    _removebutton1.hidden = true;
    [_removebutton1 setBackgroundImage:[UIImage imageNamed:@"delete-normal"] forState:UIControlStateNormal];
    
    
    [_removebutton1 addTarget:self action:@selector(ondeleteItem1:) forControlEvents:UIControlEventTouchDown];
    
    [_textfield addTarget:self action:@selector(editClicked:) forControlEvents:UIControlEventTouchDown];
    
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

-(void)ondeleteItem1:(id)sender
{
    Project116 * curproj = [[DataCenter116 GetInstance]GetCurrentProject];
    [[DataCenter116 GetInstance] RemoveItem:_item116 atProject:curproj];
}



- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _removebutton1.hidden = false;


}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    _removebutton1.hidden = true;
    [[DataCenter116 GetInstance]ChangeItemName:_textfield.text atItem:_item116 atProject:[[DataCenter116 GetInstance]GetCurrentProject]];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    _removebutton1.hidden = true;
    [[DataCenter116 GetInstance]ChangeItemName:_textfield.text atItem:_item116 atProject:[[DataCenter116 GetInstance]GetCurrentProject]];
    return YES;
}


@end
