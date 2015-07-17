//
//  CustomPush.m
//  116
//
//  Created by baidu on 15/4/10.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import "CustomPush.h"

@implementation CustomPush
-(void)perform
{
    UIViewController * current = self.sourceViewController;
    UIViewController * dest = self.destinationViewController;
    [current.navigationController pushViewController:self.destinationViewController animated:NO];
}
@end
