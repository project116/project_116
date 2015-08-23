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
    _removeButton = [[UIButton alloc]initWithFrame:CGRectMake(realwidth - 50, 0, 50,self.bounds.size.height)];
    [self addSubview:_removeButton];
    [_removeButton setTitle:@"删除" forState:UIControlStateNormal];

    _removeButton.backgroundColor = [UIColor redColor];
    
    [_removeButton addTarget:self action:@selector(ondeleteItem:) forControlEvents:UIControlEventTouchDown];
    
    [_removeButton setFont: [UIFont fontWithName:@"fangsong" size: 17.0f]] ;
    
    self.forgroundView = [[UIView alloc] init];
    self.forgroundView.frame = CGRectMake(0, 0, realwidth,self.bounds.size.height);
    self.forgroundView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.forgroundView];
    
    _textlabel = [[UILabel alloc]initWithFrame:CGRectMake(_forgroundView.bounds.origin.x + 50, _forgroundView.bounds.origin.y, _forgroundView.bounds.size.width, _forgroundView.bounds.size.height)];
    
    _bottomLine = [[UILabel alloc]initWithFrame:CGRectMake(_forgroundView.bounds.origin.x + 50, _forgroundView.bounds.origin.y + _forgroundView.bounds.size.height - 1, _forgroundView.bounds.size.width, 1)];
    _bottomLine.backgroundColor = [UIColor lightGrayColor];
    
    
    [_forgroundView addSubview:_textlabel];
    [_forgroundView addSubview:_bottomLine];
    _textlabel.textAlignment = UITextAlignmentLeft;
   [_textlabel setFont: [UIFont fontWithName:@"fangsong" size: 17.0f]] ;
    
    
    
    
    
    
    
    _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
    [_panGestureRecognizer setMinimumNumberOfTouches:1];
    [_panGestureRecognizer setMaximumNumberOfTouches:1];
    _panGestureRecognizer.delegate = self;
    [self.forgroundView addGestureRecognizer:_panGestureRecognizer];
    firstX = 50;
    swipeWidth = 50;
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
