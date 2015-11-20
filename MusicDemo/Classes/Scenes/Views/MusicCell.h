//
//  MusicCell.h
//  MusicDemo
//
//  Created by chock on 15/11/12.
//  Copyright © 2015年 chock. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MusicModel;
@interface MusicCell : UITableViewCell

//歌曲
@property (nonatomic,strong) MusicModel *music;

@end
