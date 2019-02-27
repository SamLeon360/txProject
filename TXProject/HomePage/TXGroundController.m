//
//  TXGroundController.m
//  TXProject
//
//  Created by Sam on 2018/12/27.
//  Copyright © 2018年 sam. All rights reserved.
//

#import "TXGroundController.h"
#import "TXLoginNavControllerViewController.h"
#import "LoginBottomView.h"
#import "AppDelegate.h"
#import "SDCycleScrollView.h"
#import "TXLoginController.h"
#import "TXWebViewController.h"
#import "GroundCell.h"
#import "EntreprenurialController.h"
#import "InvestmentDetailController.h"
#import "LibraryController.h"
#import "ComprehensiveServerController.h"
#import "EducationChanController.h"
@interface TXGroundController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (nonatomic,strong) LoginBottomView *loginBtnView;
@property (weak, nonatomic) IBOutlet SDCycleScrollView *groundScroll;
@property (nonatomic,strong) NSMutableArray *imageURLArray;
@property (weak, nonatomic) IBOutlet UIView *oneView;
@property (weak, nonatomic) IBOutlet UIView *twoView;
@property (weak, nonatomic) IBOutlet UIView *threeView;
@property (weak, nonatomic) IBOutlet UIView *fourView;
@property (weak, nonatomic) IBOutlet UIView *fiveView;
@property (weak, nonatomic) IBOutlet UIView *sixView;
@property (weak, nonatomic) IBOutlet UIView *sevenView;
@property (weak, nonatomic) IBOutlet UIView *eightView;
@property (weak, nonatomic) IBOutlet UILabel *connectLabel;
@property (weak, nonatomic) IBOutlet UIView *scrollContentView;



@end

@implementation TXGroundController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"天寻广场";
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRGB:0x3e85fb];
    self.navigationController.navigationBar.titleTextAttributes= @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:18]};
  
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.loginBtnView.loginBtn bk_addEventHandler:^(id sender) {
        dispatch_async(dispatch_get_main_queue(), ^{
            TXLoginController *vc = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"TXLoginController"];
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            
            appDelegate.window.rootViewController = vc;
            [appDelegate.window makeKeyAndVisible];
        });
    } forControlEvents:UIControlEventTouchUpInside];
   
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO];
   
}
-(void)viewDidAppear:(BOOL)animated{
     self.scrollview.contentSize = CGSizeMake(0, 900);
    [self.scrollContentView setFrame:CGRectMake(0, 0, ScreenW, 900)];
   
}
-(void)viewDidDisappear:(BOOL)animated{
    
}

-(void)viewWillLayoutSubviews{
    if (USER_SINGLE.token.length<= 0) {
        [[UIApplication sharedApplication].keyWindow addSubview:self.loginBtnView];
    }
    
}
-(void)viewDidLayoutSubviews{
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GroundCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GroundCell"];
    [self setupClickAction:cell];
    [self setupScrollImage:cell];
    
    return cell;
}
-(void)setupScrollImage :(GroundCell *)cell{
    if (cell.imageURLArray.count > 0) {
        return;
    }
    [HTTPREQUEST_SINGLE getWithURLString:GROUND_SCROLL_IMAGE parameters:nil withHub:YES withCache:NO success:^(NSDictionary *responseDic) {
        NSString *imgURLString = responseDic[@"data"][@"square_img"];
        NSArray *imageurlArray = [imgURLString componentsSeparatedByString:@"|"];
        cell.imageURLArray = [NSMutableArray arrayWithCapacity:0];
        for (int i = 0; i <= imageurlArray.count - 1; i ++) {
            NSString *imageString = [NSString stringWithFormat:@"%@%@",@"https://app.tianxun168.com",imageurlArray[i]];
            [cell.imageURLArray addObject:imageString];
        }
        
        cell.groundScroll.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
        cell.groundScroll.imageURLStringsGroup = cell.imageURLArray;
        cell.groundScroll.showPageControl = NO;
        [cell.groundScroll setAutoScrollTimeInterval:5];
        cell.groundScroll.autoScroll = cell.imageURLArray.count >1?YES:NO;
        cell.groundScroll.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
    } failure:^(NSError *error) {
        
    }];
}
-(void)setupClickAction : (GroundCell *)cell{
    __block TXGroundController *blockSelf =self;
    cell.otherLibraryView.hidden = SHOW_WEB?YES:NO;
    cell.fiveView.hidden = SHOW_WEB?NO:YES;
    cell.sixView.hidden = SHOW_WEB?NO:YES;
    cell.eightView.hidden = SHOW_WEB?NO:YES;
    cell.sevenView.hidden = SHOW_WEB? NO:YES;
    cell.threeView.hidden = SHOW_WEB?NO:YES;
    cell.fourView.hidden = SHOW_WEB?NO:YES;
    cell.otherServiceView.hidden = SHOW_WEB?YES:NO;
    [cell.oneView bk_whenTapped:^{
        if (SHOW_WEB) {
            if (USER_SINGLE.token.length<= 0) {
                [blockSelf.loginBtnView removeFromSuperview];
                blockSelf.loginBtnView = nil;
            }
            TXWebViewController *webVC =  [[UIStoryboard storyboardWithName:@"HomePage" bundle:nil] instantiateViewControllerWithIdentifier:@"TXWebViewController"];
//        [USER_SINGLE isLogin]?check_community_token:
            webVC.intype = check_community;
            [blockSelf.navigationController pushViewController:webVC animated:YES];
        }
    }];
    [cell.twoView bk_whenTapped:^{
        if (USER_SINGLE.token.length<= 0) {
            [blockSelf.loginBtnView removeFromSuperview];
            blockSelf.loginBtnView = nil;
        }
        InvestmentDetailController *vc = [[UIStoryboard storyboardWithName:@"HomePage" bundle:nil] instantiateViewControllerWithIdentifier:@"InvestmentDetailController"];
        [blockSelf.navigationController pushViewController:vc animated:YES];
    }];
    [cell.threeView bk_whenTapped:^{
        if (USER_SINGLE.token.length<= 0) {
            [blockSelf.loginBtnView removeFromSuperview];
            blockSelf.loginBtnView = nil;
        }
        EntreprenurialController *vc = [[UIStoryboard storyboardWithName:@"Entrepreneurial" bundle:nil] instantiateViewControllerWithIdentifier:@"EntreprenurialController"];
        [self.navigationController pushViewController:vc animated:YES];
//        TXWebViewController *webVC =  [[UIStoryboard storyboardWithName:@"HomePage" bundle:nil] instantiateViewControllerWithIdentifier:@"TXWebViewController"];
////        [USER_SINGLE isLogin]?entrepreneurship_index_token:
//        webVC.intype = entrepreneurship_index;
//        [blockSelf.navigationController pushViewController:webVC animated:YES];
    }];
    [cell.fourView bk_whenTapped:^{
        if (USER_SINGLE.token.length<= 0) {
            [blockSelf.loginBtnView removeFromSuperview];
            blockSelf.loginBtnView = nil;
        }
        ComprehensiveServerController *vc = [[UIStoryboard storyboardWithName:@"HomePage" bundle:nil] instantiateViewControllerWithIdentifier:@"ComprehensiveServerController"];
        [blockSelf.navigationController pushViewController:vc animated:YES];
    }];
    [cell.fiveView bk_whenTapped:^{
        if (USER_SINGLE.token.length<= 0) {
//            [AlertView showYMAlertView:self.view andtitle:@"请登录账号"];
//            __block TXGroundController *blockSelf = self;
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [blockSelf gotoLogin];
//            });
            [blockSelf.loginBtnView removeFromSuperview];
            blockSelf.loginBtnView = nil;
        }
//        else{
        TXWebViewController *webVC =  [[UIStoryboard storyboardWithName:@"HomePage" bundle:nil] instantiateViewControllerWithIdentifier:@"TXWebViewController"];
//         [USER_SINGLE isLogin]?list_talent_token:
        webVC.intype =  list_talent;
        [blockSelf.navigationController pushViewController:webVC animated:YES];
//        }
    }];
    [cell.sixView bk_whenTapped:^{
        if (USER_SINGLE.token.length<= 0) {
            [blockSelf.loginBtnView removeFromSuperview];
            blockSelf.loginBtnView = nil;
        }
        EducationChanController *vc = [[UIStoryboard storyboardWithName:@"HomePage" bundle:nil] instantiateViewControllerWithIdentifier:@"EducationChanController"];
        [blockSelf.navigationController pushViewController:vc animated:YES];
    }];
    [cell.otherLibraryView bk_whenTapped:^{
        if (USER_SINGLE.token.length<= 0) {
            [blockSelf.loginBtnView removeFromSuperview];
            blockSelf.loginBtnView = nil;
        }
        EntreprenurialController *vc = [[UIStoryboard storyboardWithName:@"Entrepreneurial" bundle:nil] instantiateViewControllerWithIdentifier:@"EntreprenurialController"];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [cell.otherServiceView bk_whenTapped:^{
        if (USER_SINGLE.token.length<= 0) {
            [blockSelf.loginBtnView removeFromSuperview];
            blockSelf.loginBtnView = nil;
        }
        ComprehensiveServerController *vc = [[UIStoryboard storyboardWithName:@"HomePage" bundle:nil] instantiateViewControllerWithIdentifier:@"ComprehensiveServerController"];
        [blockSelf.navigationController pushViewController:vc animated:YES];
    }];
    [cell.sevenView bk_whenTapped:^{
        if (USER_SINGLE.token.length<= 0) {
            [blockSelf.loginBtnView removeFromSuperview];
            blockSelf.loginBtnView = nil;
        }
        LibraryController *vc = [[UIStoryboard storyboardWithName:@"HomePage" bundle:nil] instantiateViewControllerWithIdentifier:@"LibraryController"];
        [blockSelf.navigationController pushViewController:vc animated:YES];
    }];
    [cell.eightView bk_whenTapped:^{
        if (USER_SINGLE.token.length<= 0) {
            [blockSelf.loginBtnView removeFromSuperview];
            blockSelf.loginBtnView = nil;
        }
        TXWebViewController *webVC =  [[UIStoryboard storyboardWithName:@"HomePage" bundle:nil] instantiateViewControllerWithIdentifier:@"TXWebViewController"];
//        [USER_SINGLE isLogin]?deal_list_token:
        webVC.intype =  deal_list;
        [blockSelf.navigationController pushViewController:webVC animated:YES];
    }];
    [cell.connectLabel bk_whenTapped:^{
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"0760-88587021"];
        CGFloat version = [[[UIDevice currentDevice]systemVersion]floatValue];
        if (version >= 10.0) {
            /// 大于等于10.0系统使用此openURL方法
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str] options:@{} completionHandler:nil];
        } else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }
    }];
}
-(LoginBottomView *)loginBtnView{
    if (_loginBtnView == nil) {
        _loginBtnView = [[NSBundle mainBundle] loadNibNamed:@"LoginBottomView" owner:self options:nil][0];
        [_loginBtnView.loginBtn bk_whenTapped:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                            TXLoginNavControllerViewController *vc = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"TXLoginNavControllerViewController"];
                            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                
                            appDelegate.window.rootViewController = vc;
                            [appDelegate.window makeKeyAndVisible];
                });
        }];
        [_loginBtnView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.7]];
        _loginBtnView.frame = CGRectMake(0, ScreenH-112, ScreenW, 64);
        [_loginBtnView.loginBtn makeCorner:_loginBtnView.loginBtn.frame.size.height/2];
    }
    return _loginBtnView;
}
-(void)gotoLogin{
    TXLoginNavControllerViewController *vc = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"TXLoginNavControllerViewController"];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    appDelegate.window.rootViewController = vc;
    [appDelegate.window makeKeyAndVisible];
}

@end
