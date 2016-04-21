//
//  CountriesData.h
//  countries
//
//  Created by  Andrew on 21.04.16.
//  Copyright © 2016 Andrew Sad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CountriesData : NSObject

@property (nonatomic) NSMutableArray *favoriteCountries;
@property (nonatomic) NSArray *loadedCountries;

+ (CountriesData *)sharedInstance;
+ (void)setCountriesWith : (NSArray *)data;

@end
