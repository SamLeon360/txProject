//
//  TXLoginController.m
//  TXProject
//
//  Created by Sam on 2018/12/25.
//  Copyright © 2018年 sam. All rights reserved.
//

#import "TXLoginController.h"
#import "TXLoginNoPwdController.h"
#import "AppDelegate.h"
#import "TXMainViewController.h"
#import "YKNavigationController.h"
#import "TXRegesiterController.h"
#import "CommerceList.h"
#import "TXWebViewController.h"
#import "JPUSHService.h"
@interface TXLoginController ()
@property (weak, nonatomic) IBOutlet UITextField *loginNameTF;
@property (weak, nonatomic) IBOutlet UITextField *loginPwdTF;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UILabel *forgetPwdLabel;
@property (weak, nonatomic) IBOutlet UILabel *signinLabel;
@property (weak, nonatomic) IBOutlet UILabel *yinsiLabel;
@property (weak, nonatomic) IBOutlet UILabel *shuomingLabel;
@property (weak, nonatomic) IBOutlet UIButton *connectBtn;

@property (nonatomic) CommerceList *commerceList ;
@end

@implementation TXLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupClickAction];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRGB:0x202c3d];
}
-(void)viewDidLayoutSubviews{
    [self setupView];
}
-(void)setupView{
    [self.loginNameTF setValue:[UIColor colorWithRGB:0x8f9499] forKeyPath:@"_placeholderLabel.textColor"];
    [self.loginPwdTF setValue:[UIColor colorWithRGB:0x8f9499] forKeyPath:@"_placeholderLabel.textColor"];
    [self.loginNameTF setValue:[UIFont boldSystemFontOfSize:12] forKeyPath:@"_placeholderLabel.font"];
    [self.loginPwdTF setValue:[UIFont boldSystemFontOfSize:12] forKeyPath:@"_placeholderLabel.font"];
    [self.loginBtn makeCorner:self.loginBtn.frame.size.height/2];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"如果您登录使用天寻遇到的任何问题点击联系我们提供免费服务"];
    NSRange range1 = [[str string] rangeOfString:@"联系我们"];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRGB:0xFFF000] range:range1]; 
    self.shuomingLabel.attributedText = str;
}
-(void)setupClickAction{
    __block TXLoginController *blockSelf= self;
    [self.forgetPwdLabel bk_whenTapped:^{
        TXLoginNoPwdController *vc = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"TXLoginNoPwdController"];
        [blockSelf.navigationController pushViewController:vc animated:YES];
    }];
    [self.signinLabel bk_whenTapped:^{
        TXRegesiterController *vc = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"TXRegesiterController"];
        [blockSelf.navigationController pushViewController:vc animated:YES];
    }];
    [self.yinsiLabel bk_whenTapped:^{
       
        TXWebViewController *vc = [[UIStoryboard storyboardWithName:@"HomePage" bundle:nil] instantiateViewControllerWithIdentifier:@"TXWebViewController"];
        vc.intype = privacy_policy;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [self.shuomingLabel bk_whenTapped:^{
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"0760-88587021"];
        CGFloat version = [[[UIDevice currentDevice]systemVersion]floatValue];
        if (version >= 10.0) {
            /// 大于等于10.0系统使用此openURL方法
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str] options:@{} completionHandler:nil];
        } else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }
    }];
}
- (IBAction)clickToLogin:(id)sender {
    if (self.loginNameTF.text.length <= 0 ) {
        [AlertView showYMAlertView:self.view andtitle:@"请输入账号"];
        return;
    }
    if (self.loginPwdTF.text.length <= 0) {
        [AlertView showYMAlertView:self.view andtitle:@"请输入密码"];
        return;
    }
    __block TXLoginController *blockSelf = self;
    USER_SINGLE.token = @"";
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:self.loginPwdTF.text,@"password",self.loginNameTF.text,@"user_name",@"1",@"type",@"",@"captcha_key",@"",@"verify_code", nil];
    [HTTPREQUEST_SINGLE postWithURLString:LOGIN_URL parameters:param withHub:YES withCache:NO success:^(NSDictionary *responseDic) {
        NSLog(@"%@",responseDic);
        if ([responseDic[@"code"] integerValue] == 200) {
            NSDictionary *dic = responseDic[@"data"];
            [USER_SINGLE setUserDataWithDic:dic];
            [[NSUserDefaults standardUserDefaults] setObject:dic[@"token"] forKey:@"token"];
            __block TXLoginController *blockblockSelf = blockSelf;
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
                    USER_SINGLE.commerceArray = dataArray;
                
                    if (dataArray.count <= 0) {
                        [blockblockSelf gotoMainView];
                    }else{
                        BOOL commerceIng = NO;
                         NSString *default_commerce_id = [NSString stringWithFormat:@"%@",USER_SINGLE.default_commerce_id];
                        for (NSDictionary *commerceDic in dataArray) {
                            NSString *commerceId = [NSString stringWithFormat:@"%@",commerceDic[@"commerce_id"]];
                            if ([commerceId isEqualToString:default_commerce_id]) {
                                commerceIng = YES;
                                USER_SINGLE.commerceDic = commerceDic;
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
- (IBAction)clickToMainView:(id)sender {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        
        TXMainViewController *mainVC = [[TXMainViewController alloc] init];
        mainVC.tabBar.hidden = NO;
        [mainVC setSelectedIndex:0];
        appDelegate.window.rootViewController = mainVC;
    });
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
-(void)gotoGroundView{
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
