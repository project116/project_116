//
//  Project116.h
//  116
//
//  Created by baidu on 14/12/23.
//  Copyright (c) 2014年 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Item116.h"
#import "sqlite3.h"
@interface Project116 : NSObject

@property NSMutableArray * items;
@property NSString * projectName;

-(void)fromDisk:(sqlite3 * )db;
-(void)toDisk:(sqlite3 * )db;
@end
