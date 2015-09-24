//
//  ResultViewController.m
//  116
//
//  Created by baidu on 14/12/23.
//  Copyright (c) 2014年 baidu. All rights reserved.
//

#import "ResultViewController.h"
#import "DataCenter116.h"
#import <CoreText/CoreText.h>
#import "SMPageControl.h"
#import "ResultView.h"
#import "RenderScene.h"
@interface ResultViewController ()
//@property (weak, nonatomic) IBOutlet UIButton *tryAgainButton;
@property (weak, nonatomic) IBOutlet GLKView *glkview;
@property (strong, nonatomic) EAGLContext * context;
@property (strong, nonatomic) RenderScene* renderScene;
@property (weak, nonatomic) IBOutlet SMPageControl *projectPageControl;
@property (strong, nonatomic) UILabel *ResultLabel;
@end

@implementation ResultViewController

- (void)goToMain {
    [self performSegueWithIdentifier:@"Result2Main" sender:self];
}

- (void)gotoEdit {
    [self performSegueWithIdentifier:@"Result2Table" sender:self];
}

- (void)initPageControl {
    [self.projectPageControl setPageIndicatorImage:[UIImage imageNamed:@"xiangmu"]];
    [self.projectPageControl setCurrentPageIndicatorImage:[UIImage imageNamed:@"dangqianxiangmu"]];
    self.projectPageControl.backgroundColor = [UIColor clearColor];
    self.projectPageControl.currentPageIndicatorTintColor = [UIColor redColor];
    self.projectPageControl.pageIndicatorTintColor = [UIColor yellowColor];
    self.projectPageControl.hidesForSinglePage = YES;
    self.projectPageControl.userInteractionEnabled = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem* leftButonItem =
        [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back-normal@2x.png"] style:UIBarButtonItemStylePlain target:self action:@selector(goToMain)];
    
    UIBarButtonItem* rightButtonItem =
    [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"info-normal@2x.png"] style:UIBarButtonItemStylePlain target:self action:@selector(gotoEdit)];
    
    [leftButonItem setTintColor:[UIColor blackColor]];
    [rightButtonItem setTintColor:[UIColor blackColor]];
    
    [self.navigationItem setLeftBarButtonItem:leftButonItem];
    [self.navigationItem setRightBarButtonItem:rightButtonItem];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg@2x.png"]]];
}

- (void)viewDidAppear:(BOOL)animated
{
   //[_ResultLabel removeFromSuperview];
}

- (void)render:(CADisplayLink*)displayLink {
    //NSLog(@"render");
    //GLKView* view = (GLKView*)self.view;
    //avoid UIKit freeze
    [self update];
    //NSLog(@"render1");
    //[_glkview display];
   // [self.view drawRect:CGRectMake(0, 0, 500, 500)];
}

- (void)update
{
   // [_renderScene render];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tryAgainClicked:(id)sender
{
    Project116 * curproj = [[DataCenter116 GetInstance]GetCurrentProject];
    int itemcount = curproj.items.count;
    unsigned int random = arc4random();
    int value = random % itemcount;
    int value1 = (random+1) % itemcount;
    NSString * string = [[DataCenter116 GetInstance]GetItemNameAt:value atProject:curproj];
    NSString * string1 = [[DataCenter116 GetInstance]GetItemNameAt:value1 atProject:curproj];
    _ResultLabel.text = [string isEqualToString:@""]?string1:string ; 
    _ResultLabel.textColor = [UIColor blackColor];
}

@end
