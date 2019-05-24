//
//  HomeServerCell.m
//  TXProject
//
//  Created by Sam on 2018/12/26.
//  Copyright © 2018年 sam. All rights reserved.
//

#import "HomeServerCell.h"
#import "HomePageModelCell.h"
#import "TXWebViewController.h"
#import "CompanyListController.h"
#import "SameCityCommerceController.h"
#import "ProductionListController.h"
@interface HomeServerCell()<UICollectionViewDelegate,UICollectionViewDataSource>
@end
@implementation HomeServerCell

- (void)awakeFromNib {
    [super awakeFromNib];    // Initialization code
}
-(void)setupArray{
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    UICollectionViewFlowLayout *layout =[[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.itemSize = CGSizeMake(ScreenW/3,125*kScale);
    self.collectionView.collectionViewLayout = layout;
    self.collectionView.scrollEnabled = NO;
    [self.collectionView reloadData];
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

// 设置每个分区返回多少item
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.serverArray.count;
}

// 设置集合视图有多少个分区
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

//#pragma mark  定义每个UICollectionView的大小
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return  CGSizeMake(125*kScale,125*kScale);
//}
//#pragma mark  定义整个CollectionViewCell与整个View的间距
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    return UIEdgeInsetsMake(0, 0, 0, 0);//（上、左、下、右）
//}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.typeIndex == 0) {
        if (indexPath.row == 0) {
            SameCityCommerceController *vc = [[UIStoryboard storyboardWithName:@"CommerceView" bundle:nil] instantiateViewControllerWithIdentifier:@"SameCityCommerceController"];
            vc.sameCity = YES;///同籍社团
            [self.serverVC.navigationController pushViewController:vc animated:YES];
      
        }else if (indexPath.row == 1){
            SameCityCommerceController *vc = [[UIStoryboard storyboardWithName:@"CommerceView" bundle:nil] instantiateViewControllerWithIdentifier:@"SameCityCommerceController"];
            vc.sameCity = NO;///同籍社团
            [self.serverVC.navigationController pushViewController:vc animated:YES];
          
        }else if (indexPath.row == 2){
            [self gotoWebView:enterprise_search];
        }
    }else if(self.typeIndex == 1){
        if (indexPath.row == 0 ) {
            ProductionListController *vc = [[UIStoryboard storyboardWithName:@"Production" bundle:nil] instantiateViewControllerWithIdentifier:@"ProductionListController"];
            [self.serverVC.navigationController pushViewController:vc animated:YES];
//
        }else{
            [self gotoWebView:list_service];
       
        }
    }else if (self.typeIndex == 2){
        if (indexPath.row == 0) {
            [self gotoWebView:commerce_library_list];
        }else{
            [self gotoWebView:company_library_list];
           
        }
    }else{
        if (indexPath.row == 0) {
//            CompanyListController.h
            CompanyListController *vc = [[UIStoryboard storyboardWithName:@"CommerceView" bundle:nil] instantiateViewControllerWithIdentifier:@"CompanyListController"];
            [self.serverVC.navigationController pushViewController:vc animated:YES];
//             [self gotoWebView:list_bind_enterprise];
        }else if (indexPath.row == 1){
            [self gotoWebView:list_base];
        }else if (indexPath.row == 2){
            [self gotoWebView:list_job];
        }else if (indexPath.row == 3){
            [self gotoWebView:list_internship_apply];
        }else if (indexPath.row == 4){
            [self gotoWebView:pef_internship_list];
        }else if (indexPath.row == 5){
            [self gotoWebView:common_project_list];
        }
    }
    
}
-(void)gotoWebView:(INTYPE)type{
    TXWebViewController *webVC =  [[UIStoryboard storyboardWithName:@"HomePage" bundle:nil] instantiateViewControllerWithIdentifier:@"TXWebViewController"];
    webVC.intype = type;
    [self.serverVC.navigationController pushViewController:webVC animated:YES];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HomePageModelCell *cell = (HomePageModelCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"HomePageModelCell" forIndexPath:indexPath];
    NSDictionary *dic = self.serverArray[indexPath.row];
    [cell.bgImage setImage:[UIImage imageNamed:dic[@"image"]]];
    cell.titleLabel.text = dic[@"title"];
    return cell;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
