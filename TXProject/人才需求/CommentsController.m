//
//  CommentsController.m
//  TXProject
//
//  Created by Sam on 2019/3/26.
//  Copyright © 2019 sam. All rights reserved.
//

#import "CommentsController.h"
#import "CommentCell.h"
@interface CommentsController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *commentNumber;
@property (weak, nonatomic) IBOutlet UITextField *commentTF;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *submitLabel;
@property (nonatomic) NSArray *commentArray;
@end

@implementation CommentsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.title = @"留言信息";
    [self.submitLabel bk_whenTapped:^{
        NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:@"",@"academy_id",self.commentTF.text,@"content",self.dataDic[@"talent_id"],@"demand_id",self.dataDic[@"job_name"],@"demand_name",@"4",@"msg_type", self.dataDic[@"member_id"],@"receiver_id", @"2",@"role_type", @"",@"son_id",@"1",@"page", nil];
        [HTTPREQUEST_SINGLE postWithURLString:SH_COMMENT_REPAY parameters:param withHub:YES withCache:NO success:^(NSDictionary *responseDic) {
            if ([responseDic[@"code"] integerValue] == -1002) {
                [self GetCommentData];
                self.commentTF.text = @"";
                
            }
        } failure:^(NSError *error) {
            
        }];
    }];
    [self GetCommentData];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.commentArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = self.commentArray[indexPath.row];
    CGFloat labelHeight = [CustomFountion getHeightLineWithString:dic[@"content"] withWidth:(ScreenW - 30) withFont:[UIFont systemFontOfSize:13]];
    if (labelHeight > 26) {
        return 100 - 26 + labelHeight;
    }else{
       return  100;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = self.commentArray[indexPath.row];
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell"];
    cell.name.text = dic[@"member_name"];
    [cell.avatar sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@/%@.jpg",@"https://app.tianxun168.com/uploads/mem_info/",dic[@"sender_id"],dic[@"sender_id"]]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (error) {
            [cell.avatar setImage:[UIImage imageNamed:@"default_avatar"]];
        }
    }];
    cell.comment.text = dic[@"content"];
    cell.time.text = [NSString stringWithFormat:@"%@",dic[@"create_time"]] ;
    return cell;
}
-(void)GetCommentData {
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:self.dataDic[@"talent_id"],@"demand_id",@"4",@"msg_type", nil];
    [HTTPREQUEST_SINGLE postWithURLString:SH_COMMENT_LIST parameters:param withHub:YES withCache:NO success:^(NSDictionary *responseDic) {
        if ([responseDic[@"code"] integerValue] == 0) {
            self.commentArray = responseDic[@"data"];
            self.commentNumber.text = [NSString stringWithFormat:@"全部留言 : %ld条",self.commentArray.count];
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}



@end
