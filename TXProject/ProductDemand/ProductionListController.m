//
//  ProductionListController.m
//  TXProject
//
//  Created by Sam on 2019/3/21.
//  Copyright © 2019 sam. All rights reserved.
//

#import "ProductionListController.h"
#import "ProductionListCell.h"
#import "ProductionPXView.h"
#import "ProductionSelectView.h"
#import "MJRefresh.h"
#import "BottomView.h"
#import "ProductionDetail/ProductionDetailController.h"
#import "UploadProductionController.h"
#import "ProListSearchController.h"
@interface ProductionListController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *searchTF;
@property (weak, nonatomic) IBOutlet UILabel *pxLabel;
@property (weak, nonatomic) IBOutlet UILabel *selectLabel;
@property (weak, nonatomic) IBOutlet UIView *popView;
@property (nonatomic) BottomView *bottomBtn;
@property (nonatomic) NSString *pxString;
@property (nonatomic) NSString *typeString;
@property (nonatomic) NSString *searchString;
@property (nonatomic) NSMutableArray *productionArray;
@property (nonatomic) ProductionPXView *pxView;
@property (nonatomic) ProductionSelectView *selectView;
@property (nonatomic) NSInteger nPage;
@property (nonatomic) NSArray *typeArray;
@property (weak, nonatomic) IBOutlet UIView *searchView;

@end

@implementation ProductionListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.nPage = 1;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.title = @"产品需求服务";
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    NOTIFY_ADD(GetProductionData, @"GetProductionData");
    [self GetProductionData];
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(GetProductionDataMore)];
    self.tableView.mj_footer = footer;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.typeArray = @[@"全部", @"组件零部件",@"文化教育创意",@"酒店旅游餐饮",@"食品饮料",@"医疗保健",@"家电家居",@"冶金能源环保",@"化学化工",@"汽车工业",@"其他"];
    self.pxView.hidden = YES;
    self.selectView.hidden = YES;
    __block ProductionListController *blockSelf = self;
    [self.selectLabel bk_whenTapped:^{
        blockSelf.selectView.hidden = !blockSelf.selectView.hidden;
    }];
    
    [self.pxLabel bk_whenTapped:^{
        blockSelf.pxView.hidden = !blockSelf.pxView.hidden;
    }];
    [self.popView bk_whenTapped:^{
        [blockSelf.navigationController popViewControllerAnimated:YES];
    }];
    [self.searchView bk_whenTapped:^{
        ProListSearchController *vc = [[UIStoryboard storyboardWithName:@"Production" bundle:nil] instantiateViewControllerWithIdentifier:@"ProListSearchController"];
        vc.selectStringCallBack = ^(NSString *str) {
            self.searchTF.text = str;
            [self GetProductionData];
        };
        [blockSelf.navigationController pushViewController:vc animated:YES];
    }];
    [self.view addSubview:self.bottomBtn];
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 85)];
    self.tableView.tableFooterView = footerView;
    [self.bottomBtn makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@45);
        make.width.equalTo(@188);
        make.bottom.equalTo(@(-40));
        make.centerX.equalTo(@0);
    }];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.productionArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ProductionListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProductionListCell"];
    NSDictionary *dic = self.productionArray[indexPath.row];
    cell.title.text = dic[@"product_name"];
    cell.type.text = self.typeArray[[dic[@"product_type"] integerValue]];
    cell.number.text = [NSString stringWithFormat:@"%@%@",[NSString stringWithFormat:@"%@",dic[@"need_number"]],dic[@"product_unit"]];
    NSArray *picArray = [dic[@"avatar"] isKindOfClass:[NSNull class]]?@[]:dic[@"avatar"];
    if (picArray.count > 0) {
        [cell.proImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",AVATAR_HOST_URL,picArray.firstObject]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
    }
//
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 115;
}
-(void)GetProductionData{
    self.nPage = 1;
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:@"",@"allow_publish",USER_SINGLE.default_commerce_id,@"commerce_id",  @"1",@"page", self.searchTF.text,@"product_name", self.pxString==nil?@"":self.pxString,@"product_order", self.typeString==nil?@"":self.typeString,@"product_type",@"0",@"change_select",nil];
    [HTTPREQUEST_SINGLE postWithURLString:SH_PRODUCTION_LIST parameters:param withHub:YES withCache:NO success:^(NSDictionary *responseDic) {
        if ([responseDic[@"code"] integerValue] == 1) {
            self.productionArray = responseDic[@"data"];
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ProductionDetailController *vc =[[UIStoryboard storyboardWithName:@"Production" bundle:nil] instantiateViewControllerWithIdentifier:@"ProductionDetailController"];
    vc.selectData = self.productionArray[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)GetProductionDataMore{
    self.nPage ++;
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:@"",@"allow_publish",@"",@"commerce_id", @"",@"ios", [NSString stringWithFormat:@"%ld",(long)self.nPage],@"page", self.searchTF.text,@"product_name", self.pxString,@"product_order", self.typeString,@"product_type",@"0",@"change_select",nil];
    [HTTPREQUEST_SINGLE postWithURLString:SH_PRODUCTION_LIST parameters:param withHub:YES withCache:NO success:^(NSDictionary *responseDic) {
        if ([responseDic[@"code"] integerValue] == 1) {
             [self.tableView.mj_footer endRefreshing];
            [self.productionArray addObjectsFromArray: responseDic[@"data"]];
            [self.tableView reloadData];
            NSArray *arr = responseDic[@"data"];
            if (arr.count <= 0) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }else{
            self.nPage -- ;
             [self.tableView.mj_footer endRefreshing];
        }
       
        
    } failure:^(NSError *error) {
        self.nPage --;
        [self.tableView.mj_footer endRefreshing];
    }];
}
-(ProductionPXView *)pxView{
    if (_pxView == nil) {
        _pxView = [[NSBundle mainBundle] loadNibNamed:@"ProductAlert" owner:self options:nil][5];
        _pxView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, ScreenW, ScreenH);
        _pxView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        __block ProductionListController *blockSelf = self;
        [_pxView.newest bk_whenTapped:^{
            blockSelf.pxString = @"desc";
            blockSelf.pxView.newsIcon.hidden = NO;
            blockSelf.pxView.firstIcon.hidden = YES;
            [blockSelf GetProductionData];
            blockSelf.pxView.hidden = YES;
        }];
        [_pxView.thefirst bk_whenTapped:^{
            blockSelf.pxString = @"asc";
            blockSelf.pxView.newsIcon.hidden = YES;
            blockSelf.pxView.firstIcon.hidden = NO;
            [blockSelf GetProductionData];
            blockSelf.pxView.hidden = YES;
        }];
        [self.view addSubview:_pxView];
    }
    return _pxView;
}
-(ProductionSelectView *)selectView{
    if (_selectView == nil) {
        _selectView = [[NSBundle mainBundle] loadNibNamed:@"ProductAlert" owner:self options:nil][6];
        _selectView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        _selectView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, ScreenW, ScreenH - self.tableView.frame.origin.y);
        _selectView.dataArray = self.typeArray;
        _selectView.hidden = YES;
        [self.view addSubview:_selectView];
        
        [_selectView setupCollection];
        __block ProductionListController *blockSelf = self;
        [_selectView.closeIcon bk_whenTapped:^{
            blockSelf.selectView.hidden = YES;
        }];
        _selectView.selectStringCallBack = ^(NSString * _Nonnull str) {
            blockSelf.typeString = [NSString stringWithFormat:@"%lu",(unsigned long)[blockSelf.typeArray indexOfObject:str]];
            [blockSelf GetProductionData];
        };
        
        
    }
    return _selectView;
}
-(BottomView *)bottomBtn{
    if (_bottomBtn == nil) {
        _bottomBtn = [[NSBundle mainBundle] loadNibNamed:@"CommerceList" owner:self options:nil][6];
        __block ProductionListController *blockSelf = self;
        _bottomBtn.titleLabel.text = @"发布需求";
        [_bottomBtn makeCorner:45/2];
        [_bottomBtn bk_whenTapped:^{
            UploadProductionController *vc = [[UIStoryboard storyboardWithName:@"Production" bundle:nil] instantiateViewControllerWithIdentifier:@"UploadProductionController"];
            [blockSelf.navigationController pushViewController:vc animated:YES];
        }];
    }
    return _bottomBtn;
}

@end
