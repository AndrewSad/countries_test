//
//  CountriesViewController.m
//  countries
//
//  Created by  Andrew on 21.04.16.
//  Copyright © 2016 Andrew Sad. All rights reserved.
//

#import "CountriesViewController.h"
#import "StringHelper.h"
#import "CommonHelper.h"
#import "NetworkManager.h"
#import "ImageManager.h"
#import "NSDictionary+NullReplacement.h"
#import "NSArray+NullReplacement.h"
#import "CountryCell.h"
#import "CountriesData.h"

@interface CountriesViewController ()
@property (weak, nonatomic) IBOutlet UITableView *CountriesCitiesTable;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingCountries;
@property (weak, nonatomic) IBOutlet UILabel *loadingCountriesLabel;
@property (nonatomic) NSArray *selectedCountry;
@property (nonatomic) NSArray *cells;
@end

@implementation CountriesViewController
{
    BOOL loaded;
    BOOL showCities;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    showCities = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    
    if ([[[CountriesData sharedInstance] loadedCountries] count] > 0) {
        self.CountriesCitiesTable.hidden = NO;
        [self.loadingCountries stopAnimating];
        self.loadingCountriesLabel.hidden = YES;
        loaded = YES;
        if ([[NSUserDefaults standardUserDefaults] objectForKey: [CommonHelper udefSelectedCountry]] != nil) {
            showCities = YES;
            self.selectedCountry = [[NSUserDefaults standardUserDefaults] objectForKey: [CommonHelper udefSelectedCountry]];
        }
        [self.CountriesCitiesTable reloadData];
    } else {
        loaded = NO;
        [self.loadingCountries startAnimating];
        self.loadingCountriesLabel.text = [StringHelper strLoadingCountries];
        self.loadingCountriesLabel.hidden = NO;
        self.CountriesCitiesTable.hidden = YES;
        if ([[NSUserDefaults standardUserDefaults] objectForKey: [CommonHelper udefSelectedCountry]] != nil) {
            showCities = YES;
            self.selectedCountry = [[NSUserDefaults standardUserDefaults] objectForKey: [CommonHelper udefSelectedCountry]];
        }
        [NetworkManager getCountries: ^(id result) {
            NSError *error = nil;
            NSDictionary *response = [NSJSONSerialization JSONObjectWithData : result
                                                                     options : NSJSONReadingMutableContainers
                                                                       error : &error];
            
            if (error) {
                NSString *wrongData = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
                NSRange rangeOfHyphen = [wrongData rangeOfString:@"{"];
                if (rangeOfHyphen.location != NSNotFound) {
                    NSString *goodData = [wrongData substringFromIndex:rangeOfHyphen.location];
                    NSLog(@"ERROR while retrieving data from JSON: %@", [wrongData substringToIndex:rangeOfHyphen.location]);
                    NSLog(@"WILL TRY TO EXTRACT JSON NOW...");
                    NSData *repairedData = [goodData dataUsingEncoding:NSUTF8StringEncoding];
                    NSError *hasError = nil;
                    NSDictionary *repairedResponse = [NSJSONSerialization JSONObjectWithData : repairedData
                                                                                     options : NSJSONReadingMutableContainers
                                                                                       error : &hasError];
                    if (!hasError) {
                        response = [NSDictionary dictionaryWithDictionary:repairedResponse];
                        NSLog(@"JSON EXTRACTED: %@", response);
                    }
                    else {
                        NSLog(@"wrongData: %@", wrongData);
                    }
                }
                else {
                    NSLog(@"wrongData: %@", wrongData);
                }
                
            }
            NSLog(@"%@", response);
            if ([response[@"Result"] count]  > 0) {
                self.CountriesCitiesTable.hidden = NO;
                [self.loadingCountries stopAnimating];
                self.loadingCountriesLabel.hidden = YES;
                loaded = YES;
                self.countries = [NSMutableArray arrayWithArray: response[@"Result"]];
                [CountriesData setCountriesWith : [self.countries copy]];
                [self.CountriesCitiesTable reloadData];
            }
            
            
            
        } failure : ^(NSError *err) {
            NSLog(@"%@", err.description);
            [self.loadingCountries stopAnimating];
            self.loadingCountriesLabel.text = [StringHelper strErrorNoCountries];
            self.loadingCountriesLabel.hidden = NO;
            self.CountriesCitiesTable.hidden = YES;
            loaded = NO;

            
        }];
    }


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return !loaded ? 0 : showCities ? 2 : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0)
        return loaded ? [self.countries count]: 0;
    else
        return [self.selectedCountry count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        CountryCell *cell = [tableView dequeueReusableCellWithIdentifier: [StringHelper cellCountry] forIndexPath:indexPath];
        NSArray *storedCountries = [CountriesData sharedInstance].favoriteCountries;
        cell.countryLabel.text = self.countries[indexPath.row][@"Name"];
        cell.favorite = [storedCountries indexOfObject: self.countries[indexPath.row]] != NSNotFound;
        
        [cell.favButton setImage : cell.favorite ? [ImageManager starImage] : [ImageManager grayStarImage]  forState: UIControlStateNormal];
        
        return cell;
    }else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: [StringHelper cellCity] forIndexPath:indexPath];
        if ([self.selectedCountry count] > 0)
            cell.textLabel.text = self.selectedCountry[indexPath.row][@"Name"];
        else
            cell.hidden = YES;
        
        NSDictionary *selectedCity = [[NSUserDefaults standardUserDefaults] objectForKey: [CommonHelper udefSelectedCity]];
        if (selectedCity != nil) {
            if ([cell.textLabel.text isEqual: selectedCity[@"Name"]]) {
                [cell.contentView setBackgroundColor : [UIColor lightGrayColor]];
                [cell.textLabel setBackgroundColor : [UIColor lightGrayColor]];
            }else {
                [cell.contentView setBackgroundColor : [UIColor whiteColor]];
                [cell.textLabel setBackgroundColor : [UIColor whiteColor]];
            }
        }
        return cell;
    }
}

- (UIView *)tableView: (UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame : CGRectMake(0, 0, tableView.frame.size.width, 18)];
    UILabel *label = [[UILabel alloc] initWithFrame : CGRectMake(10, 5, tableView.frame.size.width, 18)];
    
    [label setFont:[UIFont boldSystemFontOfSize:13]];
    
    NSString *title = section == 0 ? [StringHelper strSectionCountriesTitle] : [StringHelper strSectionCitiesTitle];
    
    [label setText : title];
    [label setTextColor: [UIColor whiteColor]];
    [view addSubview : label];
    [view setBackgroundColor : [UIColor blueColor]];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%d",indexPath.row);
    if (indexPath.section == 0) {
        CountryCell *cell = [tableView cellForRowAtIndexPath: indexPath];
        cell.showCities = !cell.showCities;
        showCities = cell.showCities;
        self.selectedCountry = self.countries[indexPath.row][@"Cities"];
        NSRange range = NSMakeRange(0, tableView.numberOfSections);
        NSIndexSet *sections = [NSIndexSet indexSetWithIndexesInRange:range];
        [tableView reloadSections:sections withRowAnimation:UITableViewRowAnimationFade];
    }else {
        [[NSUserDefaults standardUserDefaults] setObject: [self.selectedCountry[indexPath.row] dictionaryByReplacingNullsWithBlanks] forKey: [CommonHelper udefSelectedCity]];
        [[NSUserDefaults standardUserDefaults] setObject: [self.selectedCountry arrayByReplacingNullsWithBlanks] forKey: [CommonHelper udefSelectedCountry]];
        [tableView reloadSections: [NSIndexSet indexSetWithIndex: 1] withRowAnimation: UITableViewRowAnimationNone];
    }
}

- (IBAction)tapFavorite:(UIButton *)sender
{
    UIView *parent = [sender superview];
    while (parent && ![parent isKindOfClass:[CountryCell class]]) {
        parent = parent.superview;
    }
    CountryCell *cell = (CountryCell *)parent;
    NSIndexPath *selectedIndexPath = [self.CountriesCitiesTable indexPathForCell: cell];
    NSDictionary *selectedCountry = self.countries[selectedIndexPath.row];
    NSArray *storedCountries = [CountriesData sharedInstance].favoriteCountries;

    cell.favorite = [storedCountries indexOfObject: selectedCountry] != NSNotFound;
    if (cell.favorite) {
            [[CountriesData sharedInstance].favoriteCountries removeObject : selectedCountry];
    }else {
            [[CountriesData sharedInstance].favoriteCountries addObject : selectedCountry];
    }
    [self.CountriesCitiesTable reloadRowsAtIndexPaths: @[[self.CountriesCitiesTable indexPathForCell: cell],] withRowAnimation: UITableViewRowAnimationNone];
    
}


@end
