//
//  PlayerHelper.h
//  MusicDemo
//
//  Created by chock on 15/11/13.
//  Copyright © 2015年 chock. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 播放模式枚举
 */
typedef enum : NSUInteger {
    ListPlay, //列表播放
    ListCyclePlay, //列表循环
    SinglePlay, //单曲循环
    RandomPlay //随机播放
} PlayMode;

//播放状态代理
@protocol PlayerHelperDelegate <NSObject>

//正在播放
- (void)playerDidPlay:(float)time;

//播放完成
- (void)playerDidFinish;

@end


@interface PlayerHelper : NSObject
//音量
@property (nonatomic,assign) float volume;

//歌曲下标
@property (nonatomic,assign) NSInteger musicIndex;

//播放代理 ARC下用weak,MRC下用assign,避免循环引用
@property (nonatomic,weak) id<PlayerHelperDelegate> delegate;

//播放模式
@property (nonatomic,assign) PlayMode playMode;

//改变播放进度
- (void)seekToTime:(NSInteger)time;

//播放
- (void)play;

//暂停
- (void)pause;

//根据下标播放歌曲
- (void)playMusicWithIndex:(NSInteger)index;

//单例方法
+ (instancetype)sharePlayer;

@end
