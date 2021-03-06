//
//  SidebarTableViewController.m
//  iHackerNews
//
//  Created by Junyu Wang on 6/19/15.
//  Copyright (c) 2015 junyuwang. All rights reserved.
//

#import "SidebarTableViewController.h"
#import "SWRevealViewController.h"
#import "HNPostsTableViewController.h"
#import "constants.h"
#import <ChameleonFramework/Chameleon.h>

@interface SidebarTableViewController ()

@end

@implementation SidebarTableViewController {
    NSArray *menuItems;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    menuItems = @[@"title", @"top", @"new", @"best", @"showHN", @"askHN", @"jobs", @"favorites"];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    return [menuItems count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier = [menuItems objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // make app name cell not clickable
    if ([CellIdentifier isEqualToString:@"title"]) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont fontWithName:fontForTableViewBold size:20];
        cell.textLabel.textColor = FlatOrange;
    }else {
        // Configure the cell...
        cell.textLabel.font = [UIFont fontWithName:fontForTableViewLight size:18];
    }
    
    return cell;
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


#pragma mark - Navigation

- (NSString *)navBarTitleForCellIdentifier:(NSString *)identifier {
    if ([identifier isEqualToString:@"top"]) {
        return @"Top";
    }else if ([identifier isEqualToString:@"askHN"]) {
        return @"Ask HN";
    }else if ([identifier isEqualToString:@"jobs"]) {
        return @"Jobs";
    }else if ([identifier isEqualToString:@"new"]) {
        return @"New";
    }else if ([identifier isEqualToString:@"showHN"]) {
        return @"Show HN";
    }else if ([identifier isEqualToString:@"best"]) {
        return @"Best";
    }else if ([identifier isEqualToString:@"favorites"]) {
        return @"Favorites";
    }else{
        return @"Unknown Identifier";
    }
}
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    HNPostsTableViewController *destinationVC = [(UINavigationController *)segue.destinationViewController childViewControllers].firstObject;
    destinationVC.title = [self navBarTitleForCellIdentifier:[menuItems objectAtIndex:indexPath.row]];
    destinationVC.HNPostType = [menuItems objectAtIndex:indexPath.row];
}


@end
