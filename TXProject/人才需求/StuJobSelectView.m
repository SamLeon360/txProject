//
//  StuJobSelectView.m
//  TXProject
//
//  Created by Sam on 2019/3/21.
//  Copyright © 2019 sam. All rights reserved.
//
#import "SelectCell.h"
#import "StuJobSelectView.h"
@interface StuJobSelectView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic) NSInteger selectIndex;
@end
@implementation StuJobSelectView
-(void)setupTableView{
    [self.oneTableView registerNib:[UINib nibWithNibName:@"SelectCell" bundle:nil] forCellReuseIdentifier:@"SelectCell"];
    [self.twoTableView registerNib:[UINib nibWithNibName:@"SelectCell" bundle:nil] forCellReuseIdentifier:@"SelectCell"];
    self.oneTableView.delegate = self;
    self.oneTableView.dataSource = self;
    self.twoTableView.delegate = self;
    self.twoTableView.dataSource = self;
    [self.oneTableView reloadData];
    [self.twoTableView reloadData];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == 1) {
        return self.oneArray.count;
    }else{
        return self.twoArray.count;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 1) {
        SelectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SelectCell"];
        cell.titleLabel.text = self.oneArray[indexPath.row];
        return cell;
    }else{
        SelectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SelectCell"];
        cell.titleLabel.text = self.twoArray[indexPath.row];
        if (self.selectIndex == indexPath.row) {
            cell.backgroundColor = [UIColor colorWithRGB:0x3E85FB];
            cell.titleLabel.textColor = [UIColor whiteColor];
        }else{
            cell.backgroundColor = [UIColor whiteColor];
            cell.titleLabel.textColor = [UIColor darkTextColor];
        }
        return cell;
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView.tag == 2) {
        self.selectIndex = indexPath.row;
        switch (self.viewType) {
            case 1:{
                self.studentVc.jobTypeString = indexPath.row==0?@"": [NSString stringWithFormat:@"%ld",indexPath.row];
            }break;
            case 2:{
                
                self.studentVc.educationString = indexPath.row==0?@"": [NSString stringWithFormat:@"%ld",indexPath.row];
            }break;
            case 3:{
                self.studentVc.jobTimeString = indexPath.row==0?@"": [NSString stringWithFormat:@"%ld",indexPath.row];
            }break;
                
            default:
                break;
        }
        self.hidden = YES;
        [self.twoTableView reloadData];
        [self.studentVc GetNetData];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
@end
