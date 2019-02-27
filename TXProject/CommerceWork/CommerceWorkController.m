//
//  CommerceWorkController.m
//  TXProject
//
//  Created by Sam on 2019/1/15.
//  Copyright © 2019 sam. All rights reserved.
//

#import "CommerceWorkController.h"
#import "CommerceWorkCell.h"
@interface CommerceWorkController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSArray *serverNameArray;
@property (nonatomic,strong) NSArray *serverImageArray;
@end

@implementation CommerceWorkController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource  = self;
    self.title = @"社团工作";
    self.serverNameArray = @[@"办公管理",@"日常工作"];
    self.serverImageArray = @[@[ @{@"image":@"Membership",@"title":@"会费管理"},@{@"image":@"cooperation",@"title":@"商务合作"},@{@"image":@"inter",@"title":@"入会审核"}],@[@{@"image":@"Notes",@"title":@"社团事记"},@{@"image":@"Council",@"title":@"理、监事会"},@{@"image":@"upload",@"title":@"文件上传"}]];
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
    if (indexPath.row == self.serverNameArray.count - 1) {
        return 125*2 + 50;
    }
    return 175;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommerceWorkCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"CommerceWorkCell"];
    NSArray *serverCellArray = self.serverImageArray[indexPath.row];
    cell.serverVC = self;
    cell.typeIndex = indexPath.row;
    cell.serverArray = serverCellArray;
    [cell setupArray];
    cell.serverNameLabel.text = self.serverNameArray[indexPath.row];
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
