//
//  StringHelper.m
//  countries
//
//  Created by  Andrew on 21.04.16.
//  Copyright © 2016 Andrew Sad. All rights reserved.
//

#import "StringHelper.h"

@implementation StringHelper

// cells

+ (NSString *)cellCountry
{
    return @"cellCountry";
}

+ (NSString *)cellCity
{
    return @"cellCity";
}

+ (NSString *)cellFavorite
{
    return @"cellFavorite";
}

// section titles

+ (NSString *)strSectionCountriesTitle
{
    return @"Страны";
}

+ (NSString *)strSectionCitiesTitle
{
    return @"Города";
}

// common strings

+ (NSString *)strLoadingCountries
{
    return @"Подождите, загружается информация о странах...";
}

// errors

+ (NSString *)strErrorNoCountries
{
    return @"Не удалось загрузить информацию о странах";
}

// delete cell button title
+ (NSString *)deleteCellButtonTitle
{
    return @"✕";
}

@end
