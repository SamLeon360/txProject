
//
//  MineCompanyListController.m
//  TXProject
//
//  Created by Sam on 2019/2/19.
//  Copyright © 2019 sam. All rights reserved.
//

#import "MineCompanyListController.h"
#import "CompanyListCell.h"
#import "MJRefresh.h"
#import "EditCompanyMessageController.h"
@interface MineCompanyListController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic) NSArray *companyListArray;
@property (nonatomic) NSArray *typeArray;
@property (nonatomic) NSInteger nPage;
@property (nonatomic) UIButton *addDataBtn;
@end

@implementation MineCompanyListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.title = @"我的企业";
    self.typeArray = @[@"全部",@"电子信息",@"装备制造",@"能源环保",@"生物技术与医药",@"新材料",@"现在农业",@"其他行业"];
    [self GetCompanyData];
    [self.view addSubview:self.addDataBtn];
    self.myTableView.tableFooterView = [[UIView alloc] init];
}
-(void)viewWillAppear:(BOOL)animated{
    [self GetCompanyData];
}
-(void)GetCompanyData{
    __block MineCompanyListController *blockSelf = self;
    [HTTPREQUEST_SINGLE postWithURLString:SH_COMPANY_LIST parameters:@{@"member_id":self.memberId} withHub:YES withCache:NO success:^(NSDictionary *responseDic) {
        if ([responseDic[@"code"] integerValue]== 0) {
            blockSelf.companyListArray = responseDic[@"data"];
            [blockSelf.myTableView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}
- (void)addRightBtn {
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(onClickedOKbtn)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
}

- (void)onClickedOKbtn {
    EditCompanyMessageController *vc = [[UIStoryboard storyboardWithName:@"CompanyView" bundle:nil] instantiateViewControllerWithIdentifier:@"EditCompanyMessageController"];
    [self.navigationController pushViewController:vc animated:YES];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.companyListArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = self.companyListArray[indexPath.row];
    CompanyListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CompanyListCell"];
    [cell.companyImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",AVATAR_HOST_URL,dic[@"enterprise_logo"]]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (error) {
             [cell.companyImage setImage:[UIImage imageNamed:@"default_avatar"]];
        }
    }];
    if ([USER_SINGLE.default_company_dic[@"enterprise_name"] isEqualToString:dic[@"enterprise_name"]]) {
        cell.defaultLabel.hidden = NO;
        [cell.selectDefualtBtn setImage:[UIImage imageNamed:@"pro_sel_icon"] forState:UIControlStateNormal];
    }else{
        cell.defaultLabel.hidden = YES;
        [cell.selectDefualtBtn setImage:[UIImage imageNamed:@"pro_no_select_company"] forState:UIControlStateNormal];
    }
    cell.companyNameLabel.text = [dic[@"enterprise_name"] isKindOfClass:[NSNull class]]?@"":dic[@"enterprise_name"];
    cell.companyTypeCell.text = self.typeArray[[dic[@"domain"] integerValue] - 1];
    cell.companyAddressLabel.text = [dic[@"area"] isKindOfClass:[NSNull class]]?@"":dic[@"area"];
    [cell.selectDefualtBtn bk_whenTapped:^{
        [self ChangeCompanyDefault:@{@"enterprise_id":dic[@"enterprise_id"],@"handle_type":@"1"} andIndex:indexPath];
    }];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic =  self.companyListArray[indexPath.row];
    EditCompanyMessageController *vc = [[UIStoryboard storyboardWithName:@"CompanyView" bundle:nil] instantiateViewControllerWithIdentifier:@"EditCompanyMessageController"];
    vc.companyIdDic = dic;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)ChangeCompanyDefault:(NSDictionary *)param andIndex : (NSIndexPath *)indexP{
    [HTTPREQUEST_SINGLE postWithURLString:SH_COMPANY_DEFAULT parameters:param withHub:YES withCache:NO success:^(NSDictionary *responseDic) {
        if ([responseDic[@"code"] integerValue] == -1002) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:self.companyListArray[indexP.row]];
            [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[NSNull class]]) {
                    [dic setObject:@"" forKey:key];
                }
            }];
            USER_SINGLE.default_company_dic = dic;
            [AlertView showYMAlertView:self.view andtitle: responseDic[@"message"]];
            [self.myTableView reloadData];
        }else{
            [AlertView showYMAlertView:self.view andtitle: @"绑定失败"];
        }
    } failure:^(NSError *error) {
         [AlertView showYMAlertView:self.view andtitle: @"绑定失败"];
    }];
}
-(UIButton *)addDataBtn{
    if (!_addDataBtn) {
        _addDataBtn = [[UIButton alloc] initWithFrame:CGRectMake((ScreenW-192)/2, ScreenH-170, 192, 50 )];
        [_addDataBtn makeCorner:25];
        _addDataBtn.hidden = NO;
        [_addDataBtn setTitle:@"创建企业" forState:UIControlStateNormal];
        [_addDataBtn setBackgroundColor:[UIColor colorWithRGB:0x0E56B8] forState:UIControlStateNormal];
//        [_addDataBtn setImage:[UIImage imageNamed:@"cy_zh_bottom_btn"] forState:UIControlStateNormal];
        __block MineCompanyListController *blockSelf = self;
        [_addDataBtn bk_whenTapped:^{
            if (USER_SINGLE.token.length <= 0) {
                [AlertView showYMAlertView:self.view andtitle:@"请先登录!"];
                return ;
            }
            [blockSelf onClickedOKbtn];
            
            
        }];
    }
    return _addDataBtn;
}
@end
