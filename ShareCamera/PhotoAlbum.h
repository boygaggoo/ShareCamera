//
//  PhotoAlbum.h
//  ShareCamera
//
//  Created by 谷 亮介 on 2014/11/19.
//  Copyright (c) 2014年 Ryosuke Tani. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>

@interface PhotoAlbum : NSObject

@property (strong, nonatomic) NSString *privacy;
@property (strong, nonatomic) NSString *link;
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSString *albumID;
@property (strong, nonatomic) NSString *title;

@property (strong, nonatomic) NSMutableArray *albumArray; // ストレージから取得したアルバム情報を配列として保管

// Albumインスタンスを取得（シングルトン）
+ (PhotoAlbum *)sharedCurrentAlbum;
// 新規のアルバムを作成する
- (void)makeAlbumWithTitle:(NSString *)title;
// ストレージ上のアルバム情報を取得
- (void)requestAlbumInfo;
// 写真をアルバムへアップロード
- (void)uploadImageToAlbum:(UIImage *)image;

@end
