//
//  NetworkManager.m
//  countries
//
//  Created by  Andrew on 21.04.16.
//  Copyright © 2016 Andrew Sad. All rights reserved.
//

#import "NetworkManager.h"

@implementation NetworkManager

+ (void)getCountries : (void (^)(id))success
             failure : (void (^)(NSError *))failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET : [NSString stringWithFormat : @"%@countries", [Settings API_URL]]
       parameters : nil
          success : ^(AFHTTPRequestOperation *operation, id responseObject) {
              success(responseObject);
          }
          failure : ^(AFHTTPRequestOperation *operation, NSError *error) {
              failure(error);
          }
     ];
}


@end
