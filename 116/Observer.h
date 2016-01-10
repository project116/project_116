//
//  Observer.h
//  KVX
//
//  Created by JayGuo on 15/10/9.
//  Copyright (c) 2015年 JayGuo. All rights reserved.
//

#ifndef KVX_Observer_h
#define KVX_Observer_h


@interface Observer : NSObject
+ (instancetype)observerWithObject:(id)object
                           keyPath:(NSString*)keyPath
                            target:(id)target
                          selector:(SEL)selector;
@end //Observer


#endif
