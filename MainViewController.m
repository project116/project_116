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
#import "AboutViewController.h"
#import "ItemLayer.h"
#import "ItemLayerEx.h"
#import "VerticalWriteLabel.h"
#import "Utils116.h"
#import "NSMutableArray+RandomArray.h"
#import "LayerBuilder.h"
#import "EventDefine.h"
#import "Observer.h"

@interface MainViewController ()

@property (strong, nonatomic) UIScrollView *projectScrollView;
@property (weak, nonatomic) IBOutlet SMPageControl *projectPageControl;
@property (weak, nonatomic) IBOutlet UIButton *btnStart;
@property (strong, nonatomic) UILabel *resultLabel;
@property (weak, nonatomic) IBOutlet UIButton *btnTryAgain;
@property (nonatomic) UIView* animationContainerView;
@property (strong, nonatomic) UIImageView* tagView;
@property (nonatomic) NSArray* pageStatus;
@property (nonatomic, strong) NSMutableArray* observers;
@property (nonatomic, strong) LayerBuilder* builder;
typedef enum : NSUInteger {
    kStateNormal,
    kStateAnimation,
    kStateResult,
} ENState;

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
    
    [_projectPageControl addTarget: self action: @selector(pageControlClicked:) forControlEvents: UIControlEventValueChanged];


    [self refreshPages];
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    self.animationContainerView = [[UIView alloc]initWithFrame:CGRectMake(0, 120, screenBounds.size.width, screenBounds.size.height - 240)];
    [self.animationContainerView setHidden:YES];
    //[self.view addSubview:self.animationContainerView];
    [self.projectScrollView addSubview:self.animationContainerView];
    CATransform3D trans = CATransform3DIdentity;
    trans.m34 = -1/500.f;
    [self.animationContainerView.layer setSublayerTransform:trans];
    [self.animationContainerView.layer setMasksToBounds:YES];
    
    [self initNoticationObserver];
}

- (void)initNoticationObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onStartBtnClickEvent:)
                                                 name:EVENT_STARTBTN_CLICKED
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onProjectAnimationStop)
                                                 name:EVENT_PROJECT_ANIMATION_STOP
                                               object:nil];
    
    self.observers = [[NSMutableArray alloc]init];
    [self.observers addObject:[Observer observerWithObject:[DataCenter116 GetInstance] keyPath:@"currentProj" target:self selector:@selector(projectSelectionChanged)]];
}

- (void)projectSelectionChanged {
    
    [self switchState:kStateNormal];
}

- (void)onProjectAnimationStop {
    [self switchState:kStateResult];
}

- (void)onStartBtnClickEvent:(NSNotification*)notify {
    UIView* currentProjectView = [self getProjectCurrentPageView];
    UIImage* img = [Utils116 GetSnapshot:currentProjectView];
    
    if (self.tagView) {
        [self.tagView removeFromSuperview];
    }

    self.tagView = [[UIImageView alloc] initWithImage:img];
    [self.view addSubview:self.tagView];
    
    // currentProjectView是在self.projectScrollView中的，而tagView是在self.view中的，需要进行坐标转换.
    CGPoint offset = self.projectScrollView.contentOffset;
    CGRect targetRect = [currentProjectView convertRect:currentProjectView.frame toView:self.view];
    targetRect.origin.x -= offset.x;
    targetRect.origin.y -= offset.y;
    [self.tagView setFrame:targetRect];
    [self switchState:kStateAnimation];
    [self playProjectAnimation:self.tagView];
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

// 获取当前项目的UIView.
- (UIView*)getProjectCurrentPageView {
    UIView* result = nil;
    CGPoint offsetPoint = self.projectScrollView.contentOffset;
    NSUInteger offsetIdx = offsetPoint.x / self.projectScrollView.bounds.size.width;
    if (offsetIdx >= 0 && offsetIdx < self.projectScrollView.subviews.count) {
        result = [self.projectScrollView.subviews objectAtIndex:offsetIdx];
    }
    
    return result;
}

- (void)refreshPages{
    int numberOfPages = [[DataCenter116 GetInstance] GetProjectCount] ;
    [_projectScrollView setContentSize: CGSizeMake(_projectScrollView.bounds.size.width * numberOfPages, 0)] ;
    _projectPageControl.numberOfPages = numberOfPages;     //几个小点
    
    //为每个分页添加内容
    MainProjectView *pageLabel;
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
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_STARTBTN_CLICKED object:nil];
}

- (IBAction)onTryAgain:(id)sender {
    if (self.builder) {
        [self.builder resumePlay];
    }
    
    [self switchState:kStateAnimation];
}

- (void)playProjectAnimation:(UIView*)view {
    UIViewAnimationOptions options = UIViewAnimationCurveEaseOut;
    [UIView animateWithDuration:2.f
                          delay:0.25f
                        options:options
                     animations:^{
                         CGRect screenBounds = [[UIScreen mainScreen] bounds];
                         CGPoint destination = CGPointMake(self.view.bounds.size.width - 40, self.view.bounds.origin.y);
                         CGAffineTransform trans = CGAffineTransformIdentity;
                         trans = CGAffineTransformScale(trans, 0.3f, 0.3f);
                         CGPoint pt = view.center;
                         trans = CGAffineTransformTranslate(trans, destination.x, (destination.y - view.center.y)/0.3f + view.bounds.size.height);
                         [view setTransform:CGAffineTransformConcat(view.transform, trans)];

                     }
                     completion:^(BOOL bFinished){
                         UIView* view = [self getProjectCurrentPageView];
                         [self.animationContainerView setFrame:view.frame];
                         [self.animationContainerView setHidden:NO];
                     }];
    
    [self buildItemLayer];
}

- (void)buildItemLayer {
    Project116* curProj = [[DataCenter116 GetInstance] GetCurrentProject];
    NSMutableArray* items = [curProj items];
    
    NSMutableArray<NSString*>* names = [NSMutableArray arrayWithCapacity:items.count];
    for (id obj in items) {
        [names addObject:[obj itemName]];
    }
    

    self.builder = [[LayerBuilder alloc]initWithView:self.animationContainerView];
    [self.builder build:names];
}

- (void)switchState:(ENState)state {
    
    switch (state) {
        case kStateNormal:
            [self.btnStart setHidden:NO];
            [self.btnTryAgain setHidden:YES];
            [self.animationContainerView setHidden:YES];
            [self.projectPageControl setHidden:NO];
            [[self getProjectCurrentPageView] setHidden:NO];
            [self.projectScrollView setScrollEnabled:YES];

            if (self.tagView) {
                [self.tagView removeFromSuperview];
            }
            
            if (self.builder) {
                [self.builder stopAndClear];
            }
            break;
        case kStateAnimation:
            [self.btnStart setHidden:YES];
            [self.btnTryAgain setHidden:YES];
            [self.animationContainerView setHidden:NO];
            [self.projectPageControl setHidden:YES];
            [[self getProjectCurrentPageView] setHidden:YES];
            // 禁止滚动
            [self.projectScrollView setScrollEnabled:NO];
            break;
        case kStateResult:
            [self.btnTryAgain setHidden:NO];
            [self.btnStart setHidden:YES];
            [self.projectPageControl setHidden:NO];
            [self.projectScrollView setScrollEnabled:YES];
            break;
        default:
            break;
    }
}

- (void)randomLayout:(NSDictionary*)dict {
    int row_max = 2;
    int col_max = 4;
    int xMargin = 10;
    int yMargin = 10;

    int actual_rows = 0;
    float actual_rowsf = dict.count * 1.f / col_max;
    if (actual_rowsf > (int)actual_rowsf) {
        actual_rows = actual_rowsf + 1;
    }
    else {
        actual_rows = actual_rows;
    }
    
    int verticalPartDistance = (self.view.frame.size.height - 2*yMargin - self.btnStart.frame.size.height) / actual_rows;
    int horizontalPartDistance = (self.view.frame.size.width - 2*xMargin) / col_max;
    int lastCol = dict.count % col_max;
    int lastRowHorizontalPartDistance = (self.view.bounds.size.width - 2*xMargin) / lastCol;
    
    int idx = 0;
    NSEnumerator<CItemLayerEx*>* enumerator = [dict objectEnumerator];
    do {
        CItemLayerEx* obj = [enumerator nextObject];
        if (!obj) break;
        
        int row = idx / col_max;
        int col = idx % col_max;
        
        CGRect rectOfBounds = CGRectZero;
        if (row == actual_rows-1) {
            rectOfBounds.origin.x = lastRowHorizontalPartDistance*col + xMargin;
            rectOfBounds.size.width = lastRowHorizontalPartDistance;
        }
        else {
            rectOfBounds.origin.x = horizontalPartDistance*col + xMargin;
            rectOfBounds.size.width = horizontalPartDistance;
        }
        
        rectOfBounds.origin.y = verticalPartDistance * row + yMargin;
        rectOfBounds.size.height = verticalPartDistance;
        
        CGRect rectOfLayer = CGRectMake(
                                        rectOfBounds.origin.x + (rectOfBounds.size.width-obj.bounds.size.width)/2+arc4random()%15,
                                        rectOfBounds.origin.y + (rectOfBounds.size.height-obj.bounds.size.height)/2+arc4random()%20,
                                        obj.bounds.size.width,
                                        obj.bounds.size.height);
        
        [self.view.layer addSublayer:obj];
        [obj setFrame:rectOfLayer];
        
        idx++;
        
    } while(true);
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

- (IBAction)goAboutView:(id)sender {
    
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    AboutViewController *aboutView = (AboutViewController*)[storyboard instantiateViewControllerWithIdentifier:@"AboutViewController"];

    [self.navigationController pushViewController:aboutView animated:YES];
}

@end


