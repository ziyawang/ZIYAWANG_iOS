//
//  RecordManager.m
//  Ziyawang
//
//  Created by Mr.Xu on 2016/11/25.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import "RecordManager.h"

@interface RecordManager ()<AVAudioRecorderDelegate,AVAudioPlayerDelegate>

@end

@implementation RecordManager
+ (RecordManager *)recordManager
{
    static RecordManager *defaultManager = nil;
    static dispatch_once_t oneceToken;
    dispatch_once(&oneceToken, ^{
        defaultManager = [[RecordManager alloc]init];
        
    });
    
    return defaultManager;
}
- (void)recordWithView:(UIView *)recordView url:(NSString *)url
{
    //录音与播放按钮
    self.recorderbutton =[UIButton buttonWithType:(UIButtonTypeSystem)];
    //        [self.recorderbutton setTitle:@"录音" forState:(UIControlStateNormal)];
    [self.recorderbutton setBackgroundImage:[UIImage imageNamed:@"changluyin"] forState:(UIControlStateNormal)];
    
    [self.recorderbutton setFrame:CGRectMake(75, 5, 150, 30)];
    [recordView addSubview:self.recorderbutton];
    /**
     *  添加录音按钮的事件
     *
     *  @param startRecorder startRecorder description
     *
     *  @return return value description
     */
    [self.recorderbutton addTarget:self action:@selector(startRecorder) forControlEvents:UIControlEventTouchDown];
    [self.recorderbutton addTarget:self action:@selector(cancelRecorder) forControlEvents:UIControlEventTouchUpInside];
    [self.recorderbutton addTarget:self action:@selector(dragRecorder) forControlEvents:UIControlEventTouchDragExit];
    
    self.playRecorderButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [self.playRecorderButton setFrame:CGRectMake(75, 5, 120, 30)];
    [self.playRecorderButton setTitle:@"播放" forState:(UIControlStateNormal)];
    [self.playRecorderButton setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateNormal)];
    
    //    [self.playRecorderButton setTitle:@"播放" forState:(UIControlStateNormal)];
    [recordView addSubview:self.playRecorderButton];
    [self.playRecorderButton setBackgroundImage:[UIImage imageNamed:@"yuyinbofang"] forState:(UIControlStateNormal)];
    self.rerecorderButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [self.rerecorderButton setTitle:@"重录" forState:(UIControlStateNormal)];
    [self.rerecorderButton setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateNormal)];
    self.rerecorderButton.titleLabel.font = [UIFont systemFontOfSize:8];
    
    //    [self.rerecorderButton setTitle:@"重录" forState:(UIControlStateNormal)];
    [self.rerecorderButton setFrame:CGRectMake(85 + self.playRecorderButton.bounds.size.width, 5, 30, 30)];
    ;
    [self.rerecorderButton setBackgroundImage:[UIImage imageNamed:@"rerecord"] forState:(UIControlStateNormal)];
    [recordView addSubview:self.rerecorderButton];
    [self.rerecorderButton setHidden:YES];
    [self.playRecorderButton setHidden:YES];
    [self.playRecorderButton addTarget:self action:@selector(playRecorder) forControlEvents:UIControlEventTouchUpInside];
    [self.rerecorderButton addTarget:self action:@selector(didClickRerecorder:) forControlEvents:(UIControlEventTouchUpInside)];
    
}
- (void)didClickRerecorder:(UIButton*)rerecorderButton
{
    [self.playRecorderButton setHidden:YES];
    [self.recorderbutton setHidden:NO];
    [self.rerecorderButton setHidden:YES];
    
    
}
/**
 *  设置录音中动画提示
 */
- (void)setRecordAnimation
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake([[UIApplication sharedApplication]keyWindow].bounds.size.width/2-50, [[UIApplication sharedApplication]keyWindow].bounds.size.height/2-114, 100, 100)];
    
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 50;
    self.recordAnimationView = view;
    //    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.x, self.view.y, 100, 100 )];
    self.recordAnimationView.backgroundColor = [UIColor colorWithHexString:@"fdd000"];
    UILabel *recordLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, self.recordAnimationView.bounds.size.height/2-10, 80, 20)];
    recordLabel.font = [UIFont systemFontOfSize:15];
    recordLabel.text = @"正在录音...";
    [self.recordAnimationView addSubview:recordLabel];
    recordLabel.textColor = [UIColor whiteColor];
}
#pragma mark----设置录音机，添加录音事件
/**
 *  初始化录音机
 */
- (void)setaudioWithView:(UIView *)view recordView:(UIView *)recordView
{
    
    [self setRecordAnimation];
    
    self.view = view;
    //录音设置
    NSMutableDictionary *setting = [[NSMutableDictionary alloc]init];
    [setting setValue:[NSNumber numberWithUnsignedInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
    [setting setValue:[NSNumber numberWithFloat:11025.0] forKey:AVSampleRateKey];
    [setting setValue:[NSNumber numberWithInt:1] forKey:AVNumberOfChannelsKey];
    [setting setValue:[NSNumber numberWithInt:8] forKey:AVLinearPCMBitDepthKey];
    [setting setValue:[NSNumber numberWithInt:AVAudioQualityMin] forKey:AVEncoderAudioQualityKey];
    NSString *urlStr = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSLog(@"%@",urlStr);
    NSString *fileName = @"lll.wav";
    NSString *urlpath = [urlStr stringByAppendingString:fileName];
    NSURL *url2 = [NSURL URLWithString:urlpath];
    
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/lll.wav",urlStr]];
    self.aurl = url;
    
    //若想要在真机播放，必须在初始化录音机之前添加这一段代码
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *setCategoryError = nil;
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&setCategoryError];
    if(setCategoryError){
        NSLog(@"%@", [setCategoryError description]);
    }
    self.recorder = [[AVAudioRecorder alloc]initWithURL:url settings:setting error:nil];
    self.recorder.meteringEnabled = YES;
    self.recorder.delegate = self;
    
    [self recordWithView:recordView url:urlStr];
    
}

/**
 *  开始录音
 */
- (void)startRecorder
{
    NSDate *date = [NSDate date];
    NSLog(@"-----------%@",date);
    if(self.recorder.currentTime == 0)
    {
        if ([self.recorder prepareToRecord]) {
            [self.recorder record];
        }
//        [s addSubview:self.recordAnimationView];
        [[[UIApplication sharedApplication]keyWindow] addSubview:self.recordAnimationView];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(detectVoice) userInfo:nil repeats:YES];
    }
    else
    {
        [self playRecorder];
    }
}

/**
 *  可以通过此方法以音量设置UI(扩展方法)
 */
- (void)detectVoice
{

    //    NSTimeInterval time = self.timer.timeInterval;
    //    NSString *string = [NSString stringWithFormat:@"%02li:%02li:%02li",
    //                        lround(floor(time / 3600.)) % 100,
    //                        lround(floor(time / 60.)) % 60,
    //                        lround(floor(time)) % 60];
    //    NSLog(@"############%@",string);
    //通过音量设置UI
    //    NSLog(@"通过音量设置UI");
    if (self.recorder.currentTime > 30) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"录音时间不能超过30秒" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        [self.recordAnimationView removeFromSuperview];
//        self.haveVideo = YES;
        
        [self.recorderbutton setHidden:YES];
        [self.playRecorderButton setHidden:NO];
        [self.rerecorderButton setHidden:NO];
        
        [self.recorder stop];
        [self.timer invalidate];
    }
}
/**
 *  时间转换方法
 *
 *  @param totalSeconds 时间转换
 *
 *  @return NO
 */
- (NSString *)timeFormatted:(int)totalSeconds
{
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    //    int hours = totalSeconds / 3600;
    return [NSString stringWithFormat:@"%2d:%02d", minutes, seconds];
}

/**
 *  录音结束
 */
- (void)cancelRecorder
{
    double cTime = self.recorder.currentTime;
    NSLog(@"(((((((((((((((((((((%f",cTime);
    int time = (int)cTime;
    NSLog(@")))))))))))))))))))%d",time);
    NSString *timeStr = [self timeFormatted:time];
    NSLog(@"录音的总时长为：%@",timeStr);
    // 在这个地方铺设新的播放按钮
    if (cTime > 0.5&&cTime<30.0) {
        [self.recordAnimationView removeFromSuperview];
        [self.timer invalidate];
//        self.haveVideo = YES;
        [self.recorderbutton setHidden:YES];
        [self.playRecorderButton setHidden:NO];
        [self.rerecorderButton setHidden:NO];
        NSLog(@"可以发送语音");
    }
    //    else if (cTime > 30.0)
    //    {
    //        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"录音时间不能超过30秒" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    //        [alert show];
    //
    //        [self.timer invalidate];
    //        self.haveVideo = YES;
    //        [self.recorderbutton setHidden:YES];
    //        [self.playRecorderButton setHidden:NO];
    //        [self.rerecorderButton setHidden:NO];
    //    }
    else
    {
        [self.recordAnimationView removeFromSuperview];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"录音时间过短" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        //删除记录的
        [self.recorder deleteRecording];
        //删除存储的
    }
    NSDate *date = [NSDate date];
    NSLog(@">>??????????????%@",date);
    [self.recorder stop];
    [self.timer invalidate];
}
/**
 *  拖拽删除录音
 */
- (void)dragRecorder
{
    [self.recorder deleteRecording];
    [self.timer invalidate];
    [self.recorder stop];
    [self.recordAnimationView removeFromSuperview];
    
}
/**
 *  播放录音
 */
- (void)playRecorder
{
    
    
    if ([self.audioPlayer isPlaying]) {
        [self.audioPlayer stop];
        [self.playRecorderButton setTitle:@"播放" forState:(UIControlStateNormal)];
        return;
    }
    else
    {
        self.audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:self.aurl error:nil];
        self.audioPlayer.delegate = self;
        [self.audioPlayer play];
        [self.playRecorderButton setTitle:@"正在播放" forState:(UIControlStateNormal)];
        
    }
    //    [self.playRecorderButton setTitle:@"正在播放" forState:(UIControlStateNormal)];
    //
    //    [self.avPlayer pause];
    //    self.avPlayer = [[AVPlayer alloc]initWithURL:self.aurl];
    //    [self.avPlayer play];
    
}
/**
 *  AVaudioPlayer代理方法
 *
 *  @param player
 *  @param flag
 */
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self.playRecorderButton setTitle:@"播放" forState:(UIControlStateNormal)];
}

@end
