//
//  CommerceWorkCell.m
//  TXProject
//
//  Created by Sam on 2019/1/15.
//  Copyright © 2019 sam. All rights reserved.
//

#import "CommerceWorkCell.h"
#import "HomePageModelCell.h"
#import "TXWebViewController.h"
@interface CommerceWorkCell ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic) NSArray *urlArray;
@end
@implementation CommerceWorkCell


- (void)awakeFromNib {
    [super awakeFromNib];    // Initialization code
}
-(void)setupArray{
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.scrollEnabled = NO;
    self.urlArray = @[@[@"",@"",[NSString stringWithFormat:@"%@secretary/approved_list/0/1",WEB_HOST_URL]],@[[NSString stringWithFormat:@"%@secretary_member/manager/event_list/1/%@/1",WEB_HOST_URL,USER_SINGLE.default_commerce_id],[NSString stringWithFormat:@"%@secretary_member/manager/event_list/2/%@/1",WEB_HOST_URL,USER_SINGLE.default_commerce_id],[NSString stringWithFormat:@"%@secretary_member/manager/lib_list/1/////1",WEB_HOST_URL]]];
    [self.collectionView reloadData];
}


// 设置每个分区返回多少item
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.serverArray.count;
}

// 设置集合视图有多少个分区
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

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *arr = self.urlArray[self.typeIndex];
    if (!(SHOW_WEB)) {
        return;
    }
    [self gotoWebView: arr[indexPath.row]];
}
-(void)gotoWebView:(NSString *)url{
    if (url.length <= 0) {
        return;
    }
    TXWebViewController *webVC =  [[UIStoryboard storyboardWithName:@"HomePage" bundle:nil] instantiateViewControllerWithIdentifier:@"TXWebViewController"];
    webVC.webUrl = url;
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
