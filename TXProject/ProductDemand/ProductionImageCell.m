//
//  ProductionImageCell.m
//  TXProject
//
//  Created by Sam on 2019/3/27.
//  Copyright © 2019 sam. All rights reserved.
//

#import "ProductionImageCell.h"
#import "uploadProImageCell.h"
#import <ZLPhotoActionSheet.h>
#import <PYPhotoBrowser/PYPhotoBrowser.h>
@interface ProductionImageCell()<UICollectionViewDelegate,UICollectionViewDataSource,PYPhotoBrowseViewDelegate,PYPhotoBrowseViewDataSource>

@end
@implementation ProductionImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setupCollection{
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView reloadData];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.imageArray.count < 5) {
        return self.imageArray.count +1;
    }
    return self.imageArray.count == 0?1:self.imageArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(115*kScale, 115*kScale);
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    uploadProImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"uploadProImageCell" forIndexPath:indexPath];
    if (self.imageArray.count < 5) {
        if (indexPath.row == 0) {
            [cell.imageCell setImage: [UIImage imageNamed:@"upload_image"]];
            cell.delimageView.hidden = YES;
        }else{
            cell.delimageView.hidden = NO;
            [cell.imageCell setImage:self.imageArray[indexPath.row-1]];
        }
    }else{
        [cell.imageCell setImage:self.imageArray[indexPath.row]];
        cell.delimageView.hidden = NO;
        
    }
    [cell.delimageView bk_whenTapped:^{
        NSIndexPath *indexP = [collectionView indexPathForCell:cell];
        if (self.imageArray.count < 5) {
            [self.imageArray removeObjectAtIndex:indexP.row - 1];
        }else{
            [self.imageArray removeObjectAtIndex:indexP.row ];
        }
         self.selectArrayCallBack(self.imageArray);
        [self.tableView reloadData];
    }];
  
    [cell makeCorner:5];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.imageArray.count < 5) {
        if (indexPath.row == 0) {
            [self openLocalPhoto];
        }else{
            PYPhotoBrowseView *browseView = [[PYPhotoBrowseView alloc] init];
            
            // 2.设置数据源和代理并实现数据源和代理方法
            browseView.dataSource = self;
            browseView.delegate = self;
            browseView.images = self.imageArray;
            browseView.currentIndex = indexPath.row - 1;
            [browseView show];
        }
    }else{
        PYPhotoBrowseView *browseView = [[PYPhotoBrowseView alloc] init];
        
        // 2.设置数据源和代理并实现数据源和代理方法
        browseView.dataSource = self;
        browseView.delegate = self;
        browseView.images = self.imageArray;
        browseView.currentIndex = indexPath.row;
        [browseView show];
    }
}
-(void)openLocalPhoto{
    ZLPhotoActionSheet *ac = [[ZLPhotoActionSheet alloc] init];
    
    //相册参数配置，configuration有默认值，可直接使用并对其属性进行修改
    ac.configuration.maxSelectCount = 5 - self.imageArray.count;
    ac.configuration.maxPreviewCount = 10;
    ac.configuration.allowMixSelect = NO;
    ac.configuration.allowSelectGif = NO;
    ac.configuration.allowSelectVideo = NO;
    ac.configuration.clipRatios = @[GetClipRatio(1, 1)];
    //如调用的方法无sender参数，则该参数必传
    ac.sender = self.uploadVC;
    __block ProductionImageCell *blockSelf= self;
    //选择回调
    [ac setSelectImageBlock:^(NSArray<UIImage *> * _Nonnull images, NSArray<PHAsset *> * _Nonnull assets, BOOL isOriginal) {
        [blockSelf.imageArray addObjectsFromArray:images];
        blockSelf.selectArrayCallBack(blockSelf.imageArray);
        [blockSelf.collectionView reloadData];
    }];
    
    //调用相册
    [ac showPreviewAnimated:YES];
    
    //预览网络图片
//    [ac previewPhotos:arrNetImages index:0 hideToolBar:YES complete:^(NSArray * _Nonnull photos) {
//        //your codes
//    }];
}
@end
