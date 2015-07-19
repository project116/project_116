//
//  AboutViewController.m
//  116
//
//  Created by baidu on 14/12/23.
//  Copyright (c) 2014年 baidu. All rights reserved.
//

#import "AboutViewController.h"


@interface AboutViewController ()
- (void)initDevTeam;
- (void)initDesignTeam;
- (UILabel*) createPersonLabel:(NSString*)_name :(UIView*)_previouseSibling :(CGFloat)_verticalSpace;
@end


@implementation AboutViewController





- (void)initControlFont {
    self.projectName.font = [UIFont fontWithName:@"FangSong_GB2312" size:20];
    
    self.teamAuthor.font = [UIFont fontWithName:@"fzsxslkjw--gb1-0" size:36];
    
    self.designTeam.font = [UIFont fontWithName:@"fzsxslkjw--gb1-0" size:30];
}

- (UILabel*) createPersonLabel:(NSString*)_name :(UIView*)_previouseSibling :(CGFloat)_verticalSpace {
    UILabel* result = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 21)];
    if (result) {
        [result setText:_name];
        [result setTextColor:[UIColor colorWithRed:0.56f green:0.56f blue:0.58f alpha:1.f]];
        [result setBackgroundColor:[UIColor clearColor]];
        [result setNumberOfLines:0];
        [result setTextAlignment:NSTextAlignmentCenter];
        
        // 必须制定，默认是Autoresizing
        [result setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        UIFont *font = [UIFont fontWithName:@"Arial" size:26.0];
        CGSize size = [_name sizeWithFont:font constrainedToSize:CGSizeMake(175.0f, 2000.0f) lineBreakMode:UILineBreakModeWordWrap];
        
        CGRect rect = result.frame;
        [result setFont:font];
        rect.size = size;
        [result setFrame:rect];
        
    }
    
    return result;
}

- (void)initDesignTeam{
    NSArray *designTeam = [[NSArray alloc]initWithObjects:@"Cczhang", @"Emmadai", @"Estherzhang", @"Lillianli", @"Sinkinwang", @"Vigarwang", nil];
    
    NSUInteger calculator = 0;
    NSUInteger defaultVerticalSpace = 7;
    NSUInteger firstVerticalSpace = 20;
    NSUInteger rowHeight = 0;
    
    [[self designMemberView] setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    UIView *previousSibling = nil;
    for (NSString* name in designTeam) {
        UILabel *newMember = [self createPersonLabel:name :previousSibling :20];
        [[self designMemberView] addSubview:newMember];
        rowHeight = newMember.bounds.size.height;
        
        CGFloat verticalSpace = calculator == 0 ? firstVerticalSpace:defaultVerticalSpace;
        
        NSLayoutConstraint *constraintTop =
            [NSLayoutConstraint constraintWithItem:newMember attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:previousSibling attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.f];
        
        NSLayoutConstraint *constraintCenter =
        [NSLayoutConstraint constraintWithItem:newMember attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.designMemberView attribute:NSLayoutAttributeCenterX multiplier:1.f constant:0.f];

        /*any views involved must be either the receiving view itself, or a subview of the receiving view.*/
        [[self designMemberView]addConstraint:constraintTop];
        [[self designMemberView]addConstraint:constraintCenter];
        
        calculator++;
        
        previousSibling = newMember;
    }
    
//    NSUInteger viewHeight = designTeam.count * rowHeight + (designTeam.count - 1) * defaultVerticalSpace;
//    CGRect rect = [[self designMemberView]frame];
//    rect.size.height = 0;//viewHeight;
//    [[self designMemberView] setFrame:rect];
}

- (void)initDevTeam {
    NSArray *designTeam = [[NSArray alloc]initWithObjects:@"Jacktan", @"Jayguo", @"Jimzou", nil];
    
    NSUInteger calculator = 0;
    NSUInteger defaultVerticalSpace = 7;
    NSUInteger firstVerticalSpace = 20;
    
    UIView *previousSibling = [self designTeam];
    for (NSString* name in designTeam) {
        UILabel *newMember = [self createPersonLabel:name :previousSibling :20];
        [[self scrollView] addSubview:newMember];
        
        CGFloat verticalSpace = calculator == 0 ? firstVerticalSpace:defaultVerticalSpace;
        
        NSLayoutConstraint *constraintTop =
        [NSLayoutConstraint constraintWithItem:newMember attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:previousSibling attribute:NSLayoutAttributeBottom multiplier:1.0f constant:verticalSpace];
        
        NSLayoutConstraint *constraintCenter =
        [NSLayoutConstraint constraintWithItem:newMember attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeCenterX multiplier:1.f constant:0.f];
        
        /*any views involved must be either the receiving view itself, or a subview of the receiving view.*/
        [[self scrollView]addConstraint:constraintTop];
        [[self scrollView]addConstraint:constraintCenter];
        
        calculator++;
        
        previousSibling = newMember;
    }

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
    
    [self initControlFont];
    [self initDesignTeam];
    //[self initDevTeam];
    [[self scrollView]setScrollEnabled:true];
    CGSize size = [[self view]frame].size;
    size.height -= 410;
    [[self scrollView]setContentSize:size];
    CGRect rectOfScrollFrame = [[self view]window].frame;
    rectOfScrollFrame.origin.y += 410;
    [[self scrollView]setFrame:rectOfScrollFrame];
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
