//
//  NewTXLoginController.m
//  TXProject
//
//  Created by Sam on 2019/3/7.
//  Copyright © 2019 sam. All rights reserved.
//

#import "NewTXLoginController.h"
#import "TXLoginNoPwdController.h"
#import "AppDelegate.h"
#import "TXMainViewController.h"
#import "YKNavigationController.h"
#import "TXRegesiterController.h"
#import "CommerceList.h"
#import "TXWebViewController.h"
#import "JPUSHService.h"
#import "TXFinishMessageController.h"
@interface NewTXLoginController ()
@property (weak, nonatomic) IBOutlet UIButton *popView;
@property (weak, nonatomic) IBOutlet UITextField *accountTF;
@property (weak, nonatomic) IBOutlet UITextField *pwdTF;
@property (weak, nonatomic) IBOutlet UIImageView *pwdIcon;
@property (weak, nonatomic) IBOutlet UIImageView *clearIcon;
@property (weak, nonatomic) IBOutlet UILabel *getCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *changeTypeBtn;
@property (weak, nonatomic) IBOutlet UIView *codeAlertView;
@property (nonatomic) NSInteger isRegister;
@property (strong,nonatomic) NSTimer *myTimer;
@property (nonatomic) NSInteger resendTime;
@property (nonatomic) BOOL sendCode;
@property (nonatomic) NSString *verifycode;
@property (nonatomic) CommerceList *commerceList ;
@property (weak, nonatomic) IBOutlet UILabel *proviceLabel;

@end

@implementation NewTXLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    __block NewTXLoginController *blockSelf = self;
    [[self.pwdTF rac_textSignal] subscribeNext:^(id x) {
        blockSelf.clearIcon.hidden = !blockSelf.pwdTF.text.length;
    }];
    [self.clearIcon bk_whenTapped:^{
        blockSelf.pwdTF.text = @"";
    }];
    [self.navigationController setNavigationBarHidden:YES];
    self.codeAlertView.hidden = YES;
    self.clearIcon.hidden = YES;
    self.sendCode = NO;
    [self setupClickAction];
}
-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
-(void)setupClickAction{
    
    self.myTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                    target:self
                                                  selector:@selector(timerFire)
                                                  userInfo:nil
                                                   repeats:YES];
    [self.myTimer setFireDate:[NSDate distantFuture]];
    __block NewTXLoginController *blockSelf = self;
    [self.getCodeBtn bk_whenTapped:^{
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:self.accountTF.text,@"phone_number", nil];
        [HTTPREQUEST_SINGLE postWithURLString:LOGIN_SEND_CODE parameters:dic withHub:YES withCache:NO success:^(NSDictionary *responseDic) {
            if ([responseDic[@"code"] integerValue] == 200) {
                [AlertView showYMAlertView:self.view andtitle:@"验证码发送 成功"];
                blockSelf.isRegister = [responseDic[@"data"][@"register"] integerValue];
                blockSelf.resendTime = 30;
                blockSelf.sendCode = YES;
                blockSelf.codeAlertView.hidden = NO;
                blockSelf.verifycode = responseDic[@"data"][@"verify_code"];
                [blockSelf.myTimer setFireDate:[NSDate distantPast]];
            }else{
                [AlertView showYMAlertView:blockSelf.view andtitle:@"信息错误"];
            }
        } failure:^(NSError *error) {
            ///获取失败
            [AlertView showYMAlertView:self.view andtitle:@"验证码发送失败"];
        }];
    }];
    [self.changeTypeBtn bk_whenTapped:^{
        if (blockSelf.changeTypeBtn.tag == 1) {
            [blockSelf.changeTypeBtn setTitle:@"短信验证码登录" forState:UIControlStateNormal];
            [blockSelf.pwdIcon setImage:[UIImage imageNamed:@"pwd_close_eyes"]];
            [blockSelf.getCodeBtn setBackgroundColor:[UIColor whiteColor]];
            blockSelf.getCodeBtn.textColor = [UIColor colorWithRGB:0x4a494b];
            blockSelf.getCodeBtn.text = @"忘记密码";
            blockSelf.getCodeBtn.hidden = YES;
            blockSelf.pwdIcon.tag = 1;
            blockSelf.pwdTF.placeholder = @"请输入密码";
            blockSelf.changeTypeBtn.tag = 2;
            blockSelf.isRegister = 1;
            [blockSelf.loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        }else{
            [blockSelf.pwdIcon setImage:[UIImage imageNamed:@"login_pwd_icon"]];
            [blockSelf.getCodeBtn setBackgroundColor:[UIColor colorWithRGB:0xEFEFEF]];
            blockSelf.getCodeBtn.textColor = [UIColor colorWithRGB:0x3F78BC];
            blockSelf.getCodeBtn.hidden = NO;
            blockSelf.getCodeBtn.text = @"获取验证码";
            blockSelf.pwdTF.placeholder = @"请输入验证码";
            blockSelf.pwdIcon.tag = 3;
            blockSelf.changeTypeBtn.tag = 1;
            blockSelf.isRegister = 0;
            [blockSelf.loginBtn setTitle:@"登录/新用户注册" forState:UIControlStateNormal];
        }
    }];
    [self.pwdIcon bk_whenTapped:^{
        if (blockSelf.pwdIcon.tag == 3) {
            return ;
        }
        if (blockSelf.pwdIcon.tag == 1) {
            blockSelf.pwdTF.secureTextEntry = YES;
            [blockSelf.pwdIcon setImage:[UIImage imageNamed:@"pwd_open_eyes"]];
            blockSelf.pwdIcon.tag = 2;
        }else{
            blockSelf.pwdIcon.tag = 1;
            blockSelf.pwdTF.secureTextEntry = NO;
            [blockSelf.pwdIcon setImage:[UIImage imageNamed:@"pwd_close_eyes"]];
        }
    }];
    [self.popView bk_whenTapped:^{
        [self gotoMainView];
    }];
    [self.proviceLabel bk_whenTapped:^{
        TXWebViewController *vc = [[UIStoryboard storyboardWithName:@"HomePage" bundle:nil] instantiateViewControllerWithIdentifier:@"TXWebViewController"];
        vc.intype = privacy_policy;
        [self.navigationController pushViewController:vc animated:YES];
    }];
}
- (IBAction)clickToLogin:(id)sender {
    if (self.accountTF.text.length <= 0 ) {
        [AlertView showYMAlertView:self.view andtitle:@"请输入账号"];
        return;
    }
    if (self.pwdTF.text.length <= 0&&self.changeTypeBtn.tag == 2) {
        [AlertView showYMAlertView:self.view andtitle:@"请输入验证码"];
        return;
    }
    
    if (self.pwdTF.text.length <= 0&&self.changeTypeBtn.tag == 1 ) {
        [AlertView showYMAlertView:self.view andtitle:@"请输入密码"];
        return;
    }
    
    
    if (![self.pwdTF.text isEqualToString:self.verifycode]&&self.changeTypeBtn.tag == 1&&self.isRegister == 0 ) {
        [AlertView showYMAlertView:self.view andtitle:@"请输入正确的验证码"];
        return;
    }
    if (self.isRegister == 0 ) {
        TXFinishMessageController *vc = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"TXFinishMessageController"];
        vc.phoneNumber = self.accountTF.text;
        vc.codeString = self.pwdTF.text;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    
    
    __block NewTXLoginController *blockSelf = self;
    USER_SINGLE.token = @"";
    NSDictionary *param ;
    if (self.changeTypeBtn.tag == 1) {
        param  =  [[NSDictionary alloc] initWithObjectsAndKeys:@"",@"password",self.accountTF.text,@"user_name",@"2",@"type",@"",@"captcha_key",self.pwdTF.text,@"verify_code", nil];
    }else{
        param =  [[NSDictionary alloc] initWithObjectsAndKeys:self.pwdTF.text,@"password",self.accountTF.text,@"user_name",@"1",@"type",@"",@"captcha_key",@"",@"verify_code", nil];
    }
    [HTTPREQUEST_SINGLE postWithURLString:LOGIN_URL parameters:param withHub:YES withCache:NO success:^(NSDictionary *responseDic) {
        NSLog(@"%@",responseDic);
        if ([responseDic[@"code"] integerValue] == 200) {
            NSDictionary *dic = responseDic[@"data"];
            [USER_SINGLE setUserDataWithDic:dic];
            USER_SINGLE.phone = self.accountTF.text;
            [[NSUserDefaults standardUserDefaults] setObject:dic[@"token"] forKey:@"token"];
            __block NewTXLoginController *blockblockSelf = blockSelf;
            NSString *default_commerce_id = [NSString stringWithFormat:@"%@",USER_SINGLE.default_commerce_id];
            if ([default_commerce_id isEqualToString:@""]) {
                
                [AlertView showYMAlertView:self.view andtitle:@"登录成功"];
                [JPUSHService setAlias:USER_SINGLE.token completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
                    
                } seq:1];
                [blockSelf gotoMainView];
            }else{
                NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:USER_SINGLE.exp,@"exp",USER_SINGLE.member_id,@"member_id",USER_SINGLE.role_type,@"role_type",USER_SINGLE.default_commerce_id,@"default_commerce_id",USER_SINGLE.default_role_type,@"default_role_type",USER_SINGLE.TokenFrom,@"TokenFrom", nil];
                [HTTPREQUEST_SINGLE shitPostWithURLString:COMMERCE_LIST parameters:param withHub:YES withCache:NO success:^(NSDictionary *responseDic) {
                    NSArray *dataArray = responseDic[@"data"];
                    NSMutableArray *newCommerceArray = [NSMutableArray arrayWithCapacity:0];
                    for (NSDictionary *dic in dataArray) {
                        NSMutableDictionary *newDic = [NSMutableDictionary dictionaryWithCapacity:0];
                        [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                            if ([obj isKindOfClass:[NSNull class]]) {
                                [newDic setObject:@"" forKey:key];
                            }else{
                                [newDic setObject:obj forKey:key];
                            }
                        }];
                        [newCommerceArray addObject:newDic];
                    }
                    
                    USER_SINGLE.commerceArray = newCommerceArray;
                    
                    if (dataArray.count <= 0) {
                        [blockblockSelf gotoMainView];
                    }else{
                        BOOL commerceIng = NO;
                        NSString *default_commerce_id = [NSString stringWithFormat:@"%@",USER_SINGLE.default_commerce_id];
                        for (NSDictionary *commerceDic in dataArray) {
                            NSString *commerceId = [NSString stringWithFormat:@"%@",commerceDic[@"commerce_id"]];
                            if ([commerceId isEqualToString:default_commerce_id]) {
                                commerceIng = YES;
                                NSMutableDictionary *newCommerceObj = [NSMutableDictionary dictionaryWithCapacity:0];
                                [commerceDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                                    if ([obj isKindOfClass:[NSNull class]]) {
                                        [newCommerceObj setObject:@"" forKey:key];
                                    }else{
                                        [newCommerceObj setObject:obj forKey:key];
                                    }
                                }];
                                USER_SINGLE.commerceDic = newCommerceObj;
                                break;
                            }
                        }
                        if (!commerceIng) {
                            [blockblockSelf showCommerceListView:dataArray];
                        }else{
                            [blockblockSelf gotoMainView];
                        }
                        
                    }
                    
                } failure:^(NSError *error) {
                    [AlertView showYMAlertView:self.view andtitle:@"网络异常，请检查网络"];
                }];
                
            }
            
        }else{
            [AlertView showYMAlertView:self.view andtitle:responseDic[@"message"]];
        }
        
        
    } failure:^(NSError *error) {
        [AlertView showYMAlertView:self.view andtitle:@"网络异常，请检查网络"];
    }];
}

-(void)viewDidLayoutSubviews{
    [self.loginBtn makeCorner:self.loginBtn.frame.size.height/2];
    [self.getCodeBtn makeCorner:self.getCodeBtn.frame.size.height/2];
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
-(void)gotoMainView{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        TXMainViewController *mainVC = [[TXMainViewController alloc] init];
        mainVC.tabBar.hidden = NO;
        [mainVC setSelectedIndex:0];
        appDelegate.window.rootViewController = mainVC;
    });
}
-(void)showCommerceListView:(NSArray *)commerceArray{
    self.commerceList = [[NSBundle mainBundle] loadNibNamed:@"CommerceList" owner:self options:nil][0];
    
    [self.commerceList setCommerceArray:commerceArray];
    if (commerceArray.count <= 3) {
        self.commerceList.frame =  CGRectMake(0, 0, 261, 45 * commerceArray.count + 40);
    }else{
        self.commerceList.frame =  CGRectMake(0, 0, 261, 45 * 3 + 40);
    }
    self.commerceList.center = self.view.center;
    [self.view addSubview:self.commerceList];
}
@end
