//
//  MusicCell.m
//  MusicDemo
//
//  Created by chock on 15/11/12.
//  Copyright © 2015年 chock. All rights reserved.
//

#import "MusicCell.h"
#import "MusicModel.h"
#import "UIImageView+WebCache.h"

@interface MusicCell ()

@property (weak, nonatomic) IBOutlet UIImageView *musicHeadView;

@property (weak, nonatomic) IBOutlet UILabel *musicTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *singerLabel;

@end

@implementation MusicCell



//重写setMuiscModel
- (void)setMusic:(MusicModel *)music {
    if (_music != music) {
        _music = nil;
        _music = music;
        [self setMusicCellContent];
    }
}

//设置cell的内容
- (void)setMusicCellContent {
    self.musicTitleLabel.text = self.music.name;
    self.singerLabel.text = self.music.singer;
    [self.musicHeadView sd_setImageWithURL:[NSURL URLWithString:self.music.picUrl]];
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
