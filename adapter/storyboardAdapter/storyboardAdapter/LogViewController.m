//
//  LogViewController.m
//  storyboardAdapter
//
//  Created by kangxg on 2017/10/23.
//  Copyright © 2017年 zy. All rights reserved.
//

#import "LogViewController.h"
#import <AVFoundation/AVFoundation.h>
//屏幕的宽
#define kScreenWith [UIScreen mainScreen].bounds.size.width

//屏幕的高
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
@interface LogViewController ()
@property (nonatomic, strong) AVPlayer * player;

@property (nonatomic, strong) AVPlayerItem * playerItem;

@property (nonatomic, assign) CMTime time;

@property (nonatomic, strong) UIImageView * coverImageView;

@end

@implementation LogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createAvPlayer];
    
    //截取视频第一帧作为视频预览图 监听AVPlayer 当播放时 remove掉预览图
   [self creatCoverImageView];
//    
    [self addVideoKVO];
//    
    [self addNotification];
    // Do any additional setup after loading the view.
}
- (void)createAvPlayer
{
    CGRect playerFrame = CGRectMake(0, 0, kScreenWith, kScreenHeight);
    
    NSURL * url = [[NSBundle mainBundle] URLForResource:@"guideVideo" withExtension:@"mp4"];
    
    AVURLAsset * asset = [AVURLAsset assetWithURL:url];
    
    _playerItem = [AVPlayerItem playerItemWithAsset: asset];
    
    _player = [[AVPlayer alloc]initWithPlayerItem:_playerItem];
    
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    
    playerLayer.frame = playerFrame;
    
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    
    [self.view.layer addSublayer:playerLayer];
    
    [_player play];
}

- (void)creatCoverImageView
{
    self.coverImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.coverImageView];
    self.coverImageView.image = [self getVideoPreViewImage];
}

/*** 获取视频第一帧 ***/
- (UIImage*)getVideoPreViewImage
{
    NSURL * url = [[NSBundle mainBundle] URLForResource:@"guideVideo" withExtension:@"mp4"];
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:url options:nil];
    
    AVAssetImageGenerator * gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    
    gen.appliesPreferredTrackTransform = YES;
    
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    
    NSError *error = nil;
    
    CMTime actualTime;
    
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    
    UIImage *img = [[UIImage alloc] initWithCGImage:image];
    
    CGImageRelease(image);
    
    return img;
}
#pragma -mark- KVO

- (void)addVideoKVO
{
    //KVO
    [_playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
}
- (void)removeVideoKVO
{
    [_playerItem removeObserver:self forKeyPath:@"status"];
}

- (void)observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary<NSString*, id> *)change context:(nullable void *)context
{
    if ([keyPath isEqualToString:@"status"])
    {
        AVPlayerItemStatus status = _playerItem.status;
        switch (status)
        {
            case AVPlayerItemStatusReadyToPlay:
            {
                NSLog(@"AVPlayerItemStatusReadyToPlay");
                [self.coverImageView removeFromSuperview];
            }
                break;
            case AVPlayerItemStatusUnknown:
            {
                NSLog(@"AVPlayerItemStatusUnknown");
            }
                break;
            case AVPlayerItemStatusFailed:
            {
                NSLog(@"AVPlayerItemStatusFailed");
            }
                break;
                
            default:
                break;
        }
    }
}
#pragma -mark- Notification

-(void)addNotification
{
    //给AVPlayerItem添加播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSccess:) name:k_Notification_login object:nil];
}

- (void)playbackFinished:(NSNotification *)notification
{
    // 播放完成后重复播放
    // 跳到最新的时间点开始播放
    
    [_player seekToTime:kCMTimeZero];
    [_player play];
    
}

- (void)appWillResignActive:(NSNotification *)notification
{
    if (self.player)
    {
        [self.player pause];
        
        self.time = self.player.currentTime;
    }
}

- (void)appBecomeActive:(NSNotification *)notification
{
    //在刚启动播放的时候，以及在播放到最后一帧的时候，有可能会出现异常并crash
    //用@try@catch来捕获这个异常，当出现异常的时候直接调用play让播放器自己决定播放的进度
    
    @try {
        
        [self.player seekToTime:self.time toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:^(BOOL finished) {
            if (finished) {
                [self.player play];
            }
        }];
        
        
    } @catch (NSException *exception) {
        
        [self.player play];
        
    } @finally {
        
    }
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
