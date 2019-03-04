//
//  InvestmentListController.m
//  TXProject
//
//  Created by Sam on 2019/3/1.
//  Copyright © 2019 sam. All rights reserved.
//

#import "InvestmentListController.h"
#import "InvestmentListCell.h"
@interface InvestmentListController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *investmentLabel;
@property (weak, nonatomic) IBOutlet UILabel *haveMotionLabel;
@property (weak, nonatomic) IBOutlet UILabel *postView;
@property (weak, nonatomic) IBOutlet UILabel *jobTypeView;
@property (weak, nonatomic) IBOutlet UILabel *selectView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSInteger selectType;

@property (nonatomic) NSMutableArray *investmentArray;///招商引资
@property (nonatomic) NSMutableArray *motionArray;///有意向
@end

@implementation InvestmentListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.investmentArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    InvestmentListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InvestmentListCell"];
    [cell.cellView makeCorner:5];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 92;
}


@end
