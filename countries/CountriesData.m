//
//  CountriesData.m
//  countries
//
//  Created by  Andrew on 21.04.16.
//  Copyright © 2016 Andrew Sad. All rights reserved.
//

#import "CountriesData.h"

@implementation CountriesData

+ (CountriesData *)sharedInstance
{
    static CountriesData *sharedClassObject = nil;
    if (sharedClassObject == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sharedClassObject = [[CountriesData alloc] init];
            sharedClassObject.favoriteCountries = [NSMutableArray array];
        });
    }
    
    return sharedClassObject;
}

+ (void)setCountriesWith : (NSArray *)data
{
    [self sharedInstance].loadedCountries = [NSArray arrayWithArray: data];
}

@end
