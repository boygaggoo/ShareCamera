//
//  PhotoAlbum.m
//  ShareCamera
//
//  Created by 谷 亮介 on 2014/11/19.
//  Copyright (c) 2014年 Ryosuke Tani. All rights reserved.
//

#import "PhotoAlbum.h"

@interface PhotoAlbum()

- (id)initWithTitle:(NSString *)title description:(NSString *)message;

@end

@implementation PhotoAlbum

static PhotoAlbum* sharedCurrentAlbum = nil;

- (id) initWithTitle:(NSString *)title description:(NSString *)message {
    if (self = [super init]) {
        // initialization
        self.title = title;
        self.privacy = @"CUSTOM";
        if (message != nil) {
            self.text = message;
        }
        self.link = @"select an album";
    }
    return self;
}

+ (PhotoAlbum *)sharedCurrentAlbum
{
    @synchronized(self) {
        if (sharedCurrentAlbum == nil) {
            sharedCurrentAlbum = [[self alloc ]initWithTitle:@"アルバムを選択する" description:@""];
        }
    }
    return sharedCurrentAlbum;
}

- (void)makeAlbumWithTitle:(NSString *)title
{
    
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:title, @"name", @"", @"message",@"SELF", @"value",nil];
    
    [FBRequestConnection startWithGraphPath:@"/me/albums"
                                 parameters:params
                                 HTTPMethod:@"POST"
                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                              if (!error) {
                                  NSLog(@"album '%@' was successfuly made.", title);
                                  [self requestAlbumInfo];
                              } else {
                                  NSLog(@"something occured making new album");
                              }
                          }];
}

- (void)requestAlbumInfo
{
    // Get album from facebook.
    [FBRequestConnection startWithGraphPath:@"/me/albums"
                                 parameters:nil
                                 HTTPMethod:@"GET"
                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                              // handle result
                              if (!error) {
                                  NSMutableArray *FBresult = [result objectForKey:@"data"];
                                  // FBresultに新しいアルバムが追加されていればalbumArrayを更新
                                  if ([FBresult count] != [_albumArray count]) {
                                      // 2回目以降用
                                      _albumArray = [[NSMutableArray alloc] init];
                                      [[self mutableArrayValueForKey:@"albumArray"] addObjectsFromArray:FBresult];
                                      NSLog(@"FBrequest complete");
                                      NSLog(@"first: %@", _albumArray[0]);
                                  };
                              } else {
                                  // description of error
                                  NSLog(@"error %@", error.description);
                              }
                          }];
}

- (void)uploadImageToAlbum:(UIImage *)image
{
    PhotoAlbum *currentAlbum = [PhotoAlbum sharedCurrentAlbum];
    NSLog(@"%@", image);
    if (currentAlbum.albumID != nil) {
        NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:image, @"source", @"true", @"no_story", nil];
        NSString *requestUrl = [[NSString alloc] initWithFormat:@"/%@/photos",currentAlbum.albumID];
        [FBRequestConnection startWithGraphPath:requestUrl
                                     parameters:params
                                     HTTPMethod:@"POST"
                              completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                  // handle the result
                                  NSLog(@"successfuly uploaded file : %@", [result objectForKey:@"id"]);
                              }];
    } else {
        // you need to select an album
        NSLog(@"you need to select an album");
    }
}

@end
