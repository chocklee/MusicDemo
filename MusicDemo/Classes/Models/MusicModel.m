//
//  MusicModel.m
//  MusicDemo
//
//  Created by chock on 15/11/13.
//  Copyright © 2015年 chock. All rights reserved.
//

#import "MusicModel.h"

@implementation MusicModel

//arc时也需重写dealloc,释放属性
- (void)dealloc {
    self.mp3Url = nil;
    self.ID = nil;
    self.name = nil;
    self.picUrl = nil;
    self.singer = nil;
    self.duration = nil;
    self.lyric = nil;
    self.blurPicUrl = nil;
}

- (void)setValue:(id)value forKey:(NSString *)key {
    [super setValue:value forKey:key];
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {

}

@end
