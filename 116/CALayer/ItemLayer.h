//
//  ItemLayer.h
//  116
//
//  Created by JayGuo on 15/11/9.
//  Copyright © 2015年 baidu. All rights reserved.
//

#ifndef ItemLayer_h
#define ItemLayer_h

#import <UIKit/UIKit.h>

@interface CItemLayer : CATextLayer
{
}

- (instancetype)initWithText:(NSString*)text;
- (void)showLayerWithAnimation;
@end // CItemLayer


#endif /* ItemLayer_h */
