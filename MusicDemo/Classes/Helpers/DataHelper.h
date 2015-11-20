//
//  DataHelper.h
//  MusicDemo
//
//  Created by chock on 15/11/13.
//  Copyright © 2015年 chock. All rights reserved.
//

#import <Foundation/Foundation.h>


//向前声明
@class MusicModel;
@interface DataHelper : NSObject

//当歌曲列表加载完后,回调
@property (nonatomic,copy) void(^ResultBlock)();
//歌曲的个数
@property (nonatomic,assign) NSInteger count;


//根据indexPath获取MusicModel
- (MusicModel *)getMusicModelFromIndexPath:(NSIndexPath *)indexPath;

//根据下标获取MusicModel
- (MusicModel *)getMusicModelFromIndex:(NSInteger)index;

//获得无序歌曲列表
- (NSArray *)getAllMusicOfRandomArray;

//单例方法
+ (instancetype)shareDataHelper;

@end
