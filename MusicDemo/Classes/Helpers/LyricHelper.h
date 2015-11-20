//
//  LyricHelper.h
//  MusicDemo
//
//  Created by chock on 15/11/14.
//  Copyright © 2015年 chock. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LyricHelper : NSObject

//歌词行数
@property (nonatomic,assign) NSInteger count;

//单例
+ (instancetype)shareLyricHelper;

//根据时间获取对应下标
- (NSInteger)indexWithTime:(NSInteger)time;

//根据下标获取对应歌词
- (NSString *)stringWithIndex:(NSInteger)index;

//将字符串转为歌词数组
- (void)serializeString:(NSString *)string;

//根据歌词下标返回时间
- (NSInteger)getTimeWithIndex:(NSInteger)index;

@end
