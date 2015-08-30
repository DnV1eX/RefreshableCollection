//
//  FirstViewController.m
//  RefreshableCollection
//
//  Created by Alexey Demin on 26/08/15.
//  Copyright (c) 2015 Alexey Demin. All rights reserved.
//

#import "FirstViewController.h"


static NSString *const TableViewCellReuseIdentifier = @"TableViewCellReuseIdentifier";


@interface FirstViewController ()

@end


@implementation FirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:TableViewCellReuseIdentifier];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
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


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TableViewCellReuseIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithHue:(indexPath.row / 20.) saturation:0.5 brightness:1 alpha:1];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

@end
