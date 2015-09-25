//
//  MainViewController.m
//  116
//
//  Created by baidu on 14/12/23.
//  Copyright (c) 2014年 baidu. All rights reserved.
//

#import "MainViewController.h"
#import "DataCenter116.h"
#import "SMPageControl.h"
#import "MainProjectView.h"
#import "UINavigationBar+customBar.h"
#import "NSString+VerticalNSString.h"

@interface MainViewController ()

@property (strong, nonatomic) UIScrollView *projectScrollView;
@property (weak, nonatomic) IBOutlet SMPageControl *projectPageControl;
@property (weak, nonatomic) IBOutlet UIButton *btnStart;
@property (strong, nonatomic) UILabel *resultLabel;
@property (weak, nonatomic) IBOutlet UIButton *btnTryAgain;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
    
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.title = @"主页";

    self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    

    [self.navigationController.navigationBar setBackIndicatorImage:
     [UIImage imageNamed:@"back-normal"]];
    [self.navigationController.navigationBar setBackIndicatorTransitionMaskImage:
     [UIImage imageNamed:@"back-normal"]];
    
    
    [[DataCenter116 GetInstance] addObserver:self forKeyPath: @"ProjectRemoved" options:0 context:NULL];
    [[DataCenter116 GetInstance] addObserver:self forKeyPath: @"ProjectAdded" options:0 context:NULL];
    [[DataCenter116 GetInstance] addObserver:self forKeyPath: @"ProjectChanged" options:0 context:NULL];
    
    _projectScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) ];
    [self.view insertSubview:_projectScrollView atIndex:0];
    [_projectScrollView setPagingEnabled:YES];
    
    _projectScrollView.delegate = self;
    _projectScrollView.showsVerticalScrollIndicator = NO;
    _projectScrollView.showsHorizontalScrollIndicator = NO;
    
    
    [_projectPageControl setPageIndicatorImage:[UIImage imageNamed:@"xiangmu"]];
    [_projectPageControl setCurrentPageIndicatorImage:[UIImage imageNamed:@"dangqianxiangmu"]];
    _projectPageControl.backgroundColor = [UIColor clearColor];
    _projectPageControl.currentPageIndicatorTintColor = [UIColor redColor];
    _projectPageControl.pageIndicatorTintColor = [UIColor yellowColor];
    _projectPageControl.hidesForSinglePage = YES;
    _projectPageControl.userInteractionEnabled = YES;
    
    [_projectPageControl addTarget: self action: @selector(pageControlClicked:) forControlEvents: UIControlEventValueChanged] ;


    [self refreshPages];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:@"ProjectRemoved"] || [keyPath isEqualToString:@"ProjectAdded"]|| [keyPath isEqualToString:@"ProjectChanged"]) {
        [self refreshPages];
    }
}

- (void)refreshPages{
    int numberOfPages = [[DataCenter116 GetInstance] GetProjectCount] ;
    [_projectScrollView setContentSize: CGSizeMake(_projectScrollView.bounds.size.width * numberOfPages, 0)] ;
    _projectPageControl.numberOfPages = numberOfPages;     //几个小点
    
    //为每个分页添加内容
    MainProjectView *pageLabel ;
    CGRect pageFrame ;
    char aLetter ;
    
    for(UIView * subview in [_projectScrollView subviews])
    {
        [subview removeFromSuperview];
    }
    
    for (int i = 0 ; i < numberOfPages ; i++)
    {
        // determine the frame of the current page
        pageFrame = CGRectMake(i * _projectScrollView.bounds.size.width, 0.0f, _projectScrollView.bounds.size.width, 400) ;
        
        // create a page as a simple UILabel
        pageLabel = [[MainProjectView alloc] initWithFrame: pageFrame withString:[[DataCenter116 GetInstance] GetProjectNameAt:i] ] ;
        
        // add it to the scroll view
        [_projectScrollView addSubview: pageLabel] ;
        
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// //In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
////     Get the new view controller using [segue destinationViewController].
////     Pass the selected object to the new view controller.
//
//}


#pragma mark DDPageControl triggered actions
- (void)pageControlClicked:(id)sender
{
    UIPageControl *thePageControl = (UIPageControl *)sender ;
    [_projectScrollView setContentOffset: CGPointMake(_projectScrollView.bounds.size.width * thePageControl.currentPage, _projectScrollView.contentOffset.y) animated: YES] ;
}

#pragma mark UIScrollView delegate methods
- (void)scrollViewDidScroll:(UIScrollView *)aScrollView
{
    CGFloat pageWidth = _projectScrollView.bounds.size.width ;
    float fractionalPage = _projectScrollView.contentOffset.x / pageWidth ;
    NSInteger nearestNumber = lround(fractionalPage) ;
    
    if (_projectPageControl.currentPage != nearestNumber)
    {
        _projectPageControl.currentPage = nearestNumber;
        
        // if we are dragging, we want to update the page control directly during the drag
        if (_projectScrollView.dragging)
            [_projectPageControl updateCurrentPageDisplay] ;
    }
    

    [[DataCenter116 GetInstance ] SetCurrentProject: nearestNumber];
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)aScrollView
{
    // if we are animating (triggered by clicking on the page control), we update the page control
     [_projectPageControl updateCurrentPageDisplay] ;
}

- (IBAction)clickSelect:(id)sender {
    [self switchMainResult:YES];
    [self createLabel4Result:@"中华人名共和国万岁万万岁"];
}

- (IBAction)onTryAgain:(id)sender {
    [self switchMainResult:NO];
}

- (void)switchMainResult:(Boolean)main2result {
    
    if (YES == main2result) {
        [self.projectScrollView setHidden:YES];
        [self.btnStart setHidden:YES];
        [self.resultLabel setHidden:NO];
        [self.btnTryAgain setHidden:NO];
    }
    else {
        [self.projectScrollView setHidden:NO];
        [self.btnStart setHidden:NO];
        [self.resultLabel setHidden:YES];
        [self.btnTryAgain setHidden:YES];

    }
}

- (UILabel*)createLabel4Result:(NSString*)str {
    UILabel *result = nil;
    
    if (self.resultLabel == nil) {
         self.resultLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 45)];
    }
    
    result = self.resultLabel;

    if (result != nil) {
        
        [result setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.view addSubview:result];
        
        NSLayoutConstraint *constraintTop =
        [NSLayoutConstraint constraintWithItem:result attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeBaseline multiplier:1.f constant:35.f];
        
        NSLayoutConstraint *constraintWidth =
        [NSLayoutConstraint constraintWithItem:result attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:45];
        
        NSLayoutConstraint *constraintHeight =
        [NSLayoutConstraint constraintWithItem:result attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:310];

        NSLayoutConstraint *constraintCenterY =
        [NSLayoutConstraint constraintWithItem:result attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.f constant:0.f];
        
        
        [result addConstraint:constraintWidth];
        [result addConstraint:constraintHeight];
        [self.view addConstraint:constraintTop];
        [self.view addConstraint:constraintCenterY];
        
        NSString *text = str;
        
        if (text.length > 10) {
            text = [text substringWithRange:NSMakeRange(0, 10)];
        }
        
        NSString* verticalText = [text makeVerticalOutString];
        [self setResultLabel:result text:verticalText src:text];
        [result setNumberOfLines:0];
        [result setTextAlignment:NSTextAlignmentCenter];

    }
    
    return  result;
}

- (void) setResultLabel:(UILabel*) label text: (NSString*) text src:(NSString*) src {
    if (nil != label) {
    
        if (src.length >= 10) {
            NSMutableParagraphStyle* paragraphStryle = [[NSMutableParagraphStyle alloc]init];
            NSMutableDictionary *dictionary = @{NSParagraphStyleAttributeName:paragraphStryle};
            [paragraphStryle setMaximumLineHeight:50];
            [paragraphStryle setMinimumLineHeight:28];
            [paragraphStryle setAlignment:NSTextAlignmentJustified];
            [paragraphStryle setParagraphSpacingBefore:0.0];
            [paragraphStryle setLineSpacing:0.0];
            [paragraphStryle setParagraphSpacing:0.0];
            
            NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:text attributes:dictionary];

            [label setFont: [UIFont fontWithName:@"FZSuXinShiLiuKaiS-R-GB" size: 28.0f]];
            [label setAttributedText:attributedStr];
        }
        else {
            [label setText:text];
            [label setFont: [UIFont fontWithName:@"FZSuXinShiLiuKaiS-R-GB" size: 120.0f]];
            [label setAdjustsFontSizeToFitWidth:YES];
        }
        
    }
}


@end


