//
//  SchoolListController.m
//  TXProject
//
//  Created by Sam on 2019/1/21.
//  Copyright © 2019 sam. All rights reserved.
//

#import "SchoolListController.h"
#import "SchoolListMsgCell.h"
#import "MJRefresh.h"
@interface SchoolListController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *searchTF;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSMutableArray *schoolListArray;
@property (nonatomic) NSInteger nPage;
@end

@implementation SchoolListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.nPage = 1;
    self.title = @"院校信息列表";
    [self getSchoolDataRefresh];
    __block SchoolListController *blockSelf = self;
    [self.searchBtn bk_whenTapped:^{
        [blockSelf getSchoolDataRefresh];
    }];
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getSchoolDataMore)];
    self.tableView.mj_footer = footer;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 1)];
}
-(void)getSchoolDataRefresh{
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:self.searchTF.text,@"academy_name",[NSString stringWithFormat:@"%ld",(long)self.nPage],@"page",@"",@"academy_type",@"",@"affiliated_area", nil];
    __block SchoolListController *blockSelf = self;
    [HTTPREQUEST_SINGLE postWithURLString:SH_SCHOOL_LIST parameters:param withHub:YES withCache:NO success:^(NSDictionary *responseDic) {
        if (blockSelf.nPage == 1) {
            blockSelf.schoolListArray = [NSMutableArray arrayWithCapacity:0];
        }
        NSArray *arr = responseDic[@"data"];
        if (arr.count > 0) {
           [blockSelf.schoolListArray addObjectsFromArray:responseDic[@"data"]];
            
        }
        [blockSelf.tableView reloadData];
        blockSelf.nPage  = 1;
    } failure:^(NSError *error) {
        
    }];
}

-(void)getSchoolDataMore{
   
    self.nPage ++;
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:self.searchTF.text,@"academy_name",[NSString stringWithFormat:@"%ld",self.nPage],@"page",@"",@"academy_type",@"",@"affiliated_area", nil];
    __block SchoolListController *blockSelf = self;
    [HTTPREQUEST_SINGLE postWithURLString:SH_SCHOOL_LIST parameters:param withHub:YES withCache:NO success:^(NSDictionary *responseDic) {
        NSArray *arr = responseDic[@"data"];
        if (arr.count > 0) {
            [blockSelf.schoolListArray addObjectsFromArray:responseDic[@"data"]];
         [blockSelf.tableView reloadData];
        }else{
            blockSelf.nPage --;
        }
        [blockSelf.tableView.mj_footer endRefreshing];
        
    } failure:^(NSError *error) {
        blockSelf.nPage --;
         [blockSelf.tableView.mj_footer endRefreshing];
    }];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.schoolListArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SchoolListMsgCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SchoolListMsgCell"];
    NSDictionary *dic = self.schoolListArray[indexPath.row];
    [cell.schoolImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",AVATAR_HOST_URL,dic[@"academy_logo"]]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (error) {
            [cell.schoolImage setImage:[UIImage imageNamed:@"default_avatar"]];
        }
    }];
    NSString *typeString = @"";
    switch ([dic[@"academy_type"] integerValue]) {
        case 1:
            typeString = @"大专院校";
            break;
        case 2:
            typeString = @"高职院校";
            break;
        case 3:
            typeString = @"中职院校";
            break;
        case 4:
            typeString = @"科研院校";
            break;
        case 5:
            typeString = @"本科院校";
            break;
        default:
            break;
    }
    cell.name.text = dic[@"academy_name"];
    cell.type.text = [NSString stringWithFormat:@"单位类别：%@",typeString];
    cell.address.text = [NSString stringWithFormat:@"通讯地址：%@",dic[@"address"]];
    cell.phone.text = [NSString stringWithFormat:@"联系电话：%@",dic[@"phone"]];
    cell.webUrl.text = [NSString stringWithFormat:@"学校网址：%@",dic[@"website"]];
    return cell;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
