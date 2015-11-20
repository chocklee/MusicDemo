//
//  MusicModel.h
//  MusicDemo
//
//  Created by chock on 15/11/13.
//  Copyright © 2015年 chock. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 <key>mp3Url</key>
 <key>id</key>
 <key>name</key>
 <key>picUrl</key>
 <key>singer</key>
 <key>duration</key>
 <key>lyric</key>
*/

@interface MusicModel : NSObject

//mp3网址
@property (nonatomic,copy) NSString *mp3Url;
//id
@property (nonatomic,copy) NSString *ID;
//歌曲名
@property (nonatomic,copy) NSString *name;
//歌手名
@property (nonatomic,copy) NSString *singer;
//时长
@property (nonatomic,copy) NSNumber *duration;
//歌词
@property (nonatomic,copy) NSString *lyric;
//封面
@property (nonatomic,copy) NSString *picUrl;
//背景图片
@property (nonatomic,copy) NSString *blurPicUrl;

@end
