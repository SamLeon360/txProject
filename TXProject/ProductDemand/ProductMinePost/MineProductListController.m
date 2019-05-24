//
//  MineProductListController.m
//  TXProject
//
//  Created by Sam on 2019/4/6.
//  Copyright © 2019 sam. All rights reserved.
//

#import "MineProductListController.h"
#import "MineProductCell.h"
#import "MJRefresh.h"
#import "UploadProductionController.h"
@interface MineProductListController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *myPostLB;
@property (weak, nonatomic) IBOutlet UILabel *otherPostLB;
@property (weak, nonatomic) IBOutlet UIImageView *bottomLine;
@property (weak, nonatomic) IBOutlet UITextField *searchTF;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSMutableArray *proArray;
@property (nonatomic) NSArray *typeArray;
@property (nonatomic) NSInteger listType;///1 : 我发布 , 2 : 别人发布
@property (nonatomic) NSInteger nPage;
@end

@implementation MineProductListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.listType = 1;
    self.typeArray = @[@"全部", @"组件零部件",@"文化教育创意",@"酒店旅游餐饮",@"食品饮料",@"医疗保健",@"家电家居",@"冶金能源环保",@"化学化工",@"汽车工业",@"其他"];
    self.title = @"产品需求信息";
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(GetProductionDataMore)];
    self.tableView.mj_footer = footer;
    self.tableView.tableFooterView = [[UIView alloc] init];
    __block MineProductListController *blockSelf = self;
    [self.myPostLB bk_whenTapped:^{
        __block MineProductListController *blockblockSelf= blockSelf;
        [UIView animateWithDuration:0.3 animations:^{
            blockblockSelf.bottomLine.center = CGPointMake(blockblockSelf.myPostLB.center.x,  blockblockSelf.myPostLB.frame.size.height-blockblockSelf.bottomLine.frame.size.height);
        }];
        blockSelf.listType = 1;
        [blockSelf GetProductionData];
    }];
    [self.searchBtn bk_whenTapped:^{
        [blockSelf GetProductionData];
    }];
    [self.otherPostLB bk_whenTapped:^{
        __block MineProductListController *blockblockSelf= blockSelf;
        [UIView animateWithDuration:0.3 animations:^{
            blockblockSelf.bottomLine.center = CGPointMake(blockblockSelf.otherPostLB.center.x,  blockblockSelf.otherPostLB.frame.size.height-blockblockSelf.bottomLine.frame.size.height);
        }];
        blockSelf.listType = 2;
        [blockSelf GetProductionData];
    }];
    [self GetProductionData];
}

-(void)GetProductionData{
    self.nPage = 1;
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:@"",@"allow_publish",USER_SINGLE.default_commerce_id,@"commerce_id",  @"1",@"page", self.searchTF.text,@"product_name", @"",@"product_order",@"",@"product_type",[NSString stringWithFormat:@"%ld",self.listType],@"change_select",nil];
    [HTTPREQUEST_SINGLE postWithURLString:SH_PRODUCTION_LIST parameters:param withHub:YES withCache:NO success:^(NSDictionary *responseDic) {
        if ([responseDic[@"code"] integerValue] == 1) {
            self.proArray = responseDic[@"data"];
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)GetProductionDataMore{
    self.nPage ++;
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:@"",@"allow_publish",USER_SINGLE.default_commerce_id,@"commerce_id",  @"1",@"page", self.searchTF.text,@"product_name", @"",@"product_order",@"",@"product_type",[NSString stringWithFormat:@"%ld",self.listType],@"change_select",nil];
    [HTTPREQUEST_SINGLE postWithURLString:SH_PRODUCTION_LIST parameters:param withHub:YES withCache:NO success:^(NSDictionary *responseDic) {
        if ([responseDic[@"code"] integerValue] == 1) {
             [self.tableView.mj_footer endRefreshing];
            [self.proArray addObjectsFromArray: responseDic[@"data"]];
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
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.proArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MineProductCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineProductCell"];
    NSDictionary *dic = self.proArray[indexPath.row];
    
    cell.titleLB.text = dic[@"product_name"];
    cell.typeLB.text = self.typeArray[[dic[@"product_type"] integerValue]];
    cell.needNumberLB.text = [NSString stringWithFormat:@"%@%@",[NSString stringWithFormat:@"%@",dic[@"need_number"]],dic[@"product_unit"]];
    
    cell.threeView.hidden = self.listType == 1 ? NO : YES;
    cell.twoView.hidden = self.listType == 1 ? YES : NO;
    
    
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = self.proArray[indexPath.row];
    UploadProductionController *vc = [[UIStoryboard storyboardWithName:@"Production" bundle:nil] instantiateViewControllerWithIdentifier:@"UploadProductionController"];
    vc.editDic = dic;
    [self.navigationController pushViewController:vc animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 155;
}

@end
