//
//  FacebookAPI.m
//  ShareCamera
//
//  Created by 谷 亮介 on 2014/10/19.
//  Copyright (c) 2014年 Ryosuke Tani. All rights reserved.
//

#import "StorageAPI.h"
#import <FacebookSDK/FacebookSDK.h>

@implementation StorageAPI

- (void)connectTo:(NSString *)storageName
{
    if ([storageName isEqualToString:@"facebook"]) {
        [FBRequestConnection startWithGraphPath:@"/{photo-id}"
                                     parameters:nil HTTPMethod:@"GET"
                              completionHandler:^(
                                    FBRequestConnection *connection,
                                    id result,
                                    NSError *error
                                ){
                                  if (error) {
                                      NSLog(@"error!");
                                  } else{
                                      NSLog(@"result: %@", result);
                                  }
                              }];
    };
}

@end
