//
//  TTextView.m
//  UIKit
//
//  Created by kennethmiao on 2018/9/18.
//  Copyright © 2018年 Tencent. All rights reserved.
//

#import "TTextView.h"
#import "TRecordView.h"
#import "THeader.h"
#import "THelper.h"
#import "TUIKit.h"
#import <AVFoundation/AVFoundation.h>

@interface TTextView() <UITextViewDelegate, AVAudioRecorderDelegate>
@property (nonatomic, strong) TRecordView *record;
@property (nonatomic, strong) NSDate *recordStartTime;
@property (nonatomic, strong) AVAudioRecorder *recorder;
@property (nonatomic, strong) NSTimer *recordTimer;
@end

@implementation TTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self setupViews];
        [self defaultLayout];
    }
    return self;
}

- (void)setupViews
{
    self.backgroundColor = TTextView_Background_Color;
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = TTextView_Line_Color;
    [self addSubview:self.lineView];
    
    self.micButton = [[UIButton alloc] init];
    [self.micButton addTarget:self action:@selector(voiceUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [self.micButton setImage:[UIImage imageNamed:@"voice_normal"] forState:UIControlStateNormal];
    [self.micButton setImage:[UIImage imageNamed:@"voice_pressed"] forState:UIControlStateHighlighted];
    self.micButton.hidden = NO;
    [self addSubview:self.micButton];
    
    self.faceButton = [[UIButton alloc] init];
    [self.faceButton addTarget:self action:@selector(faceUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [self.faceButton setImage:[UIImage imageNamed:@"face_normal"] forState:UIControlStateNormal];
    [self.faceButton setImage:[UIImage imageNamed:@"face_pressed"] forState:UIControlStateHighlighted];
    self.faceButton.hidden = YES;
    [self addSubview:self.faceButton];
    
    
    self.keyboardButton = [[UIButton alloc] init];
    [self.keyboardButton addTarget:self action:@selector(keyboardUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [self.keyboardButton setImage:[UIImage imageNamed:@"keyboard_normal"] forState:UIControlStateNormal];
    [self.keyboardButton setImage:[UIImage imageNamed:@"keyboard_pressed"] forState:UIControlStateHighlighted];
    self.keyboardButton.hidden = YES;
    
    [self addSubview:self.keyboardButton];
    
    self.moreButton = [[UIButton alloc] init];
    [self.moreButton addTarget:self action:@selector(moreUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [self.moreButton setImage:[UIImage imageNamed:@"more_normal"] forState:UIControlStateNormal];
    [self.moreButton setImage:[UIImage imageNamed:@"more_pressed"] forState:UIControlStateHighlighted];
    self.moreButton.hidden = NO;
    [self addSubview:self.moreButton];
    
    self.recordButton = [[UIButton alloc] init];
    [self.recordButton.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [self.recordButton.layer setMasksToBounds:YES];
    [self.recordButton.layer setCornerRadius:4.0f];
    [self.recordButton.layer setBorderWidth:0.5f];
    [_recordButton.layer setBorderColor:TTextView_Line_Color.CGColor];
    [_recordButton addTarget:self action:@selector(talkDown:) forControlEvents:UIControlEventTouchDown];
    [_recordButton addTarget:self action:@selector(talkUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [_recordButton addTarget:self action:@selector(talkCancel:) forControlEvents:UIControlEventTouchUpOutside | UIControlEventTouchCancel];
    [_recordButton addTarget:self action:@selector(talkExit:) forControlEvents:UIControlEventTouchDragExit];
    [_recordButton addTarget:self action:@selector(talkEnter:) forControlEvents:UIControlEventTouchDragEnter];
    [_recordButton setTitle:@"按住说话" forState:UIControlStateNormal];
    [_recordButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _recordButton.hidden = NO;
    [self addSubview:_recordButton];
    
    _inputTextView = [[TResponderTextView alloc] init];
    _inputTextView.delegate = self;
    [_inputTextView setFont:[UIFont systemFontOfSize:16]];
    [_inputTextView.layer setMasksToBounds:YES];
    [_inputTextView.layer setCornerRadius:4.0f];
    [_inputTextView.layer setBorderWidth:0.5f];
    [_inputTextView.layer setBorderColor:TTextView_Line_Color.CGColor];
    _inputTextView.userInteractionEnabled  = YES;
    [_inputTextView setReturnKeyType:UIReturnKeySend];
   
    [self addSubview:_inputTextView];
    
}

- (void)defaultLayout
{
    _lineView.frame = CGRectMake(0, 0, Screen_Width, TTextView_Line_Height);
    CGSize buttonSize = TTextView_Button_Size;
    CGFloat buttonOriginY = (TTextView_Height - buttonSize.height) * 0.5;
    _micButton.frame = CGRectMake(TTextView_Margin, buttonOriginY, buttonSize.width, buttonSize.height);
    _keyboardButton.frame = _micButton.frame;
    _moreButton.frame = CGRectMake(Screen_Width - buttonSize.width - TTextView_Margin, buttonOriginY, buttonSize.width, buttonSize.height);
    _faceButton.frame = CGRectMake(_moreButton.frame.origin.x - buttonSize.width - TTextView_Margin, buttonOriginY, buttonSize.width, buttonSize.height);
    
    CGFloat beginX = _micButton.frame.origin.x + _micButton.frame.size.width + TTextView_Margin;
    CGFloat endX = _faceButton.frame.origin.x - TTextView_Margin;
    _recordButton.frame = CGRectMake(beginX, (TTextView_Height - TTextView_TextView_Height_Min) * 0.5, endX - beginX, TTextView_TextView_Height_Min);
    _inputTextView.frame = _recordButton.frame;
}

- (void)layoutButton:(CGFloat)height
{
    CGRect frame = self.frame;
    CGFloat offset = height - frame.size.height;
    frame.size.height = height;
    self.frame = frame;
    
    CGSize buttonSize = TTextView_Button_Size;
    CGFloat bottomMargin = (TTextView_Height - buttonSize.height) * 0.5;
    CGFloat originY = frame.size.height - buttonSize.height - bottomMargin;
    
    CGRect faceFrame = _faceButton.frame;
    faceFrame.origin.y = originY;
    _faceButton.frame = faceFrame;
    
    CGRect moreFrame = _moreButton.frame;
    moreFrame.origin.y = originY;
    _moreButton.frame = moreFrame;
    
    CGRect voiceFrame = _micButton.frame;
    voiceFrame.origin.y = originY;
    _micButton.frame = voiceFrame;
    
    CGRect keyboardFrame = _keyboardButton.frame;
    keyboardFrame.origin.y = originY;
    _keyboardButton.frame = keyboardFrame;
    
    if(_delegate && [_delegate respondsToSelector:@selector(textView:didChangeInputHeight:)]){
        [_delegate textView:self didChangeInputHeight:offset];
    }
}

- (void)customLayout
{
}

- (void)voiceUpInside:(UIButton *)sender
{
    _recordButton.hidden = NO;
    _inputTextView.hidden = YES;
    _micButton.hidden = YES;
    _keyboardButton.hidden = NO;
    [_inputTextView resignFirstResponder];
    [self layoutButton:TTextView_Height];
    if(_delegate && [_delegate respondsToSelector:@selector(textViewDidTouchMore:)]){
        [_delegate textViewDidTouchVoice:self];
    }
}

- (void)keyboardUpInside:(UIButton *)sender
{
    _micButton.hidden = NO;
    _keyboardButton.hidden = YES;
    _recordButton.hidden = YES;
    _inputTextView.hidden = NO;
    [self layoutButton:_inputTextView.frame.size.height + 2 * TTextView_Margin];
    [_inputTextView becomeFirstResponder];
    
}

- (void)faceUpInside:(UIButton *)sender
{
    _micButton.hidden = NO;
    _keyboardButton.hidden = YES;
    _recordButton.hidden = YES;
    _inputTextView.hidden = NO;
    if(_delegate && [_delegate respondsToSelector:@selector(textViewDidTouchFace:)]){
        [_delegate textViewDidTouchFace:self];
    }
}

- (void)moreUpInside:(UIButton *)sender
{
    if(_delegate && [_delegate respondsToSelector:@selector(textViewDidTouchMore:)]){
        [_delegate textViewDidTouchMore:self];
    }
}

- (void)talkDown:(UIButton *)sender
{
    if(!_record){
        _record = [[TRecordView alloc] init];
        _record.frame = [UIScreen mainScreen].bounds;
    }
    [self.window addSubview:_record];
    _recordStartTime = [NSDate date];
    [_record setStatus:Record_Status_Recording];
    _recordButton.backgroundColor = [UIColor lightGrayColor];
    [_recordButton setTitle:@"松开结束" forState:UIControlStateNormal];
    [self startRecord];
}

- (void)talkUpInside:(UIButton *)sender
{
    _recordButton.backgroundColor = [UIColor clearColor];
    [_recordButton setTitle:@"按住说话" forState:UIControlStateNormal];
    NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:_recordStartTime];
    if(interval < 1 || interval > 60){
        if(interval < 1){
            [_record setStatus:Record_Status_TooShort];
        }
        else{
            [_record setStatus:Record_Status_TooLong];
        }
        [self cancelRecord];
        __weak typeof(self) ws = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [ws.record removeFromSuperview];
        });
    }
    else{
        [_record removeFromSuperview];
        NSString *path = [self stopRecord];
        if(_delegate && [_delegate respondsToSelector:@selector(textView:didSendVoice:)]){
            [_delegate textView:self didSendVoice:path];
        }
    }
}

- (void)talkCancel:(UIButton *)sender
{
    [_record removeFromSuperview];
    _recordButton.backgroundColor = [UIColor clearColor];
    [_recordButton setTitle:@"按住说话" forState:UIControlStateNormal];
    [self cancelRecord];
}

- (void)talkExit:(UIButton *)sender
{
    [_record setStatus:Record_Status_Cancel];
    [_recordButton setTitle:@"上拉取消" forState:UIControlStateNormal];
}

- (void)talkEnter:(UIButton *)sender
{
    [_record setStatus:Record_Status_Recording];
    [_recordButton setTitle:@"松开结束" forState:UIControlStateNormal];
}

- (void)textViewDidChange:(UITextView *)textView
{
    CGSize size = [_inputTextView sizeThatFits:CGSizeMake(_inputTextView.frame.size.width, TTextView_TextView_Height_Max)];
    CGFloat oldHeight = _inputTextView.frame.size.height;
    CGFloat newHeight = size.height;
    
    if(newHeight > TTextView_TextView_Height_Max){
        newHeight = TTextView_TextView_Height_Max;
    }
    if(newHeight < TTextView_TextView_Height_Min){
        newHeight = TTextView_TextView_Height_Min;
    }
    if(oldHeight == newHeight){
        return;
    }

    __weak typeof(self) ws = self;
    [UIView animateWithDuration:0.3 animations:^{
        CGRect textFrame = ws.inputTextView.frame;
        textFrame.size.height += newHeight - oldHeight;
        ws.inputTextView.frame = textFrame;
        [ws layoutButton:newHeight + 2 * TTextView_Margin];
    }];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"]){
        if(_delegate && [_delegate respondsToSelector:@selector(textView:didSendMessage:)]){
            if(![textView.text isEqualToString:@""]){
                [_delegate textView:self didSendMessage:textView.text];
                [self clearInput];
            }
        }
        return NO;
    }
    else if (textView.text.length > 0 && [text isEqualToString:@""]) {
        if ([textView.text characterAtIndex:range.location] == ']') {
            NSUInteger location = range.location;
            NSUInteger length = range.length;
            while (location != 0) {
                location --;
                length ++ ;
                char c = [textView.text characterAtIndex:location];
                if (c == '[') {
                    textView.text = [textView.text stringByReplacingCharactersInRange:NSMakeRange(location, length) withString:@""];
                    return NO;
                }
                else if (c == ']') {
                    return YES;
                }
            }
        }
        else{
            textView.text = [textView.text stringByReplacingCharactersInRange:range withString:@""];
            return NO;
        }
    }
    return YES;
}

- (void)clearInput
{
    _inputTextView.text = @"";
    [self textViewDidChange:_inputTextView];
}

- (NSString *)getInput
{
    return _inputTextView.text;
}

- (void)addEmoji:(NSString *)emoji
{
    [_inputTextView setText:[_inputTextView.text stringByAppendingString:emoji]];
    if(_inputTextView.contentSize.height > TTextView_TextView_Height_Max){
        float offset = _inputTextView.contentSize.height - _inputTextView.frame.size.height;
        [_inputTextView scrollRectToVisible:CGRectMake(0, offset, _inputTextView.frame.size.width, _inputTextView.frame.size.height) animated:YES];
    }
    [self textViewDidChange:_inputTextView];
}

- (void)backDelete
{
    [self textView:_inputTextView shouldChangeTextInRange:NSMakeRange(_inputTextView.text.length - 1, 1) replacementText:@""];
    [self textViewDidChange:_inputTextView];
}

- (void)startRecord
{
//    AVAudioSession *session = [AVAudioSession sharedInstance];
//    NSError *error = nil;
//    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
//    [session setActive:YES error:&error];
//
//    //设置参数
//    NSDictionary *recordSetting = [[NSDictionary alloc] initWithObjectsAndKeys:
//                                   //采样率  8000/11025/22050/44100/96000（影响音频的质量）
//                                   [NSNumber numberWithFloat: 8000.0],AVSampleRateKey,
//                                   // 音频格式
//                                   [NSNumber numberWithInt: kAudioFormatLinearPCM],AVFormatIDKey,
//                                   //采样位数  8、16、24、32 默认为16
//                                   [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,
//                                   // 音频通道数 1 或 2
//                                   [NSNumber numberWithInt: 1], AVNumberOfChannelsKey,
//                                   //录音质量
//                                   [NSNumber numberWithInt:AVAudioQualityHigh],AVEncoderAudioQualityKey,
//                                   nil];
//
    NSString *path = [TUIKit_Voice_Path stringByAppendingString:[THelper genVoiceName:nil withExtension:@"wav"]];
    NSURL *url = [NSURL fileURLWithPath:path];
//    _recorder = [[AVAudioRecorder alloc] initWithURL:url settings:recordSetting error:nil];
//    _recorder.meteringEnabled = YES;
//    [_recorder prepareToRecord];
//    [_recorder record];
//    [_recorder updateMeters];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error: nil];
    NSMutableDictionary *recordSettings = [[NSMutableDictionary alloc] init];
    [recordSettings setValue :[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey: AVFormatIDKey];
    [recordSettings setValue :[NSNumber numberWithFloat:11025.0] forKey: AVSampleRateKey];
 
    [recordSettings setValue :[NSNumber numberWithInt:1] forKey: AVNumberOfChannelsKey];
    [recordSettings setValue:[NSNumber numberWithInt:AVAudioQualityMin] forKey:AVEncoderAudioQualityKey];
    _recorder.meteringEnabled = YES;
    
    _recorder = [[AVAudioRecorder alloc] initWithURL:url settings:recordSettings error:nil];
    
    [_recorder prepareToRecord];
    [_recorder record];
    [_recorder updateMeters];
    _recordTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(recordTick:) userInfo:nil repeats:YES];
}

- (void)recordTick:(NSTimer *)timer{
    [_recorder updateMeters];
    float power = [_recorder averagePowerForChannel:1];
    [_record setPower:power];
}


- (NSString *)stopRecord
{
    if(_recordTimer){
        [_recordTimer invalidate];
        _recordTimer = nil;
    }
    if([_recorder isRecording]){
        [_recorder stop];
    }
    NSString *wavPath = _recorder.url.path;
//    NSString *amrpath = [[wavPath stringByDeletingPathExtension] stringByAppendingString:@".amr"];
//    [THelper convertWav:wavPath toAmr:amrpath];
//    [[NSFileManager defaultManager] removeItemAtPath:wavPath error:nil];
    return wavPath;
}

- (void)cancelRecord
{
    if(_recordTimer){
        [_recordTimer invalidate];
        _recordTimer = nil;
    }
    if([_recorder isRecording]){
        [_recorder stop];
    }
    NSString *path = _recorder.url.path;
    if([[NSFileManager defaultManager] fileExistsAtPath:path]){
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
}
@end
