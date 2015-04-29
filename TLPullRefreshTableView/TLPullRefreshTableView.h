//
//  TLPullRefreshTableView.h
//  TLPullRefreshViewDemo
//
//  Created by Creolophus on 4/16/15.
//  Copyright (c) 2015 Creolophus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTopRefreshView.h"
#import "BaseLoadMoreView.h"


typedef enum : NSUInteger {
    PRTypeTopRefresh, //只顶部刷新
    PRTypeBottomLoad, //只底部加载更多
    PRTypeTopRefreshBottomLoad, //顶部刷新，底部加载更多
    PRTypeTopLoad, //只顶部加载更多
} PullRefreshType;

typedef void(^RefreshBlock)();
typedef void(^LoadBlock)();

@interface TLPullRefreshTableView : UITableView
/**
 *  若数据加载完，可以设置YES，来告诉用户到达最末端了。
 */
@property (assign, nonatomic) BOOL reachedEnd;

/**
 *  判断table是不是在刷新。
 *  当从服务器获取到数据时，可以根据这个变量来决定是否需要删除之前的数据。
 */
@property (assign, nonatomic) BOOL isRefreshing;

@property (strong, nonatomic) BaseTopRefreshView *topRefreshView;

@property (strong, nonatomic) BaseLoadMoreView *loadMoreView;

@property (copy, nonatomic) RefreshBlock refreshBlock;

@property (copy, nonatomic) LoadBlock loadBlock;

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style pullRefreshType:(PullRefreshType)prType;

/**
 *  结束加载或刷新
 */
- (void)finishLoading;

- (BaseTopRefreshView *)topRefreshView;

- (BaseLoadMoreView *)loadMoreView;


@end
