//
//  SelectAlbumTableViewController.h
//  ShareCamera
//
//  Created by 谷 亮介 on 2014/11/19.
//  Copyright (c) 2014年 Ryosuke Tani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoAlbum.h"
#import "CustomTableViewCell.h"

@interface SelectAlbumTableViewController : UITableViewController

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) PhotoAlbum *photoAlbum;


// AlertViewを表示
- (IBAction)popAlertToMakeNewAlbum:(id)sender;
- (IBAction)showLinkAlert:(id)sender event:(UIEvent *)event;

@end
