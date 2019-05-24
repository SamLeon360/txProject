//
//  NewCommerceDetailController.m
//  TXProject
//
//  Created by Sam on 2019/4/22.
//  Copyright © 2019 sam. All rights reserved.
//

#import "NewCommerceDetailController.h"
#import "CommerceBaseModel.h"
#import "CommerceEventListModel.h"
#import "CommerceMasterModel.h"
#import "ComDetailSectionCell.h"
#import "ContentCheckMoreCell.h"
#import "CommerceDetailViewModel.h"
#import "EditCommerceDataController.h"
#import "ContentTextCell.h"
#import "CommerceEventCell.h"
#import "CommerceHeaderCell.h"
#import "AddCommerceController.h"
#import "MemberListController.h"
@interface NewCommerceDetailController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *addCommerceLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *autoHeight;
@property (nonatomic,strong) CommerceBaseModel *baseModel;
@property (nonatomic,strong) CommerceEventListModel *listModel;
@property (nonatomic,strong) CommerceMasterModel *masterModel;
@property (nonatomic,strong) CommerceDetailViewModel *contentVM;



@property (nonatomic, strong) NSArray *baseMsgCellArray;
@property (nonatomic, strong) NSMutableArray *masterSectionCellArray;///根据“会长”区分多少届理事会
@property (nonatomic)NSDictionary *commerceDic;
@end

@implementation NewCommerceDetailController

-(CommerceDetailViewModel *)contentVM{
    if (!_contentVM) {
        _contentVM = [[CommerceDetailViewModel alloc] init];
        _contentVM.vc = self;
    }
    return _contentVM;
}
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"社团详情";
    self.tableType = 1;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.commerceCheckMore = NO;
    self.cooditionCheckMore = NO;
    self.secretariatCheckMore = NO;
    self.baseMsgCellArray = @[@2,@5,@2,@2,@7];
    if (self.comeType != nil) {
        [self.autoHeight setConstant:0];
        self.addCommerceLabel.hidden = YES;
       
    }else{
        if (SHOW_WEB&&self.commerceId!=nil && [USER_SINGLE.default_role_type integerValue] == 1) {
            for (NSDictionary *commerceDic in USER_SINGLE.commerceArray) {
                if ([commerceDic[@"commerce_id"] integerValue] == [self.commerceId integerValue]) {
                    UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    editBtn.frame = CGRectMake(0, 0, 20, 20);
                    [editBtn setBackgroundImage:[UIImage imageNamed:@"edit_icon"] forState:UIControlStateNormal];
                    [editBtn addTarget:self action:@selector(clickToEdit) forControlEvents:UIControlEventTouchUpInside];
                    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:editBtn];
                    self.navigationItem.rightBarButtonItem = rightItem;
                }
            }
            
        }
    }
    [self registerTableCell];
    [self loadData];
    self.addCommerceLabel.userInteractionEnabled = YES;
    __block NewCommerceDetailController *blockSelf = self;
    for (NSDictionary *commerceDic in USER_SINGLE.commerceArray) {
        if ([commerceDic[@"commerce_id"] integerValue] == [self.commerceId integerValue]) {
            self.addCommerceLabel.text = @"查看会员";
            self.commerceDic = commerceDic;
        }
    }
    [self.addCommerceLabel bk_whenTapped:^{
        if ([blockSelf.addCommerceLabel.text isEqualToString:@"查看会员"]) {
            MemberListController *vc = [[UIStoryboard storyboardWithName:@"MemberList" bundle:nil] instantiateViewControllerWithIdentifier:@"MemberListController"];
            vc.checkMember = NO;
            vc.commerceDic = self.commerceDic;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
        AddCommerceController *vc = [[UIStoryboard storyboardWithName:@"CommerceView" bundle:nil] instantiateViewControllerWithIdentifier:@"AddCommerceController"];
        vc.commerceDic =  [blockSelf.contentVM.baseModel mj_keyValues];
        [blockSelf.navigationController pushViewController:vc animated:YES];
        }
    }];
    NOTIFY_ADD(loadData, @"commerceDetailData");
   
    
}
-(void)clickToEdit{
    EditCommerceDataController *vc = [[EditCommerceDataController alloc] initWithNibName:@"EditCommerceDataController" bundle:nil];
    vc.commerceId = [NSString stringWithFormat:@"%ld",(long)[self.commerceId integerValue]];
    
    [self.navigationController pushViewController:vc animated:YES];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
   return  [self setupBaseMsgCell:indexPath];
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return nil;
    }else{
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 10)];
        view.backgroundColor = [UIColor colorWithRGB:0xf2f2f2];
        return view;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 0.01;
    }
    return 10;
}
-(UITableViewCell *)setupBaseMsgCell:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        CommerceHeaderCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"CommerceHeaderCell"];
        cell.commerceDetailVC = self;
        cell.model = self.contentVM.baseModel;
        [cell.baseMsgView bk_whenTapped:^{
            [self.tableView reloadData];
        }];
        [cell.eventView bk_whenTapped:^{
            [self reloadTableView];
        }];
        [cell.masterView bk_whenTapped:^{
            [self reloadTableView];
        }];
        return cell;
    }
    if (self.tableType == 1) {
        if (indexPath.row == 0) {
            ComDetailSectionCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ComDetailSectionCell"];
            cell.tableType = self.tableType;
            cell.indexPath = indexPath;
            
            return cell;
        }else{
            if (indexPath.section == 1 || indexPath.section == 3|| indexPath.section == 4) {
                ContentCheckMoreCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ContentCheckMoreCell"];
                cell.vc = self;
                cell.model = self.contentVM.baseModel;
                cell.indexPath = indexPath;
                return cell;
            }else{
                ContentTextCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ContentTextCell"];
                cell.indexPath = indexPath;
                cell.model = self.contentVM.baseModel;
                return cell;
            }
        }
    }else if (self.tableType == 2){
        CommerceEventCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"CommerceEventCell"];
        cell.model = self.contentVM.modelArr[indexPath.section-1];
        return cell;
    }else{
        if (indexPath.row != 0) {
            NSArray *arr = self.masterSectionCellArray[indexPath.section - 1];
            ContentTextCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ContentTextCell"];
            cell.indexPath = indexPath;
            cell.masterModel =  arr[indexPath.row - 1];
            return cell;
        }else{
            ComDetailSectionCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ComDetailSectionCell"];
             cell.tableType = self.tableType;
            cell.indexPath = indexPath;
            return cell;
        }
    }
}

-(void)countMasterNumber{
    NSInteger sectionCount = 0;
    self.masterSectionCellArray = [NSMutableArray arrayWithCapacity:0];
    for (CommerceMasterModel *model in self.contentVM.masterArr) {
        if ([model.league_post isEqualToString:@"会长"]) {
            sectionCount ++;
        }
    }
    for (int i = 0 ; i < sectionCount ; i++) {
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
        for (int j = 0 ; j < self.contentVM.masterArr.count ; j++) {
            CommerceMasterModel *model = self.contentVM.masterArr[j];
            
            if (model.post_count == i + 1) {
                
                [arr addObject:model];
            }
        }
        [self.masterSectionCellArray addObject:arr];
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.tableType == 1) {
        if (indexPath.section == 5&&indexPath.row == 4) {
            [CustomFountion callPhone:self.contentVM.baseModel.contact_phone andView:self.view];
        }
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 306;
    }
    if (self.tableType == 1) {
        
        if (indexPath.row == 0) {
            return 46;
        }else if (indexPath.section == 1 || indexPath.section == 3||indexPath.section == 4){
            if (indexPath.section == 1) {
                if (self.commerceCheckMore) {
                    return [CustomFountion getHeightLineWithString:self.contentVM.baseModel.commerce_introduction withWidth:396*kScale withFont:[UIFont systemFontOfSize:16]];
                }else{
                    return 130;
                }
            }else if (indexPath.section == 3){
                if (self.secretariatCheckMore) {
                    return [CustomFountion getHeightLineWithString:self.contentVM.baseModel.secretariat_introduction withWidth:396*kScale withFont:[UIFont systemFontOfSize:16]];
                }else{
                    return 130;
                }
            }else if(indexPath.section == 4){
                if (self.cooditionCheckMore) {
                    return [CustomFountion getHeightLineWithString:self.contentVM.baseModel.membership_conditions withWidth:396*kScale withFont:[UIFont systemFontOfSize:16]];
                }else{
                    return 130;
                }
            }else{
               
                return  50;
            }
            
        }else if (indexPath.section == 2){
            if (indexPath.row == 2) {
                if ([CustomFountion getHeightLineWithString:self.contentVM.baseModel.executive_president  withWidth:250*kScale withFont:[UIFont systemFontOfSize:16]] < 50) {
                    return [CustomFountion getHeightLineWithString:self.contentVM.baseModel.executive_president  withWidth:250*kScale withFont:[UIFont systemFontOfSize:16]];
                }else{
                    return 50;
                }
            }else{
                return 50;
            }
        }
        else{
            if (indexPath.row == 6 && indexPath.section == 5) {
                if ([CustomFountion getHeightLineWithString:self.contentVM.baseModel.office_address withWidth:165*kScale withFont:[UIFont systemFontOfSize:16]] > 50) {
                    return [CustomFountion getHeightLineWithString:self.contentVM.baseModel.office_address withWidth:165*kScale withFont:[UIFont systemFontOfSize:16]];
                }else{
                    return 50;
                }
            }
            return 50;
        }
    }else if(self.tableType == 2){
        CommerceEventListModel *model = self.contentVM.modelArr[indexPath.section - 1];
        return 50 + [CustomFountion getHeightLineWithString:model.content withWidth:396*kScale withFont:[UIFont systemFontOfSize:16]];
    }else{
        if (indexPath.row == 0) {
            return 50;
        }else{
            NSArray *arr = self.masterSectionCellArray[indexPath.section - 1];
            
            CommerceMasterModel *model = arr[indexPath.row - 1];
            CGFloat lineHeight = [CustomFountion getHeightLineWithString:model.member_name withWidth:160*kScale withFont:[UIFont systemFontOfSize:16]];
            if (lineHeight < 50) {
                return 50;
            }else{
                return lineHeight;
            }
        }
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.tableType == 1) {
        return 5 + 1;
    }else if (self.tableType == 2){
        return  self.contentVM.modelArr.count + 1;
    }else{
        return self.masterSectionCellArray.count + 1;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    if (self.tableType == 1) {
        NSInteger num = [self.baseMsgCellArray[section-1] integerValue];
        return num;
    }else if (self.tableType == 2){
        return 1;
    }else{
        NSArray *arr = self.masterSectionCellArray[section - 1];
        return arr.count + 1;
    }
}

-(void)registerTableCell{
    NSArray *cellStringArr = @[@"ComDetailSectionCell",@"ContentCheckMoreCell",@"ContentTextCell",@"CommerceEventCell",@"CommerceHeaderCell"];
    for (NSString *string in cellStringArr) {
        [self.tableView registerNib:[UINib nibWithNibName:string bundle:nil] forCellReuseIdentifier:string];
    }
    
}
-(void)reloadTableView{
    [self.tableView reloadData];
}
-(void)reloadCommerceCell{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:1];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}
-(void)reloadSecretCell{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:3];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

-(void)reloadConditionCell{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}
- (void)loadData {
    self.contentVM.commerceId = self.commerceId;
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
@end
