//
//  SameCityCommerceController.m
//  TXProject
//
//  Created by Sam on 2019/1/16.
//  Copyright © 2019 sam. All rights reserved.
//

#import "SameCityCommerceController.h"
#import "MemberListCell.h"
#import "CommerceDetailController.h"
#import "TXWebViewController.h"
@interface SameCityCommerceController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *searchTF;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableVieddw;
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (nonatomic) NSMutableArray *commerceArray;
@end

@implementation SameCityCommerceController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.sameCity? @"同籍社团":@"同城社团";
    self.tableVieddw.delegate = self;
    self.tableVieddw.dataSource = self;
    self.searchView.layer.borderWidth = 1;
    self.searchView.layer.borderColor = [UIColor colorWithRGB:0xf2f2f2].CGColor;
    [self.searchView makeCorner:5];
    [self getCommerceData];
    self.tableVieddw.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 1)];
    __block SameCityCommerceController *blockSelf = self;
    [self.searchBtn bk_whenTapped:^{
        [blockSelf getCommerceData];
    }];
}

-(void)getCommerceData{
    __block SameCityCommerceController *blockSelf = self;
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:USER_SINGLE.default_commerce_id,@"commerce_id",self.searchTF.text,@"commerce_name",self.sameCity?@"2":@"1",@"search_type", nil];
    [HTTPREQUEST_SINGLE allUserHeaderPostWithURLString:SH_SEARCH_COMMERCE_LIST parameters:dic withHub:YES withCache:NO success:^(NSDictionary *responseDic) {
        if ([responseDic[@"code"] integerValue] == 0) {
            blockSelf.commerceArray = [NSMutableArray arrayWithCapacity:0];
            [blockSelf.commerceArray addObjectsFromArray:responseDic[@"data"]];
            [blockSelf.tableVieddw reloadData];
            [blockSelf.tableVieddw scrollsToTop];
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
    [cell.avatarImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",AVATAR_HOST_URL,dic[@"commerce_logo"]]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (error) {
            [cell.avatarImage setImage:[UIImage imageNamed:@"default_avatar"]];
        }
    }];
    cell.memberName.text = dic[@"commerce_name"];
    NSString *commerceType = @"";
    switch ([dic[@"commerce_type"] integerValue]) {
        case 1:{
            commerceType = @"行业协会";
        }break;
        case 2:{
            commerceType = @"综合型商会";
        }break;
        case 3:{
            commerceType = @"地方商会";
        }break;
        case 4:{
            commerceType = @"异地商会";
        }break;
        default:
            break;
    }
    cell.memberCompany.text = [NSString stringWithFormat:@"%@  %@",commerceType,dic[@"commerce_location"]];
    cell.memberType.text = [NSString stringWithFormat:@"%@名会员",dic[@"ct"]];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = self.commerceArray[indexPath.row];
    CommerceDetailController *vc = [[UIStoryboard storyboardWithName:@"CommerceView" bundle:nil] instantiateViewControllerWithIdentifier:@"CommerceDetailController"];
    vc.commerceId = [NSString stringWithFormat:@"%ld",[dic[@"commerce_id"] integerValue]];
    
    [self.navigationController pushViewController:vc animated:YES];
//    TXWebViewController *vc = [[UIStoryboard storyboardWithName:@"HomePage" bundle:nil] instantiateViewControllerWithIdentifier:@"TXWebViewController"];
//    vc.webUrl = [NSString stringWithFormat:@"https://app.tianxun168.com/h5/#/member/detail_platform/%@/",dic[@"commerce_id"]];
//    [self.navigationController pushViewController:vc animated:YES];
}
@end
