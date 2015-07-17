//
//  DataCenter116.m
//  116
//
//  Created by baidu on 14/12/23.
//  Copyright (c) 2014年 baidu. All rights reserved.
//

#import "DataCenter116.h"
#import "Project116.h"


@interface DataCenter116 ()

@property (strong, nonatomic) NSMutableArray *projectarray;
@property (weak, nonatomic) Project116* currentProj;
@end

@implementation DataCenter116

static DataCenter116 * instance;

- (DataCenter116 *)init
{
    self = [super init];
    self.projectarray = [[NSMutableArray alloc]init];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"database_name"];
    
    if (sqlite3_open([path UTF8String], &_db) != SQLITE_OK) {
        sqlite3_close(_db);
        NSAssert(0, @"数据库打开失败。");
    }
    NSString *ceateSQL = @"CREATE TABLE IF NOT EXISTS Project116(ID INTEGER PRIMARY KEY AUTOINCREMENT, PROJECTNAME TEXT, PROJECTID INTEGER)";
    
    char *ERROR;
    
    if (sqlite3_exec(_db, [ceateSQL UTF8String], NULL, NULL, &ERROR)!=SQLITE_OK){
        sqlite3_close(_db);
        NSAssert(0, @"ceate table faild!");
        NSLog(@"表创建失败");
    }
    ceateSQL = @"CREATE TABLE IF NOT EXISTS Item116(ID INTEGER PRIMARY KEY AUTOINCREMENT, ITEMNAME TEXT, PROJECTNAME TEXT)";
    

    if (sqlite3_exec(_db, [ceateSQL UTF8String], NULL, NULL, &ERROR)!=SQLITE_OK){
        sqlite3_close(_db);
        NSAssert(0, @"ceate table faild!");
        NSLog(@"表创建失败");
    }

    
    [self fromDisk];
    return self;
}
+ (DataCenter116*)GetInstance
{
    if (instance == nil) {
        instance = [[DataCenter116 alloc]init];
    }
    if ([instance GetProjectCount] == 0) {
        [instance setDefaultData];
    }
    return instance;
}

- (int)GetProjectCount
{
    return _projectarray.count;
}

- (void)SetCurrentProject:(NSUInteger)projectIndex
{
    _currentProj = [_projectarray objectAtIndex:projectIndex];
}

- (Project116 * )GetCurrentProject
{
    return _currentProj;
}

- (void)setDefaultData
{
    Project116 * tmp = [[Project116 alloc]init];
    tmp.projectName = @"晚饭";
    [tmp.items addObject:[[Item116 alloc]initWithName:@"a"]];
    [_projectarray addObject:tmp];

    
    
    tmp = [[Project116 alloc]init];
    tmp.projectName = @"B";
    [tmp.items addObject:[[Item116 alloc]initWithName:@"b"]];
    [tmp.items addObject:[[Item116 alloc]initWithName:@"bb"]];
    [_projectarray addObject:tmp];
    
    tmp = [[Project116 alloc]init];
    tmp.projectName = @"C";
    [tmp.items addObject:[[Item116 alloc]initWithName:@"c"]];
    [tmp.items addObject:[[Item116 alloc]initWithName:@"cc"]];
    [tmp.items addObject:[[Item116 alloc]initWithName:@"ccc"]];
    [_projectarray addObject:tmp];
    
    [self toDisk];
}

- (NSString *)GetProjectNameAt:(int)projectIndex
{
    if (_projectarray.count > projectIndex) {
        Project116* tmp = [_projectarray objectAtIndex:projectIndex];
        return tmp.projectName;
    }
    return nil;
}

- (Project116 *)GetProjectAt:(int)projectIndex
{
    if (_projectarray.count > projectIndex) {
        Project116* tmp = [_projectarray objectAtIndex:projectIndex];
        return tmp;
    }
    return nil;
}

- (void)SetProjectToBeEdit:(NSString*) projectName
{
    for (int i = 0; i < _projectarray.count; i++) {
        Project116 * tmp = [_projectarray objectAtIndex:i];
        if(tmp.projectName == projectName)
        {
            [self SetCurrentProject:i];
            break;
        }
    }
    [self willChangeValueForKey:@"ProjectTobeEdit"];
    [self didChangeValueForKey:@"ProjectTobeEdit"];
}

- (void)RemoveProject:(Project116*)project116
{
    [self willChangeValueForKey:@"ProjectRemoved"];
    [_projectarray removeObject:project116];
  
    char *errorMsg = NULL;
    NSString *delete = [NSString stringWithFormat:@"delete from Project116 where PROJECTNAME =('%@')",project116.projectName];
    //将SQL语句放入sqlite3_stmt中
    int success = sqlite3_exec(_db, [delete UTF8String], NULL, NULL, &errorMsg);
    if (success != SQLITE_OK) {
        NSLog(@"Error: failed to delete:testTable");
        sqlite3_close(_db);
    }
    
    errorMsg = NULL;
    delete = [NSString stringWithFormat:@"delete from Item116 where PROJECTNAME =('%@')",project116.projectName];
    //将SQL语句放入sqlite3_stmt中
     success = sqlite3_exec(_db, [delete UTF8String], NULL, NULL, &errorMsg);
    if (success != SQLITE_OK) {
        NSLog(@"Error: failed to delete:testTable");
        sqlite3_close(_db);
    }
    
    [self didChangeValueForKey:@"ProjectRemoved"];

}

-(NSString *)GetItemNameAt:(int)itemIndex atProject:(Project116 *)project
{
    Item116* tmp = [project.items objectAtIndex:itemIndex];
    return tmp.itemName;
}

-(NSString *)GetItemAt:(int)itemIndex atProject:(Project116 *)project
{
    Item116* tmp = [project.items objectAtIndex:itemIndex];
    return tmp;
}

-(void)RemoveItem:(Item116 *)item116 atProject:(Project116 *)project
{
    [self willChangeValueForKey:@"ItemRemoved"];
    [project.items removeObject:item116];
    
    char *errorMsg = NULL;
    NSString *delete = [NSString stringWithFormat:@"delete from Item116 where PROJECTNAME =('%@') and ITEMNAME=('%@')",project.projectName, item116];
    //将SQL语句放入sqlite3_stmt中
    int success = sqlite3_exec(_db, [delete UTF8String], NULL, NULL, &errorMsg);
    if (success != SQLITE_OK) {
        NSLog(@"Error: failed to delete:testTable");
        sqlite3_close(_db);
    }
    
    [self didChangeValueForKey:@"ItemRemoved"];
}

-(void)AddProject:(NSString *)projectName
{
    if ([projectName isEqualToString:@""]) {
        return;
    }
    for (Project116* project116 in _projectarray) {
        if ([project116.projectName isEqualToString: projectName]) {
            return;
        }
    }
    [self willChangeValueForKey:@"ProjectAdded"];
    Project116 * project116 = [[Project116 alloc]init];
    project116.projectName = projectName;
    [_projectarray addObject:project116];
    
    char *errorMsg = NULL;
    NSString *add = [NSString stringWithFormat:@"insert into Project116('%@','%@')VALUES('%@','%d')",@"PROJECTNAME",@"PROJECTID",projectName,9];
    //将SQL语句放入sqlite3_stmt中
    int success = sqlite3_exec(_db, [add UTF8String], NULL, NULL, &errorMsg);
    if (success != SQLITE_OK) {
        NSLog(@"Error: failed to delete:testTable");
        sqlite3_close(_db);
    }
    self.currentProj = project116;
    [self didChangeValueForKey:@"ProjectAdded"];
}

-(void)AddItem:(NSString *)itemName atProject:(Project116 *)project
{
    if ([itemName isEqualToString:@""]) {
        return;
    }
    [self willChangeValueForKey:@"ItemAdded"];
    [project.items addObject:[[Item116 alloc]initWithName:itemName]];
    
    char *errorMsg = NULL;
    NSString *add = [NSString stringWithFormat:@"insert into Item116('%@','%@')VALUES('%@','%@')",@"ITEMNAME",@"PROJECTNAME",itemName,project.projectName];
    //将SQL语句放入sqlite3_stmt中
    int success = sqlite3_exec(_db, [add UTF8String], NULL, NULL, &errorMsg);
    if (success != SQLITE_OK) {
        NSLog(@"Error: failed to delete:testTable");
        sqlite3_close(_db);
    }
    
    [self didChangeValueForKey:@"ItemAdded"];
}

- (void)ChangeItemName:(NSString*)itemName atItem:(Item116 *)item atProject:(Project116 *)project
{
    if ([itemName isEqualToString:@""]) {
        return;
    }
    [self willChangeValueForKey:@"ItemChanged"];
    NSString* oldname = item.itemName;
    item.itemName = itemName;
    
    char *errorMsg = NULL;
    NSString *update = [NSString stringWithFormat:@"update Item116 set ITEMNAME=('%@') where PROJECTNAME=('%@') and ITEMNAME=('%@')",itemName, project.projectName,oldname];
    //将SQL语句放入sqlite3_stmt中
    int success = sqlite3_exec(_db, [update UTF8String], NULL, NULL, &errorMsg);
    if (success != SQLITE_OK) {
        NSLog(@"Error: failed to delete:testTable");
        sqlite3_close(_db);
    }
    
    [self didChangeValueForKey:@"ItemChanged"];
}

-(void)ChangeProjectName:(NSString *)projectName atProject:(Project116 *)project
{
    if ([projectName isEqualToString:@""]) {
        return;
    }
    [self willChangeValueForKey:@"ProjectChanged"];
    NSString* oldname = project.projectName;
    project.projectName = projectName;
    
    char *errorMsg = NULL;
    NSString *update = [NSString stringWithFormat:@"update Project116 set PROJECTNAME=('%@') where PROJECTNAME=('%@') ",projectName, oldname];
    //将SQL语句放入sqlite3_stmt中
    int success = sqlite3_exec(_db, [update UTF8String], NULL, NULL, &errorMsg);
    if (success != SQLITE_OK) {
        NSLog(@"Error: failed to delete:testTable");
        sqlite3_close(_db);
    }
    
    [self didChangeValueForKey:@"ProjectChanged"];
}

-(void)fromDisk
{
    NSString *quary = @"SELECT * FROM Project116";//SELECT ROW,FIELD_DATA FROM FIELDS ORDER BY ROW
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(_db, [quary UTF8String], -1, &stmt, nil) == SQLITE_OK) {
        
        while (sqlite3_step(stmt)==SQLITE_ROW) {
            
            char *projectname = (char *)sqlite3_column_text(stmt, 1);
            
            int projectid = sqlite3_column_int(stmt, 2);
            
            NSString * projectName = [[NSString alloc]initWithUTF8String:projectname];
            Project116 * tmp = [[Project116 alloc]init];
            tmp.projectName = projectName;
            [self.projectarray addObject:tmp];
            
            [tmp fromDisk:_db];
        }
        
        sqlite3_finalize(stmt);
    }

}

-(void)toDisk
{
    
    
    char *errorMsg = NULL;
    //执行语句
    for (Project116* tmp in self.projectarray) {
        NSString *insert = [NSString stringWithFormat:@"INSERT OR REPLACE INTO Project116('%@','%@')VALUES('%@','%d')",@"PROJECTNAME",@"PROJECTID",tmp.projectName,9];
        if (sqlite3_exec(_db, [insert UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK) {
            sqlite3_close(_db);
        }
        [tmp toDisk:_db];
    }
    
    
    
}
@end
