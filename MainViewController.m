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
@interface MainViewController ()

@property (strong, nonatomic) UIScrollView *projectScrollView;
@property (weak, nonatomic) IBOutlet SMPageControl *projectPageControl;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
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
    UILabel *pageLabel ;
    CGRect pageFrame ;
    char aLetter ;
    
    for(UIView * subview in [_projectScrollView subviews])
    {
        [subview removeFromSuperview];
    }
    
    for (int i = 0 ; i < numberOfPages ; i++)
    {
        // determine the frame of the current page
        pageFrame = CGRectMake(i * _projectScrollView.bounds.size.width, 0.0f, _projectScrollView.bounds.size.width, _projectScrollView.bounds.size.height) ;
        
        // create a page as a simple UILabel
        pageLabel = [[UILabel alloc] initWithFrame: pageFrame] ;
        
        // add it to the scroll view
        [_projectScrollView addSubview: pageLabel] ;
        //[pageLabel release] ;
        
        // determine and set its (random) background color
        //color = [UIColor colorWithRed: (CGFloat)arc4random()/ARC4RANDOM_MAX green: (CGFloat)arc4random()/ARC4RANDOM_MAX blue: (CGFloat)arc4random()/ARC4RANDOM_MAX alpha: 1.0f] ;
        //[pageLabel setBackgroundColor: color] ;
        
        // set some label properties
        [pageLabel setFont: [UIFont boldSystemFontOfSize: 100.0f]] ;
        [pageLabel setTextAlignment: UITextAlignmentCenter] ;
        [pageLabel setTextColor: [UIColor darkTextColor]] ;
        
        // set the label's text as the letter corresponding to the current page index
        //aLetter = (char)((i+65)-(i/26)*26) ;    // the capitalized alphabet characters are in the range 65-90
        pageLabel.text = [[DataCenter116 GetInstance] GetProjectNameAt:i] ;
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



@end
