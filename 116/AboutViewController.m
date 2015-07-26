//
//  AboutViewController.m
//  116
//
//  Created by baidu on 14/12/23.
//  Copyright (c) 2014年 baidu. All rights reserved.
//

#import "AboutViewController.h"


@interface AboutViewController ()
@end


@implementation AboutViewController


- (void)initControlFont {
    self.projectName.font = [UIFont fontWithName:@"FangSong_GB2312" size:20];
    
    self.teamAuthor.font = [UIFont fontWithName:@"fzsxslkjw--gb1-0" size:36];
    
    UIFont* font4Team = [UIFont fontWithName:@"fzsxslkjw--gb1-0" size:30];
    
    self.designTeam.font = font4Team;
    self.devTeam.font = font4Team;
    self.lblPublisher.font = font4Team;
}

- (UILabel*) createPersonLabel:(NSString*)_name {
    UILabel* result = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 21)];
    if (result) {
        //[result setTranslatesAutoresizingMaskIntoConstraints:YES];
        [result setText:_name];
        [result setTextColor:[UIColor colorWithRed:0.56f green:0.56f blue:0.58f alpha:1.f]];
        [result setBackgroundColor:[UIColor clearColor]];
        [result setNumberOfLines:0];
        [result setTextAlignment:NSTextAlignmentCenter];
        
        // 必须制定，默认是Autoresizing
        [result setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        UIFont *font = [UIFont fontWithName:@"Palatino-Roman" size:26.0];
        CGSize size = [_name sizeWithFont:font constrainedToSize:CGSizeMake(175.0f, 2000.0f) lineBreakMode:UILineBreakModeWordWrap];
        
        [result setFont:font];
        
        CGRect rect = result.bounds;
        rect.size = size;
        [result setBounds:rect];
        
    }
    
    return result;
}

- (void)initDesignTeam {
    NSArray *designTeam = [[NSArray alloc]initWithObjects:@"Cczhang", @"Emmadai", @"Estherzhang", @"Lillianli", @"Sinkinwang", @"Vigarwang", nil];
    
    NSUInteger calculator = 0;
    NSUInteger defaultVerticalSpace = 7;
    NSUInteger firstVerticalSpace = 0;
    NSUInteger designMemberViewActualHeight = 0;
    
    UIView *previousSibling = [self designMemberView];
    for (NSString* name in designTeam) {
        UILabel *newMember = [self createPersonLabel:name];
        [[self designMemberView] addSubview:newMember];
        
        CGFloat verticalSpace = calculator == 0 ? firstVerticalSpace:defaultVerticalSpace;
        NSLayoutAttribute attr = calculator == 0 ? NSLayoutAttributeTop : NSLayoutAttributeBottom;
        
        NSLayoutConstraint *constraintTop =
        [NSLayoutConstraint constraintWithItem:newMember attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:previousSibling attribute:attr multiplier:1.0f constant:verticalSpace];
        
        NSLayoutConstraint *constraintCenter =
        [NSLayoutConstraint constraintWithItem:newMember attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.designMemberView attribute:NSLayoutAttributeCenterX multiplier:1.f constant:0.f];
        
        /*any views involved must be either the receiving view itself, or a subview of the receiving view.*/
        [[self designMemberView]addConstraint:constraintTop];
        [[self designMemberView]addConstraint:constraintCenter];
        
        calculator++;
        
        previousSibling = newMember;
    }
    
    NSLayoutConstraint *constraintBottomSpace =
    [NSLayoutConstraint constraintWithItem:self.designMemberView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem: previousSibling attribute:NSLayoutAttributeBottom multiplier:1.f constant:0.f];
    
    [[self designMemberView] addConstraint:constraintBottomSpace];
    
    NSLayoutConstraint *constraintTopSpace =
    [NSLayoutConstraint constraintWithItem:self.img_sep_design_tech attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.designMemberView attribute:NSLayoutAttributeBottom multiplier:1.f constant:30.f];
    
    [[self scrollContentView] addConstraint:constraintTopSpace];
}

- (void)initDevTeam {
    
    NSArray *devTeam = [[NSArray alloc]initWithObjects:@"Jacktan", @"Jayguo", @"Jimzou", nil];
    

    NSUInteger calculator = 0;
    NSUInteger defaultVerticalSpace = 7;
    NSUInteger firstVerticalSpace = 0;
    NSUInteger designMemberViewActualHeight = 0;
    
    UIView *previousSibling = [self devMemberView];
    for (NSString* name in devTeam) {
        UILabel *newMember = [self createPersonLabel:name];
        [[self devMemberView] addSubview:newMember];
        
        CGFloat verticalSpace = calculator == 0 ? firstVerticalSpace:defaultVerticalSpace;
        NSLayoutAttribute attr = calculator == 0 ? NSLayoutAttributeTop : NSLayoutAttributeBottom;
        
        NSLayoutConstraint *constraintTop =
        [NSLayoutConstraint constraintWithItem:newMember attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:previousSibling attribute:attr multiplier:1.0f constant:verticalSpace];
        
        NSLayoutConstraint *constraintCenter =
        [NSLayoutConstraint constraintWithItem:newMember attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.devMemberView attribute:NSLayoutAttributeCenterX multiplier:1.f constant:0.f];
        
        /*any views involved must be either the receiving view itself, or a subview of the receiving view.*/
        [[self devMemberView]addConstraint:constraintTop];
        [[self devMemberView]addConstraint:constraintCenter];
        
        calculator++;
        
        previousSibling = newMember;
    }
    
    NSLayoutConstraint *constraintBottomSpace =
    [NSLayoutConstraint constraintWithItem:self.devMemberView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem: previousSibling attribute:NSLayoutAttributeBottom multiplier:1.f constant:0.f];
    
    [[self devMemberView] addConstraint:constraintBottomSpace];
   
    NSLayoutConstraint *constraintTopSpace =
    [NSLayoutConstraint constraintWithItem:self.img_dev_studio attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.devMemberView attribute:NSLayoutAttributeBottom multiplier:1.f constant:30.f];
    
    [[self scrollContentView] addConstraint:constraintTopSpace];
  
}

- (void)initScrollView {
    NSLayoutConstraint *leading =
    [NSLayoutConstraint constraintWithItem:self.scrollContentView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeLeading multiplier:1.f constant:0.f];
    
    NSLayoutConstraint *trailing =
    [NSLayoutConstraint constraintWithItem:self.scrollContentView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeTrailing multiplier:1.f constant:0.f];
    
    NSLayoutConstraint *top =
    [NSLayoutConstraint constraintWithItem:self.scrollContentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeTop multiplier:1.f constant:0.f];
    
    NSLayoutConstraint *bottom =
    [NSLayoutConstraint constraintWithItem:self.scrollContentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeBottom multiplier:1.f constant:0.f];
    
    [[self scrollView] addConstraint:leading];
    [[self scrollView] addConstraint:trailing];
    [[self scrollView] addConstraint:top];
    [[self scrollView] addConstraint:bottom];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSArray *familyNames = [UIFont familyNames];
    for( NSString *familyName in familyNames ){
        printf( "Family: %s \n", [familyName UTF8String] );
        NSArray *fontNames = [UIFont fontNamesForFamilyName:familyName];
        for( NSString *fontName in fontNames ){
            printf( "\tFont: %s \n", [fontName UTF8String] );
        }
    }
    
    [[self navigationController] setNavigationBarHidden:YES];
    
    [self initControlFont];
    [self initDesignTeam];
    [self initDevTeam];
    [self initScrollView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
