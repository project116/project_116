//
//  UITableViewCell_ContainRemover2.m
//  116
//
//  Created by baidu on 14/12/26.
//  Copyright (c) 2014年 baidu. All rights reserved.
//

#import "UITableViewCell_ContainRemover2.h"
#import "DataCenter116.h"

@interface UITableViewCell_ContainRemover2()
@property (strong, nonatomic) UIButton * removeButton;
@end

@implementation UITableViewCell_ContainRemover2

- (void)awakeFromNib :(CGFloat)realwidth {
    // Initialization code
    
    for (UIView* subview in self.subviews) {
        [subview removeFromSuperview];
    }
    
    _removeButton = [[UIButton alloc]initWithFrame:CGRectMake(realwidth - 40, 0, 40,self.bounds.size.height)];
    [self addSubview:_removeButton];
    [_removeButton setTitle:@"Del" forState:UIControlStateNormal];
    
    _removeButton.backgroundColor = [UIColor grayColor];
    _removeButton.hidden = true;
    
    [_removeButton addTarget:self action:@selector(ondeleteItem:) forControlEvents:UIControlEventTouchDown];
    
    
    
    self.textlable = [[UIButton alloc]init];
    self.textlable.frame = CGRectMake(40, 0,self.bounds.size.width - 40, self.bounds.size.height);
    _textfield = [[UITextField alloc]initWithFrame:CGRectMake(40, 0,self.bounds.size.width - 40, self.bounds.size.height)];
    [self addSubview:self.textlable];
    [self addSubview:_textfield];
    
    _textfield.hidden = true;
    [self.textLabel setTextColor: [UIColor blueColor]];
    _textfield.placeholder = @"项目名称";
    _textfield.delegate = self;
    
    //button长按事件
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(btnLong:)];
    longPress.minimumPressDuration = 0.8; //定义按的时间
    [self addGestureRecognizer:longPress];
    
}

-(void)btnLong:(UILongPressGestureRecognizer *)gestureRecognizer{
    _removeButton.hidden = false;
    _textfield.hidden = false;
    _textlable.hidden = true;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)ondeleteItem:(id)sender
{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"你确定要删除整个项目吗？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消",nil];
    alert.alertViewStyle=UIAlertViewStyleDefault;
    [alert show];
    
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0 && _project116 != nil)
    {
        [[DataCenter116 GetInstance] RemoveProject: _project116];
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [self textFieldShouldReturn:textField];
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (_project116 == nil) {
        [[DataCenter116 GetInstance]AddProject:textField.text];
    }
    else
    {
        [[DataCenter116 GetInstance]ChangeProjectName:textField.text atProject:_project116];
    }
    return YES;
}

@end
