//
//  JobSelectView.m
//  TXProject
//
//  Created by Sam on 2019/3/28.
//  Copyright © 2019 sam. All rights reserved.
//
#import "JobStringCell.h"
#import "JobSelectView.h"
@interface JobSelectView()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic) BOOL type;
@property (nonatomic) NSString *indexString;
@property (nonatomic) NSMutableArray *dataArr;
@property (nonatomic) NSMutableArray *welfareArray;
@end

@implementation JobSelectView
-(void)setupTableView{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.indexString = @"";
    self.welfareArray = [NSMutableArray arrayWithCapacity:0];
    [self.tableView registerNib:[UINib nibWithNibName:@"JobCell" bundle:nil] forCellReuseIdentifier:@"JobStringCell"];
    [self.tableView reloadData];
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.sureLabel bk_whenTapped:^{
        self.hidden = YES;
        if (!self.muSelect) {
            if (self.type) {
                 self.selectStringCallBack(self.indexString);
            }else{
                NSDictionary *dic = self.dataArray[[self.indexString integerValue]-1];
                self.selectStringCallBack(dic[@"enterprise_id"]);
            }
            
        }else{
            if (self.indexString.length > 0) {
                self.indexString = @"";
                for (int i = 0 ; i< self.welfareArray.count; i++) {
                    if (i == 0) {
                        self.indexString = self.welfareArray[0];
                    }else{
                        self.indexString = [self.indexString stringByAppendingString:[NSString stringWithFormat:@"|%@",self.welfareArray[i]]];
                    }
                }
                self.selectStringCallBack(self.indexString);
            }else{
                self.selectStringCallBack(@"");
            }
        }
        
    }];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JobStringCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JobStringCell"];
    if ([self.dataArray[indexPath.row] isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dic = self.dataArray[indexPath.row];
        cell.cellString.text = dic[@"enterprise_name"];
    }else{
        cell.cellString.text = self.dataArray[indexPath.row];
    }
    if (self.muSelect) {
        if (self.indexString.length != 0) {
           
            [cell.cellString setTextColor:[UIColor blackColor]];
            for (NSString *index in self.welfareArray) {
                if ([index integerValue] == indexPath.row) {
                    [cell.cellString setTextColor:[UIColor colorWithRGB:0x3E85FB]];
                }
            }
        }
        
    }else{
        if (![self.indexString isEqualToString:@""] && [self.indexString integerValue]-1 == indexPath.row) {
            [cell.cellString setTextColor:[UIColor colorWithRGB:0x3E85FB]];
        }else{
            [cell.cellString setTextColor:[UIColor blackColor]];
        }
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.dataArray[indexPath.row] isKindOfClass:[NSDictionary class]]) {
        self.type = NO;
        
        self.indexString =  [NSString stringWithFormat:@"%d",indexPath.row+1];
    }else{
        self.type = YES;
        if (!self.muSelect) {
            self.indexString =[NSString stringWithFormat:@"%ld",(long)(indexPath.row+1)];
        }else{
            if (self.indexString.length <= 0) {
                self.indexString = [self.indexString stringByAppendingString:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
            }else{
                JobStringCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                if (cell.cellString.textColor == [UIColor blackColor]) {
                    [self.welfareArray addObject:[NSString stringWithFormat:@"%ld",indexPath.row]];
                }else{
                    [self.welfareArray removeObject:[NSString stringWithFormat:@"%ld",indexPath.row]];
                }
                
            }
            
        }
        
    }
    [self.tableView reloadData];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}



@end
