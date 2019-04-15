//
//  StudentJobController.m
//  TXProject
//
//  Created by Sam on 2019/3/21.
//  Copyright © 2019 sam. All rights reserved.
//

#import "StudentJobController.h"
#import "HomeJobCell.h"
#import "StuJobSelectView.h"
#import "MJRefresh.h"
#import "JobPostAndEditController.h"
#import "StudentJobDetailController.h"
#import "GetAreaView.h"
@interface StudentJobController ()<UITableViewDataSource,UITableViewDelegate,LPSwitchTagDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *jobtypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *educationLabel;
@property (weak, nonatomic) IBOutlet UILabel *selectLabel;
@property (weak, nonatomic) IBOutlet UILabel *selectWorkAreaLabel;
@property (weak, nonatomic) IBOutlet UITextField *searchTF;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;
@property (nonatomic) NSMutableArray *jobArray;
@property (nonatomic) StuJobSelectView *jobTypeView;
@property (nonatomic) StuJobSelectView *educationView;
@property (nonatomic) StuJobSelectView *jobTimeView;
@property (nonatomic) NSInteger nPage;
@property (nonatomic) NSArray *companyList;
@property (nonatomic) NSString *selectAreaString;
@property (nonatomic) GetAreaView *getAreaView;
@end

@implementation StudentJobController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.jobTypeView.hidden = YES;
    self.educationView.hidden = YES;
    self.jobTimeView.hidden = YES;
    self.jobTimeString = @"";
    self.jobTypeString = @"";
    self.educationString = @"";
    self.title = @"人才需求";
     self.getAreaView.hidden = YES;
    [self GetNetData];
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(GetNetDataMore)];
    self.tableView.mj_footer = footer;
    [self setupClickAction];
    [self GetCompanyData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GetNetData) name:@"GetJobListData" object:nil];
}
-(void)GetCompanyData{
    __block StudentJobController *blockSelf = self;
    [HTTPREQUEST_SINGLE postWithURLString:SH_COMPANY_LIST parameters:@{@"member_id":USER_SINGLE.member_id} withHub:YES withCache:NO success:^(NSDictionary *responseDic) {
        if ([responseDic[@"code"] integerValue]== 0) {
            blockSelf.companyList = responseDic[@"data"];
            
        }
    } failure:^(NSError *error) {
        
    }];
}
-(void)setupClickAction{
    __block StudentJobController *blockSelf = self;
    
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(onClickToUpload)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    [self.jobtypeLabel bk_whenTapped:^{
        blockSelf.jobTypeView.hidden = NO;
        blockSelf.jobTimeView.hidden = YES;
        blockSelf.educationView.hidden = YES;
        blockSelf.getAreaView.hidden = YES;
    }];
    [self.educationLabel bk_whenTapped:^{
        blockSelf.educationView.hidden = NO;
        blockSelf.jobTypeView.hidden = YES;
        blockSelf.jobTimeView.hidden = YES;
        blockSelf.getAreaView.hidden = YES;
    }];
    [self.selectLabel bk_whenTapped:^{
        blockSelf.jobTimeView.hidden = NO;
        blockSelf.jobTypeView.hidden = YES;
        blockSelf.educationView.hidden = YES;
        blockSelf.getAreaView.hidden = YES;
    }];
    [self.selectWorkAreaLabel bk_whenTapped:^{
        blockSelf.jobTimeView.hidden = YES;
        blockSelf.jobTypeView.hidden = YES;
        blockSelf.educationView.hidden = YES;
        blockSelf.getAreaView.hidden = NO;
    }];
    
    [self.searchBtn bk_whenTapped:^{
        [blockSelf GetNetData];
    }];
}
-(void)onClickToUpload{
    if (USER_SINGLE.token.length <= 0) {
        [AlertView showYMAlertView:self.view andtitle:@"请先登录"];
        return;
    }
    if (self.companyList.count <= 0 || self.companyList  == nil) {
        [AlertView showYMAlertView:self.view andtitle:@"请先创建公司"];
        return;
    }
    
    JobPostAndEditController *vc = [[UIStoryboard storyboardWithName:@"StudentJob" bundle:nil] instantiateViewControllerWithIdentifier:@"JobPostAndEditController"];
    vc.companyArray = self.companyList;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)GetNetDataMore{
    __block StudentJobController *blockSelf = self;
    self.nPage ++;
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:self.selectAreaString==nil?@"":self.selectAreaString,@"affiliated_area",@"",@"allow_publish",USER_SINGLE.default_commerce_id,@"commerce_id",self.educationString,@"education",@"",@"enterprise_id",@"",@"ios",self.searchTF.text,@"job_name",self.jobTypeString,@"job_type",[NSString stringWithFormat:@"%ld",self.nPage],@"page",@"2",@"receive_fresh_graduate",self.jobTimeString,@"work_type", nil];
    [HTTPREQUEST_SINGLE postWithURLString:SH_STUDENT_JOB_LIST parameters:param withHub:YES withCache:NO success:^(NSDictionary *responseDic) {
        if ([responseDic[@"code"] integerValue] == 1) {
            [blockSelf.jobArray addObjectsFromArray: responseDic[@"data"]];
            NSArray *arr = responseDic[@"data"];
            if (arr.count <= 0) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [blockSelf.tableView.mj_footer endRefreshing];
            }
        }else{
            blockSelf.nPage --;
            [blockSelf.tableView.mj_footer endRefreshing];
        }
        
         [blockSelf.tableView reloadData];
    } failure:^(NSError *error) {
        blockSelf.nPage --;
        [blockSelf.tableView.mj_footer endRefreshing];
    }];
}
-(void)GetNetData{
    __block StudentJobController *blockSelf = self;
    self.nPage = 1;
    self.jobArray = [NSMutableArray arrayWithCapacity:0];
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:self.selectAreaString==nil?@"":self.selectAreaString,@"affiliated_area",@"",@"allow_publish",USER_SINGLE.default_commerce_id,@"commerce_id",self.educationString,@"education",@"",@"enterprise_id",@"",@"ios",self.searchTF.text,@"job_name",self.jobTypeString,@"job_type",@"1",@"page",@"2",@"receive_fresh_graduate",self.jobTimeString,@"work_type", nil];
    [HTTPREQUEST_SINGLE postWithURLString:SH_STUDENT_JOB_LIST parameters:param withHub:YES withCache:NO success:^(NSDictionary *responseDic) {
        if ([responseDic[@"code"] integerValue] == 1) {
            [blockSelf.jobArray addObjectsFromArray: responseDic[@"data"]];
            [blockSelf.tableView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.jobArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 135;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeJobCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeJobCell"];
    NSDictionary *dic  = self.jobArray[indexPath.row];
    cell.cellName.text = dic[@"job_name"];
    cell.cellMoney.text = [NSString stringWithFormat:@"%ld-%ld元/月",[dic[@"salary_min"] integerValue],[dic[@"salary_max"] integerValue]];
    cell.cellCompany.text = dic[@"enterprise_name"];
    
    cell.cellAddress.text = [dic[@"area"] stringByReplacingOccurrencesOfString:@"|" withString:@""];
    LPTagCollectionView *tagCollectionView ;
    
    if (cell.cellTypeTag.subviews.count <= 0) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(50, 13);
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 10, 0);
        tagCollectionView = [[LPTagCollectionView alloc] initWithFrame:cell.cellTypeTag.frame collectionViewLayout:layout];
        [cell.cellTypeTag addSubview:tagCollectionView];
    }else{
        tagCollectionView = cell.cellTypeTag.subviews.firstObject;
    }
    NSArray *tagArray = [dic[@"welfare"] componentsSeparatedByString:@"|"];
    NSMutableArray *modelArray = [NSMutableArray arrayWithCapacity:0];
    tagCollectionView.fontColor = [UIColor colorWithRGB:0x3f78bc];
    tagCollectionView.borderColor = [UIColor colorWithRGB:0x3f78bc];
    for (int i = 0; i < tagArray.count ; i++) {
        LPTagModel *model = [[LPTagModel alloc] init];
        model.name = tagArray[i];
        model.isChoose = NO;
        [modelArray addObject:model];
    }
    tagCollectionView.tagArray = modelArray;
    tagCollectionView.fontSize = 12;
    tagCollectionView.cellHeight = 19;
    tagCollectionView.scrollEnabled = NO;
    tagCollectionView.tagDelegate = self;
    [tagCollectionView reloadData];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    StudentJobDetailController *vc = [[UIStoryboard storyboardWithName:@"StudentJob" bundle:nil] instantiateViewControllerWithIdentifier:@"StudentJobDetailController"];
    vc.selectData = self.jobArray[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}
-(StuJobSelectView *)jobTypeView{
    if (_jobTypeView == nil) {
        _jobTypeView = [[NSBundle mainBundle] loadNibNamed:@"StudentSelect" owner:self options:nil][0];
        _jobTypeView.frame = CGRectMake(self.tableView.frame.origin.x, 100, ScreenW, self.tableView.frame.size.height);
        [self.view addSubview:_jobTypeView];
        NSArray *oneArr = @[@"职业类型"];
        NSArray *twoArr = @[@"全部",@"IT通信电子",@"财务金融",@"房产/建筑建设/物业",@"服务业",@"管理/人力资源/行政",@"广告/市场/媒体/艺术",@"汽车/工程机械",@"消费品生产/物流",@"销售/客户/导购",@"医药/化工/能源/环保",@"资讯/法律/教育/翻译",@"农牧业",@"其他"];
        _jobTypeView.oneArray = oneArr;
        _jobTypeView.twoArray = twoArr;
        _jobTypeView.viewType = 1;
        _jobTypeView.studentVc = self;
        [_jobTypeView setupTableView];
    }
    return _jobTypeView;
}
-(StuJobSelectView *)educationView{
    if (_educationView == nil) {
        _educationView = [[NSBundle mainBundle] loadNibNamed:@"StudentSelect" owner:self options:nil][0];
        _educationView.frame = CGRectMake(self.tableView.frame.origin.x, 100, ScreenW, self.tableView.frame.size.height);
        [self.view addSubview:_educationView];
        NSArray *oneArr = @[@"学历要求"];
        NSArray *twoArr = @[@"全部",@"博士",@"硕士",@"本科",@"大专",@"高职",@"中职",@"不限"];
        _educationView.oneArray = oneArr;
        _educationView.twoArray = twoArr;
        _educationView.viewType = 2;
        _educationView.studentVc = self;
        [_educationView setupTableView];
    }
    return _educationView;
}
-(StuJobSelectView *)jobTimeView{
    if (_jobTimeView == nil) {
        _jobTimeView = [[NSBundle mainBundle] loadNibNamed:@"StudentSelect" owner:self options:nil][0];
        _jobTimeView.frame = CGRectMake(self.tableView.frame.origin.x, 100, ScreenW, self.tableView.frame.size.height);
        [self.view addSubview:_jobTimeView];
        NSArray *oneArr = @[@"工作方式"];
        NSArray *twoArr = @[@"全部",@"全职",@"兼职"];
        _jobTimeView.oneArray = oneArr;
        _jobTimeView.twoArray = twoArr;
        _jobTimeView.viewType = 3;
        _jobTimeView.studentVc = self;
        [_jobTimeView setupTableView];
    }
    return _jobTimeView;
}

-(GetAreaView *)getAreaView{
    if (_getAreaView == nil) {
        __block StudentJobController *blockSelf = self;
        _getAreaView = [[NSBundle mainBundle] loadNibNamed:@"Area" owner:self options:nil][0];
        _getAreaView.frame = CGRectMake(0, 0, ScreenW, ScreenH);
        [self.view addSubview:_getAreaView];
        _getAreaView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        [_getAreaView setupTableView];
        [_getAreaView.sureBtn bk_whenTapped:^{
            self.selectAreaString = [NSString stringWithFormat:@"%@省|%@市",blockSelf.getAreaView.selectProvince,blockSelf.getAreaView.selecCity];
            [blockSelf GetNetData];
            blockSelf.getAreaView.hidden = YES;
        }];
        [_getAreaView.clearBtn bk_whenTapped:^{
            blockSelf.selectAreaString = @"";
            blockSelf.getAreaView.selecCity = @"";
            blockSelf.getAreaView.selectProvince = @"";
            blockSelf.getAreaView.hidden = YES;
            [blockSelf.getAreaView.provinceTable reloadData];
            [blockSelf.getAreaView.cityTable reloadData];
            [blockSelf GetNetData];
        }];
    }
    return _getAreaView;
}
@end
