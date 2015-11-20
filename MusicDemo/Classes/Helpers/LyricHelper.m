//
//  LyricHelper.m
//  MusicDemo
//
//  Created by chock on 15/11/14.
//  Copyright © 2015年 chock. All rights reserved.
//

#import "LyricHelper.h"
#import "LyricModel.h"

@interface LyricHelper ()

//歌词的数组
@property (nonatomic,strong) NSMutableArray *lyricArray;

@end

@implementation LyricHelper

//懒加载
- (NSMutableArray *)lyricArray {
    if (!_lyricArray) {
        _lyricArray = [NSMutableArray array];
    }
    return _lyricArray;
}

//单例
+ (instancetype)shareLyricHelper {
    static LyricHelper *lyricHelper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        lyricHelper = [[LyricHelper alloc] init];
    });
    return lyricHelper;
}

// count
- (NSInteger)count {
    return self.lyricArray.count;
}

//解析字符串
- (void)serializeString:(NSString *)string {
    NSArray *array = [string componentsSeparatedByString:@"\n"];
    [self.lyricArray removeAllObjects];
    //遍历数组
    for (NSString *lyricString in array) {
        //根据"]"分割,第一个是时间,第二个是歌词
        NSArray *lyricStrArray = [lyricString componentsSeparatedByString:@"]"];
        if (lyricStrArray.count <= 1) {
            continue;
        }
        //根据":"分割,第一个是分,第二个是秒
        NSArray *timeArray = [lyricStrArray[0] componentsSeparatedByString:@":"];
        NSInteger minute = 0;
        if ([timeArray[0] length] > 0) {
            minute = [timeArray[0] substringFromIndex:1].integerValue;
        }
        NSInteger time = minute * 60 + [timeArray[1] integerValue];
        //创建歌词模型
        LyricModel *lyric = [LyricModel lyricWithTime:time andString:lyricStrArray[1]];
        //添加到歌词数组
        [self.lyricArray addObject:lyric];
    }
}

//根据时间获取对应下标
- (NSInteger)indexWithTime:(NSInteger)time {
    for (int i = 0; i < self.lyricArray.count; i++) {
        if (time < [self.lyricArray[i] time]) {
           return i - 1 < 0 ? 0 : i - 1;
        }
    }
    return self.lyricArray.count - 1;
}

//根据下标获取对应歌词
- (NSString *)stringWithIndex:(NSInteger)index {
    return [self.lyricArray[index] string];
}

//根据歌词下标返回时间
- (NSInteger)getTimeWithIndex:(NSInteger)index {
    return [self.lyricArray[index] time];
}

@end
