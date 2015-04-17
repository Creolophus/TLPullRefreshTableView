//
//  ViewController.m
//  TLPullRefreshViewDemo
//
//  Created by Creolophus on 4/16/15.
//  Copyright (c) 2015 Creolophus. All rights reserved.
//

#import "ViewController.h"
#import "TLPullRefreshTableView.h"
#import "CustomTopRefreshView.h"

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) TLPullRefreshTableView *tableView;

@property (strong, nonatomic) NSMutableArray *localArray;


@end

struct Page {
    NSInteger pageSize;
    NSInteger pageNum;
};

struct Page page;

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    _tableView = [[TLPullRefreshTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain pullRefreshType:PRTypeTopRefreshBottomLoad];
    _tableView.topRefreshView = [[CustomTopRefreshView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor redColor];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _tableView.tableFooterView = [UIView new];
    
    page.pageNum = 0;
    page.pageSize = 30;
    
    __weak ViewController *wkSelf = self;
    _tableView.refreshBlock = ^(void){
        page.pageNum = 0;
        [wkSelf loadData];
    };
    _tableView.loadBlock = ^(void){
        [wkSelf loadData];
    };
    self.navigationController.navigationBar.translucent = NO;
    [self.view addSubview:_tableView];
    
    
    
    _localArray = [NSMutableArray array];
    for (int i=0; i<page.pageSize; i++) {
        [_localArray addObject:[NSString stringWithFormat:@"%@", @(i + page.pageNum * page.pageSize)]];
    }
    page.pageNum++;

}

- (void)loadData{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if (_tableView.isRefreshing) {
            [_localArray removeAllObjects];
        }

        for (int i=0; i<page.pageSize; i++) {
            [_localArray addObject:[NSString stringWithFormat:@"%@", @(i + page.pageNum * page.pageSize)]];
        }
        
        if (page.pageNum == 2) {
            _tableView.reachedEnd = YES;
        }
        page.pageNum++;
        [_tableView reloadData];
        [_tableView finishLoading];

    });
    
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _localArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellId"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@", _localArray[indexPath.row]];

    return cell;
}

#pragma mark -- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
