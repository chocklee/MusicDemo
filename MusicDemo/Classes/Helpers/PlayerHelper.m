//
//  PlayerHelper.m
//  MusicDemo
//
//  Created by chock on 15/11/13.
//  Copyright © 2015年 chock. All rights reserved.
//

#import "PlayerHelper.h"
#import <AVFoundation/AVFoundation.h>
#import "MusicModel.h"
#import "DataHelper.h"

@interface PlayerHelper ()

//播放器属性
@property (nonatomic,strong) AVPlayer *avPlayer;

//当前下标
@property (nonatomic,assign) NSInteger currentIndex;

//播放状态
@property (nonatomic,assign) BOOL isPlay;

@end

@implementation PlayerHelper

//懒加载
- (AVPlayer *)avPlayer {
    if (!_avPlayer) {
        _avPlayer = [[AVPlayer alloc] init];
        //添加定时器
        [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(performDelegateAction) userInfo:nil repeats:YES];
    }
    return _avPlayer;
}

//调用代理
- (void)performDelegateAction {
    //判断播放状态
    if (self.avPlayer.rate) {
        //播放时调用播放的代理方法
        //respondsToSelector: 用来判断是否有以某个名字命名的方法
        if ([self.delegate respondsToSelector:@selector(playerDidPlay:)]) {
            //当前播放的时间
//            NSLog(@"value :%lld",self.avPlayer.currentTime.value);
//            NSLog(@"value :%d",self.avPlayer.currentTime.timescale);
            float time = self.avPlayer.currentTime.value / self.avPlayer.currentTime.timescale;
            //当前时间作为参数调用代理
            [self.delegate playerDidPlay:time];
            self.isPlay = YES;
        }
    } else if (self.isPlay && !self.avPlayer.rate) { //只在播放结束的时候执行一次
        //完成播放调用完成的代理方法
        if ([self.delegate respondsToSelector:@selector(playerDidFinish)]) {
            [self.delegate playerDidFinish];
            self.isPlay = NO;
        }
    }
}

//单例方法
+ (instancetype)sharePlayer {
    static PlayerHelper *player = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        player = [[PlayerHelper alloc] init];
        player.currentIndex = -1;
        player.playMode = ListPlay;
    });
    return player;
}

//音量
- (void)setVolume:(float)volume {
    self.avPlayer.volume = volume;
}

- (float)volume {
    return self.avPlayer.volume;
}

//下标
//下标值从-1开始
- (void)setMusicIndex:(NSInteger)musicIndex {
    if (self.currentIndex != musicIndex) {
        _musicIndex = musicIndex;
        _currentIndex = musicIndex;
    
        MusicModel *music = [[DataHelper shareDataHelper] getMusicModelFromIndex:musicIndex];
        //创建AVPlayerItem
        AVPlayerItem *currentItem = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:music.mp3Url]];
        //将此Item播放
        [self.avPlayer replaceCurrentItemWithPlayerItem:currentItem];
        [self.avPlayer play];
    }
}

//根据下标播放歌曲
- (void)playMusicWithIndex:(NSInteger)index {
    self.musicIndex = index;
}

//播放
- (void)play {
    [self.avPlayer play];
    self.isPlay = YES;
}

//暂停
- (void)pause {
    [self.avPlayer pause];
    self.isPlay = NO;
}

//改变播放进度
- (void)seekToTime:(NSInteger)time {
    //如果是播放状态
    if (self.isPlay) {
        //先暂停当前歌曲
        [self pause];
        //改变播放进度
        [self.avPlayer seekToTime:CMTimeMake(time * self.avPlayer.currentTime.timescale, self.avPlayer.currentTime.timescale)];
        //继续播放
        [self play];
    } else {
        //改变播放进度
        [self.avPlayer seekToTime:CMTimeMake(time * self.avPlayer.currentTime.timescale, self.avPlayer.currentTime.timescale)];
    }
}





@end
