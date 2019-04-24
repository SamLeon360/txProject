//
//  ChangePwdController.m
//  TXProject
//
//  Created by Sam on 2019/1/8.
//  Copyright © 2019 sam. All rights reserved.
//

#import "ChangePwdController.h"

@interface ChangePwdController ()
@property (weak, nonatomic) IBOutlet UITextField *onePwdTF;
@property (weak, nonatomic) IBOutlet UITextField *twoPwdTF;

@end

@implementation ChangePwdController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (IBAction)clickToSubmitPwd:(id)sender {
    [HTTPREQUEST_SINGLE postWithURLString:ACCOUT_CHANGE_PWD parameters:@{@"password":self.onePwdTF.text} withHub:YES withCache:NO success:^(NSDictionary *responseDic) {
        if ([responseDic[@"code"] integerValue] == 3) {
            [AlertView showYMAlertView:self.view andtitle:@"修改密码成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSError *error) {
        
    }];
}


@end
