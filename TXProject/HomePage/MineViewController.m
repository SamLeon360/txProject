//
//  MineViewController.m
//  TXProject
//
//  Created by Sam on 2019/1/3.
//  Copyright © 2019 sam. All rights reserved.
//

#import "MineViewController.h"
#import "MineViewHeader.h"
#import "MineCommerceCell.h"
#import "AccountMsgController.h"
#import "EditUserDataController.h"
#import "LogoutViewController.h"
@interface MineViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic) MineViewHeader *tableHeader;
    @property (nonatomic) NSDictionary *userDic;
    @property (nonatomic) NSString *moment_count;
    @property (nonatomic) NSString *friends_count;
@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.title = @"我的";
    NOTIFY_ADD(getMineMessage, @"getMineMessage");
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRGB:0x3e85fb];
    self.navigationController.navigationBar.titleTextAttributes= @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:18]};
    [self getFriendNumber];
   
    [self getCommerceMessage];
    
}
-(void)viewWillAppear:(BOOL)animated{
     [self getMineMessage];
    [self.navigationController setNavigationBarHidden:NO];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 375;
}
    
-(void)getFriendNumber{
    [HTTPREQUEST_SINGLE shitPostWithURLString:SH_FRIEND_NUMBER parameters:nil withHub:YES withCache:NO success:^(NSDictionary *responseDic) {
        
        if ([responseDic[@"code"] integerValue] == 3) {
            self.friends_count = [NSString stringWithFormat:@"%@",responseDic[@"data"][@"friends_count"]];
            self.moment_count = [NSString stringWithFormat:@"%@",responseDic[@"data"][@"moment_count"]];
            [self.myTableView reloadData];
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
            [self.myTableView reloadData];
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
            [self.myTableView reloadData];
        }else if([responseDic[@"code"] integerValue] == -1001){
            [USER_SINGLE logout];
        }
        
    } failure:^(NSError *error) {
        
    }];
}
-(void)changeCommerce:(NSDictionary *)dic{
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:dic[@"commerce_id"],@"default_commerce_id",dic[@"commerce_name"],@"default_commerce_name", nil];
    [HTTPREQUEST_SINGLE postWithURLStringHeaderAndBody:SH_CHANGE_COMMERCE headerParameters:nil bodyParameters:param withHub:YES withCache:NO success:^(NSDictionary *responseDic) {
        if ([responseDic[@"code"] integerValue] == 0) {
            USER_SINGLE.commerceDic = dic;
            USER_SINGLE.default_commerce_id = [NSString stringWithFormat:@"%@",dic[@"commerce_id"]];
            USER_SINGLE.default_commerce_name = dic[@"commerce_name"];
            [self.myTableView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = self.commerceArray[indexPath.row];
    [self changeCommerce:dic];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.tableHeader;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.commerceArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MineCommerceCell *cell = [self.myTableView dequeueReusableCellWithIdentifier:@"MineCommerceCell"];
    NSDictionary *dic = self.commerceArray[indexPath.row];
    cell.commerceName.text = dic[@"commerce_name"];
    cell.commerceName.textColor = [UIColor blackColor];
    for (int i = 0; i<self.commerceArray.count ; i++) {
        NSDictionary *dic = self.commerceArray[i];
        if ([[NSString stringWithFormat:@"%@",USER_SINGLE.default_commerce_id] isEqualToString:[NSString stringWithFormat:@"%@",dic[@"commerce_id"]]]) {
            cell.commerceName.textColor = [UIColor colorWithRGB:0x4185E6];
        }
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 34;
}
-(MineViewHeader *)tableHeader{
    
        _tableHeader = [[NSBundle mainBundle] loadNibNamed:@"MineHeader" owner:self options:nil][0];
        [_tableHeader.userAvatar sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",AVATAR_HOST_URL,self.userDic[@"member_avatar"]]]];
        _tableHeader.userName.text = self.userDic[@"member_name"];
        _tableHeader.userType.text = [USER_SINGLE.role_type integerValue] == 1?@"秘书处":@"会员";
        _tableHeader.messageNumber.text = @"0";
        _tableHeader.dongtaiNumber.text = self.moment_count;
        _tableHeader.friendsNumber.text = self.friends_count;
    __block MineViewController *blockSelf = self;
    [_tableHeader.accountMessageView bk_whenTapped:^{
        AccountMsgController *vc = [[UIStoryboard storyboardWithName:@"MineView" bundle:nil] instantiateViewControllerWithIdentifier:@"AccountMsgController"];
        vc.userDic = blockSelf.userDic;
        [blockSelf.navigationController pushViewController:vc animated:YES];
    }];
    [_tableHeader.typeMessageView bk_whenTapped:^{
        EditUserDataController *vc = [[UIStoryboard storyboardWithName:@"MineView" bundle:nil] instantiateViewControllerWithIdentifier:@"EditUserDataController"];
        vc.userDic = blockSelf.userDic;
        [blockSelf.navigationController pushViewController:vc animated:YES];
    }];
    [_tableHeader.appSettingView bk_whenTapped:^{
        LogoutViewController *vc = [[UIStoryboard storyboardWithName:@"MineView" bundle:nil] instantiateViewControllerWithIdentifier:@"LogoutViewController"];
        [blockSelf.navigationController pushViewController:vc animated:YES];
    }];
    return _tableHeader;
}
@end
