//
//  SCAppDelegate.m
//  ShareCamera
//
//  Created by 谷 亮介 on 2014/10/14.
//  Copyright (c) 2014年 Ryosuke Tani. All rights reserved.
//

#import "SCAppDelegate.h"
#import "SCViewController.h"
#import <FacebookSDK/FacebookSDK.h>

@implementation SCAppDelegate
@synthesize loginViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    return YES;
}

- (void)checkFBSession
{
    // logout状態であれば、事前処理を実施
    if (!FBSession.activeSession.state) {
        [self userLoggedOut];
    }
    // Whenever a person opens the app, check for a cached session
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        //if there's one, just open the session silently, without showing the user the login UI
        [FBSession openActiveSessionWithReadPermissions:@[@"public_profile", @"publish_actions", @"user_photos"]
                                           allowLoginUI:NO
                                      completionHandler:^(FBSession *session, FBSessionState state, NSError *error){
                                          //Handler for session state change
                                          //This method will be changed EACH time the session state changes,
                                          //also for intermediate states and NOT just the session open
                                          [self sessionStateChanged:session state:state error:error];
                                      }];
    }
}

- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState)state error:(NSError *)error
{
    NSLog(@"sessionStateChange");
    NSLog(@"%u", state);
    // if the session was open successfuly
    if(!error && state == FBSessionStateOpen){
        // Show the user the loggin UI
        [self userLoggedIn];
        return;
    }
    if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed) {
        // if the session is closed
        // show the user the logged-out UI
        [self userLoggedOut];
    }
    
    // Handle errors
    if (error) {
        NSLog(@"Error");
        NSString *alertText;
        NSString *alertTitle;
        // if the error people using an app to make an action outside of the app in order to recover
        if ([FBErrorUtility shouldNotifyUserForError:error] == YES) {
            alertTitle = @"Something went wrong";
            alertText = [FBErrorUtility userMessageForError:error];
            [self showMessage:alertText withTitle:alertText];
        } else {
            // if the user cancelled login, do nothing
            if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
                NSLog(@"User cancelled login");
            } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession){
                alertTitle = @"Session Error";
                alertText = @"Your current session is no longer valid. Please log in again.";
                [self showMessage:alertText withTitle:alertTitle];
            } else {
                // get more error information from the error
                NSDictionary *errorInformation = [[[error.userInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"] objectForKey:@"body"] objectForKey:@"error"];
                
                // show the user an error message
                alertTitle = @"Something went wrong";
                alertText = [NSString stringWithFormat:@"Please retry. \n\n If the problem persists contact us and mention this error code: %@", [errorInformation objectForKey:@"message"]];
                [self showMessage:alertText withTitle:alertTitle];
            }
        }
        //clear this token
        [FBSession.activeSession closeAndClearTokenInformation];
        // show the user the logged-out UI
        [self userLoggedOut];
    }
}

// Show the user the logged-out UI
- (void)userLoggedOut
{
    NSLog(@"userLoggedOut");
    // Set the button title as "Log in with-Facebook"
    UIButton *loginButton = [self.loginViewController customLoginButton];
    [loginButton setTitle:@"Log in with Facebook" forState:UIControlStateNormal];
    
    [self.loginViewController.cameraButton setHidden:YES];
    [self.loginViewController.cameraButtonLabel setHidden:YES];
    [self.loginViewController.message setHidden:NO];
    // Confirm logout message
    // [self showMessage:@"You're now logged out" withTitle:@""];
}

// Show the user the logged-in UI
- (void)userLoggedIn
{
    NSLog(@"userLoggedIn");
    // Set the button title as "Log out"
    UIButton *loginButton = self.loginViewController.customLoginButton;
    UIColor *fbcolor = [UIColor colorWithRed:0.231f green:0.349f blue:0.596f alpha:1.000f];
    self.loginViewController.navigationController.navigationBar.barTintColor = fbcolor;
    [loginButton setBackgroundColor:fbcolor];
    [loginButton setTitle:@"Log out" forState:UIControlStateNormal];
    [self.loginViewController.cameraButton setHidden:NO];
    [self.loginViewController.cameraButtonLabel setHidden:NO];
    [self.loginViewController.message setHidden:YES];
    // Welcome message
    // [self showMessage:@"You're now logged in" withTitle:@"Welcome!"];
}

- (void)showMessage:(NSString *)text withTitle:(NSString *)title
{
    [[[UIAlertView alloc] initWithTitle:title
                                message:text
                               delegate:self
                      cancelButtonTitle:@"OK!"
                      otherButtonTitles:nil, nil] show];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    // Handle the user leaving the app while the Facebook login dialog is being shown
    // For example: when the user presses the iOS "home" button while the login dialog is active
    [FBAppCall handleDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//FacebookSDK用
// During the Facebook login flow, your app passes control to the Facebook to the Facebook iOS app or Facebook in a mobile browser.
// After authentication, your app will be called back with the session information.
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    // attempt to extract a token from the url
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
}

@end
