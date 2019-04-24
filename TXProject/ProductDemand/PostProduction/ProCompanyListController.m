//
//  ProCompanyListController.m
//  TXProject
//
//  Created by Sam on 2019/4/4.
//  Copyright © 2019 sam. All rights reserved.
//

#import "ProCompanyListController.h"
#import "ProCompanyListCell.h"
#import "BottomView.h"
#import "EditCompanyMessageController.h"
@interface ProCompanyListController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSMutableArray *companyList;
@property (nonatomic) NSArray *typeArray;
@property (nonatomic) BottomView *bottomBtn;
@property (nonatomic) NSDictionary *selectCompanyDic;
@end

@implementation ProCompanyListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.bottomBtn];
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 85)];
    self.tableView.tableFooterView = footerView;
    [self.bottomBtn makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@45);
        make.width.equalTo(@188);
        make.bottom.equalTo(@(-40));
        make.centerX.equalTo(@0);
    }];
    self.title = @"我的企业";
    self.typeArray = @[@"全部", @"高新技术企业", @"科技型中小企业", @"规模以上企业", @"创新型企业", @"民营科技企业", @"大中型企业", @"其他"];
    [self GetCompanyData];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.companyList.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ProCompanyListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProCompanyListCell"];
    NSDictionary *dic = self.companyList[indexPath.row];
    [cell.avatar sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",AVATAR_HOST_URL,dic[@"enterprise_logo"]]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (error) {
            [cell.avatar setImage:[UIImage imageNamed:@"default_avatar"]];
        }
    }];
    cell.name.text = [dic[@"enterprise_name"] isKindOfClass:[NSNull class]]?@"":dic[@"enterprise_name"];
    cell.type.text = self.typeArray[[dic[@"enterprise_type"] integerValue]];
    cell.area.text = [dic[@"area"] isKindOfClass:[NSNull class]]?@"":dic[@"area"];
    if (USER_SINGLE.default_company_dic != nil) {
        if ([USER_SINGLE.default_company_dic[@"enterprise_id"] integerValue] == [dic[@"enterprise_id"] integerValue]) {
            [cell.selectIcon setImage:[UIImage imageNamed:@"pro_sel_icon"]];
            cell.defaultLabel.hidden = NO;
        }else{
            [cell.selectIcon setImage:[UIImage imageNamed:@"pro_no_select_company"]];
            cell.defaultLabel.hidden = YES;
        }
       
    }
    [cell.selectIcon bk_whenTapped:^{
        NSIndexPath *indexP = [tableView indexPathForCell:cell];
        self.selectCompanyDic = dic;
        if (self.changeDefault) {
            [self ChangeCompanyDefault:@{@"enterprise_id":dic[@"enterprise_id"],@"handle_type":@"1"} :indexP.row];
        }else{
            self.selectNSDictionaryCallBack(self.selectCompanyDic);
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    
       
    }];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 115;
}
-(void)GetCompanyData{
    __block ProCompanyListController *blockSelf = self;
    [HTTPREQUEST_SINGLE postWithURLString:SH_COMPANY_LIST parameters:@{@"member_id":USER_SINGLE.member_id} withHub:YES withCache:NO success:^(NSDictionary *responseDic) {
        if ([responseDic[@"code"] integerValue]== 0) {
            blockSelf.companyList = [NSMutableArray arrayWithArray:responseDic[@"data"]];
            [blockSelf.tableView reloadData];
        }else{
            
        }
    } failure:^(NSError *error) {
        
    }];
}

-(void)ChangeCompanyDefault:(NSDictionary *)param  :(NSInteger )index{
    [HTTPREQUEST_SINGLE postWithURLString:SH_COMPANY_DEFAULT parameters:param withHub:YES withCache:NO success:^(NSDictionary *responseDic) {
        if ([responseDic[@"code"] integerValue] == -1002) {
            USER_SINGLE.default_company_dic = self.companyList[index];
            [AlertView showYMAlertView:self.view andtitle: responseDic[@"message"]];
            [self.tableView reloadData];
        }else{
            [AlertView showYMAlertView:self.view andtitle: @"绑定失败"];
        }
    } failure:^(NSError *error) {
        [AlertView showYMAlertView:self.view andtitle: @"绑定失败"];
    }];
}
-(BottomView *)bottomBtn{
    if (_bottomBtn == nil) {
        _bottomBtn = [[NSBundle mainBundle] loadNibNamed:@"CommerceList" owner:self options:nil][6];
        __block ProCompanyListController *blockSelf = self;
        _bottomBtn.titleLabel.text = @"创建企业";
        [_bottomBtn makeCorner:45/2];
        [_bottomBtn bk_whenTapped:^{
            EditCompanyMessageController *vc = [[UIStoryboard storyboardWithName:@"CompanyView" bundle:nil] instantiateViewControllerWithIdentifier:@"EditCompanyMessageController"];
            [blockSelf.navigationController pushViewController:vc animated:YES];
        }];
    }
    return _bottomBtn;
}

@end
