//
//  ProductionSelectView.m
//  TXProject
//
//  Created by Sam on 2019/4/2.
//  Copyright © 2019 sam. All rights reserved.
//
#import "ProductionTypeCell.h"
#import "ProductionSelectView.h"
@interface ProductionSelectView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic) NSString *selectString;
@end
@implementation ProductionSelectView

-(void)setupCollection{
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"ProductionCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"ProductionTypeCell"];
    [self.collectionView reloadData];
    __block ProductionSelectView *blockSelf = self;
    [self.sureLabel bk_whenTapped:^{
       blockSelf.selectStringCallBack(blockSelf.selectString);
        blockSelf.hidden = YES;
    }];
    [self.resetLabel bk_whenTapped:^{
        blockSelf.selectString = @"";
        [blockSelf.collectionView reloadData];
    }];
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ProductionTypeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ProductionTypeCell" forIndexPath:indexPath];
    cell.title.text = self.dataArray[indexPath.row];
    if ([self.selectString isEqualToString:cell.title.text]) {
        cell.bgView.backgroundColor =[UIColor colorWithRGB:0x3f78bc];
        cell.title.textColor = [UIColor whiteColor];
    }else{
        cell.bgView.backgroundColor =[UIColor colorWithRGB:0xf2f2f2];
        cell.title.textColor = [UIColor colorWithRGB:0x676868];
    }
    return cell;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}
//是否可以选中某个Item，返回NO，则不能选中
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath; {
    return YES;
}

//是否可以取消选中某个Item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath; {
    return YES;
}

//已经选中某个item时触发的方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath; {
   
    ProductionTypeCell *cell =(ProductionTypeCell *) [collectionView cellForItemAtIndexPath:indexPath];
    self.selectString = cell.title.text;
    
     [self.collectionView reloadData];
}

//取消选中某个Item时触发的方法
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath; {
//    ProductionTypeCell *cell =(ProductionTypeCell *) [collectionView cellForItemAtIndexPath:indexPath];
    self.selectString = @"";
    [self.collectionView reloadData];
}

#pragma mark  定义每个UICollectionView的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return  CGSizeMake((ScreenW-15) /3,48*kScale);
}



#pragma mark  定义整个CollectionViewCell与整个View的间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(2, 3.5, 0, 0);//（上、左、下、右）
}


@end
