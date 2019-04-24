//
//  SearchCommerceController.m
//  TXProject
//
//  Created by Sam on 2019/2/12.
//  Copyright © 2019 sam. All rights reserved.
//

#import "SearchCommerceController.h"
#import "SearchCommerceNameView.h"
#import "SearchCommerceTypeView.h"
#import "HomeCommerceCell.h"
#import "MJRefresh.h"
#import "UploadCommerceControllerController.h"
#import "BottomView.h"
#import "GetAreaView.h"
#import "CommerceDetailController.h"
#import "NewCommerceDetailController.h"
@interface SearchCommerceController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *commerceType;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;
@property (weak, nonatomic) IBOutlet UITextField *searchTF;
@property (weak, nonatomic) IBOutlet UIView *selectView;

@property (weak, nonatomic) IBOutlet UILabel *areaLabel;
@property (weak, nonatomic) IBOutlet UIView *areaView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) SearchCommerceNameView *searchNameView;
@property (nonatomic) SearchCommerceTypeView *searchTypeView;
@property (nonatomic) BottomView *bottomBtn;
@property (nonatomic) NSMutableArray *commerceArray;
@property (nonatomic) NSString *selCommerceType;
@property (nonatomic) NSInteger nPage;

@property (nonatomic) GetAreaView *getAreaView;
@property (nonatomic) NSString *selectAreaString;
@property (nonatomic) UIView *backgroundView;
@end

@implementation SearchCommerceController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.title = @"社团查询";
    self.nPage = 1;
    self.selCommerceType = @"";
    self.backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 100, ScreenW, ScreenH)];
    self.backgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    [self.view addSubview:self.bottomBtn];
    [self.view addSubview:self.backgroundView];
    [self.backgroundView addSubview:self.searchTypeView];
    self.backgroundView.hidden = YES;
    self.selectAreaString = @"";
    self.getAreaView.hidden = YES;
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 85)];
    self.tableView.tableFooterView = footerView;
    [self.bottomBtn makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@45);
        make.width.equalTo(@188);
        make.bottom.equalTo(@(-40));
        make.centerX.equalTo(@0);
    }];
  
    __block SearchCommerceController *blockSelf= self;
    [self.commerceType bk_whenTapped:^{
        
        if (blockSelf.backgroundView.hidden) {
            blockSelf.backgroundView.hidden = NO;
            blockSelf.searchNameView.hidden = YES;
        }else{
            blockSelf.backgroundView.hidden = YES;
        }
    }];
   
    [self.areaView bk_whenTapped:^{
        blockSelf.getAreaView.hidden = !blockSelf.getAreaView.hidden;
    }];
    [self.view bk_whenTapped:^{
        blockSelf.searchNameView.hidden = YES;
        blockSelf.backgroundView.hidden = YES;
        [blockSelf.view endEditing:YES];
    }];
    [self.searchBtn bk_whenTapped:^{
        [blockSelf getCommerceArray];
        blockSelf.searchNameView.hidden = YES;
        [blockSelf.view endEditing:YES];
    }];
    [self getCommerceArray];
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getDataArrayByMore)];
    self.tableView.mj_footer = footer;
    NOTIFY_ADD(getCommerceArray, @"getcommerceArray");
}
-(void)getCommerceArray{
    __block SearchCommerceController *blockSelf = self;
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:self.selectAreaString,@"affiliated_area",self.searchTF.text,@"commerce_name",self.selCommerceType,@"commerce_type",@"1",@"page",@"",@"ios", nil];
    [HTTPREQUEST_SINGLE postWithURLString:SH_HOME_COMMERCES parameters:param withHub:YES withCache:NO success:^(NSDictionary *responseDic) {
        if ([responseDic[@"code"] integerValue] == 1) {
            blockSelf.commerceArray = [NSMutableArray arrayWithCapacity:0];
            blockSelf.commerceArray = responseDic[@"data"];
            [blockSelf.tableView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}
-(void)getDataArrayByMore{
    self.nPage ++;
    NSString *name =self.searchTF.text.length==0?@"":self.searchTF.text;
    __block SearchCommerceController *blockSelf = self;
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:self.selectAreaString,@"affiliated_area",name,@"commerce_name",self.selCommerceType == nil?@"":self.selCommerceType,@"commerce_type",[NSString stringWithFormat:@"%ld",(long)self.nPage],@"page",@"",@"ios", nil];
    [HTTPREQUEST_SINGLE postWithURLString:SH_HOME_COMMERCES parameters:param withHub:YES withCache:NO success:^(NSDictionary *responseDic) {
        if ([responseDic[@"code"] integerValue] == 1) {
            [blockSelf.commerceArray addObjectsFromArray:responseDic[@"data"]] ;
            [blockSelf.tableView reloadData];
            NSArray *arr = responseDic[@"data"];
            if (arr.count <= 0) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                 [blockSelf.tableView.mj_footer endRefreshing];
            }
            
        }else{
            self.nPage --;
             [blockSelf.tableView.mj_footer endRefreshing];
        }
        
    } failure:^(NSError *error) {
        self.nPage -- ;
         [blockSelf.tableView.mj_footer endRefreshing];
    }];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
        HomeCommerceCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"HomeCommerceCell"];
        NSDictionary *dic = self.commerceArray[indexPath.row];
        cell.titleLabel.text = dic[@"commerce_name"];
        NSString *commerceType = @"";
        switch ([dic[@"commerce_type"] integerValue]) {
            case 1:{
                commerceType = @"行业协会";
            }break;
            case 2:{
                commerceType = @"综合型商会";
            }break;
            case 3:{
                commerceType = @"地方商会";
            }break;
            case 4:{
                commerceType = @"异地商会";
            }break;
            default:
                break;
        }
        cell.contentLabel.text = commerceType;
        cell.cityLabel.text = [NSString stringWithFormat:@"  %@",dic[@"commerce_location"]];
        cell.numberLabel.text = [NSString stringWithFormat:@"%@名会员",dic[@"ct"]];
        [cell.cellView makeCorner:5];
    [cell.cellView bk_whenTapped:^{
        NSIndexPath *indexP = [tableView indexPathForCell:cell];
        NSDictionary *dic = self.commerceArray[indexP.row];
        NewCommerceDetailController *vc = [[NewCommerceDetailController alloc] initWithNibName:@"NewCommerceDetailController" bundle:nil];
        vc.commerceId = [NSString stringWithFormat:@"%ld",(long)[dic[@"commerce_id"] integerValue]];
        
        [self.navigationController pushViewController:vc animated:YES];
    }];
        if ([dic[@"commerce_logo"] isKindOfClass:[NSNull class]]) {
            [cell.commerceImage setImage:[UIImage imageNamed:@"default_avatar"]];
        }else{
            [cell.commerceImage sd_setImageWithURL: [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",AVATAR_HOST_URL,dic[@"commerce_logo"]]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if (error) {
                    [cell.commerceImage setImage:[UIImage imageNamed:@"default_avatar"]];
                }
            }];
        }
        
        return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        return 95;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.commerceArray.count;
}

-(SearchCommerceNameView *)searchNameView{
    if (_searchNameView == nil) {
        _searchNameView = [[NSBundle mainBundle] loadNibNamed:@"CommerceList" owner:self options:nil][5];
        _searchNameView.frame = CGRectMake(0, 50, ScreenW, 50);
        __block SearchCommerceController *blockSelf = self;
//        [_searchNameView.searchBtn bk_whenTapped:^{
//           
//        }];
        _searchNameView.hidden = YES;
    }
    
    return _searchNameView;
}
-(SearchCommerceTypeView *)searchTypeView{
    if (_searchTypeView == nil) {
        _searchTypeView = [[NSBundle mainBundle] loadNibNamed:@"CommerceList" owner:self options:nil][4];
        _searchTypeView.frame = CGRectMake(0, 0, ScreenW, 200);
        __block SearchCommerceController *blockSelf = self;
        [_searchTypeView.allView bk_whenTapped:^{
            blockSelf.selCommerceType = @"";
            [blockSelf resetLabelColor];
            blockSelf.searchTypeView.allLabel.textColor = [UIColor colorWithRGB:0x00bfff];
            [blockSelf getCommerceArray];
            blockSelf.backgroundView.hidden = YES;
            blockSelf.commerceType.text = blockSelf.searchTypeView.allLabel.text;
            blockSelf.searchTypeView.allIcon.hidden = NO;
        }];
        [_searchTypeView.oneView bk_whenTapped:^{
            blockSelf.selCommerceType = @"1";
            [blockSelf resetLabelColor];
            blockSelf.searchTypeView.oneLabel.textColor = [UIColor colorWithRGB:0x00bfff];
            [blockSelf getCommerceArray];
            blockSelf.backgroundView.hidden = YES;
            blockSelf.searchTypeView.oneIcon.hidden =NO;
            
            blockSelf.commerceType.text = blockSelf.searchTypeView.oneLabel.text;
        }];
        [_searchTypeView.twoView bk_whenTapped:^{
            blockSelf.selCommerceType = @"2";
            [blockSelf resetLabelColor];
            blockSelf.searchTypeView.twoLabel.textColor = [UIColor colorWithRGB:0x00bfff];
            [blockSelf getCommerceArray];
            blockSelf.backgroundView.hidden = YES;
            blockSelf.searchTypeView.twoIcon.hidden =NO;
            blockSelf.commerceType.text = blockSelf.searchTypeView.twoLabel.text;
        }];
        [_searchTypeView.threeView bk_whenTapped:^{
            blockSelf.selCommerceType = @"3";
            [blockSelf resetLabelColor];
            blockSelf.searchTypeView.threeLabel.textColor = [UIColor colorWithRGB:0x00bfff];
            [blockSelf getCommerceArray];
            blockSelf.backgroundView.hidden = YES;
            blockSelf.searchTypeView.threeIcon.hidden =NO;
            blockSelf.commerceType.text = blockSelf.searchTypeView.threeLabel.text;
        }];
        [_searchTypeView.fourView bk_whenTapped:^{
            blockSelf.selCommerceType = @"4";
            [blockSelf resetLabelColor];
            blockSelf.searchTypeView.fourLabel.textColor = [UIColor colorWithRGB:0x00bfff];
            [blockSelf getCommerceArray];
            blockSelf.backgroundView.hidden = YES;
            blockSelf.searchTypeView.fourIcon.hidden =NO;
            blockSelf.commerceType.text = blockSelf.searchTypeView.fourLabel.text;
        }];
        _searchTypeView.hidden = NO;
        [self resetLabelColor];
    }
    
    return _searchTypeView;
}

-(void)resetLabelColor{
    self.searchTypeView.oneLabel.textColor = [UIColor blackColor];
    self.searchTypeView.twoLabel.textColor = [UIColor blackColor];
    self.searchTypeView.threeLabel.textColor = [UIColor blackColor];
    self.searchTypeView.fourLabel.textColor = [UIColor blackColor];
    self.searchTypeView.allLabel.textColor = [UIColor blackColor];
    self.searchTypeView.allIcon.hidden = YES;
    self.searchTypeView.oneIcon.hidden = YES;
    self.searchTypeView.twoIcon.hidden = YES;
    self.searchTypeView.threeIcon.hidden = YES;
    self.searchTypeView.fourIcon.hidden = YES;
    
}
-(BottomView *)bottomBtn{
    if (_bottomBtn == nil) {
        _bottomBtn = [[NSBundle mainBundle] loadNibNamed:@"CommerceList" owner:self options:nil][6];
        __block SearchCommerceController *blockSelf = self;
        [_bottomBtn makeCorner:45/2];
        [_bottomBtn bk_whenTapped:^{
            if (USER_SINGLE.token.length <= 0) {
                [AlertView showYMAlertView:self.view andtitle:@"请先登录!"];
                return ;
            }
            UploadCommerceControllerController *vc = [[UIStoryboard storyboardWithName:@"CommerceView" bundle:nil] instantiateViewControllerWithIdentifier:@"UploadCommerceControllerController"];
            [blockSelf.navigationController pushViewController:vc animated:YES];
        }];
    }
    return _bottomBtn;
}

-(GetAreaView *)getAreaView{
    if (_getAreaView == nil) {
        __block SearchCommerceController *blockSelf = self;
        _getAreaView = [[NSBundle mainBundle] loadNibNamed:@"Area" owner:self options:nil][0];
        _getAreaView.frame = CGRectMake(0, 100, ScreenW, self.view.frame.size.height*kScale);
        [self.view addSubview:_getAreaView];
        _getAreaView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        [_getAreaView bk_whenTapped:^{
            blockSelf.getAreaView.hidden = YES;
        }];
        [_getAreaView setupTableView];
        [_getAreaView.sureBtn bk_whenTapped:^{
            if (blockSelf.getAreaView.selecCity == nil) {
                 blockSelf.selectAreaString = [NSString stringWithFormat:@"%@省|",blockSelf.getAreaView.selectProvince];
            }else{
                 blockSelf.selectAreaString = [NSString stringWithFormat:@"%@省|%@市|",blockSelf.getAreaView.selectProvince,blockSelf.getAreaView.selecCity];
            }
            blockSelf.areaLabel.text = [blockSelf.selectAreaString stringByReplacingOccurrencesOfString:@"|" withString:@""];
//            [blockSelf.dataDic setObject:blockSelf.selectAreaString forKey:@"area"];
            blockSelf.getAreaView.hidden = YES;
            [blockSelf getCommerceArray];
        }];
        [_getAreaView.clearBtn bk_whenTapped:^{
            blockSelf.selectAreaString = @"";
            blockSelf.getAreaView.selecCity = @"";
            blockSelf.getAreaView.selectProvince = @"";
            [blockSelf.getAreaView.provinceTable reloadData];
            [blockSelf.getAreaView.cityTable reloadData];
            blockSelf.getAreaView.hidden = YES;
            [blockSelf getCommerceArray];
            blockSelf.areaLabel.text = @"地区";
        }];
    }
    return _getAreaView;
}
@end
