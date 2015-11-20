//
//  PlayerViewController.h
//  MusicDemo
//
//  Created by chock on 15/11/12.
//  Copyright © 2015年 chock. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayerViewController : UIViewController

//歌曲下标
@property (nonatomic,assign) NSInteger musicIndex;

//单例获取方法
+ (instancetype)sharePlayerVC;

@end
