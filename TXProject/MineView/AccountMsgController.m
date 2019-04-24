//
//  AccountMsgController.m
//  TXProject
//
//  Created by Sam on 2019/1/8.
//  Copyright © 2019 sam. All rights reserved.
//

#import "AccountMsgController.h"
#import "ChangePwdController.h"

@interface AccountMsgController ()
    @property (weak, nonatomic) IBOutlet UILabel *phoneNumber;
    @property (weak, nonatomic) IBOutlet UIView *pwdView;
    
@end

@implementation AccountMsgController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.phoneNumber.text = self.userDic[@"member_phone"];
    __block AccountMsgController *blockSelf = self;
    [self.pwdView bk_whenTapped:^{
        ChangePwdController *vc = [[UIStoryboard storyboardWithName:@"MineView" bundle:nil] instantiateViewControllerWithIdentifier:@"ChangePwdController"];
        vc.title = @"修改密码";
        [blockSelf.navigationController pushViewController:vc animated:YES];
    }];
}

@end
