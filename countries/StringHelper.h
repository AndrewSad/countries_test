//
//  StringHelper.h
//  countries
//
//  Created by  Andrew on 21.04.16.
//  Copyright © 2016 Andrew Sad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StringHelper : NSObject

// cells
+ (NSString *)cellCountry;
+ (NSString *)cellCity;
+ (NSString *)cellFavorite;

// section titles
+ (NSString *)strSectionCountriesTitle;
+ (NSString *)strSectionCitiesTitle;

// common strings

+ (NSString *)strLoadingCountries;

// errors

+ (NSString *)strErrorNoCountries;

// delete cell title

+ (NSString *)deleteCellButtonTitle;

@end
