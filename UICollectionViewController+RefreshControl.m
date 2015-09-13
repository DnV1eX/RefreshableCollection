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
        CGFloat h = refreshControl.frame.size.height; // Offset without resistance.
        CGFloat r = 1.6; // Initial resistance.
        CGFloat l = 900; // Maximum offset.
        CGFloat x = translation.y + h * r / (1 - h / l) - h;
        offset.y = -(translation.y < h ? translation.y : x / (r + x / l));
        offset.y -= self.topLayoutGuide.length;
        self.collectionView.contentOffset = offset;
    }
}

@end
