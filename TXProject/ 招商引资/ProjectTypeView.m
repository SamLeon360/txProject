//
//  ProjectTypeView.m
//  TXProject
//
//  Created by Sam on 2019/3/4.
//  Copyright © 2019 sam. All rights reserved.
//

#import "ProjectTypeView.h"
#import "ProjectTypeCell.h"
@interface ProjectTypeView()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation ProjectTypeView
-(void)setupTableview{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"ProjectTypeCell" bundle:nil] forCellReuseIdentifier:@"ProjectTypeCell"];
    [self.tableView reloadData];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.typeArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ProjectTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProjectTypeCell"];
    cell.typeLabel.text = self.typeArray[indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  40;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.listVc.selectTypeIndex = indexPath.row;
    self.listVc.nPage = 1;
    NOTIFY_POST(@"getinvestmentArrayByRefresh");
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, ScreenW, 0);
    }];
}

@end
