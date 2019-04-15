//
//  TXForgetPwdController.m
//  TXProject
//
//  Created by Sam on 2019/3/7.
//  Copyright © 2019 sam. All rights reserved.
//

#import "TXForgetPwdController.h"

@interface TXForgetPwdController ()
@property (weak, nonatomic) IBOutlet UIView *popView;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UIView *codeAlertView;
@property (weak, nonatomic) IBOutlet UIImageView *clearIcon;
@property (weak, nonatomic) IBOutlet UILabel *getCodeBtn;

@property (strong,nonatomic) NSTimer *myTimer;
@property (nonatomic) NSInteger resendTime;
@property (nonatomic) BOOL sendCode;
@end

@implementation TXForgetPwdController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.codeAlertView.hidden = YES;
    self.clearIcon.hidden = YES;
    __block TXForgetPwdController *blockSelf = self;
    [[self.codeTF rac_textSignal] subscribeNext:^(id x) {
        blockSelf.clearIcon.hidden = !blockSelf.codeTF.text.length;
    }];
    self.myTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                    target:self
                                                  selector:@selector(timerFire)
                                                  userInfo:nil
                                                   repeats:YES];
    [self.myTimer setFireDate:[NSDate distantFuture]];
    [self.getCodeBtn bk_whenTapped:^{
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:self.phoneTF.text,@"phone_number", nil];
        [HTTPREQUEST_SINGLE postWithURLString:LOGIN_SEND_CODE parameters:dic withHub:YES withCache:NO success:^(NSDictionary *responseDic) {
            if ([responseDic[@"code"] integerValue] == 200) {
                [AlertView showYMAlertView:self.view andtitle:@"验证码发送成功"];
                blockSelf.resendTime = 30;
                blockSelf.sendCode = YES;
                blockSelf.codeAlertView.hidden = NO;
                [blockSelf.myTimer setFireDate:[NSDate distantPast]];
            }else{
                [AlertView showYMAlertView:blockSelf.view andtitle:@"信息错误"];
            }
        } failure:^(NSError *error) {
            ///获取失败
            [AlertView showYMAlertView:self.view andtitle:@"验证码发送失败"];
        }];
    }];
    
}
-(void)timerFire{
    if (self.resendTime <= 0) {
        self.getCodeBtn.text = @"获取验证码";
        self.getCodeBtn.userInteractionEnabled  = YES;
        self.resendTime = 30;
        [self.myTimer setFireDate:[NSDate distantFuture]];
    }else{
        self.getCodeBtn.text = [NSString stringWithFormat:@"%ld秒后重新获取",(long)self.resendTime];
        self.getCodeBtn.userInteractionEnabled = NO;
    }
    self.resendTime --;
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
