//
//  MainProjectView.m
//  116
//
//  Created by baidu on 15/8/9.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import "MainProjectView.h"

@interface MainProjectView()
@property (strong, nonatomic) NSString* oriString;
@property (strong, nonatomic) NSString* pinyinString;
@property (strong, nonatomic) NSString* verticalString;
@property (strong, nonatomic) UIImageView* iconView;
@property (strong, nonatomic) UILabel* pinyinLable;
@property (strong, nonatomic) UILabel* verticalLable;
@end

@implementation MainProjectView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame withString:(NSString*) projectname
{
    self = [super initWithFrame:frame];
    if (nil == self) {
        return nil;
    }
    _oriString = projectname;
    NSMutableString *ms = [[NSMutableString alloc] initWithString:projectname];
    if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformMandarinLatin, NO) &&
        CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformStripDiacritics, NO)) {
        _pinyinString = [ms uppercaseString];
    }
    
    _verticalString = [[NSString alloc]init];
    for (int i = 0; i < _oriString.length; ++ i) {
        if (i < 5) {
            _verticalString = [_verticalString stringByAppendingString:[_oriString substringWithRange:NSMakeRange(i, 1)]];
            _verticalString = [_verticalString stringByAppendingString:@"\n"];
        }
    }
    
    _iconView = [[UIImageView alloc]initWithFrame:CGRectMake(100, 100, 36, 36)];
    [_iconView setImage:[UIImage imageNamed:@"yao-icon"]];
    [self addSubview: _iconView];
    
    _pinyinLable = [[UILabel alloc]initWithFrame:CGRectMake(-10, 250, 250, 36)];
    _pinyinLable.transform = CGAffineTransformMakeRotation(90*M_PI/180);
    _pinyinLable.text = _pinyinString;
    [_pinyinLable setFont: [UIFont fontWithName:@"fangsong" size: 100.0f]] ;
    [self addSubview:_pinyinLable];
    
    _verticalLable = [[UILabel alloc]initWithFrame:CGRectMake(150, 50, 100, 350)];
    _verticalLable.numberOfLines = 0;
    _verticalLable.text = _verticalString;
    [_verticalLable setFont: [UIFont fontWithName:@"FZSuXinShiLiuKaiS-R-GB" size: 100.0f]] ;
    [self addSubview:_verticalLable];
    
    return self;
}

@end
