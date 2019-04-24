//
//  HomeServerController.m
//  TXProject
//
//  Created by Sam on 2018/12/26.
//  Copyright © 2018年 sam. All rights reserved.
//

#import "HomeServerController.h"
#import "HomeServerCell.h"
#import "SameCityCommerceController.h"
@interface HomeServerController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSArray *serverNameArray;
@property (nonatomic,strong) NSArray *serverImageArray;
@end

@implementation HomeServerController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"天寻应用";
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRGB:0x3e85fb];
    self.navigationController.navigationBar.titleTextAttributes= @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:18]};
    self.tableView.delegate = self;
    self.tableView.dataSource  = self;
//    self.serverNameArray = SHOW_WEB?@[@"人脉社交",@"商务信息",@"文库",@"企业商务服务"]:@[@"人脉社交"];
    
    ///
    self.serverNameArray = @[@"人脉社交",@"商务信息"];//
    self.serverImageArray = @[@[@{@"image":@"ren_icon_1",@"title":@"同籍社团"},@{@"image":@"ren_icon_2",@"title":@"同城社团"}],@[@{@"image":@"chan_icon_1",@"title":@"产品需求信息"},@{@"image":@"chan_icon_2",@"title":@"服务需求信息"}]];
//    self.serverImageArray =
//    SHOW_WEB? @[@[ @{@"image":@"ren_icon_1",@"title":@"同籍社团"},@{@"image":@"ren_icon_2",@"title":@"同城社团"},@{@"image":@"ren_icon_3",@"title":@"行业查找"}],@[@{@"image":@"chan_icon_1",@"title":@"产品需求信息"},@{@"image":@"chan_icon_2",@"title":@"服务需求信息"}],@[@{@"image":@"wen_icon_1",@"title":@"社团文库"},@{@"image":@"wen_icon_2",@"title":@"企业文库"}],@[@{@"image":@"qi_icon_1",@"title":@"企业管理"},@{@"image":@"qi_icon_2",@"title":@"基地"},@{@"image":@"qi_icon_3",@"title":@"工作"},@{@"image":@"qi_icon_4",@"title":@"实习审核"},@{@"image":@"qi_icon_5",@"title":@"实习需求"},@{@"image":@"qi_icon_6",@"title":@"项目合作"}]]:;
    [self.tableView reloadData];
}
-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.serverNameArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.row == self.serverNameArray.count - 1) {
//        return 125*2 + 50;
//    }
    return 125*kScale + 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeServerCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"HomeServerCell"];
    NSArray *serverCellArray = self.serverImageArray[indexPath.row];
    cell.serverVC = self;
    cell.typeIndex = indexPath.row;
    cell.serverArray = serverCellArray;
    [cell setupArray];
    cell.serverNameLabel.text = self.serverNameArray[indexPath.row];
    return cell;
}


@end
