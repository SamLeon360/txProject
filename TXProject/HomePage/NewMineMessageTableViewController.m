//
//  NewMineMessageTableViewController.m
//  TXProject
//
//  Created by Sam on 2019/2/18.
//  Copyright © 2019 sam. All rights reserved.
//

#import "NewMineMessageTableViewController.h"
#import "MineCommerceController.h"
#import "AccountMsgController.h"
#import "LogoutViewController.h"
#import "EditUserDataController.h"
#import "MineCompanyListController.h"
#import "MemberDetailController.h"
#import "FriendListController.h"
#import "NotifyListController.h"
@interface NewMineMessageTableViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *userHeaderIamge;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *msgLabel;
@property (weak, nonatomic) IBOutlet UILabel *activeLabel;
@property (weak, nonatomic) IBOutlet UILabel *friendLabel;
@property (weak, nonatomic) IBOutlet UILabel *commerceName;
@property (weak, nonatomic) IBOutlet UITableViewCell *companyCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *accountCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *memberCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *softCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *useCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *commerceCell;
@property (weak, nonatomic) IBOutlet UIView *notifyView;
@property (weak, nonatomic) IBOutlet UIView *friendView;
@property (nonatomic) NSDictionary *userDic;
@property (nonatomic) NSArray *commerceArray;
@end

@implementation NewMineMessageTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRGB:0x3e85fb];
    self.navigationController.navigationBar.titleTextAttributes= @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:18]};
    self.navigationItem.title = @"个人中心";
    [self getFriendNumber];
    [self  getMineMessage];
    [self.commerceCell bk_whenTapped:^{
        if (self.commerceArray.count > 0) {
            MineCommerceController *vc = [[UIStoryboard storyboardWithName:@"MineView" bundle:nil] instantiateViewControllerWithIdentifier:@"MineCommerceController"];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
    __block NewMineMessageTableViewController *blockSelf = self;
    [self.accountCell bk_whenTapped:^{
        AccountMsgController *vc = [[UIStoryboard storyboardWithName:@"MineView" bundle:nil] instantiateViewControllerWithIdentifier:@"AccountMsgController"];
        vc.userDic = blockSelf.userDic;
        [blockSelf.navigationController pushViewController:vc animated:YES];
    }];
    [self.memberCell bk_whenTapped:^{
        EditUserDataController *vc = [[UIStoryboard storyboardWithName:@"MineView" bundle:nil] instantiateViewControllerWithIdentifier:@"EditUserDataController"];
        vc.userDic = blockSelf.userDic;
        [blockSelf.navigationController pushViewController:vc animated:YES];
    }];
    [self.softCell bk_whenTapped:^{
        LogoutViewController *vc = [[UIStoryboard storyboardWithName:@"MineView" bundle:nil] instantiateViewControllerWithIdentifier:@"LogoutViewController"];
        [blockSelf.navigationController pushViewController:vc animated:YES];
    }];
    [self.companyCell bk_whenTapped:^{
        MineCompanyListController *vc = [[UIStoryboard storyboardWithName:@"CompanyView" bundle:nil] instantiateViewControllerWithIdentifier:@"MineCompanyListController"];
        vc.memberId = blockSelf.userDic[@"member_id"];
        [blockSelf.navigationController pushViewController:vc animated:YES];
    }];
    [self.friendView bk_whenTapped:^{
        FriendListController *vc = [[UIStoryboard storyboardWithName:@"MineView" bundle:nil] instantiateViewControllerWithIdentifier:@"FriendListController"];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [self.notifyView bk_whenTapped:^{
        NotifyListController *vc = [[UIStoryboard storyboardWithName:@"Entrepreneurial" bundle:nil] instantiateViewControllerWithIdentifier:@"NotifyListController"];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
}


-(void)getFriendNumber{
    [HTTPREQUEST_SINGLE shitPostWithURLString:SH_FRIEND_NUMBER parameters:nil withHub:YES withCache:NO success:^(NSDictionary *responseDic) {
        
        if ([responseDic[@"code"] integerValue] == 3) {
            self.friendLabel.text = [NSString stringWithFormat:@"%@",responseDic[@"data"][@"friends_count"]];
            self.msgLabel.text = [NSString stringWithFormat:@"%@",responseDic[@"data"][@"moment_count"]];
//            [self.myTableView reloadData];
        }else if([responseDic[@"code"] integerValue] == -1001){
            [USER_SINGLE logout];
        }
        
    } failure:^(NSError *error) {
        
    }];
}
-(void)getMineMessage{
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:USER_SINGLE.member_id,@"member_id", nil];
    [HTTPREQUEST_SINGLE postWithURLStringHeaderAndBody:SH_MINE_MESSAGE headerParameters:nil bodyParameters:params withHub:YES withCache:NO success:^(NSDictionary *responseDic) {
        NSDictionary *dic = responseDic;
        if ([responseDic[@"code"] integerValue] == 0) {
            self.userDic = dic[@"data"];
            USER_SINGLE.member_name = self.userDic[@"member_name"];
            USER_SINGLE.member_id = [NSString stringWithFormat:@"%@",self.userDic[@"member_id"]];
            self.userNameLabel.text = self.userDic[@"member_name"];
           self.userTypeLabel.text = [self.userDic[@"role_type"] integerValue] == 1?@"秘书处":@"会员";
            [self.userHeaderIamge sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",AVATAR_HOST_URL,self.userDic[@"member_avatar"]]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if (error) {
                    [self.userHeaderIamge setImage:[UIImage imageNamed:@"default_avatar"]];
                }
            }];
            [self getCommerceMessage];
//            [self.myTableView reloadData];
        }else if([responseDic[@"code"] integerValue] == -1001){
            [USER_SINGLE logout];
        }
    } failure:^(NSError *error) {
        
    }];
    
}
-(void)getCommerceMessage{
    [HTTPREQUEST_SINGLE shitPostWithURLString:SH_COMMERCE_ARRAY parameters:nil withHub:YES withCache:NO success:^(NSDictionary *responseDic) {
        NSDictionary *dic = responseDic;
        if ([responseDic[@"code"] integerValue] == 0) {
            self.commerceArray = dic[@"data"];
            if (USER_SINGLE.default_commerce_name == nil) {
                if (self.commerceArray.count <= 0) {
                    self.commerceName.text = @"请先申请加入社团";
                }else{
                    NSDictionary *dic = self.commerceArray.firstObject;
                    self.commerceName.text = dic[@"commerce_name"];
                }
            }else{
                self.commerceName.text = USER_SINGLE.default_commerce_name;
            }
//            [self.myTableView reloadData];
        }else if([responseDic[@"code"] integerValue] == -1001){
            [USER_SINGLE logout];
        }
        
    } failure:^(NSError *error) {
        
    }];
}
@end
