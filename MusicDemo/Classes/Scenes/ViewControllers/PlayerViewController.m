//
//  PlayerViewController.m
//  MusicDemo
//
//  Created by chock on 15/11/12.
//  Copyright © 2015年 chock. All rights reserved.
//

#import "PlayerViewController.h"
#import "MusicModel.h"
#import "DataHelper.h"
#import "UIImageView+WebCache.h"
#import <AVFoundation/AVFoundation.h>
#import "PlayerHelper.h"
#import "LyricHelper.h"
#import "LyricModel.h"
#import "MBProgressHUD.h"


@interface PlayerViewController () <PlayerHelperDelegate,UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *musicTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *singerLabel;

@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;

@property (weak, nonatomic) IBOutlet UIImageView *musicHeadView;

//显示歌词的tableView
@property (weak, nonatomic) IBOutlet UITableView *lyricTableView;

@property (nonatomic,strong) MusicModel *music;

@property (weak, nonatomic) IBOutlet UIButton *playButton;

@property (weak, nonatomic) IBOutlet UIImageView *blurPicView;

@property (weak, nonatomic) IBOutlet UISlider *timeSlider;

//播放模式按钮点击次数
@property (nonatomic,assign) NSInteger clickModeCount;

//播放暂停按钮点击次数
@property (nonatomic,assign) BOOL isPlay;

//当前歌词所在行
@property (nonatomic,assign) NSInteger currentIndex;

//歌词背景
@property (weak, nonatomic) IBOutlet UIImageView *lyricBackgroundView;

//显示播放模式
@property (nonatomic,strong) MBProgressHUD *hud;

//显示当前播放歌词
@property (weak, nonatomic) IBOutlet UILabel *lyricLabel;


@end

@implementation PlayerViewController

//单例获取方法
+ (instancetype)sharePlayerVC {
    static PlayerViewController *playerVC = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //从当前的Main.storyboard中
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        //获取playerVC实例
        playerVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"playvc"];
    });
    //返回playerVC
    return playerVC;
}

//懒加载hud
- (MBProgressHUD *)hud {
    if (!_hud) {
        _hud = [[MBProgressHUD alloc] initWithView:self.view];
        _hud.mode = MBProgressHUDModeCustomView;
        [self.view addSubview:_hud];
    }
    return _hud;
}

// musicIndex的set方法
- (void)setMusicIndex:(NSInteger)musicIndex {
    _musicIndex = musicIndex;
    [self changeMusic];
}

//更换歌曲
- (void)changeMusic {
 
    self.music = [[DataHelper shareDataHelper] getMusicModelFromIndex:self.musicIndex];
    //歌名
    self.musicTitleLabel.text = self.music.name;
    //歌手
    self.singerLabel.text = self.music.singer;
    //背景图片
    [self.blurPicView sd_setImageWithURL:[NSURL URLWithString:self.music.blurPicUrl]];
    //专辑封面
    [self.musicHeadView sd_setImageWithURL:[NSURL URLWithString:self.music.picUrl] placeholderImage:[UIImage imageNamed:@"music"]];
    //歌词背景
    [self.lyricBackgroundView sd_setImageWithURL:[NSURL  URLWithString:self.music.blurPicUrl]];
    
    //总时长
    self.totalTimeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld",self.music.duration.integerValue / 1000 / 60, self.music.duration.integerValue / 1000 % 60];
    
    //播放下标对应的歌曲
    [[PlayerHelper sharePlayer] playMusicWithIndex:self.musicIndex];
    
    //设置播放按钮
    self.isPlay = YES;
    [self.playButton setImage:[UIImage imageNamed:@"iconfont-zanting.png"] forState:UIControlStateNormal];
    
    //设置播放进度的slider
    self.timeSlider.minimumValue = 0;
    self.timeSlider.maximumValue = self.music.duration.integerValue / 1000;
    //设置歌词
    [[LyricHelper shareLyricHelper] serializeString:self.music.lyric];
    [self.lyricTableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.musicHeadView.layer.cornerRadius = self.musicHeadView.frame.size.width * 0.5;
//    self.musicHeadView.layer.masksToBounds = YES;
    self.musicHeadView.clipsToBounds = YES;
    
    //指定代理
    [PlayerHelper sharePlayer].delegate = self;
    self.lyricTableView.dataSource = self;
    self.lyricTableView.delegate = self;
    //音乐模式点击次数初始化
    self.clickModeCount = 0;
    
    //设置tableView的背景色
    self.lyricTableView.backgroundColor = [UIColor blackColor];
    self.lyricTableView.alpha = 0.7;

}


//timer的方法 转
- (void)rotate {
    [UIView animateWithDuration:0.1 animations:^{
        self.musicHeadView.transform = CGAffineTransformRotate(self.musicHeadView.transform, M_PI_4 * 0.05);
    }];
}

//返回播放列表
- (IBAction)didClickCancelButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//上一首按钮
- (IBAction)didClickLastMusicButton:(id)sender {
    //self.musicIndex-- 实现上一首
    if (self.musicIndex <= 0) {
        return;
    }
    self.musicIndex--;
}

//播放/暂停按钮
- (IBAction)didClickPlayPauseButton:(id)sender {
    UIButton *button = sender;
    if (!self.isPlay) {
        [button setImage:[UIImage imageNamed:@"iconfont-zanting.png"] forState:UIControlStateNormal];
        [[PlayerHelper sharePlayer] play];
        self.isPlay = YES;
    } else {
        [button setImage:[UIImage imageNamed:@"iconfont-player-play.png"] forState:UIControlStateNormal];
        [[PlayerHelper sharePlayer] pause];
        self.isPlay = NO;
    }
}

//下一首按钮
- (IBAction)didClickNextMusicButton:(id)sender {
    if (self.musicIndex >= [DataHelper shareDataHelper].count - 1) {
        return;
    }
    if ([PlayerHelper sharePlayer].playMode == RandomPlay) {
        self.musicIndex = arc4random() % 200;
    } else {
        self.musicIndex++;
    }
}

//音量
- (IBAction)didChangeVolumeSlider:(UISlider *)sender {
    [PlayerHelper sharePlayer].volume = sender.value;
}

//播放进度
- (IBAction)didChangeTimeSlider:(UISlider *)sender {
    //更改播放进度
    [[PlayerHelper sharePlayer] seekToTime:sender.value];
}

#pragma mark --- PlayerHelperDelegate
//播放
- (void)playerDidPlay:(float)time {
//    NSLog(@"%s,%d",__FUNCTION__,__LINE__);
    //设置当前时间的label
    self.currentTimeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld",(NSInteger)time / 60,(NSInteger)time % 60];
    //设置timeSlider的value
    self.timeSlider.value = time;
    //旋转动画
    [self rotate];
    
    if ([LyricHelper shareLyricHelper].count > 0) {
        //获取时间对应的行
        NSInteger row = [[LyricHelper shareLyricHelper] indexWithTime:time];
        //此行的indexPath
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
        //使歌词tableView滚动到那一行
        [self.lyricTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        //设置选中的cell
        [self.lyricTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
        //显示当前播放的歌词
        self.lyricLabel.text = [[LyricHelper shareLyricHelper] stringWithIndex:row];
        
//        self.currentIndex = row;
//        [self.lyricTableView reloadData];
    }
}

//播放模式
- (IBAction)playModeButton:(id)sender {
    UIButton *button = sender;
    if (self.clickModeCount == 0) {
        [button setImage:[UIImage imageNamed:@"iconfont-xunhuanbofang.png"] forState:UIControlStateNormal];
        [PlayerHelper sharePlayer].playMode = ListCyclePlay;
        self.hud.labelText = @"列表循环";
        [self showHUD];
    }
    if (self.clickModeCount == 1) {
        [button setImage:[UIImage imageNamed:@"iconfont-danquxunhuan.png"] forState:UIControlStateNormal];
        [PlayerHelper sharePlayer].playMode = SinglePlay;
        self.hud.labelText = @"单曲循环";
        [self showHUD];
    }
    if (self.clickModeCount == 2) {
        [button setImage:[UIImage imageNamed:@"iconfont-suijibofang.png"] forState:UIControlStateNormal];
        [PlayerHelper sharePlayer].playMode = RandomPlay;
        self.hud.labelText = @"随机播放";
        [self showHUD];
    }
    if (self.clickModeCount == 3) {
        self.clickModeCount = 0;
        [button setImage:[UIImage imageNamed:@"iconfont-ttpodicon.png"] forState:UIControlStateNormal];
        [PlayerHelper sharePlayer].playMode = ListPlay;
        self.hud.labelText = @"列表播放";
        [self showHUD];
        return;
    }
    self.clickModeCount++;
}

//显示hud
- (void)showHUD {
    [self.hud show:YES];
    [self.hud hide:YES afterDelay:0.5];
}

//停止
- (void)playerDidFinish {
//    NSLog(@"%s,%d",__FUNCTION__,__LINE__);
    
    //播放模式
    //列表播放
    if ([PlayerHelper sharePlayer].playMode == ListPlay) {
        if (self.musicIndex == [DataHelper shareDataHelper].count - 1) {
            return;
        }
        //下一首
        self.musicIndex++;
    }
    //列表循环
    if ([PlayerHelper sharePlayer].playMode == ListCyclePlay) {
        if (self.musicIndex == [DataHelper shareDataHelper].count - 1) {
            self.musicIndex = 0;
        } else {
            //下一首
            self.musicIndex++;
        }
    }
    //单曲循环
    if ([PlayerHelper sharePlayer].playMode == SinglePlay) {
        [[PlayerHelper sharePlayer] seekToTime:0];
    }
    //随机播放
    if ([PlayerHelper sharePlayer].playMode == RandomPlay) {
        self.musicIndex = arc4random() % 200;
    }
}

#pragma mark --- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [LyricHelper shareLyricHelper].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    //设置被选中的cell的样式
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    //设置cell的内容
    cell.textLabel.text = [[LyricHelper shareLyricHelper] stringWithIndex:indexPath.row];
    cell.textLabel.textColor = [UIColor lightGrayColor];
    //设置cell为无色
    cell.backgroundColor = [UIColor clearColor];
    //设置被选中cell的高亮色
    cell.textLabel.highlightedTextColor = [UIColor redColor];

    UIView *background = [[UIView alloc] init];
    background.backgroundColor = [UIColor clearColor];
    cell.selectedBackgroundView = background;
    
//    if (indexPath.row == self.currentIndex) {
//        cell.textLabel.textColor = [UIColor redColor];
//    } else {
//        cell.textLabel.textColor = [UIColor blackColor];
//    }
    return cell;
}

//点击歌词改编进度
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger time = [[LyricHelper shareLyricHelper] getTimeWithIndex:indexPath.row];
    [[PlayerHelper sharePlayer] seekToTime:time];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
