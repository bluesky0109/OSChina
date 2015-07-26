//
//  VoiceTweetEditingVC.m
//  OSChina
//
//  Created by sky on 15/7/26.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import "VoiceTweetEditingVC.h"
#import "PlaceholderTextView.h"
#import "Utils.h"
#import "Config.h"
#import "LoginViewController.h"
#import <MBProgressHUD.h>
#import <AFNetworking.h>
#import <AFOnoResponseSerializer.h>
#import <Ono.h>
#import "OSCAPI.h"

#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>

@interface VoiceTweetEditingVC() <UITextViewDelegate, AVAudioRecorderDelegate, AVAudioPlayerDelegate>
{
    NSTimer *timer;
    int recordTime;
    int minute;
    int second;
    BOOL isPlay;
    BOOL hasVoice;
    int recordNumber;
    
    int playDuration;
    int playTimes;
}
@property (nonatomic, strong) PlaceholderTextView   *edittingArea;
@property (nonatomic, strong) UILabel *tweetTextLabel;
@property (nonatomic, strong) UIImageView *voiceImageView;
@property (nonatomic, strong) UILabel *voiceTimes;

@property (nonatomic, strong) UILabel *timesLabel;
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) UIButton *recordingButton;
@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, strong) UILabel *textLabel;

@property (nonatomic, strong) NSURL *recordingUrl;

@property (nonatomic, strong) AVAudioRecorder *audioRecorder;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) AVAudioSession *audioSession;


@end

@implementation VoiceTweetEditingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.navigationItem.title = @"弹一弹";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(cancelButtonClicked)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发表"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(pubTweet)];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    
    [self initSubViews];
    [self setLayout];
    
    [self prepareForAudio];
    
    recordNumber = 1;
}

- (void)initSubViews
{
    _edittingArea = [[PlaceholderTextView alloc] initWithPlaceholder:@"为你的声音附上一段描述..."];
    _edittingArea.delegate = self;
    _edittingArea.placeholderFont = [UIFont systemFontOfSize:16];
    _edittingArea.returnKeyType = UIReturnKeySend;
    _edittingArea.enablesReturnKeyAutomatically = YES;
    _edittingArea.scrollEnabled = NO;
    _edittingArea.font = [UIFont systemFontOfSize:16];
    _edittingArea.autocorrectionType = UITextAutocorrectionTypeNo;
    //边框设置
    _edittingArea.layer.borderColor = UIColor.grayColor.CGColor;
    _edittingArea.layer.borderWidth = 2;
    [self.view addSubview:_edittingArea];
    
    _voiceImageView = [UIImageView new];
    _voiceImageView.image = [UIImage imageNamed:@"voice_0.png"];
    [self.view addSubview:_voiceImageView];
    
    //添加图片
    NSMutableArray *PicArray = [NSMutableArray new];
    for (int nums = 1; nums < 4; nums++) {//四张图片
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"voice_%d.png", nums]];
        
        [PicArray addObject:image];
    }
    _voiceImageView.animationImages = PicArray;
    _voiceImageView.animationDuration = 1;//一次完整动画的时长
    _voiceImageView.hidden = YES;
    
    _voiceTimes = [UILabel new];
    [_voiceTimes setTextAlignment:NSTextAlignmentLeft];
    [self.view addSubview:_voiceTimes];
    
    
    _timesLabel = [UILabel new];
    _timesLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_timesLabel];
    
    _playButton = [UIButton new];
    [_playButton setImage:[UIImage imageNamed:@"voice_play.png"] forState:UIControlStateNormal];
    [_playButton addTarget:self action:@selector(PlayVoice) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_playButton];
    
    _recordingButton = [UIButton new];
    [_recordingButton setImage:[UIImage imageNamed:@"voice_record.png"] forState:UIControlStateNormal];
    [_recordingButton addTarget:self action:@selector(StartRecordingVoice) forControlEvents:UIControlEventTouchDown];
    [_recordingButton addTarget:self action:@selector(StopRecordingVoice) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_recordingButton];
    
    _deleteButton = [UIButton new];
    [_deleteButton setImage:[UIImage imageNamed:@"voice_delete.png"] forState:UIControlStateNormal];
    [_deleteButton addTarget:self action:@selector(DeleteVoice) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_deleteButton];
    
    _textLabel = [UILabel new];
    _textLabel.textAlignment = NSTextAlignmentCenter;
    _textLabel.text = @"长按  录音";
    [self.view addSubview:_textLabel];
    
    
}

- (void)setLayout
{
    for (UIView *view in self.view.subviews) {
        view.translatesAutoresizingMaskIntoConstraints = NO;
    }
    NSDictionary *views = NSDictionaryOfVariableBindings(_edittingArea, _voiceImageView, _voiceTimes, _timesLabel, _playButton, _recordingButton, _deleteButton, _textLabel);
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_edittingArea(100)]-8-[_voiceImageView(30)]->=5-[_timesLabel]"
                                                                      options:NSLayoutFormatAlignAllLeft metrics:nil views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-10-[_edittingArea]-10-|"
                                                                      options:0 metrics:nil views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-10-[_voiceImageView(90)]-10-[_voiceTimes]-10-|"
                                                                      options:NSLayoutFormatAlignAllCenterY metrics:nil views:views]];
    
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_timesLabel]-10-[_recordingButton(100)]-8-[_textLabel]-10-|"
                                                                      options:NSLayoutFormatAlignAllCenterX metrics:nil views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-10-[_timesLabel]-10-|" options:0 metrics:nil views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_playButton(50)]"
                                                                      options:0 metrics:nil views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_deleteButton(50)]"
                                                                      options:0 metrics:nil views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-30-[_playButton(50)]->=25-[_recordingButton(100)]->=25-[_deleteButton(50)]-30-|"
                                                                      options:NSLayoutFormatAlignAllCenterY metrics:nil views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-10-[_textLabel]-10-|" options:0 metrics:nil views:views]];
    
}

- (void)prepareForAudio
{
    _audioSession = [AVAudioSession sharedInstance];
    NSError *error = nil;
    [_audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
    
    if (error) {
        NSLog(@"audioSession:%@ %d %@", [error domain], (int)[error code], [[error userInfo] description]);
        return;
    }
    [_audioSession setActive:YES error:&error];
    error = nil;
    if (error) {
        NSLog(@"audioSession:%@ %d %@", [error domain], (int)[error code], [[error userInfo] description]);
        return;
    }
    
    NSDictionary *recordSetting = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   [NSNumber numberWithFloat: 44100.0],AVSampleRateKey,
                                   [NSNumber numberWithInt: kAudioFormatLinearPCM],AVFormatIDKey,
                                   [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,
                                   [NSNumber numberWithInt: 2], AVNumberOfChannelsKey,
                                   [NSNumber numberWithInt:AVAudioQualityHigh],AVEncoderAudioQualityKey, nil];
    
    _recordingUrl = [NSURL URLWithString:[NSTemporaryDirectory() stringByAppendingString:@"selfRecord.wav"]];
    
    error = nil;
    _audioRecorder = [[AVAudioRecorder alloc] initWithURL:_recordingUrl settings:recordSetting error:&error];
    _audioRecorder.meteringEnabled = YES;
    _audioRecorder.delegate = self;
}

#pragma mark- 长按 开始录音
- (void)StartRecordingVoice
{
    NSLog(@"开始  录音");
    
    //判断是否是第一次录制
    if (recordNumber > 1) {
        [self recordAgain];
    }
    
    _audioSession = [AVAudioSession sharedInstance];
    
    if (!_audioRecorder.recording) {
        
        recordNumber++;
        
        hasVoice = YES;
        _timesLabel.hidden = NO;
        _textLabel.text = @"放开  停止";
        
        [_audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        [_audioSession setActive:YES error:nil];
        
        [_audioRecorder prepareToRecord];
        [_audioRecorder peakPowerForChannel:0.0];
        [_audioRecorder record];
        
        recordTime = 0;
        
        [self recordTimeStart];
    }
}

#pragma mark - 录音时间
- (void)recordTimeStart
{
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(recordTime) userInfo:nil repeats:YES];
}

- (void)recordTime
{
    recordTime += 1;
    if (recordTime == 30) {
        recordTime = 0;
        [_audioRecorder stop];
        [[AVAudioSession sharedInstance] setActive:NO error:nil];
        
        [timer invalidate];
        _timesLabel.text = @"00:00";
        
        return;
    }
    [self updateRecordTime];
}
- (void)updateRecordTime
{
    minute = recordTime/60.0;
    second = recordTime-minute*60;
    
    _timesLabel.text = [NSString stringWithFormat:@"%02d:%02d", minute, second];
}

#pragma mark- 放开长按 停止录音
- (void)StopRecordingVoice
{
    NSLog(@"停止  录音");
    
    _audioSession = [AVAudioSession sharedInstance];
    
    if (_audioRecorder.isRecording) {
        int seconds = minute*60+second;
        _voiceTimes.text = [NSString stringWithFormat:@"%d\" ",seconds];
        
        _voiceImageView.hidden = NO;
        _voiceTimes.hidden = NO;
        _textLabel.text = @"长按  录音";
        
        [_audioRecorder stop];
        [_audioSession setActive:NO error:nil];
        [timer invalidate];
        
        [self updateRecordTime];
    }
}

#pragma mark - 播放录音
- (void)PlayVoice
{
    if (hasVoice) {
        _audioSession = [AVAudioSession sharedInstance];
        
        if (isPlay) {
            NSLog(@"暂停");
            [_playButton setImage:[UIImage imageNamed:@"voice_play.png"] forState:UIControlStateNormal];
            isPlay = NO;
            
            [_voiceImageView stopAnimating];
            
            [_audioPlayer pause];
            [_audioSession setActive:NO error:nil];
        } else {
            NSLog(@"播放中");
            _voiceImageView.hidden = NO;
            _voiceTimes.hidden = NO;
            [_voiceImageView startAnimating];
            
            [_playButton setImage:[UIImage imageNamed:@"voice_pause.png"] forState:UIControlStateNormal];
            isPlay = YES;
            
            [_audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
            [_audioSession setActive:YES error:nil];
            
            NSError *error = nil;
            if (_recordingUrl != nil) {
                _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:_recordingUrl error:&error];
            }
            
            //            _audioPlayer.delegate = self;
            if (error) {
                NSLog(@"error:%@", [error description]);
            }
            
            [_audioPlayer prepareToPlay];
            _audioPlayer.volume = 1;
            [_audioPlayer play];
            
            //播放时间
            playDuration = (int)_audioPlayer.duration;
            playTimes = 0;
            [self audioPlayTimesStart];
        }
        
    } else {
        MBProgressHUD *HUD = [Utils createHUD];
        HUD.labelText = @"没有语音信息可播";
        HUD.mode = MBProgressHUDModeCustomView;
        [HUD hide:YES afterDelay:1];
    }
    
}

#pragma mark - 播放录音时间

- (void)audioPlayTimesStart
{
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(playTimeTick) userInfo:nil repeats:YES];
}

- (void)playTimeTick
{
    //当播放时长等于音频时长时，停止跳动。
    if (playDuration == playTimes) {
        NSLog(@"已播完");
        
        isPlay = NO;
        [_playButton setImage:[UIImage imageNamed:@"voice_play.png"] forState:UIControlStateNormal];
        [_voiceImageView stopAnimating];
        
        
        playTimes = 0;
        [_audioPlayer stop];
        [[AVAudioSession sharedInstance] setActive:NO error:nil];
        
        [timer invalidate];
        return;
    }
    if (!_audioPlayer.isPlaying) {
        return;
    }
    playTimes += 1;
    NSLog(@"playDuration:%d playTimes:%d", playDuration, playTimes);
}

- (void)recordAgain
{
    [_audioPlayer stop];
    [_audioRecorder stop];
    [_audioSession setActive:NO error:nil];
    
    [timer invalidate];
    recordTime = 0;
    playTimes = 0;
}

#pragma mark - 删除录音
- (void)DeleteVoice
{
    _audioSession = [AVAudioSession sharedInstance];
    
    NSLog(@"删除");
    hasVoice = NO;
    //
    [_audioRecorder deleteRecording];
    
    _voiceImageView.hidden = YES;
    _voiceTimes.hidden = YES;
    _timesLabel.text = @"00:00";
}

#pragma mark - 取消发送动弹
- (void)cancelButtonClicked
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 发送语音动弹
- (void)pubTweet
{
    if ([Config getOwnID] == 0) {
        [self.navigationController pushViewController:[LoginViewController new] animated:YES];
        return;
    }
    
    MBProgressHUD *HUD = [Utils createHUD];
    HUD.labelText = @"语音动弹发送中";
    [HUD hide:YES afterDelay:1];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFOnoResponseSerializer XMLResponseSerializer];
    
    [manager POST:[NSString stringWithFormat:@"%@%@", OSCAPI_PREFIX, OSCAPI_TWEET_PUB]
       parameters:@{
                    @"uid": @([Config getOwnID]),
                    @"msg": [Utils convertRichTextToRawText:_edittingArea]
                    }
constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    
    if (_recordingUrl.absoluteString.length) {
        
        NSError *error = nil;
        
        NSString *voicePath = [NSString stringWithFormat:@"%@selfRecord.wav", NSTemporaryDirectory()];
        
        [formData appendPartWithFileURL:[NSURL fileURLWithPath:voicePath isDirectory:NO]
                                   name:@"amr"
                               fileName:@"selfRecord.wav"
                               mimeType:@"audio/mpeg"
                                  error:&error];
        
    }
}
          success:^(AFHTTPRequestOperation *operation, ONOXMLDocument *responseDocument) {
              ONOXMLElement *result = [responseDocument.rootElement firstChildWithTag:@"result"];
              int errorCode = [[[result firstChildWithTag:@"errorCode"] numberValue] intValue];
              NSString *errorMessage = [[result firstChildWithTag:@"errorMessage"] stringValue];
              
              HUD.mode = MBProgressHUDModeCustomView;
              [HUD show:YES];
              
              if (errorCode == 1) {
                  _edittingArea.text = @"";
                  
                  HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-done"]];
                  HUD.labelText = @"语音动弹发表成功";
              } else {
                  HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
                  HUD.labelText = [NSString stringWithFormat:@"错误：%@", errorMessage];
              }
              
              [HUD hide:YES afterDelay:1];
              
              [self dismissViewControllerAnimated:YES completion:nil];
              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              HUD.mode = MBProgressHUDModeCustomView;
              HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
              HUD.labelText = @"网络异常，动弹发送失败";
              
              [HUD hide:YES afterDelay:1];
          }];
    
}

#pragma mark - 取消键盘第一响应者
- (void)keyboardHide
{
    [_edittingArea resignFirstResponder];
}


- (void)textViewDidChange:(PlaceholderTextView *)textView
{
    [textView checkShouldHidePlaceholder];
}


@end
