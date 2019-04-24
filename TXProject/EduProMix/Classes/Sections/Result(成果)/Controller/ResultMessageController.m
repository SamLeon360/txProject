//
//  ResultMessageController.m
//  TXProject
//
//  Created by Sam on 2019/4/18.
//  Copyright © 2019 sam. All rights reserved.
//

#import "ResultMessageController.h"
#import "ResultMessageModel.h"
#import "ResultMessageCell.h"
#import "ResultMessageViewModel.h"
#import "TSAchievementDetailViewController.h"
@interface ResultMessageController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *modelArray;
@property (nonatomic, strong) UIViewController *controller;

@property (nonatomic, strong) ResultMessageViewModel *contentVM;
@end

@implementation ResultMessageController

- (ResultMessageViewModel *)contentVM {
    
    if(!_contentVM){
        _contentVM = [[ResultMessageViewModel alloc]init];
    }
    return _contentVM;
    
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self.view addSubview:self.tableView];
        [self loadData];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"专家团队信息列表";
    
    // Do any additional setup after loading the view.
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ResultMessageModel *model = self.contentVM.modelArr[indexPath.row];
    
    if(![self.contentVM.model isEqual:[NSNull null]]) {
        TSAchievementDetailViewController *vc = [[TSAchievementDetailViewController alloc] init];
        vc.title = @"成果详细";
        vc.results_id = model.results_id;
        vc.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
    
    //    _contentVM.modelArr
    //    NSString *academy_id =  _contentVM.modelArr[indexPath.row].academy_id;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 136;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contentVM.modelArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ResultMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ResultMessageCell"];
    if(!cell){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ResultMessageCell" owner:self options:nil] objectAtIndex:0];
    }
    cell.model = self.contentVM.modelArr[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


- (void)loadData {
    
    [self.contentVM loadDataArrFromNetwork];
    
    RACSignal *recommendContentSignal = [self.contentVM.requestCommand execute:nil];
    @weakify(self);
    [[RACSignal combineLatest:@[recommendContentSignal]] subscribeNext:^(RACTuple *x) {
        
        @strongify(self);
        
        // 刷新tableView数据源
        [self.tableView reloadData];
        
    } error:^(NSError *error) {
        [AlertView showYMAlertView:self.view andtitle:@"网络异常，请检查网络"];
        //        [_contentTableView.mj_header endRefreshing];
    }];
}



- (UITableView *)tableView {
    if (!_tableView) {
        
        _tableView  = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH-64)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.separatorStyle = UITableViewCellEditingStyleNone;
        _tableView.backgroundColor = TSColor_RGB(235, 235, 235);
        
        [_tableView registerNib:[UINib nibWithNibName:@"ResultMessageCell" bundle:nil] forCellReuseIdentifier:@"ResultMessageCell"];
        
        //        UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        //        tableHeaderView.backgroundColor = [UIColor whiteColor];
        
        _tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        //        _tableView.tableHeaderView = tableHeaderView;
        
        
        
    }
    return _tableView;
}

- (NSMutableArray *)modelArray {
    if (!_modelArray) {
        
        _modelArray = [NSMutableArray array];
    }
    return _modelArray;
}

@end
