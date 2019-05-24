//
//  InvestmentListController.m
//  TXProject
//
//  Created by Sam on 2019/3/1.
//  Copyright © 2019 sam. All rights reserved.
//

#import "InvestmentListController.h"
#import "InvestmentListCell.h"
#import "ProjectTypeView.h"
#import "ProjectSelectView.h"
#import "MJRefresh.h"
#import "InvestmentListDetailController.h"
@interface InvestmentListController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *investmentLabel;
@property (weak, nonatomic) IBOutlet UILabel *haveMotionLabel;
@property (weak, nonatomic) IBOutlet UILabel *postView;
@property (weak, nonatomic) IBOutlet UILabel *jobTypeView;
@property (weak, nonatomic) IBOutlet UILabel *selectView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *returnView;
@property (nonatomic) NSInteger selectType;

@property (nonatomic) ProjectSelectView *projectSelectView;
@property (nonatomic) ProjectTypeView *projectTypeView;

@property (nonatomic) NSMutableArray *investmentArray;///招商引资
@property (nonatomic) NSMutableArray *motionArray;///有意向
@property (nonatomic) NSArray *projectType ;


@end

@implementation InvestmentListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.nPage = 1;
    self.selectTypeIndex = 0;
    self.selectType = 0;
    self.tableView.dataSource = self;
    
//    [self.navigationController addObserver:self forKeyPath:@"navigationBarHidden" options:NSKeyValueObservingOptionNew context:nil];
    self.projectType = @[  @"全部", @"园区建设", @"基础设施", @"农牧农副",
                           @"工业制造", @"医药化工", @"文化旅游", @"能源矿产",
                           @"金融投资", @"商贸物流", @"生物医药", @"现代服务业",
                           @"大健康医药", @"健康养老", @"医疗服务业", @"科教文卫",
                           @"高新科技", @"设施管理", @"其他"];
    [self setupClickAction];
    [self.investmentLabel setTextColor:[UIColor colorWithRGB:0xFACB46]];
    __block InvestmentListController *blockSelf = self;
    
    self.tableView.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
        if (self.selectType == 0) {
            [blockSelf getinvestmentArrayByRefresh];
        }else{
            [blockSelf getMotionArrayDataByRefresh];
        }
    }];
    [self.tableView.mj_header beginRefreshing];
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMoreData)];
    self.tableView.mj_footer = footer;
    NOTIFY_ADD(getinvestmentArrayByRefresh, @"getinvestmentArrayByRefresh");
    [self setupClickAction];
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
-(void)viewDidLayoutSubviews{
//     [self.navigationController setNavigationBarHidden:YES animated:NO];
}
-(void)viewDidAppear:(BOOL)animated{
//  [self.navigationController setNavigationBarHidden:YES animated:NO];
}
-(void)setupClickAction{
    __block InvestmentListController *blockSelf = self;
    [self.jobTypeView bk_whenTapped:^{
        __block InvestmentListController *blockBlockSelf = blockSelf;
        [UIView animateWithDuration:0.3 animations:^{
            if (blockBlockSelf.projectTypeView.frame.size.height <= 0) {
                blockBlockSelf.projectTypeView.frame = blockBlockSelf.tableView.frame;
            }else{
                blockBlockSelf.projectTypeView.frame = CGRectMake(blockBlockSelf.tableView.frame.origin.x, blockBlockSelf.tableView.frame.origin.y, blockBlockSelf.tableView.frame.size.width, 0);
            }
        }];
    }];
    [self.selectView bk_whenTapped:^{
        self.projectSelectView.hidden = NO;
        __block InvestmentListController *blockBlockSelf = blockSelf;
        [UIView animateWithDuration:0.3 animations:^{
            if (blockBlockSelf.projectSelectView.frame.size.height <= 0) {
                blockBlockSelf.projectSelectView.frame = CGRectMake(blockBlockSelf.tableView.frame.origin.x, blockBlockSelf.tableView.frame.origin.y, blockBlockSelf.tableView.frame.size.width, 200);
            }else{
                blockBlockSelf.projectSelectView.frame = CGRectMake(blockBlockSelf.tableView.frame.origin.x, blockBlockSelf.tableView.frame.origin.y, blockBlockSelf.tableView.frame.size.width, 0);
            }
        }];
    }];
    [self.returnView bk_whenTapped:^{
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [self.investmentLabel bk_whenTapped:^{
        [blockSelf.haveMotionLabel setTextColor:[UIColor whiteColor]];
        [blockSelf.investmentLabel setTextColor:[UIColor colorWithRGB:0xFACB46]];
        blockSelf.selectType = 0;
//         [self.navigationController setNavigationBarHidden:YES animated:NO];
        [blockSelf getinvestmentArrayByRefresh];
    }];
    [self.haveMotionLabel bk_whenTapped:^{
        [blockSelf.investmentLabel setTextColor:[UIColor whiteColor]];
        [blockSelf.haveMotionLabel setTextColor:[UIColor colorWithRGB:0xFACB46]];
        blockSelf.selectType = 1;
//         [self.navigationController setNavigationBarHidden:YES animated:NO];
        [blockSelf getMotionArrayDataByRefresh];
    }];
    [self.projectSelectView.resetBtn bk_whenTapped:^{
        blockSelf.projectSelectView.minPriceTF.text = @"";
        blockSelf.projectSelectView.maxPriceTF.text = @"";
    }];
    [self.projectSelectView.searchBtn bk_whenTapped:^{
        __block InvestmentListController *blockBlockSelf = blockSelf;
        [UIView animateWithDuration:0.3 animations:^{
              blockBlockSelf.projectSelectView.frame = CGRectMake(blockBlockSelf.tableView.frame.origin.x, blockBlockSelf.tableView.frame.origin.y, blockBlockSelf.tableView.frame.size.width, 0);
        }];
    
        [blockSelf getinvestmentArrayByRefresh];
        blockSelf.projectSelectView.hidden = YES;
    }];
    
}
-(void)getMotionArrayDataByRefresh{
    [HTTPREQUEST_SINGLE postWithURLString:SH_MOTION_LIST parameters:@{@"type":@"1"} withHub:YES withCache:NO success:^(NSDictionary *responseDic) {
        [self.tableView.mj_header endRefreshing];
        if ([responseDic[@"code"] integerValue] == 0) {
            self.motionArray = [NSMutableArray arrayWithCapacity:0];
            [self.motionArray addObjectsFromArray:responseDic[@"data"]];
            [self.tableView reloadData];
          
        }else{
             [AlertView showYMAlertView:self.view andtitle:@"获取数据失败"];
        }
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
          [AlertView showYMAlertView:self.view andtitle:@"网络异常,请检查网络"];
    }];
}
-(void)getinvestmentArrayByRefresh{
    self.nPage = 1;
    self.jobTypeView.text = self.selectTypeIndex==0?@"行业类别":self.projectType[self.selectTypeIndex];
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:@"",@"affiliated_area",self.projectSelectView.maxPriceTF.text,@"max_price",self.projectSelectView.minPriceTF.text,@"min_price",[NSString stringWithFormat:@"%ld",(long)self. nPage],@"page",@"",@"projects_order",[NSString stringWithFormat:@"%@",self.selectTypeIndex==0?@"":[NSString stringWithFormat:@"%ld",self.selectTypeIndex]],@"projects_type", nil];
    [HTTPREQUEST_SINGLE postWithURLString:SH_INVESTMENT_LIST parameters:param withHub:YES withCache:NO success:^(NSDictionary *responseDic) {
        if ([responseDic[@"code"] integerValue] == 1) {
            self.investmentArray = [NSMutableArray arrayWithCapacity:0];
            [self.investmentArray addObjectsFromArray: responseDic[@"data"]];
            self.nPage = 2;
            [self.tableView reloadData];
        }else{
            [AlertView showYMAlertView:self.view andtitle:@"获取数据失败"];
        }
        [self.tableView.mj_header endRefreshing];
      
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [AlertView showYMAlertView:self.view andtitle:@"网络异常,请检查网络"];
    }];
    
}
-(void)getMoreData{
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:@"",@"affiliated_area",self.projectSelectView.maxPriceTF.text,@"max_price",self.projectSelectView.minPriceTF.text,@"min_price",[NSString stringWithFormat:@"%ld",self. nPage],@"page",@"",@"projects_order",[NSString stringWithFormat:@"%@",self.selectTypeIndex==0?@"":[NSString stringWithFormat:@"%ld",self.selectTypeIndex]],@"projects_type", nil];
    [HTTPREQUEST_SINGLE postWithURLString:SH_INVESTMENT_LIST parameters:param withHub:YES withCache:NO success:^(NSDictionary *responseDic) {
        if ([responseDic[@"code"] integerValue] == 1) {
            [self.investmentArray addObjectsFromArray: responseDic[@"data"]];
            self.nPage ++;
            [self.tableView reloadData];
            NSArray *arr = responseDic[@"data"];
            if (arr.count <= 0) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                 [self.tableView.mj_footer endRefreshing];
            }
        }else{
            [AlertView showYMAlertView:self.view andtitle:@"获取数据失败"];
             [self.tableView.mj_footer endRefreshing];
        }
       
       
    } failure:^(NSError *error) {
        [AlertView showYMAlertView:self.view andtitle:@"网络异常,请检查网络"];
        [self.tableView.mj_footer endRefreshing];
    }];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.selectType==0?self.investmentArray.count:self.motionArray.count;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    InvestmentListDetailController *vc = [[UIStoryboard storyboardWithName:@"Investment" bundle:nil] instantiateViewControllerWithIdentifier:@"InvestmentListDetailController"];
    vc.dataDic = self.investmentArray[indexPath.row];
    
    [self.navigationController pushViewController:vc animated:YES];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    InvestmentListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InvestmentListCell"];
    [cell.cellView makeCorner:5];
    NSDictionary *dic = self.selectType == 0 ?self.investmentArray[indexPath.row]:self.motionArray[indexPath.row];
    cell.titleLabel.text = self.selectType == 0?dic[@"projects_name"]: dic[@"interested_name"];
    cell.addressLabel.text = dic[@"projects_unit"];
    cell.moneyLabel.text = [NSString stringWithFormat:@"%@亿元",dic[@"investment_amount"]];
    NSArray *timeArray = [dic[@"release_time"] componentsSeparatedByString:@" "];
    cell.timeLabel.text = timeArray[0];
    if (![dic[@"picture"] isKindOfClass:[NSNull class]]) {
        
        NSArray *picArray = [dic[@"picture"] componentsSeparatedByString:@"|"];
        [cell.avatarImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?imageView2/2/w/200/h/200",AVATAR_HOST_URL,picArray.firstObject]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (error) {
                cell.avatarImage.contentMode = UIViewContentModeScaleAspectFit;
                [cell.avatarImage setImage:[UIImage imageNamed:@"default_avatar"]];
            }else{
                [cell.avatarImage setImage: image];
            }
        }];
    }else{
        [cell.avatarImage setImage:[UIImage imageNamed:@"default_avatar"]];
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 92;
}
-(ProjectTypeView *)projectTypeView{
    if (_projectTypeView == nil) {
        _projectTypeView = [[NSBundle mainBundle] loadNibNamed:@"InvestmentView" owner:self options:nil][0];
        _projectTypeView.typeArray = self.projectType;
        _projectTypeView.listVc = self;
        [_projectTypeView setupTableview];
        [self.view addSubview:_projectTypeView];
        _projectTypeView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, 0);
        
    }
    return _projectTypeView;
}

-(ProjectSelectView *)projectSelectView{
    if (_projectSelectView == nil) {
        _projectSelectView = [[NSBundle mainBundle] loadNibNamed:@"InvestmentView" owner:self options:nil][1];
        _projectSelectView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, ScreenW, 0);
        [_projectSelectView setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:_projectSelectView];
    }
    return _projectSelectView;
}
//-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
//    [self.navigationController setNavigationBarHidden:YES animated:NO];
//}

@end
