//
//  Project116.m
//  116
//
//  Created by baidu on 14/12/23.
//  Copyright (c) 2014年 baidu. All rights reserved.
//

#import "Project116.h"

@implementation Project116

-(Project116*) init
{
    self = [super init];
    _items = [[NSMutableArray alloc]init];
    return self;
}

-(void)fromDisk:(sqlite3 *) db
{
    NSString *quary = [NSString stringWithFormat:@"SELECT * FROM Item116 where PROJECTNAME=('%@')", _projectName];//SELECT ROW,FIELD_DATA FROM FIELDS ORDER BY ROW
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(db, [quary UTF8String], -1, &stmt, nil) == SQLITE_OK) {
        
        while (sqlite3_step(stmt)==SQLITE_ROW) {
            
            char *itemname = (char *)sqlite3_column_text(stmt, 1);
            NSString * itemName = [[NSString alloc]initWithUTF8String:itemname];
            Item116 * tmp = [[Item116 alloc]initWithName:itemName];
            [self.items addObject:tmp];
        }
        
        sqlite3_finalize(stmt);
    }

}

-(void)toDisk:(sqlite3 *)db
{
    char *errorMsg = NULL;
    //执行语句
    for (Item116* tmp in self.items) {
        NSString *insert = [NSString stringWithFormat:@"INSERT OR REPLACE INTO ITEM116('%@','%@')VALUES('%@','%@')",@"ITEMNAME",@"PROJECTNAME",tmp.itemName,_projectName];
        if (sqlite3_exec(db, [insert UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK) {
            sqlite3_close(db);
        }
    }
}
@end
