//
//  ItemTableViewController.m
//  116
//
//  Created by baidu on 14/12/23.
//  Copyright (c) 2014年 baidu. All rights reserved.
//

#import "ItemTableViewController.h"
#import "UITableViewCell_ContainSwitcher.h"
#import "UITableViewCell_ContainRemover_116Item.h"
#import "UITableViewCell_ContainRemover2.h"
#import "DataCenter116.h"

@interface ItemTableViewController ()

@end

@implementation ItemTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dodone)];
    doneBtn.enabled = false;
    //UIBarButtonItem *pauseBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPause target:self action:@selector(stopDownloadAll)];
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects: doneBtn,nil]];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidAppear:(BOOL)animated
{
    [[DataCenter116 GetInstance] addObserver:self forKeyPath: @"ItemRemoved" options:0 context:NULL];
    
    [[DataCenter116 GetInstance] addObserver:self forKeyPath: @"ItemAdded" options:0 context:NULL];
    
    [[DataCenter116 GetInstance] addObserver:self forKeyPath: @"ItemChanged" options:0 context:NULL];
    
    [[DataCenter116 GetInstance] addObserver:self forKeyPath: @"ProjectRemoved" options:0 context:NULL];
    
    [[DataCenter116 GetInstance] addObserver:self forKeyPath: @"ProjectAdded" options:0 context:NULL];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[DataCenter116 GetInstance] removeObserver:self forKeyPath: @"ItemRemoved" ];
    [[DataCenter116 GetInstance] removeObserver:self forKeyPath: @"ItemAdded" ];
    [[DataCenter116 GetInstance] removeObserver:self forKeyPath: @"ItemChanged"];
    [[DataCenter116 GetInstance] removeObserver:self forKeyPath: @"ProjectRemoved" ];
    [[DataCenter116 GetInstance] removeObserver:self forKeyPath: @"ProjectAdded" ];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if(keyPath == @"ItemRemoved" || keyPath == @"ItemAdded" || keyPath == @"ItemChanged")
    {
        [self.tableView reloadData];
    }
    else if(keyPath == @"ProjectRemoved")
    {
        [self.navigationController popViewControllerAnimated:true];
    }
    else if([keyPath isEqualToString:@"ProjectAdded"])
    {
        self.project116 = [[DataCenter116 GetInstance]GetCurrentProject];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    int itemCount = 0;
    if (_project116 != nil) {
        itemCount = _project116.items.count;
    }
    return 3 + itemCount;
}

-(void)dodone
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    int itemCount = 0;
    if (_project116 != nil) {
        itemCount = _project116.items.count;
    }

    if(indexPath.row == 2 + itemCount) {
        static NSString *CellIdentifier = @"Switheritem116CellIdentifier";
        UITableViewCell_ContainSwitcher *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell_ContainSwitcher alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
    
        [cell awakeFromNib: tableView.bounds.size.width];
        return cell;
    }
    else if(indexPath.row == 0)
    {
        static NSString *CellIdentifier = @"ProjectNameCellIdentifier";
        UITableViewCell_ContainRemover2 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell_ContainRemover2 alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
            cell.backgroundColor = [UIColor grayColor];
        }
        [cell awakeFromNib: tableView.bounds.size.width];
        if (_project116 != nil) {
            cell.textfield.text = _project116.projectName;
            [cell.textlable setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [cell.textlable setTitle:_project116.projectName forState:UIControlStateNormal ];
        }
        else
        {
            cell.textfield.hidden = false;
        }
        cell.project116 = _project116;
        
        return cell;
    }
    else if(indexPath.row == 1 + itemCount)
    {
        static NSString *CellIdentifier = @"EmptyCellIdentifier";
        UITableViewCell_ContainRemover_116Item *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell_ContainRemover_116Item alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
        }
        [cell awakeFromNib: tableView.bounds.size.width];
        return cell;
    }
    else if(indexPath.row > 0 && indexPath.row < (1+ itemCount))
    {
        static NSString *CellIdentifier = @"item116CellIdentifier";
        
        UITableViewCell_ContainRemover_116Item *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell_ContainRemover_116Item alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
            
        }
        [cell awakeFromNib: tableView.bounds.size.width];
        
        
        cell.item116 = [[DataCenter116 GetInstance]GetItemAt:(indexPath.row - 1) atProject:_project116];
        cell.textfield.text = [[DataCenter116 GetInstance] GetItemNameAt:(indexPath.row - 1) atProject:_project116];
        return cell;

    }
    return nil;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
