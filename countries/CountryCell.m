//
//  CountryCell.m
//  countries
//
//  Created by  Andrew on 21.04.16.
//  Copyright © 2016 Andrew Sad. All rights reserved.
//

#import "CountryCell.h"

@implementation CountryCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    if (self != nil)
        self.showCities = NO;
}



@end
