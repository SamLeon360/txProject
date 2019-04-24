//
//  TXFinishMessageController.m
//  TXProject
//
//  Created by Sam on 2019/3/7.
//  Copyright © 2019 sam. All rights reserved.
//

#import "TXFinishMessageController.h"
#import "JPUSHService.h"
@interface TXFinishMessageController ()
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *onePwdTF;
@property (weak, nonatomic) IBOutlet UITextField *twoPwdTF;
@property (weak, nonatomic) IBOutlet UIButton *finishBtn;
@property (weak, nonatomic) IBOutlet UIView *popView;

@end

@implementation TXFinishMessageController
- (IBAction)clickToFinish:(id)sender {
    if (self.nameTF.text.length <= 0) {
        [AlertView showYMAlertView:self.view andtitle:@"请输入姓名"];
        return;
    }
    if (self.onePwdTF.text.length <= 0) {
        [AlertView showYMAlertView:self.view andtitle:@"请输入密码"];
        return;
    }
    if (![self.onePwdTF.text isEqualToString:self.twoPwdTF.text]||self.twoPwdTF.text.length <= 0) {
        [AlertView showYMAlertView:self.view andtitle:@"两次密码不一致"];
    }
   
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:self.phoneNumber,@"phone_number",self.nameTF.text,@"member_name",self.onePwdTF.text,@"password",self.codeString,@"verify_code", nil];
    [HTTPREQUEST_SINGLE postWithURLString:REGISTER_USER parameters:param withHub:YES withCache:NO success:^(NSDictionary *responseDic) {
        NSDictionary *data = responseDic[@"data"];
        if ([responseDic[@"code"] integerValue] == -1002) {
            NSDictionary *param  =  [[NSDictionary alloc] initWithObjectsAndKeys:self.onePwdTF.text,@"password",self.phoneNumber,@"user_name",@"1",@"type",@"",@"captcha_key",@"",@"verify_code", nil];
           
            [HTTPREQUEST_SINGLE postWithURLString:LOGIN_URL parameters:param withHub:YES withCache:NO success:^(NSDictionary *responseDic) {
                NSLog(@"%@",responseDic);
                if ([responseDic[@"code"] integerValue] == 200) {
                    NSDictionary *dic = responseDic[@"data"];
                    [USER_SINGLE setUserDataWithDic:dic];
                    [[NSUserDefaults standardUserDefaults] setObject:dic[@"token"] forKey:@"token"];
                    __block TXFinishMessageController *blockblockSelf = self;
             
                        [AlertView showYMAlertView:self.view andtitle:@"注册成功"];
                        [JPUSHService setAlias:USER_SINGLE.token completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {} seq:1];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [blockblockSelf gotoMainView];
                        });
                }else{
                    NSArray *arr = responseDic[@"message"];
                    NSDictionary *dic = arr.firstObject;
                    [AlertView showYMAlertView:self.view andtitle:dic.allValues.firstObject];
                }
                
                
            } failure:^(NSError *error) {
                [AlertView showYMAlertView:self.view andtitle:@"网络异常，请检查网络"];
            }];
            
          
        }else{
            [AlertView showYMAlertView:self.view andtitle:@"注册失败"];
        }
    } failure:^(NSError *error) {
        [AlertView showYMAlertView:self.view andtitle:@"网络异常，请检查网络"];
    }];
}

-(void)viewDidLayoutSubviews{
    [self.finishBtn makeCorner:self.finishBtn.frame.size.height/2];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.popView bk_whenTapped:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
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
