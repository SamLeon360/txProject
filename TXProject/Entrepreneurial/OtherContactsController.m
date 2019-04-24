//
//  OtherContactsController.m
//  TXProject
//
//  Created by Sam on 2019/4/17.
//  Copyright © 2019 sam. All rights reserved.
//

#import "OtherContactsController.h"
#import "OtherContactCell.h"
@interface OtherContactsController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSArray *contactArray;
@end

@implementation OtherContactsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"联系方式";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.contactArray = @[@{@"image":@"phone",@"title":@"联系电话",@"content":[NSString stringWithFormat:@"电话：%@",self.dataDic[@"telephone"]]},@{@"image":@"qq",@"title":@"QQ",@"content":[NSString stringWithFormat:@"QQ：%@",[self.dataDic[@"qq"] isKindOfClass:[NSNull class]]?@"无":self.dataDic[@"qq"]]},
        @{@"image":@"wx",@"title":@"微信",@"content":[NSString stringWithFormat:@"微信：%@",[self.dataDic[@"weixin"] isKindOfClass:[NSNull class]]?@"无":self.dataDic[@"weixin"]]},
       @{@"image":@"letter",@"title":@"发送邮箱",@"content":[NSString stringWithFormat:@"邮箱：%@",[self.dataDic[@"email"] isKindOfClass:[NSNull class]]?@"无":self.dataDic[@"email"]]},
    @{@"image":@"position",@"title":@"公司邮箱",@"content":[NSString stringWithFormat:@"地址：%@",[self.dataDic[@"address"] isKindOfClass:[NSNull class]]?@"无":self.dataDic[@"address"]]}];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.contactArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 77;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OtherContactCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OtherContactCell"];
    NSDictionary *dic = self.contactArray[indexPath.row];
    cell.cellTitle.text = dic[@"title"];
    cell.cellContent.text = dic[@"content"];
    [cell.cellIcon setImage:[UIImage imageNamed:dic[@"image"]]];
    return cell;
}


@end
