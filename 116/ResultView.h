//
//  CTView.h
//  Font2Image
//
//  Created by baidu on 15/3/5.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <GLKit/GLKit.h>
@interface ResultView : UIView

-(void)setText:(NSString*) inputtext;
-(void)characterAttribute;

@property(strong, nonatomic) UIViewController* controller;
@property(nonatomic) CGContextRef  context;
@property(strong, nonatomic) NSString* projectName;
@end
