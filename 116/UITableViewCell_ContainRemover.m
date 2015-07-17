//
//  UITableViewCell_ContainRemover.m
//  116
//
//  Created by baidu on 14/12/23.
//  Copyright (c) 2014年 baidu. All rights reserved.
//

#import "UITableViewCell_ContainRemover.h"

@interface UITableViewCell_ContainRemover()


@property (strong, nonatomic) UIButton * removeButton;

@property (strong, nonatomic) UIPanGestureRecognizer *panGestureRecognizer;

@end

@implementation UITableViewCell_ContainRemover

- (void)awakeFromNib :(CGFloat)realwidth {
    // Initialization code
    
    for (UIView* subview in self.subviews) {
        [subview removeFromSuperview];
    }
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.autoresizesSubviews = true;
    _removeButton = [[UIButton alloc]initWithFrame:CGRectMake(realwidth - 100, 0, 100,self.bounds.size.height)];
    [self addSubview:_removeButton];
    [_removeButton setTitle:@"Delete" forState:UIControlStateNormal];

    _removeButton.backgroundColor = [UIColor greenColor];
    
    [_removeButton addTarget:self action:@selector(ondeleteItem:) forControlEvents:UIControlEventTouchDown];
    
    self.forgroundView = [[UIView alloc] init];
    self.forgroundView.frame = CGRectMake(0, 0, realwidth,self.bounds.size.height);
    self.forgroundView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.forgroundView];
    
    _textlabel = [[UILabel alloc]initWithFrame:_forgroundView.bounds];
    [_forgroundView addSubview:_textlabel];
    _textlabel.textAlignment = UITextAlignmentCenter;
    
    
    
    
    
    
    _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
    [_panGestureRecognizer setMinimumNumberOfTouches:1];
    [_panGestureRecognizer setMaximumNumberOfTouches:1];
    _panGestureRecognizer.delegate = self;
    [self.forgroundView addGestureRecognizer:_panGestureRecognizer];
    firstX = 0;
    swipeWidth = 100;
}


-(void)move:(UIPanGestureRecognizer*)sender {
    
    CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:self.forgroundView];
    
    if ([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        firstX = [[sender view] center].x;
    }
    
    if (firstX+translatedPoint.x > self.frame.size.width/2){
        translatedPoint = CGPointMake(self.frame.size.width/2, self.forgroundView.center.y);
    } else if (firstX+translatedPoint.x <self.frame.size.width/2 - swipeWidth) {
        translatedPoint = CGPointMake(self.frame.size.width/2 - swipeWidth, self.forgroundView.center.y);
    } else {
        translatedPoint = CGPointMake(firstX+translatedPoint.x, self.forgroundView.center.y);
    }
    
    [[sender view] setCenter:translatedPoint];
    
    if ([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded || [(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateCancelled) {
        CGFloat velocityX = (0.2*[(UIPanGestureRecognizer*)sender velocityInView:self.forgroundView].x);
        
        CGFloat finalX = translatedPoint.x + velocityX;
        
        if (finalX < self.frame.size.width/2 - swipeWidth/2) {
            finalX = self.frame.size.width/2 - swipeWidth;
        } else {
            finalX = self.frame.size.width/2;
        }
        
        CGFloat animationDuration = (ABS(velocityX)*.0002)+.2;
        
        [UIView animateWithDuration:animationDuration animations:^{
            [[sender view] setCenter:CGPointMake(finalX, self.forgroundView.center.y)];
        }];
        
    }
    
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer class] == [UIPanGestureRecognizer class]) {
        
        UIPanGestureRecognizer *g = (UIPanGestureRecognizer *)gestureRecognizer;
        CGPoint point = [g velocityInView:self];
        
        if (fabsf(point.x) > fabsf(point.y) ) {
            
            return YES;
        }
    }
    return NO;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
