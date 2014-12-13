//
//  SCViewController.h
//  ShareCamera
//
//  Created by 谷 亮介 on 2014/10/14.
//  Copyright (c) 2014年 Ryosuke Tani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoAlbum.h"

@interface SCViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (strong, nonatomic) UIImagePickerController *imagePickerController;
@property (strong, nonatomic) IBOutlet UIButton *customLoginButton;
@property (strong, nonatomic) IBOutlet UIButton *albumTitleButton;
@property (strong, nonatomic) PhotoAlbum *currentAlbum;
@property (strong, nonatomic) IBOutlet UIButton *albumLinkButton;
@property (strong, nonatomic) IBOutlet UIView *layerView;
@property (strong, nonatomic) IBOutlet UIButton *cameraButton;
@property (strong, nonatomic) IBOutlet UILabel *cameraButtonLabel;
@property (strong, nonatomic) IBOutlet UILabel *message;

- (IBAction)showUIImagePicker;
- (IBAction)touchedButton:(id)sender;
- (IBAction)viewAlbumLink:(id)sender;
- (IBAction)pushedAlbumTitle:(id)sender;


@end
