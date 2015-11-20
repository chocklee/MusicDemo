//
//  DataHelper.m
//  MusicDemo
//
//  Created by chock on 15/11/13.
//  Copyright © 2015年 chock. All rights reserved.
//

#import "DataHelper.h"
#import "MusicModel.h"
#import "URLs.h"
#import <UIKit/UIKit.h>

@interface DataHelper ()
//存储歌曲列表
@property (nonatomic,strong) NSMutableArray *musicArray;

@end

@implementation DataHelper

//懒加载(延迟加载) 在调用get方法时去创建,只会创建一次
- (NSMutableArray *)musicArray {
    if (!_musicArray) {
        _musicArray = [NSMutableArray array];
    }
    return _musicArray;
}

//获取单例方法
+ (instancetype)shareDataHelper {
    static DataHelper *dataHelper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //初始化
        dataHelper = [[DataHelper alloc] init];
        //调用获取歌曲列表的方法
        [dataHelper requestMusicList];
    });
    return dataHelper;
}

//获取歌曲列表
- (void)requestMusicList {
    dispatch_async(dispatch_get_main_queue(), ^{
        //获取plist文件
        NSArray *plistArray = [[NSArray alloc] initWithContentsOfURL:[NSURL URLWithString:kMusicURL]];
        for (NSDictionary *musicDict in plistArray) {
            MusicModel *music = [[MusicModel alloc] init];
            [music setValuesForKeysWithDictionary:musicDict];
            [self.musicArray addObject:music];
        }
        //安全机制
        if (self.ResultBlock) {
            self.ResultBlock();
        }
    });
}

//获得无序歌曲列表
- (NSArray *)getAllMusicOfRandomArray; {
    NSSet *musicSet = [NSSet setWithArray:self.musicArray];
    NSArray *musicArray = [musicSet allObjects];
    return musicArray;
}

//歌曲个数
- (NSInteger)count {
    return self.musicArray.count;
}

//根据indexPath获取MusicModel
- (MusicModel *)getMusicModelFromIndexPath:(NSIndexPath *)indexPath {
    return [self getMusicModelFromIndex:indexPath.row];
}

//根据下标获取MusicModel
- (MusicModel *)getMusicModelFromIndex:(NSInteger)index {
    if (index >= 0 && index < self.musicArray.count) {
        return self.musicArray[index];
    }
    //只要是实例的返回值都可以return nil
    return nil;
}

@end
