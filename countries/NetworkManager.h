//
//  NetworkManager.h
//  countries
//
//  Created by  Andrew on 21.04.16.
//  Copyright © 2016 Andrew Sad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
#import "Settings.h"

@interface NetworkManager : NSObject

+ (void)getCountries : (void (^)(id))success
             failure : (void (^)(NSError *))failure;

@end
