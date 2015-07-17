//
//  ProjectViewerControllerTableViewController.m
//  116
//
//  Created by baidu on 14/12/23.
//  Copyright (c) 2014年 baidu. All rights reserved.
//

#import "ProjectViewerControllerTableViewController.h"
#import "DataCenter116.h"
#import "UITableViewCell_ContainRemover_116Project.h"
#import "ItemTableViewController.h"

@interface ProjectViewerControllerTableViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addProjectButtonItem;

@end

@implementation ProjectViewerControllerTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    
    _addProjectButtonItem.target = self;
    _addProjectButtonItem.action = @selector(AddProjectButtonClicked);
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


-(void)viewDidAppear:(BOOL)animated
{
    [[DataCenter116 GetInstance] addObserver:self forKeyPath: @"ProjectTobeEdit" options:0 context:NULL];
    [[DataCenter116 GetInstance] addObserver:self forKeyPath: @"ProjectRemoved" options:0 context:NULL];
    [[DataCenter116 GetInstance] addObserver:self forKeyPath: @"ProjectAdded" options:0 context:NULL];
    [[DataCenter116 GetInstance] addObserver:self forKeyPath: @"ProjectChanged" options:0 context:NULL];
    [self.tableView reloadData];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [[DataCenter116 GetInstance] removeObserver:self forKeyPath: @"ProjectTobeEdit"];
    [[DataCenter116 GetInstance] removeObserver:self forKeyPath: @"ProjectRemoved" ];
    [[DataCenter116 GetInstance] removeObserver:self forKeyPath: @"ProjectAdded" ];
    [[DataCenter116 GetInstance] removeObserver:self forKeyPath: @"ProjectChanged" ];
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
    return [[DataCenter116 GetInstance]GetProjectCount];
}

/**/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"project116CellIdentifier";

    UITableViewCell_ContainRemover_116Project *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell_ContainRemover_116Project alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    
    
    [cell awakeFromNib: tableView.bounds.size.width];
    cell.project116 = [[DataCenter116 GetInstance]GetProjectAt:indexPath.row];
    cell.textlabel.text = [[DataCenter116 GetInstance]GetProjectNameAt:indexPath.row];
    return cell;
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{    
    if([keyPath isEqualToString: @"ProjectTobeEdit"])
    {
        ItemTableViewController * svc=[[ItemTableViewController alloc]init];
        svc.title = @"Edit proj";
        svc.project116 = [[DataCenter116 GetInstance] GetCurrentProject];
        [self.navigationController pushViewController:svc animated:YES];
    }
    else if([keyPath isEqualToString: @"ProjectRemoved"]|| [keyPath isEqualToString:@"ProjectAdded"]||[keyPath isEqualToString:@"ProjectChanged"])
    {
        [self.tableView reloadData];
    }
}

- (void)AddProjectButtonClicked
{
    ItemTableViewController * svc=[[ItemTableViewController alloc]init];
    svc.title = @"Add proj";
    svc.project116 = nil;
    [self.navigationController pushViewController:svc animated:YES];
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
