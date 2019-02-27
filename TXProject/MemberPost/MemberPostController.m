//
//  MemberPostController.m
//  TXProject
//
//  Created by Sam on 2019/1/15.
//  Copyright © 2019 sam. All rights reserved.
//

#import "MemberPostController.h"
#import "TXWebViewController.h"
#import "HomePageModelCell.h"
@interface MemberPostController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic) NSArray *imageArray;
@property (nonatomic) NSArray *titleArray;
@property (nonatomic) NSArray *urlArray;
@end

@implementation MemberPostController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageArray = @[@"news",@"person",@"member_service",@"product",@"technology",@"comprehensive",@"Entrepreneurship"];
    self.titleArray = @[@"发布新闻",@"发布人才需求",@"发布服务需求",@"发布产品需求",@"发布技术需求",@"发布综合服务",@"发布创业宝典"];
    self.title = @"会员发布";
    self.urlArray  = @[[NSString stringWithFormat:@"%@list_m_news/0/1",WEB_HOST_URL],[NSString stringWithFormat:@"%@require_list_m_talent/1/%@/1///////1",WEB_HOST_URL,USER_SINGLE.default_commerce_id],[NSString stringWithFormat:@"%@require_list_m_service/1/%@/1////1",WEB_HOST_URL,USER_SINGLE.default_commerce_id],[NSString stringWithFormat:@"%@require_list_m_product/1/%@/1////1",WEB_HOST_URL,USER_SINGLE.default_commerce_id],[NSString stringWithFormat:@"%@require_list_m_technology/1/%@/1/////1",WEB_HOST_URL,USER_SINGLE.default_commerce_id],[NSString stringWithFormat:@"%@list_multi_services/1/1",WEB_HOST_URL],[NSString stringWithFormat:@"%@list_entrepreneurship/1/1",WEB_HOST_URL]];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
#pragma mark  定义每个UICollectionView的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return  CGSizeMake(125*kScale,125*kScale);
}
#pragma mark  定义整个CollectionViewCell与整个View的间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);//（上、左、下、右）
}
// 设置每个分区返回多少item
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.imageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HomePageModelCell *cell = (HomePageModelCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"HomePageModelCell" forIndexPath:indexPath];
    [cell.bgImage setImage:[UIImage imageNamed:self.imageArray[indexPath.row]]];
    cell.titleLabel.text = self.titleArray[indexPath.row];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *url = self.urlArray[indexPath.row];
    TXWebViewController *vc = [[UIStoryboard storyboardWithName:@"HomePage" bundle:nil] instantiateViewControllerWithIdentifier:@"TXWebViewController"];
    vc.webUrl = url;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
