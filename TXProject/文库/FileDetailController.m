//
//  FileDetailController.m
//  TXProject
//
//  Created by Sam on 2019/3/27.
//  Copyright © 2019 sam. All rights reserved.
//
#import "FileCommentCell.h"
#import "FileDetailController.h"
#import "TXWebViewController.h"
#import "FileDetailHeader.h"
#import "MJRefresh.h"
#import "FileCommentView.h"
@interface FileDetailController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) FileDetailHeader *header;
@property (nonatomic) NSMutableArray *commentsArray;
@property (nonatomic) NSInteger nPage;
@property (nonatomic) FileCommentView *commentView;
@property (nonatomic) NSString *scoreString;
@end

@implementation FileDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(GetCommentMore)];
    self.tableView.mj_footer = footer;
    self.commentView.hidden = YES;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self GetNetData];
}
-(void)GetNetData{
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:self.dataDic[@"file_id"],@"file_id", nil];
    [HTTPREQUEST_SINGLE postWithURLString:SH_DETAIL_FILE parameters:param withHub:YES withCache:NO success:^(NSDictionary *responseDic) {
        if ([responseDic[@"code"] integerValue] == 1) {
            NSArray *arr = responseDic[@"data"];
            self.dataDic = arr.firstObject;
            self.tableView.tableHeaderView = self.header;
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
    self.nPage = 1;
    NSDictionary *param1 = [[NSDictionary alloc] initWithObjectsAndKeys:self.dataDic[@"file_id"],@"file_id",@"1",@"page", nil];
    [HTTPREQUEST_SINGLE postWithURLString:SH_LIST_COMMENTS parameters:param1 withHub:NO withCache:NO success:^(NSDictionary *responseDic) {
        if ([responseDic[@"code"] integerValue] == 1) {
            self.commentsArray = [NSMutableArray arrayWithCapacity:0];
            [self.commentsArray addObjectsFromArray: responseDic[@"data"]];
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}
-(void)GetCommentMore{
    self.nPage ++;
    NSDictionary *param1 = [[NSDictionary alloc] initWithObjectsAndKeys:self.dataDic[@"file_id"],@"file_id",[NSString stringWithFormat:@"%ld",self.nPage],@"page", nil];
    [HTTPREQUEST_SINGLE postWithURLString:SH_LIST_COMMENTS parameters:param1 withHub:NO withCache:NO success:^(NSDictionary *responseDic) {
        if ([responseDic[@"code"] integerValue] == 1) {
//            self.commentsArray = [NSMutableArray arrayWithCapacity:0];
            [self.commentsArray addObjectsFromArray: responseDic[@"data"]];
            [self.tableView reloadData];
            NSArray *arr = responseDic[@"data"];
            if (arr.count <= 0) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self.tableView.mj_footer endRefreshing];
            }
        }else{
            self.nPage --;
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
    return self.commentsArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = self.commentsArray[indexPath.row];
    return 100 - 14 + [CustomFountion getHeightLineWithString:dic[@"leave_message"] withWidth:(ScreenW - 40) withFont:[UIFont systemFontOfSize:12]];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FileCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FileCommentCell"];
    NSDictionary *dic = self.commentsArray[indexPath.row];
    cell.nameLabel.text = dic[@"member_name"];
    cell.commentLabel.text = [NSString stringWithFormat:@"评价：%@",dic[@"leave_message"]];
    NSString *score ;
    switch ([dic[@"score"] integerValue]) {
        case 1:
            score = @"好";
            break;
        case 2:
            score = @"一般";
            break;
        case 3:
            score = @"差";
            break;
        default:
            break;
    }
    cell.scoreLabel.text = [NSString stringWithFormat:@"评分：%@",score];
    NSArray *timeArr = [dic[@"score_time"] componentsSeparatedByString:@" "];
    cell.areaLabel.text = timeArr.firstObject;
    return cell;
}

-(FileDetailHeader *)header{
    if (_header == nil) {
        _header = [[NSBundle mainBundle] loadNibNamed:@"LibraryView" owner:self options:nil][0];
        _header.frame = CGRectMake(0, 0, ScreenW, 440);
        _header.fileName.text = self.dataDic[@"file_name"];
        NSArray *timeArr = [self.dataDic[@"release_time"] componentsSeparatedByString:@" "];
        _header.fileTime.text = timeArr.firstObject;
        _header.likeNumber.text = @"";
        _header.seeNumber.text = [NSString stringWithFormat:@"%ld",(long)[self.dataDic[@"browsing"] integerValue]];
        _header.downloadNumber.text = [NSString stringWithFormat:@"%ld",(long)[self.dataDic[@"download"] integerValue]];
        _header.baseMsg.text = [self.dataDic[@"file_introduction"] isKindOfClass:[NSNull class]]?@"":self.dataDic[@"file_introduction"];
        [_header.previewLabel makeCorner:5];
        [_header.commentLabel makeCorner:5];
        _header.baseMsg.layer.borderWidth = 1;
        _header.baseMsg.layer.borderColor = [UIColor colorWithRGB:0xf2f2f2].CGColor;
        [_header.previewLabel bk_whenTapped:^{
            [self GetLocalHTML:self.dataDic];
        }];
        [_header.commentLabel bk_whenTapped:^{
            self.commentView.hidden = NO;
        }];
    }
    return _header;
}

-(void)GetLocalHTML : (NSDictionary *)dic{
    NSDictionary *param = @{@"path":dic[@"file"]};
    [HTTPREQUEST_SINGLE postWithURLString:SH_FILE_PREVIEW parameters:param withHub:YES withCache:NO success:^(NSDictionary *responseDic) {
        if ([responseDic[@"code"] integerValue] == 1) {
            TXWebViewController *vc = [[UIStoryboard storyboardWithName:@"HomePage" bundle:nil] instantiateViewControllerWithIdentifier:@"TXWebViewController"];
            vc.localHTML = responseDic[@"data"];
            vc.intype = 34;
            vc.title = [dic[@"file_introduction"] isKindOfClass:[NSNull class]]?@"预览文档":dic[@"file_introduction"];
            [self.navigationController pushViewController:vc animated:YES];
        }
    } failure:^(NSError *error) {
        
    }];
}
-(FileCommentView *)commentView{
    if (_commentView == nil) {
        _commentView = [[NSBundle mainBundle] loadNibNamed:@"LibraryView" owner:self options:nil][1];
        [_commentView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.4] ];
        _commentView.contentTV.layer.borderWidth = 1;
        _commentView.contentTV.layer.borderColor = [UIColor colorWithRGB:0xf2f2f2].CGColor;
        [_commentView.cancelLabel makeCorner:5];
        [_commentView.sureLabel makeCorner:5];
        [_commentView.goodLabel bk_whenTapped:^{
            self.scoreString = @"1";
            self.commentView.goodLabel.textColor = [UIColor colorWithRGB:0x3e85fb];
            self.commentView.sosoLabel.textColor = [UIColor blackColor];
            self.commentView.badLabel.textColor = [UIColor blackColor];
        }];
        [_commentView.sosoLabel bk_whenTapped:^{
            self.scoreString = @"2";
            self.commentView.sosoLabel.textColor = [UIColor colorWithRGB:0x3e85fb];
            self.commentView.goodLabel.textColor = [UIColor blackColor];
            self.commentView.badLabel.textColor = [UIColor blackColor];
        }];
        [_commentView.badLabel bk_whenTapped:^{
            self.scoreString = @"3";
            self.commentView.badLabel.textColor = [UIColor colorWithRGB:0x3e85fb];
            self.commentView.sosoLabel.textColor = [UIColor blackColor];
            self.commentView.goodLabel.textColor = [UIColor blackColor];
        }];
        [_commentView.cancelLabel bk_whenTapped:^{
            self.commentView.hidden = YES;
        }];
        [_commentView.closeView bk_whenTapped:^{
            self.commentView.hidden = YES;
        }];
        [_commentView.sureLabel bk_whenTapped:^{
            NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:self.dataDic[@"file_id"],@"file_id",self.commentView.contentTV.text,@"leave_message",self.scoreString,@"score", nil];
            [HTTPREQUEST_SINGLE postWithURLString:SH_REPAY_COMMENTS parameters:param withHub:YES withCache:NO success:^(NSDictionary *responseDic) {
                if ([responseDic[@"code"] integerValue]== -1002) {
                    self.commentView.hidden = YES;
                    [self GetNetData];
                    
                }
            } failure:^(NSError *error) {
                
            }];
        }];
        [[UIApplication sharedApplication].keyWindow addSubview:_commentView];
        
    }
    return _commentView;
}
@end
