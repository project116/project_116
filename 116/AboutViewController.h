//
//  AboutViewController.h
//  116
//
//  Created by baidu on 14/12/23.
//  Copyright (c) 2014年 baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *projectName;

@property (weak, nonatomic) IBOutlet UILabel *teamAuthor;

@property (weak, nonatomic) IBOutlet UILabel *designTeam;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIView *designMemberView;
@end
