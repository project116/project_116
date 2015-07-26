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

@property (weak, nonatomic) IBOutlet UILabel *devTeam;

@property (weak, nonatomic) IBOutlet UILabel *lblPublisher;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIView *scrollContentView;

@property (weak, nonatomic) IBOutlet UIImageView *img_sep_design_tech;

@property (weak, nonatomic) IBOutlet UIView *designMemberView;

@property (weak, nonatomic) IBOutlet UIView *devMemberView;

@property (weak, nonatomic) IBOutlet UIImageView *imgStudio;

@property (weak, nonatomic) IBOutlet UIImageView *img_dev_studio;

@end
