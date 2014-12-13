//
//  SCAppDelegate.h
//  ShareCamera
//
//  Created by 谷 亮介 on 2014/10/14.
//  Copyright (c) 2014年 Ryosuke Tani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

#import "SCViewController.h"

@interface SCAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) SCViewController *loginViewController;

- (void)checkFBSession;
- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error;
- (void)userLoggedIn;
- (void)userLoggedOut;

@end
