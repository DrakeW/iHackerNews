//
//  FavoritePostsTableViewController.m
//  iHackerNews
//
//  Created by Junyu Wang on 6/29/15.
//  Copyright (c) 2015 junyuwang. All rights reserved.
//

#import "FavoritePostsTableViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "constants.h"
#import <SCLAlertView-Objective-C/SCLAlertView.h>

@interface FavoritePostsTableViewController ()

@end

@implementation FavoritePostsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getFavoritePosts];
    [self getDifferentDatesOfPosts];
    
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
    return [_differentDates count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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

#pragma mark - get favorite posts & dates information
- (void)getFavoritePosts {
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
    NSString *user_email = [[NSUserDefaults standardUserDefaults] objectForKey:@"email"];
    NSDictionary *params;
    if (user_email) {
        params = [[NSDictionary alloc] initWithObjectsAndKeys:user_email, @"user_email", password, @"password", nil];
    }else {
        params = [[NSDictionary alloc] initWithObjectsAndKeys:username, @"username", password, @"password", nil];
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager new];
    [manager GET:postsOfUserURL
      parameters:params
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSLog(@"JSON: %@", responseObject);
             [self handleFavoritePostsResponse:responseObject];
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Error: %@", error);
         }];
}

- (void)handleFavoritePostsResponse:(id)response {
    if (response[@"success"]) {
        _favoritePosts = response[@"info"];
    }else {
        //show alert
        SCLAlertView *errorAlert = [[SCLAlertView alloc] init];
        [errorAlert showError:@"Error"
                     subTitle:response[@"error"]
             closeButtonTitle:@"OK"
                     duration:0.0f];
    }
}

- (void)getDifferentDatesOfPosts {
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
    NSString *user_email = [[NSUserDefaults standardUserDefaults] objectForKey:@"email"];
    NSDictionary *params;
    if (user_email) {
        params = [[NSDictionary alloc] initWithObjectsAndKeys:user_email, @"user_email", password, @"password", nil];
    }else {
        params = [[NSDictionary alloc] initWithObjectsAndKeys:username, @"username", password, @"password", nil];
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager new];
    [manager GET:getDifferentDatesOfPostsURL
      parameters:params
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSLog(@"JSON: %@", responseObject);
             [self handleDifferentDatesOfPostsResponse:responseObject];
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Error: %@", error);
         }];
}

- (void)handleDifferentDatesOfPostsResponse:(id)response {
    if (response[@"success"]) {
        _differentDates = response[@"info"];
    }else {
        //log error message while still showing user's favorite posts
    }
}

@end