//
//  LyricModel.h
//  MusicDemo
//
//  Created by chock on 15/11/13.
//  Copyright © 2015年 chock. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LyricModel : NSObject

//时间
@property (nonatomic,assign) NSInteger time;

//歌词内容
@property (nonatomic,copy) NSString *string;


- (instancetype)initWithTime:(NSInteger)time andString:(NSString *)string;

+ (instancetype)lyricWithTime:(NSInteger)time andString:(NSString *)string;

@end
