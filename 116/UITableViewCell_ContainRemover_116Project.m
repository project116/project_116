//
//  UITableViewCell_ContainRemover_116Project.m
//  116
//
//  Created by baidu on 14/12/23.
//  Copyright (c) 2014年 baidu. All rights reserved.
//

#import "UITableViewCell_ContainRemover_116Project.h"
#import "DataCenter116.h"
@interface UITableViewCell_ContainRemover_116Project()

@end
@implementation UITableViewCell_ContainRemover_116Project

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)awakeFromNib:(CGFloat)realwidth
{
    [super awakeFromNib:realwidth];
    _editbutton = [[UIButton alloc]initWithFrame:CGRectMake(self.forgroundView.bounds.size.width - 40, 0, 40,self.forgroundView.bounds.size.height)];
    [self.forgroundView addSubview:_editbutton];
    [_editbutton setTitle:@"i" forState:UIControlStateNormal];
    [_editbutton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_editbutton addTarget:self action:@selector(editClicked:) forControlEvents:UIControlEventTouchDown];
}
-(void)editClicked:(id)sender
{
    int numberOfPages = [[DataCenter116 GetInstance] GetProjectCount] ;
    [[DataCenter116 GetInstance] SetProjectToBeEdit: self.textlabel.text];
}

-(void)ondeleteItem:(id)sender
{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"你确定要删除整个项目吗？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消",nil];
    alert.alertViewStyle=UIAlertViewStyleDefault;
    [alert show];
    
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        [[DataCenter116 GetInstance] RemoveProject: _project116];
    }
}
@end
