//
//  UICollectionViewController+RefreshControl.m
//
//  Created by Alexey Demin on 26/08/15.
//  Copyright (c) 2015 Alexey Demin. All rights reserved.
//

#import "UICollectionViewController+RefreshControl.h"


@implementation UICollectionViewController (RefreshControl)

- (UIRefreshControl *)refreshControl
{
    for (UIView *view in self.collectionView.subviews) {
        if ([view isKindOfClass:[UIRefreshControl class]]) {
            return (UIRefreshControl *)view;
        }
    }
    return nil;
}


- (void)setRefreshControl:(UIRefreshControl *)refreshControl
{
    [self.refreshControl removeFromSuperview];
    [self.collectionView addSubview:refreshControl];
    [self.collectionView.panGestureRecognizer addTarget:self action:@selector(handlePan:)];
}


- (void)handlePan:(UIPanGestureRecognizer *)panGestureRecognizer
{
    CGPoint translation = [panGestureRecognizer translationInView:self.collectionView];
    CGPoint offset = self.collectionView.contentOffset;
    offset.y += self.topLayoutGuide.length;
    static CGFloat offsetY;
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan) offsetY = offset.y;
    translation.y -= offsetY;
//    NSLog(@"%.f, %.f, %.f", translation.y, offset.y, self.collectionView.contentInset.top);
    if (offset.y < 0 && translation.y > 0) {
        UIRefreshControl *refreshControl = self.refreshControl;
        [self.collectionView sendSubviewToBack:refreshControl];
        offset.y = -translation.y + MAX(0, translation.y - refreshControl.frame.size.height) / 2 + MAX(0, translation.y - refreshControl.frame.size.height - 146) / 4; // 146 is well-known magic number in Russia :)
        offset.y -= self.topLayoutGuide.length;
        self.collectionView.contentOffset = offset;
    }
}

@end
