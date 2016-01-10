//
//  MainViewController.h
//  116
//
//  Created by baidu on 14/12/23.
//  Copyright (c) 2014年 baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemLayer.h"
#import "ItemLayerEx.h"

@interface MainViewController : UIViewController<UIScrollViewDelegate>

@property (nonatomic, strong) CItemLayer* itemLayer;
@property (nonatomic, strong) CItemLayerEx* itemLayerEx;

@end
