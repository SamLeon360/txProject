//
//  TXRegesiterController.m
//  TXProject
//
//  Created by Sam on 2018/12/26.
//  Copyright © 2018年 sam. All rights reserved.
//

#import "TXRegesiterController.h"
#import "JPUSHService.h"
@interface TXRegesiterController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UILabel *alertPhoneLabel;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UILabel *getCodeLabel;
@property (weak, nonatomic) IBOutlet UIButton *regesiterBtn;
@property (strong,nonatomic) NSTimer *myTimer;
@property (nonatomic) NSInteger resendTime;
@property (nonatomic) BOOL sendCode;
@end

@implementation TXRegesiterController

- (void)viewDidLoad {
    [super viewDidLoad];
self.navigationController.navigationBar.titleTextAttributes= @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:18]};
    self.sendCode = NO;
    self.alertPhoneLabel.hidden = YES;
    [self setupView];
    [self setupClickAction];
}
-(void)viewDidLayoutSubviews{
    [self.regesiterBtn makeCorner:self.regesiterBtn.frame.size.height/2];
}
- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setupView{
    [self.regesiterBtn makeCorner:self.regesiterBtn.frame.size.height/2];
    [self.phoneTF setValue:[UIColor colorWithRGB:0x8f9499] forKeyPath:@"_placeholderLabel.textColor"];
    [self.nameTF setValue:[UIColor colorWithRGB:0x8f9499] forKeyPath:@"_placeholderLabel.textColor"];
    [self.passwordTF setValue:[UIColor colorWithRGB:0x8f9499] forKeyPath:@"_placeholderLabel.textColor"];
    [self.codeTF setValue:[UIColor colorWithRGB:0x8f9499] forKeyPath:@"_placeholderLabel.textColor"];
    [self.phoneTF setValue:[UIFont boldSystemFontOfSize:12] forKeyPath:@"_placeholderLabel.font"];
    [self.nameTF setValue:[UIFont boldSystemFontOfSize:12] forKeyPath:@"_placeholderLabel.font"];
    [self.passwordTF setValue:[UIFont boldSystemFontOfSize:12] forKeyPath:@"_placeholderLabel.font"];
    [self.codeTF setValue:[UIFont boldSystemFontOfSize:12] forKeyPath:@"_placeholderLabel.font"];
    
}

-(void)setupClickAction{
    self.myTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                    target:self
                                                  selector:@selector(timerFire)
                                                  userInfo:nil
                                                   repeats:YES];
    [self.myTimer setFireDate:[NSDate distantFuture]];
    __block TXRegesiterController *blockSelf = self;
    [self.getCodeLabel bk_whenTapped:^{
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:self.phoneTF.text,@"phone_number", nil];
        [HTTPREQUEST_SINGLE postWithURLString:LOGIN_SEND_CODE parameters:dic withHub:YES withCache:NO success:^(NSDictionary *responseDic) {
            blockSelf.resendTime = 30;
            blockSelf.sendCode = YES;
            [blockSelf.myTimer setFireDate:[NSDate distantPast]];
        } failure:^(NSError *error) {
            ///获取失败
        }];
    }];
}
- (IBAction)clickToRegister:(id)sender {
    if (self.phoneTF.text.length <= 0) {
        [AlertView showYMAlertView:self.view andtitle:@"请输入手机号码"];
        return;
    }
    if (self.nameTF.text.length <= 0) {
        [AlertView showYMAlertView:self.view andtitle:@"请输入姓名"];
        return;
    }
    if (self.passwordTF.text.length <= 0) {
        [AlertView showYMAlertView:self.view andtitle:@"请输入密码"];
        return;
    }
    if (self.codeTF.text.length <= 0) {
        [AlertView showYMAlertView:self.view andtitle:@"请输入验证码"];
        return;
    }
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:self.phoneTF.text,@"phone_number",self.nameTF.text,@"member_name",self.passwordTF.text,@"password",self.codeTF.text,@"verify_code", nil];
    [HTTPREQUEST_SINGLE postWithURLString:REGISTER_USER parameters:param withHub:YES withCache:NO success:^(NSDictionary *responseDic) {
        NSDictionary *data = responseDic[@"data"];
        if ([responseDic[@"code"] integerValue] == -1002) {
            [AlertView showYMAlertView:self.view andtitle:@"注册成功"];
            [USER_SINGLE setUserDataWithDic:data];
            [JPUSHService setAlias:USER_SINGLE.token completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
                
            } seq:1];
            [self gotoMainView];
        }else{
            [AlertView showYMAlertView:self.view andtitle:@"注册失败"];
        }
    } failure:^(NSError *error) {
        [AlertView showYMAlertView:self.view andtitle:@"网络异常，请检查网络"];
    }];
}

-(void)timerFire{
    if (self.resendTime <= 0) {
        self.getCodeLabel.text = @"获取验证码";
        self.getCodeLabel.userInteractionEnabled  = YES;
        self.resendTime = 30;
        [self.myTimer setFireDate:[NSDate distantFuture]];
    }else{
        self.getCodeLabel.text = [NSString stringWithFormat:@"%ld秒后重新获取",(long)self.resendTime];
        self.getCodeLabel.userInteractionEnabled = NO;
    }
    self.resendTime --;
}
-(void)gotoMainView{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        
        TXMainViewController *mainVC = [[TXMainViewController alloc] init];
        mainVC.tabBar.hidden = NO;
        [mainVC setSelectedIndex:0];
        appDelegate.window.rootViewController = mainVC;
    });
}
@end
