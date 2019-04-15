//
//  LibraryListController.m
//  TXProject
//
//  Created by Sam on 2019/3/26.
//  Copyright © 2019 sam. All rights reserved.
//

#import "LibraryListController.h"
#import "ProjectTypeView.h"
#import "LibraryListCell.h"
#import "MJRefresh.h"
#import <QuickLook/QuickLook.h>
#import "TXWebViewController.h"
#import "FileDetailController.h"
@interface LibraryListController ()<UITableViewDelegate,UITableViewDataSource,QLPreviewControllerDataSource>
@property (weak, nonatomic) IBOutlet UITextField *searchTF;
@property (weak, nonatomic) IBOutlet UILabel *libType;
@property (weak, nonatomic) IBOutlet UILabel *libGeshi;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) ProjectTypeView *libTypeView;
@property (nonatomic) ProjectTypeView *libGeshiView;
@property (nonatomic) NSMutableArray *libArray;
@property (nonatomic) NSString *libTypeIndex;
@property (nonatomic) NSString *libGeshiIndex;
@property (nonatomic) NSInteger nPage;
@property (nonatomic) NSString *documentURL;
@end

@implementation LibraryListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.nPage = 1;
    self.title = [self.libraryVCType integerValue] == 1?@"社团文库":@"企业文库";
    self.libTypeIndex = @"";
    self.libGeshiIndex = @"";
    [self getNetData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNetData) name:@"LibraryNetData" object:nil];
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getNetDataMore)];
    self.tableView.mj_footer = footer;
    __block LibraryListController *blockSelf = self;
    [self.libType bk_whenTapped:^{
        blockSelf.libTypeView.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            blockSelf.libTypeView.frame = CGRectMake(blockSelf.libTypeView.frame.origin.x, blockSelf.libTypeView.frame.origin.y, ScreenW, blockSelf.tableView.frame.size.height);
        }];
        [UIView animateWithDuration:0.3 animations:^{
            blockSelf.libGeshiView.frame = CGRectMake(blockSelf.libGeshiView.frame.origin.x, blockSelf.libGeshiView.frame.origin.y, ScreenW, 0);
        }];
    }];
    [self.libGeshi bk_whenTapped:^{
        blockSelf.libGeshiView.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            blockSelf.libGeshiView.frame = CGRectMake(blockSelf.libGeshiView.frame.origin.x, blockSelf.libGeshiView.frame.origin.y, ScreenW, blockSelf.tableView.frame.size.height);
        }];
        
        [UIView animateWithDuration:0.3 animations:^{
            blockSelf.libTypeView.frame = CGRectMake(blockSelf.libTypeView.frame.origin.x, blockSelf.libTypeView.frame.origin.y, ScreenW, 0);
        }];
    }];
    [self.searchBtn bk_whenTapped:^{
        [blockSelf getNetData];
    }];
}
-(void)getNetData{
    self.nPage = 1;
    __block LibraryListController *blockSelf = self;
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:self.libGeshiIndex,@"file_extension",self.searchTF.text,@"file_name",self.libTypeIndex,@"file_type",@"",@"ios",self.libraryVCType,@"library_type",@"-1",@"member_id",@"1",@"page",@"0",@"_search_type", nil];
    [HTTPREQUEST_SINGLE postWithURLString:SH_FILE_LIST parameters:param withHub:YES withCache:NO success:^(NSDictionary *responseDic) {
        if ([responseDic[@"code"] integerValue] == 1) {
            blockSelf.libArray = [NSMutableArray arrayWithCapacity:0];
            [blockSelf.libArray addObjectsFromArray:responseDic[@"data"]];
            [blockSelf.tableView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}
-(void)getNetDataMore{
    __block LibraryListController *blockSelf = self;
    self.nPage ++;
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:self.libGeshiIndex,@"file_extension",self.searchTF.text,@"file_name",self.libTypeIndex,@"file_type",@"",@"ios",self.libraryVCType,@"library_type",@"-1",@"member_id",[NSString stringWithFormat:@"%ld",self.nPage],@"page",@"0",@"_search_type", nil];
    [HTTPREQUEST_SINGLE postWithURLString:SH_FILE_LIST parameters:param withHub:YES withCache:NO success:^(NSDictionary *responseDic) {
        if ([responseDic[@"code"] integerValue] == 1) {
            [blockSelf.libArray addObjectsFromArray:responseDic[@"data"]];
            [blockSelf.tableView reloadData];
            NSArray *arr = responseDic[@"data"];
            if (arr.count <= 0) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [blockSelf.tableView.mj_footer endRefreshing];
            }
        }else{
            blockSelf.nPage --;
            [blockSelf.tableView.mj_footer endRefreshing];
        }
        
    } failure:^(NSError *error) {
         blockSelf.nPage --;
        [blockSelf.tableView.mj_footer endRefreshing];
    }];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.libArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LibraryListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LibraryListCell"];
    cell.outView.layer.borderWidth = 1;
    cell.outView.layer.borderColor = [UIColor colorWithRGB:0xf2f2f2].CGColor;
    [cell.outView makeCorner:5];
    NSDictionary *dic = self.libArray[indexPath.row];
    cell.title.text = [NSString stringWithFormat:@"文件名：%@",dic[@"file_name"]];
    cell.downloadCount.text = [NSString stringWithFormat:@"下载次数：%ld",(long)[dic[@"download"] integerValue]];
    [cell.checkLabel makeCorner:5];
//    [cell.downloadLabel makeCorner:5];
    [cell.checkDetailLabel makeCorner:5];
    __block LibraryListController *blockSelf = self;
    [cell.checkLabel bk_whenTapped:^{
        NSIndexPath *index = [blockSelf.tableView indexPathForCell:cell];
        NSDictionary *dic = blockSelf.libArray[index.row];
        [blockSelf GetLocalHTML:dic];
    }];
    [cell.checkDetailLabel bk_whenTapped:^{
        FileDetailController *vc = [[UIStoryboard storyboardWithName:@"Library" bundle:nil] instantiateViewControllerWithIdentifier:@"FileDetailController"];
        NSIndexPath *index = [blockSelf.tableView indexPathForCell:cell];
        NSDictionary *dic = blockSelf.libArray[index.row];
        vc.dataDic = dic;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    return cell;
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
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 143;
}
-(ProjectTypeView *)libTypeView{
    if (_libTypeView == nil) {
        _libTypeView = [[NSBundle mainBundle] loadNibNamed:@"InvestmentView" owner:self options:nil][0];
        _libTypeView.frame = CGRectMake(0, 90, self.tableView.frame.size.width, self.tableView.frame.size.height);
        [[UIApplication sharedApplication].keyWindow addSubview:_libTypeView];
        _libTypeView.hidden = YES;
        _libTypeView.typeArray = @[@"全部",@"策划方案",@"发言稿",@"管理制度",@"常用表格",@"其他"];
        _libTypeView.mainLabel.text = @"文件类型";
        [_libTypeView setupTableview];
        _libTypeView.functionName = @"LibraryNetData";
        
    }
    return _libTypeView;
}
-(ProjectTypeView *)libGeshiView{
    if (_libGeshiView == nil) {
        _libGeshiView = [[NSBundle mainBundle] loadNibNamed:@"InvestmentView" owner:self options:nil][0];
        _libGeshiView.frame = CGRectMake(0, 90, self.tableView.frame.size.width, self.tableView.frame.size.height);
        [[UIApplication sharedApplication].keyWindow addSubview:_libGeshiView];
        _libGeshiView.hidden = YES;
        _libGeshiView.typeArray = @[@"全部",@"doc",@"ppt",@"xls",@"txt"];
        _libGeshiView.mainLabel.text = @"文件格式";
        [_libGeshiView setupTableview];
        _libGeshiView.functionName = @"LibraryNetData";
        
    }
    return _libGeshiView;
}
//- (void)quickLook{
//    self.view.backgroundColor = [UIColor grayColor];
//    QLPreviewController * preVC = [[QLPreviewController alloc]init];
//    preVC.dataSource = self;
//    [self presentViewController:preVC animated:YES completion:nil];
//
//}
//-(NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller{
//    return 1;
//}
//- (id <QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index{
//    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",WEB_HOST_URL,self.documentURL]];
//    return  url;
//}
@end
