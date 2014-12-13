//
//  SelectAlbumTableViewController.m
//  ShareCamera
//
//  Created by 谷 亮介 on 2014/11/19.
//  Copyright (c) 2014年 Ryosuke Tani. All rights reserved.
//

#import "SelectAlbumTableViewController.h"
#import "SCViewController.h"

@interface SelectAlbumTableViewController ()

@property (strong, nonatomic) NSMutableArray *result;


@end

@implementation SelectAlbumTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    _photoAlbum = [PhotoAlbum sharedCurrentAlbum];
    [_photoAlbum addObserver:self forKeyPath:@"albumArray" options:0 context:NULL];
    [_photoAlbum requestAlbumInfo];
    
    self.navigationItem.hidesBackButton = YES;
}

// observer対象が更新されたときの処理
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_photoAlbum.albumArray count];
}

// table view datasource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableCell" forIndexPath:indexPath];
    UILabel *lblName = (UILabel *)[cell viewWithTag:10];
    
    // Configure the cell...
    NSInteger row = [indexPath row];
    [lblName setText:[_photoAlbum.albumArray[row] objectForKey:@"name"]];
    
    [cell.button addTarget:self action:@selector(didTouch:event:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // シングルトンsharedCurrentAlbumを取得
    PhotoAlbum *currentAlbum = [PhotoAlbum sharedCurrentAlbum];
    
    // CurrentAlbumに選択したアルバム情報を設定
    NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
    NSInteger row = [selectedIndexPath row];
    currentAlbum.albumID = [_photoAlbum.albumArray[row] objectForKey:@"id"];
    currentAlbum.title = [_photoAlbum.albumArray[row] objectForKey:@"name"];
    currentAlbum.text = [_photoAlbum.albumArray[row] objectForKey:@"text"];
    currentAlbum.link = [_photoAlbum.albumArray[row] objectForKey:@"link"];
    
    // 遷移元に戻る
    [[self navigationController] popToRootViewControllerAnimated:YES];
    [[[[self navigationController] viewControllers] firstObject] showUIImagePicker];
}

- (IBAction)popAlertToMakeNewAlbum:(id)sender {
    UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"New Album"
                                                     message:@"Enter title"
                                                    delegate:self
                                           cancelButtonTitle:@"Cancel"
                                           otherButtonTitles:@"OK", nil];
    dialog.tag = 2;
    dialog.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *textfield = [dialog textFieldAtIndex:0];
    textfield.placeholder = @"title";
    [dialog show];
}

- (IBAction)didTouch:(UIButton*)sender event:(UIEvent *)event
{
    NSLog(@"%@", sender.superview);
    NSIndexPath *indexPath = [self indexPathForControlEvent:event];
    NSInteger row = indexPath.row;
    UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Album Link"
                                                     message:@"copy your link and share!"
                                                    delegate:self
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil, nil];
    dialog.tag = 2;
    dialog.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *textfield = [dialog textFieldAtIndex:0];
    textfield.text = [_photoAlbum.albumArray[row] objectForKey:@"link"];
    [dialog show];
}

- (NSIndexPath *)indexPathForControlEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint p = [touch locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:p];
    return indexPath;
}

// AlertのOKボタンがクリックされたときの処理
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        // clicked "OK"
        NSString *title = [[alertView textFieldAtIndex:0] text];
        [_photoAlbum makeAlbumWithTitle: title];
    } else {
        // clicked "Cancel"
    }
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation
/*
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

}
*/


@end
