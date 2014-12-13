//
//  SCViewController.m
//  ShareCamera
//
//  Created by 谷 亮介 on 2014/10/14.
//  Copyright (c) 2014年 Ryosuke Tani. All rights reserved.
//

#import "SCViewController.h"
#import <FacebookSDK/FacebookSDK.h>

#import "SCAppDelegate.h"

@interface SCViewController ()

@end

@implementation SCViewController {
  dispatch_once_t onceToken;
}

@synthesize customLoginButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    dispatch_once(&onceToken, ^{
        _currentAlbum = [PhotoAlbum sharedCurrentAlbum];
    });
    self.albumLinkButton.hidden = NO;
    self.albumTitleButton.titleLabel.numberOfLines = 2;
    self.cameraButton.backgroundColor = [UIColor colorWithRed:0.231f green:0.349f blue:0.596f alpha:1.000f];
    [self.cameraButton setTintColor:[UIColor whiteColor]];
    // [self showUIImagePicker];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    // self.navigationItem.title = _currentAlbum.title;
    [self.cameraButton setTitle:@"" forState:UIControlStateNormal];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    SCAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.loginViewController = self;
    [appDelegate checkFBSession];

}

- (IBAction)showPhotoLibrary
{
    _imagePickerController = [[UIImagePickerController alloc] init];
    _imagePickerController.delegate = self;
    _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:_imagePickerController animated:YES completion:nil];
    
}

- (IBAction)touchedButton:(id)sender {
    // if the session state is any of the two "open" states when the button is clicked
    if (FBSession.activeSession.state == FBSessionStateOpen || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
        // Close the session and remove the access token from the cache
        // The session state handler (in the app delegate) will be called automatically
        [FBSession.activeSession closeAndClearTokenInformation];
        
        // If the session state is not any of the two "open" states when the button is clicked
    } else {
        // Open a session showing the user the login UI
        // You must ALWAYS ask for public_profile permissions when opening a session
        [FBSession openActiveSessionWithReadPermissions:@[@"public_profile", @"publish_actions", @"user_photos"]
                                           allowLoginUI:YES
                                      completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                          // Retrieve the app delegate
                                          SCAppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
                                          // Call the app delegate's sessionStateChanged:state:error method to handle session state change
                                          [appDelegate sessionStateChanged:session state:state error:error];
                                    }];
        }
                                          
}

- (IBAction)viewAlbumLink:(id)sender {
    UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Album Link"
                                                     message:@"copy your link and share!"
                                                    delegate:self
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil, nil];
    dialog.tag = 2;
    dialog.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *textfield = [dialog textFieldAtIndex:0];
    textfield.text = _currentAlbum.link;
    [dialog show];
}

- (IBAction)pushedAlbumTitle:(id)sender {
    [_imagePickerController dismissViewControllerAnimated:YES completion:^() {
        NSLog(@"dismiss imagePickerController");
    }];
}

- (void)showUIImagePicker
{
    //カメラが使用可能かどうか判定する
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        return;
    }
    //UIImagePickerControllerのインスタンスを生成
    _imagePickerController = [[UIImagePickerController alloc] init];
    //デリゲートを設定
    _imagePickerController.delegate = self;
    //画像の取得先をカメラに設定
    _imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    @try{
        _imagePickerController.cameraOverlayView = self.albumTitleButton;
        // アルバムタイトルを設定
        [self.albumTitleButton setTitle:_currentAlbum.title forState:UIControlStateNormal];
    }
    @catch (NSException *e) {
        NSLog(@" [ERROR][%@]", e);
        
        @throw e;
    }
    
    @finally {
        NSLog(@"**** finally ****");
    }
    
    //撮影画面をモーダルビューとして表示する
    
    
    // アルバムが設定されていなければ、設定画面に遷移
    if (_currentAlbum.albumID == nil) {
        [self performSegueWithIdentifier:@"NoAlbumSet" sender:self];
    } else {
        [self presentViewController:_imagePickerController animated:YES completion:nil];
    }
}

//画像が選択された時に呼ばれるデリゲートメソッド
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //モーダルビューを閉じる
    [self dismissViewControllerAnimated:YES completion:nil];
    // 選択したイメージをUIImageにセットする
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    //_imageView.image = image;
    [_currentAlbum uploadImageToAlbum:image];
    //[self dismissViewControllerAnimated:YES completion:nil];
    //渡されてきた画像をフォトアルバムに保存
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(targetImage:didFinishSavingWithError:contextInfo:), NULL);
}

//画像の選択がキャンセルされた時に呼ばれるデリゲートメソッド
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    //モーダルビューを閉じる
    [self dismissViewControllerAnimated:YES completion:nil];
    
    //キャンセルされたときの処理を記述
}

//　画像の保存完了時に呼ばれるメソッド
- (void)targetImage:(UIImage *)image
didFinishSavingWithError:(NSError *)error
        contextInfo:(void *)context
{
    if (error) {
        //保存失敗時のエラー処理
    } else {
        //保存成功時のエラー処理
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
