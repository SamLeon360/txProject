//
//  EditCommerceDataController.m
//  TXProject
//
//  Created by Sam on 2019/5/13.
//  Copyright © 2019 sam. All rights reserved.
//

#import "EditCommerceDataController.h"
#import "EditComMsgTFCell.h"
#import "EditComMsgTVCell.h"
#import "EditComHeaderCell.h"
#import "EditComViewModel.h"
#import "CommerceDataModel.h"
#import "ZLPhotoActionSheet.h"
#import "GetAreaView.h"
#import "NewEditAlertView.h"
#import "SHEditCommidityCameraController.h"
@interface EditCommerceDataController ()<UITableViewDelegate,UITableViewDataSource,SHEditCommidityCameraDelegate>
@property (nonatomic , strong) EditComViewModel *contentVM;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic , strong) NSDictionary *keyAndValueDic;
@property (nonatomic , strong) NSArray *titleArray;
@property (nonatomic , strong) NSArray *cellTitleArray;
@property (nonatomic , strong) NSArray *checkKeyValue;
@property (nonatomic , strong) NSArray *checkAlertArray;
@property (nonatomic) UIImage *commerceImage;
@property (nonatomic) NSInteger selectAddressIndex;
@property (nonatomic) GetAreaView *getAreaView;
@end

@implementation EditCommerceDataController
{
    NewEditAlertView *alertView;
}
-(EditComViewModel *)contentVM{
    if (!_contentVM) {
        _contentVM = [[EditComViewModel alloc] init];
        _contentVM.commerceId = self.commerceId;
        _contentVM.vc = self;
    }
    return _contentVM;
}
-(void)reloadTableView{
    [self.tableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.getAreaView.hidden = YES;
    [self.tableView registerNib:[UINib nibWithNibName:@"EditComMsgTVCell" bundle:nil] forCellReuseIdentifier:@"EditComMsgTVCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"EditCommerceCell" bundle:nil] forCellReuseIdentifier:@"EditComMsgTFCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"EditComHeaderCell" bundle:nil] forCellReuseIdentifier:@"EditComHeaderCell"];
    self.title = @"社团详情";
    [self setupNewAlertView];
    [self loadData];
    
    self.titleArray = @[@{@"":@"commerce_logo"},@{@"社团基本信息:":@{@"社团名称:":@"commerce_name"}},@{@"社团主要负责人":@{@"会长:":@"commerce_president",@"执行会长:":@"executive_president",@"监事长:":@"supervisor",@"秘书长:":@"commerce_secretary_general"}},@{@"秘书处介绍:":@{@"":@"secretariat_introduction"}},@{@"社团简介:":@{@"":@"commerce_introduction"}},@{@"入会条件:":@{@"":@"membership_conditions"}},@{@"联系信息:":@{@"社团电话:":@"commerce_phone",@"社团传真:":@"commerce_fax",@"社团联系人:":@"contact",@"联系人手机:":@"contact_phone",@"电子邮箱:":@"email",@"办公地址:":@"office_address",@"网址:":@"site",@"公众号:":@"wechat_subscription"}},@{@"地址信息:":@{@"所在地:":@"commerce_location_real",@"所属会籍:":@"commerce_belong_membership_real"}}];
    self.cellTitleArray = @[@[@"头像"],@[@"社团名称:"],@[@"会长:",@"执行会长:",@"监事长:",@"秘书长:"],@[@"秘书处:"],@[@"社团简介:"],@[@"入会条件:"],@[@"社团电话:",@"社团传真:",@"社团联系人:",@"联系人手机:",@"电子邮箱:",@"办公地址:",@"网址:",@"公众号:"],@[@"所在地:",@"所属会籍:"]];
    self.checkKeyValue = @[@"commerce_name",@"commerce_president",@"executive_president",@"supervisor",@"commerce_secretary_general",@"commerce_phone",@"commerce_fax",@"contact",@"contact_phone",@"email",@"office_address",@"site",@"wechat_subscription",@"commerce_location_real",@"commerce_belong_membership_real"];
    self.checkAlertArray = @[@"请填写社团名称",@"请填写会长",@"请填写执行会长",@"请填写监事长",@"请填写秘书长",@"请填写社团电话",@"请填写社团传真",@"请填写社团联系人",@"请填写联系人手机",@"请填写电子邮箱",@"请填写办公地址",@"请填写网址",@"请填写公众号",@"请填写所在地",@"请填写所属会籍"];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.cellTitleArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
         NSArray *titleArray = self.cellTitleArray[section];
        return titleArray.count;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return nil;
    }else{
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 50)];
        [view setBackgroundColor:[UIColor colorWithRGB:0xf3f3f3]];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, 50)];
        NSDictionary *dic = self.titleArray[section];
        label.text = dic.allKeys.firstObject;
        label.font = [UIFont boldFontOfSize:17];
        [view addSubview:label];
        return view;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.1;
    }else{
        return 50;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == self.titleArray.count - 1) {
        return 100;
    }else{
        return 0.1;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section != self.titleArray.count - 1) {
        return nil;
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 100)];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 360 * kScale, 42)];
    label.backgroundColor = [UIColor colorWithRGB:0x3e85fb];
    label.text = @"提交";
    label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label];
    label.textColor = [UIColor whiteColor];
    label.center = view.center;
    label.userInteractionEnabled = YES;
    [label bk_whenTapped:^{
        [self.modelDic removeObjectForKey:@"commerce_constitution"];
        [self.modelDic removeObjectForKey:@"commerce_level"];
        [self.modelDic removeObjectForKey:@"commerce_logo"];
        [self.modelDic removeObjectForKey:@"executive_vice_president"];
        [self.modelDic removeObjectForKey:@"organizational_structure"];
        [self.modelDic setObject:@"1" forKey:@"is_image_change"];
        [self.modelDic removeObjectForKey:@"token"];
        
        for (int i = 0 ; i < self.checkKeyValue.count ; i++) {
            NSString *key = self.checkKeyValue[i];
            if ([self.modelDic.allKeys containsObject:key]) {
                id valueString = self.modelDic[key];
                if ( [valueString isKindOfClass:[NSNull class]]) {
                    [AlertView showYMAlertView:self.view andtitle: self.checkAlertArray[i]];
                    return ;
                }
                if ([valueString isKindOfClass:[NSString class]]) {
                    NSString *newValue  = valueString;
                    if (newValue.length <= 0) {
                        [AlertView showYMAlertView:self.view andtitle: self.checkAlertArray[i]];
                        return ;
                    }
                }
            }else{
                [AlertView showYMAlertView:self.view andtitle: self.checkAlertArray[i]];
                return ;
            }
        }
        [self uploadCommerceLogo];
    }];
    return  view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 3||indexPath.section == 4||indexPath.section == 5) {
        return 106;
    }else if (indexPath.section == 0    ){
        return 200;
    }
    else{
        return 50;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self setupCell:indexPath];
}
-(UITableViewCell *)setupCell:(NSIndexPath *)indexPath{
    if (indexPath.section == 3) {
        EditComMsgTVCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"EditComMsgTVCell"];
        cell.cellTV.text = self.contentVM.model.secretariat_introduction;
        [self SetupComMsgCellTV:cell];
        [[cell.cellTV rac_textSignal] subscribeNext:^(id x) {
            NSString *string = x;
            [self.modelDic setObject:string forKey:@"secretariat_introduction"];
        }];
        return cell;
    }else if (indexPath.section == 4) {
        EditComMsgTVCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"EditComMsgTVCell"];
        cell.cellTV.text = self.contentVM.model.commerce_introduction;
        [self SetupComMsgCellTV:cell];
        [[cell.cellTV rac_textSignal] subscribeNext:^(id x) {
            NSIndexPath *indexP = [self.tableView indexPathForCell:cell];
            if (indexP.section == 4) {
                NSString *string = x;
                [self.modelDic setObject:string forKey:@"commerce_introduction"];
            }
           
        }];
        return cell;
    }else if (indexPath.section == 5) {
        EditComMsgTVCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"EditComMsgTVCell"];
        cell.cellTV.text = self.contentVM.model.membership_conditions;
        [self SetupComMsgCellTV:cell];
        [[cell.cellTV rac_textSignal] subscribeNext:^(id x) {
            NSIndexPath *indexP = [self.tableView indexPathForCell:cell];
            if (indexP.section == 5) {
                NSString *string = x;
                [self.modelDic setObject:string forKey:@"membership_conditions"];
            }
            
        }];
        return cell;
    }else if (indexPath.section == 0){
        EditComHeaderCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"EditComHeaderCell"];
        [cell.commerce_logo setImage:self.commerceImage];
        [cell.commerce_logo makeCorner:cell.commerce_logo.frame.size.height/2];
        cell.commerce_logo.userInteractionEnabled = YES;
        [cell.commerce_logo bk_whenTapped:^{
            [self showEditAlertView];
        }];
        return cell;
    }else{
        EditComMsgTFCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"EditComMsgTFCell"];
        
        NSDictionary *dic = self.titleArray[indexPath.section];
        NSDictionary *cellDataDic = dic.allValues.firstObject;
        NSArray *titleArr = self.cellTitleArray[indexPath.section];
        cell.title.text =  titleArr[indexPath.row];
        NSString *key = cellDataDic[cell.title.text];
        if (![ self.modelDic[key] isKindOfClass:[NSNull class]]) {
            cell.cellTF.text = self.modelDic[key];
        }
        [[cell.cellTF rac_textSignal] subscribeNext:^(id x) {
           
            NSIndexPath *indexP = [self.tableView indexPathForCell:cell];
            if (indexP == nil) {
                return ;
            }
            NSArray *titleArr = self.cellTitleArray[indexP.section];
            
            if ([cell.title.text isEqualToString:titleArr[indexP.row]]) {
                NSDictionary *dic = self.titleArray[indexP.section];
                NSDictionary *cellDataDic = dic.allValues.firstObject;
                NSString *key = cellDataDic[cell.title.text];
                [self.modelDic setObject:cell.cellTF.text forKey:key];
            }
           
        }];
        if (indexPath.section == self.cellTitleArray.count - 1) {
            cell.cellTF.userInteractionEnabled = NO;
            [cell bk_whenTapped:^{
                NSIndexPath *indexP = [self.tableView indexPathForCell:cell];
                self.selectAddressIndex = indexP.row;
               [[UIApplication sharedApplication].keyWindow addSubview:self.getAreaView];
                self.getAreaView.hidden = NO;
            }];
            cell.cellTF.text = [cell.cellTF.text stringByReplacingOccurrencesOfString:@"|" withString:@""];
        }else{
            cell.cellTF.userInteractionEnabled= YES;
        }
        return cell;
    }
}
-(void)SetupComMsgCellTV:(EditComMsgTVCell *)cell{
    cell.cellTV.layer.borderColor = [UIColor colorWithRGB:0xf2f2f2].CGColor;
    cell.cellTV.layer.borderWidth = 1;
    [cell.cellTV makeCorner:5];
}

- (void)loadData {
    self.contentVM.commerceId = self.commerceId;
    [self.contentVM loadDataArrFromNetwork];
    
    RACSignal *recommendContentSignal = [self.contentVM.requestCommand execute:nil];
    @weakify(self);
    [[RACSignal combineLatest:@[recommendContentSignal]] subscribeNext:^(RACTuple *x) {
        
        @strongify(self);
        [self downloadImage];
        // 刷新tableView数据源
        [self.tableView reloadData];
        
    } error:^(NSError *error) {
        [AlertView showYMAlertView:self.view andtitle:@"网络异常，请检查网络"];
        //        [_contentTableView.mj_header endRefreshing];
    }];
}
-(void)uploadCommerceLogo{
    if (self.commerceImage == nil) {
        [AlertView showYMAlertView:self.view andtitle:@"请选择社团头像"];
        return;
    }
    NSString *url = @"secretary/upload_commerce_logo";
    [HTTPREQUEST_SINGLE uploadImageArrayWithUrlStr:url parameters:@{@"commerce_id":self.commerceId} withHub:NO constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSData * imageData = UIImageJPEGRepresentation(self.commerceImage, 0.5);
        // 上传的参数名

        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
        [formData appendPartWithFileData:imageData name:@"commerce_logo" fileName:fileName mimeType:@"image/jpeg"];
    } progress:^(double progress) {
        
    } success:^(NSDictionary *responseDic) {
        [self uploadEditData];
    } failure:^(NSError *error) {
        [AlertView showYMAlertView:self.view andtitle:@"头像上传失败"];
    }];
}
-(void)uploadEditData{
    
    NSString *url = @"secretary/update_chamber";
    [HTTPREQUEST_SINGLE postWithURLString:url parameters:self.modelDic withHub:YES withCache:NO success:^(NSDictionary *responseDic) {
        if ([responseDic[@"code"] integerValue] == -1002) {
            [AlertView showYMAlertView:self.view andtitle:@"修改成功"];
            NOTIFY_POST(@"getCommerceListData");
            NOTIFY_POST(@"commerceDetailData");
            NOTIFY_POST(@"getNewMeMessage");
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else{
            [AlertView showYMAlertView:self.view andtitle:@"数据提交失败"];
        }
    } failure:^(NSError *error) {
        [AlertView showYMAlertView:self.view andtitle:@"网络异常，请检查网络"];
        
    }];
}

-(void)setupNewAlertView{
    __block EditCommerceDataController *blockSelf = self;
    alertView = [[NSBundle mainBundle] loadNibNamed:@"NewEditAlertView" owner:self options:nil][0];
    [alertView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.4]];
    alertView.frame = CGRectMake(0, 0, ScreenW, ScreenH);
    alertView.alpha = 0;
    [alertView.cancelBtn addTarget:self action:@selector(hideEditAlertView) forControlEvents:UIControlEventTouchUpInside];
    [alertView.takePhotoBtn addTarget:self action:@selector(clickToTakePhoto) forControlEvents:UIControlEventTouchUpInside];
    [alertView.photoLib addTarget:self action:@selector(clickToTakeLib) forControlEvents:UIControlEventTouchUpInside];
    [alertView bk_whenTapped:^{
        [blockSelf hideEditAlertView];
    }];
    
}

-(void)clickToTakePhoto{
    [self hideEditAlertView];
    SHEditCommidityCameraController *cameraVC = [[SHEditCommidityCameraController alloc] initWithArray:nil maxPhotoNum:1];
    cameraVC.delegate = self;
    
    [self.navigationController pushViewController:cameraVC animated:YES];
}
-(void)savePhotoWithArray:(NSArray *)array{
    if (array.count == 0) {
        return;
    }
    self.commerceImage = array[0];
    [self.tableView reloadData];
}

/**
 门店图相册
 */
-(void)clickToTakeLib{
    [self hideEditAlertView];
    
    //相册问题
    ZLPhotoActionSheet *ac = [[ZLPhotoActionSheet alloc] init];
    
    //相册参数配置，configuration有默认值，可直接使用并对其属性进行修改
    ac.configuration.maxSelectCount = 1;
    ac.configuration.allowSelectVideo = NO;
    ac.configuration.allowTakePhotoInLibrary = NO;
    ac.configuration.maxPreviewCount = 1;
    ac.configuration.editAfterSelectThumbnailImage = YES;
    ac.configuration.hideClipRatiosToolBar = YES;
    ac.configuration.clipRatios = @[GetClipRatio(1, 1)];
    ac.configuration.saveNewImageAfterEdit = NO;
    //    ac.configuration.clipRatios = @[1,1];
    //如调用的方法无sender参数，则该参数必传
    ac.sender = self;
    __block EditCommerceDataController *blockself = self;
    //选择回调
    [ac setSelectImageBlock:^(NSArray<UIImage *> * _Nonnull images, NSArray<PHAsset *> * _Nonnull assets, BOOL isOriginal) {
        if (images.count > 0 ) {
           blockself.commerceImage = images[0];
            [blockself.tableView reloadData];
        }
        
//        [blockself upavatar];
    }];
    
    
    [ac showPhotoLibrary];
}

-(void)showEditAlertView{
    [[[UIApplication sharedApplication] keyWindow] addSubview:alertView];
    alertView.alpha = 0;
    [UIView animateWithDuration:0.5 animations:^{
        self->alertView.alpha = 1;
    }];
}
-(void)hideEditAlertView{
    [UIView animateWithDuration:0.5 animations:^{
        self->alertView.alpha = 0;
    } completion:^(BOOL finished) {
        [self->alertView removeFromSuperview];
    }];
}
-(void)downloadImage{
    dispatch_queue_t globalQueue = dispatch_get_global_queue(0, 0);
    dispatch_async(globalQueue, ^{
        
        NSLog(@"开始下载图片:%@", [NSThread currentThread]);
        //NSString -> NSURL -> NSData -> UIImage
        NSString *imageStr = [NSString stringWithFormat:@"%@%@",AVATAR_HOST_URL,self.contentVM.model.commerce_logo];
        NSURL *imageURL = [NSURL URLWithString:imageStr];
        //下载图片
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        UIImage *image = [UIImage imageWithData:imageData];
        
        //从子线程回到主线程(方式二：常用)
        //组合：主队列异步执行
        dispatch_async(dispatch_get_main_queue(), ^{
//            NSLog(@"回到主线程:%@", [NSThread currentThread]);
            //更新界面
            self.commerceImage = image;
            [self.tableView reloadData];
        });
        
        NSLog(@"xxxxxxxx");
    });
    
}

-(GetAreaView *)getAreaView{
    if (_getAreaView == nil) {
        __block EditCommerceDataController *blockSelf = self;
        _getAreaView = [[NSBundle mainBundle] loadNibNamed:@"Area" owner:self options:nil][0];
        _getAreaView.frame = CGRectMake(0, 115, ScreenW, ScreenH);
        
        _getAreaView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        [_getAreaView bk_whenTapped:^{
            [blockSelf.getAreaView removeFromSuperview];
        }];
        [_getAreaView setupTableView];
        [_getAreaView.sureBtn bk_whenTapped:^{
            NSString *valueString = @"";
            NSString *keyString =  blockSelf.selectAddressIndex == 0 ?@"commerce_location_real":@"commerce_belong_membership_real";
            
            if (blockSelf.getAreaView.selecCity == nil) {
                valueString = [NSString stringWithFormat:@"%@省|",blockSelf.getAreaView.selectProvince];
            }else{
                valueString = [NSString stringWithFormat:@"%@省|%@市|",blockSelf.getAreaView.selectProvince,blockSelf.getAreaView.selecCity];
            }
            [blockSelf.modelDic setObject:valueString forKey:keyString];
            blockSelf.getAreaView.hidden = YES;
            [blockSelf.getAreaView removeFromSuperview];
            [blockSelf.tableView reloadData];
//            [blockSelf getCommerceArray];
        }];
        [_getAreaView.clearBtn bk_whenTapped:^{
//            blockSelf.selectAreaString = @"";
            blockSelf.getAreaView.selecCity = @"";
            blockSelf.getAreaView.selectProvince = @"";
            [blockSelf.getAreaView.provinceTable reloadData];
            [blockSelf.getAreaView.cityTable reloadData];
            blockSelf.getAreaView.hidden = YES;
            [blockSelf.getAreaView removeFromSuperview];
//            [blockSelf getCommerceArray];
//            blockSelf.areaLabel.text = @"地区";
        }];
    }
    return _getAreaView;
}
@end
