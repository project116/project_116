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
#import "ResultView.h"
#import "RenderScene.h"
@interface ResultViewController ()
//@property (weak, nonatomic) IBOutlet UIButton *tryAgainButton;
@property (weak, nonatomic) IBOutlet GLKView *glkview;
@property (strong, nonatomic) EAGLContext * context;
@property (strong, nonatomic) RenderScene* renderScene;
@property (strong, nonatomic) UILabel *ResultLabel;
@end

@implementation ResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [_tryAgainButton removeFromSuperview];
    _ResultLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 200, [UIScreen mainScreen].bounds.size.width -100, [UIScreen mainScreen].bounds.size.height - 400) ];
    
    [_ResultLabel setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    _ResultLabel.backgroundColor  = [UIColor whiteColor];
    [_ResultLabel setTextAlignment: UITextAlignmentCenter] ;
    [_ResultLabel setFont: [UIFont boldSystemFontOfSize: 100.0f]] ;
    [self.view addSubview:_ResultLabel];
    
    // Do any additional setup after loading the view.
    Project116 * curproj = [[DataCenter116 GetInstance]GetCurrentProject];
    int itemcount = curproj.items.count;
    unsigned int random = arc4random();
    int value = random % itemcount;
    int value1 = (random+1) % itemcount;
    NSString * string = [[DataCenter116 GetInstance]GetItemNameAt:value atProject:curproj];
    NSString * string1 = [[DataCenter116 GetInstance]GetItemNameAt:value1 atProject:curproj];
    _ResultLabel.text = [string isEqualToString:@""]?string1:string ;
    _ResultLabel.textColor = [UIColor blackColor];
    
    
    
    UIButton * _tryAgainButton = [[UIButton alloc]initWithFrame:CGRectMake(100, [UIScreen mainScreen].bounds.size.height - 200, [UIScreen mainScreen].bounds.size.width -200, 100) ];
    
    [_tryAgainButton setTitleColor: [UIColor blueColor] forState: UIControlStateNormal] ;
    [_tryAgainButton setTitle:@"再试一次" forState:UIControlStateNormal];
    [self.view addSubview:_tryAgainButton];
    
    _tryAgainButton.userInteractionEnabled = YES;
    [_tryAgainButton addTarget: self action: @selector(tryAgainClicked:) forControlEvents: UIControlEventTouchDown] ;
    
    return;
    
    
    
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    _glkview = [[GLKView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    _glkview.context = self.context;
    [self.view addSubview:_glkview];
    //    self.preferredFramesPerSecond = 60;
    
    //avoid UIKit freeze
    //http://stackoverflow.com/questions/10080932/glkviewcontrollerdelegate-getting-blocked
    _glkview.enableSetNeedsDisplay = YES;
    
    
    //view.contentScaleFactor = [UIScreen mainScreen].scale;
    //self.preferredFramesPerSecond = 0;
    displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(render:)];
    [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    displayLink.frameInterval = 5;
    
    _renderScene = [[RenderScene alloc]initWithContext:self.context];
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
