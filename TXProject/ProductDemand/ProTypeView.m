//
//  ProTypeView.m
//  TXProject
//
//  Created by Sam on 2019/4/4.
//  Copyright © 2019 sam. All rights reserved.
//

#import "ProTypeView.h"
#import "ProductionTypeCell.h"
@interface ProTypeView()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *closeIcon;

@property (nonatomic) NSString *selectString;
@end
@implementation ProTypeView
-(void)setupCollectionView{
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"ProductionCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"ProductionTypeCell"];
    [self.collectionView reloadData];
    __block ProTypeView *blockSelf = self;
    [self.closeIcon bk_whenTapped:^{
        blockSelf.hidden = YES;
    }];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(191*kScale, 59*kScale);
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


//已经选中某个item时触发的方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath; {
    
    ProductionTypeCell *cell =(ProductionTypeCell *) [collectionView cellForItemAtIndexPath:indexPath];
    self.selectString = cell.title.text;
    self.selectStringCallBack(self.selectString);
    [self.collectionView reloadData];
    self.hidden = YES;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
