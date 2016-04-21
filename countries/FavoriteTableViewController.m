//
//  FavoriteTableViewController.m
//  countries
//
//  Created by  Andrew on 21.04.16.
//  Copyright © 2016 Andrew Sad. All rights reserved.
//

#import "FavoriteTableViewController.h"
#import "StringHelper.h"
#import "CountriesData.h"

@interface FavoriteTableViewController ()

@end

@implementation FavoriteTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"%ld", (unsigned long)[[CountriesData sharedInstance].favoriteCountries count]);
    return [[CountriesData sharedInstance].favoriteCountries count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier : [StringHelper cellFavorite] forIndexPath:indexPath];
    cell.textLabel.text = [CountriesData sharedInstance].favoriteCountries[indexPath.row][@"Name"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath: indexPath animated: YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [[CountriesData sharedInstance].favoriteCountries removeObject: [[CountriesData sharedInstance].favoriteCountries objectAtIndex: indexPath.row]];
        [self.tableView deleteRowsAtIndexPaths : @[indexPath] withRowAnimation: UITableViewRowAnimationFade];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [StringHelper deleteCellButtonTitle];
}

@end
