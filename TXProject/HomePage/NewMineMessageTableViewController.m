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
#import "MyGuideController.h"
#import "UploadCommerceControllerController.h"
#import "SearchCommerceController.h"
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
@property (weak, nonatomic) IBOutlet UILabel *introLabel;
@property (weak, nonatomic) IBOutlet UITableViewCell *commerceCell;
@property (weak, nonatomic) IBOutlet UIView *notifyView;
@property (weak, nonatomic) IBOutlet UIView *friendView;
@property (nonatomic) NSDictionary *userDic;
@property (nonatomic) NSArray *commerceArray;
@property (nonatomic) CommerceAlertView *comAlertView;
@property (nonatomic) NSArray *commerceJobArray;
@end

@implementation NewMineMessageTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRGB:0x3e85fb];
    self.navigationController.navigationBar.titleTextAttributes= @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:18]};
    self.navigationItem.title = @"个人中心";
    self.commerceJobArray = @[ @"会长",@"执行会长",@"常务副会长",@"副会长",@"常务理事",@"理事",@"监事长",@"副监事长",@"监事",@"名誉会长",@"荣誉会长",@"创会会长",@"顾问",@"秘书长",@"执行秘书长",@"专职秘书长",@"副秘书长",@"干事",@"办公室主任",@"文员",@"部长",@"会员",@"创会会长"];
    [self getDataNetWork];
    NOTIFY_ADD(getDataNetWork, @"getDataNetWork");//
    NOTIFY_ADD(getNewMeMessage, @"getNewMeMessage");
    NOTIFY_ADD(getCommerceMessage, @"getCommerceMessage");
    [self.commerceCell bk_whenTapped:^{
        if (self.commerceArray.count > 0) {
            MineCommerceController *vc = [[UIStoryboard storyboardWithName:@"MineView" bundle:nil] instantiateViewControllerWithIdentifier:@"MineCommerceController"];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [[UIApplication sharedApplication].keyWindow addSubview:self.comAlertView];
        }
    }];
    __block NewMineMessageTableViewController *blockSelf = self;
    [self.accountCell bk_whenTapped:^{
        AccountMsgController *vc = [[UIStoryboard storyboardWithName:@"MineView" bundle:nil] instantiateViewControllerWithIdentifier:@"AccountMsgController"];
        vc.userDic = blockSelf.userDic;
        vc.title = @"账号信息";
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
    [self.useCell bk_whenTapped:^{
        MyGuideController *vc = [[UIStoryboard storyboardWithName:@"HomePage" bundle:nil] instantiateViewControllerWithIdentifier:@"MyGuideController"];
        vc.title = @"使用指南";
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
}
-(void)getDataNetWork{
    [self getFriendNumber];
    [self getSystemInfoCount];
    [self  getMineMessage];
}
-(void)getSystemInfoCount{
    [HTTPREQUEST_SINGLE shitPostWithURLString:SH_GET_INFO_NUMBER parameters:nil withHub:NO withCache:NO success:^(NSDictionary *responseDic) {
        if ([responseDic[@"code"] integerValue] == 3) {
            self.msgLabel.text = [NSString stringWithFormat:@"%@",responseDic[@"data"][@"info_all"]];
        }
    } failure:^(NSError *error) {
        
    }];
}
-(void)getNewMeMessage{
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:USER_SINGLE.member_id,@"member_id", nil];
    [HTTPREQUEST_SINGLE postWithURLStringHeaderAndBody:SH_MINE_MESSAGE headerParameters:nil bodyParameters:params withHub:YES withCache:NO success:^(NSDictionary *responseDic) {
        NSDictionary *dic = responseDic;
        if ([responseDic[@"code"] integerValue] == 0) {
            self.userDic = dic[@"data"];
            USER_SINGLE.member_name = self.userDic[@"member_name"];
            
        }else if([responseDic[@"code"] integerValue] == -1001){
            [USER_SINGLE logout];
        }
    } failure:^(NSError *error) {
        
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
            self.introLabel.text = [self.userDic[@"member_introduction"] isKindOfClass:[NSNull class]]?@"":self.userDic[@"member_introduction"];
            self.userNameLabel.text = self.userDic[@"member_name"];
           self.userTypeLabel.text = [self.userDic[@"role_type"] integerValue] == 1?@"秘书处":@"会员";
            [self.userHeaderIamge sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",AVATAR_HOST_URL,self.userDic[@"member_avatar"]]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if (error) {
                    [self.userHeaderIamge setImage:[UIImage imageNamed:@"default_avatar"]];
                }
            }];
            [self.userHeaderIamge makeCorner:self.userHeaderIamge.frame.size.height/2];

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
            if ([USER_SINGLE.default_commerce_name isEqualToString:@""]) {
                if (self.commerceArray.count <= 0) {
                    self.commerceName.text = @"当前社团:无";
                }else{
                    NSDictionary *dic = self.commerceArray.firstObject;
                    self.commerceName.text = dic[@"commerce_name"];
                    self.userTypeLabel.text = self.commerceJobArray[[dic[@"member_post_in_commerce"] integerValue]- 1];
                }
            }else{
                
                NSLog(@"%@",USER_SINGLE.commerceDic);
                for (NSDictionary *dic  in self.commerceArray) {
                    NSString *commerce_id = dic[@"commerce_id"];
                    if ([commerce_id integerValue] == [USER_SINGLE.default_commerce_id integerValue]) {
                        USER_SINGLE.default_commerce_name = dic[@"commerce_name"];
                        self.commerceName.text = USER_SINGLE.default_commerce_name;
                         self.userTypeLabel.text = self.commerceJobArray[[dic[@"member_post_in_commerce"] integerValue]- 1];
                    }
                }
               
            }
//            [self.myTableView reloadData];
        }else if([responseDic[@"code"] integerValue] == -1001){
            [USER_SINGLE logout];
        }
        
    } failure:^(NSError *error) {
        
    }];
}
-(CommerceAlertView *)comAlertView{
    if (_comAlertView == nil) {
        _comAlertView = [[NSBundle mainBundle] loadNibNamed:@"homeview" owner:self options:nil][2];
        _comAlertView.frame = CGRectMake(0, 0, ScreenW, ScreenH);
        _comAlertView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        [_comAlertView.comContentView makeCorner:5];
        __block NewMineMessageTableViewController *blockSelf = self;
        [_comAlertView.commerceListView bk_whenTapped:^{
            [blockSelf.comAlertView removeFromSuperview];
            SearchCommerceController *vc = [[UIStoryboard storyboardWithName:@"CommerceView" bundle:nil] instantiateViewControllerWithIdentifier:@"SearchCommerceController"];
            [blockSelf.navigationController pushViewController:vc animated:YES];
        }];
        [_comAlertView.commerceCreatView bk_whenTapped:^{
            [blockSelf.comAlertView removeFromSuperview];
            UploadCommerceControllerController *VC = [[UIStoryboard storyboardWithName:@"CommerceView" bundle:nil] instantiateViewControllerWithIdentifier:@"UploadCommerceControllerController"];
            [blockSelf.navigationController pushViewController:VC animated:YES];
        }];
        [_comAlertView bk_whenTapped:^{
            [blockSelf.comAlertView removeFromSuperview];
        }];
    }
    return _comAlertView;
}
@end
