//
//  SecondViewController.m
//  RefreshableCollection
//
//  Created by Alexey Demin on 26/08/15.
//  Copyright (c) 2015 Alexey Demin. All rights reserved.
//

#import "SecondViewController.h"
#import "UICollectionViewController+RefreshControl.h"


static NSString *const CollectionViewCellReuseIdentifier = @"CollectionViewCellReuseIdentifier";


@interface SecondViewController () <UICollectionViewDelegateFlowLayout>

@end


@implementation SecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CollectionViewCellReuseIdentifier];
    
    UIRefreshControl *refreshControl = [UIRefreshControl new];
    self.refreshControl = refreshControl;
    [self updateRefreshTitle];
    [refreshControl layoutIfNeeded];
    [refreshControl beginRefreshing];
    [refreshControl endRefreshing];
    [refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
}


- (void)updateRefreshTitle
{
    NSString *title = self.refreshControl.isRefreshing ? @"Refreshing..." : @"Pull2Refresh";
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:title];
}


- (void)refresh
{
    [self updateRefreshTitle];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.refreshControl endRefreshing];
        [self updateRefreshTitle];
    });
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 20;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CollectionViewCellReuseIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithHue:(indexPath.row / 20.) saturation:0.5 brightness:1 alpha:1];
    
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.collectionView.bounds.size.width, 44);
}


- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [self.collectionViewLayout invalidateLayout];
}

@end
