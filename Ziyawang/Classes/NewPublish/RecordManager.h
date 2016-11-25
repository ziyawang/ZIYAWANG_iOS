//
//  RecordManager.h
//  Ziyawang
//
//  Created by Mr.Xu on 2016/11/25.
//  Copyright © 2016年 Mr.Xu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface RecordManager : NSObject

@property (nonatomic,strong) AVAudioRecorder *recorder;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,strong) AVPlayer *avPlayer;
@property (nonatomic,strong) AVAudioPlayer *audioPlayer;
@property (nonatomic,strong) NSURL *aurl;
@property (nonatomic,strong) UIView *recordAnimationView;

@property (nonatomic,strong) UIButton *recorderbutton;
@property (nonatomic,strong) UIButton *playRecorderButton;
@property (nonatomic,strong) UIButton *rerecorderButton;

@property (nonatomic,strong) UIView *view;
+ (RecordManager *)recordManager;

- (void)setaudioWithView:(UIView *)view recordView:(UIView *)recordView;
- (void)recordWithView:(UIView *)recordView url:(NSString *)url;


@end
