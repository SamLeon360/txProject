//
//  CompanyListController.m
//  TXProject
//
//  Created by Sam on 2019/1/16.
//  Copyright © 2019 sam. All rights reserved.
//

#import "CompanyListController.h"
#import "MemberListCell.h"
#import "TXWebViewController.h"
@interface CompanyListController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSMutableArray *commerceArray;
@end

@implementation CompanyListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"企业信息列表";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
  
    [self getCommerceData];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 1)];
    
}

-(void)getCommerceData{
    __block CompanyListController *blockSelf = self;
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:USER_SINGLE.member_id,@"member_id", nil];
    [HTTPREQUEST_SINGLE allUserHeaderPostWithURLString:SH_COMPANY_LIST parameters:dic withHub:YES withCache:NO success:^(NSDictionary *responseDic) {
        if ([responseDic[@"code"] integerValue] == 0) {
            blockSelf.commerceArray = [NSMutableArray arrayWithCapacity:0];
            [blockSelf.commerceArray addObjectsFromArray:responseDic[@"data"]];
            [blockSelf.tableView reloadData];
            [blockSelf.tableView scrollsToTop];
        }
    } failure:^(NSError *error) {
        
    }];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.commerceArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = self.commerceArray[indexPath.row];
    MemberListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MemberListCell"];
    [cell.avatarImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",AVATAR_HOST_URL,dic[@"enterprise_photo"]]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (error) {
            [cell.avatarImage setImage:[UIImage imageNamed:@"default_avatar"]];
        }
    }];
    cell.memberName.text = dic[@"enterprise_name"];
    NSString *commerceType = @"";
    switch ([dic[@"domain"] integerValue]) {
        case 1:{
            commerceType = @"电子信息";
        }break;
        case 2:{
            commerceType = @"装备制造";
        }break;
        case 3:{
            commerceType = @"能源环保";
        }break;
        case 4:{
            commerceType = @"生物技术与医药";
        }break;
        
        case 5:{
            commerceType = @"新材料";
        }break;
            
        case 6:{
            commerceType = @"现代农药";
        }break;
            
        case 7:{
            commerceType = @"其他";
        }break;
        default:
            break;
    }
    cell.memberCompany.text = [NSString stringWithFormat:@"%@  ",commerceType];
    cell.memberType.text = [NSString stringWithFormat:@"%@",[dic[@"area"] isKindOfClass:[NSNull class]]?@"":dic[@"area"]];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = self.commerceArray[indexPath.row];
    TXWebViewController *vc = [[UIStoryboard storyboardWithName:@"HomePage" bundle:nil] instantiateViewControllerWithIdentifier:@"TXWebViewController"];
    vc.webUrl = [NSString stringWithFormat:@"https://app.tianxun168.com/h5/#/member/detail_platform/%@/",dic[@"commerce_id"]];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
