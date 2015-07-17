//
//  DataCenter116.h
//  116
//
//  Created by baidu on 14/12/23.
//  Copyright (c) 2014年 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Project116.h"
#import "sqlite3.h"

@interface DataCenter116 : NSObject

+ (DataCenter116*) GetInstance;
- (NSString *)GetProjectNameAt:(int)projectIndex;
- (Project116 *)GetProjectAt:(int)projectIndex;
- (Item116 *)GetItemAt:(int)itemIndex atProject:(Project116 *)project;
- (NSString *)GetItemNameAt:(int)itemIndex atProject:(Project116 *)project;
- (void)RemoveProject:(Project116*)project116;
- (void)RemoveProjectAt:(int)projectIndex;
- (void)RemoveItem:(Item116*)item116 atProject:(Project116 *)project;
- (void)AddProject:(NSString *)projectName;
- (void)AddItem:(NSString*)itemName atProject:(Project116 *)project;
- (void)ChangeProjectName:(NSString *)projectName atProject:(Project116 *)project;
- (void)ChangeItemName:(NSString*)itemName atItem:(Item116 *)item atProject:(Project116*) project;
- (int)GetProjectCount;
- (void)SetCurrentProject:(NSUInteger)projectIndex;
- (void)SetProjectToBeEdit:(NSString*) projectName;
- (Project116 *)GetCurrentProject;

@property(nonatomic) sqlite3 *db;
@end
