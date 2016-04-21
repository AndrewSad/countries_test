//
//  CountryCell.h
//  countries
//
//  Created by  Andrew on 21.04.16.
//  Copyright © 2016 Andrew Sad. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CountryCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *countryLabel;
@property (nonatomic) BOOL favorite;
@property (weak, nonatomic) IBOutlet UIButton *favButton;
@property (nonatomic) BOOL showCities;

@end
