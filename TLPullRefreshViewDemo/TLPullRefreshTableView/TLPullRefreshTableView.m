//
//  TLPullRefreshTableView.m
//  TLPullRefreshViewDemo
//
//  Created by Creolophus on 4/16/15.
//  Copyright (c) 2015 Creolophus. All rights reserved.
//

#import "TLPullRefreshTableView.h"

@protocol RefreshViewDelegate <NSObject>



@end

@interface TLPullRefreshTableView ()

@property (assign, nonatomic) PullRefreshType prType;


@end

@implementation TLPullRefreshTableView{
    CGFloat orignContentOffsetY;
    CGFloat orignContentInsetTop;
    BOOL needDetectTopRefreshViewFrame;
}

NSString *kContentOffset     = @"contentOffset";
NSString *kContentInset      = @"contentInset";
NSString *kContentSize       = @"contentSize";
CGFloat kPRRefreshViewHeight = 60.0;
CGFloat kPRLoadViewHeight    = 50.0;
CGFloat kPRAnimationDuration = 0.2;

#pragma mark Init Method
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [self initWithFrame:frame style:style pullRefreshType:PRTypeTopRefresh];
    if (self) {

    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style pullRefreshType:(PullRefreshType)prType{
    self = [super initWithFrame:frame style:style];
    if (self) {
        needDetectTopRefreshViewFrame = YES;
        self.prType = prType;
        [self addObserver];
    }
    return self;

}

//- (void)setPrType:(PullRefreshType)prType{
//    _prType = prType;
//    switch (prType) {
//        case PRTypeTopRefresh:{
//            UIView *backgroundView = [[UIView alloc] initWithFrame:self.bounds];
//            backgroundView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
//            [backgroundView addSubview:self.topRefreshView];
//            self.backgroundView= backgroundView;
//            break;
//        }
//        case PRTypeTopRefreshBottomLoad:{
//            //handle top refresh view
//            UIView *backgroundView = [[UIView alloc] initWithFrame:self.bounds];
//            backgroundView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
//            [backgroundView addSubview:self.topRefreshView];
//            self.backgroundView= backgroundView;
//            
//            //handle bottom load more view
//            [self addSubview:self.loadMoreView];
//    
//        }
//            break;
//            
//        default:
//            break;
//    }
//}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    if (newSuperview) {
        switch (_prType) {
            case PRTypeTopRefresh:{
                UIView *backgroundView = [[UIView alloc] initWithFrame:self.bounds];
                backgroundView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
                [backgroundView addSubview:self.topRefreshView];
                self.backgroundView= backgroundView;
                break;
            }
            case PRTypeTopRefreshBottomLoad:{
                //handle top refresh view
                UIView *backgroundView = [[UIView alloc] initWithFrame:self.bounds];
                backgroundView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
                [backgroundView addSubview:self.topRefreshView];
                self.backgroundView= backgroundView;
                
                //handle bottom load more view
                [self addSubview:self.loadMoreView];
                
            }
                break;
                
            default:
                break;
        }

    }
}

- (void)addObserver{
    [self addObserver:self forKeyPath:kContentOffset options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:kContentInset options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    [self addObserver:self forKeyPath:kContentSize options:NSKeyValueObservingOptionNew context:nil];

}

#pragma mark Getter Method
- (UIView *)topRefreshView{
    if (!_topRefreshView) {
        _topRefreshView = [[BaseTopRefreshView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, kPRRefreshViewHeight)];
    }
    return _topRefreshView;
}

- (UIView *)loadMoreView{
    if (!_loadMoreView) {
        _loadMoreView = [[BaseLoadMoreView alloc] initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, kPRLoadViewHeight)];
    }
    return _loadMoreView;
}


#pragma mark TableView State

- (void)setReachedEnd:(BOOL)reachedEnd{
    _reachedEnd = reachedEnd;
    if (_reachedEnd) {
        _loadMoreView.loadState = LoadStateReachEnd;
    }
}

- (void)tableViewDidScroll{
    needDetectTopRefreshViewFrame = NO;
    if (_topRefreshView.refreshState == PRStateRefreshing || _loadMoreView.loadState == LoadStateLoading) {
        return;
    }
    
    CGPoint offset = self.contentOffset;
    offset.y -= orignContentOffsetY;
    CGSize size = self.frame.size;
    CGSize contentSize = self.contentSize;
    if (contentSize.height < self.frame.size.height) {
        contentSize.height = self.frame.size.height;
    }
    
    if (_prType == PRTypeTopLoad) {
        //to be continued
    }else{
        
        //1.topRefreshView appears totally
        
        if (offset.y <= - kPRRefreshViewHeight) {
            _topRefreshView.refreshState = PRStateReleaseToRefresh;
            _topRefreshView.progress = 1;
        }
        
        //2.topRefreshView appears partly
        
        else if (offset.y > -kPRRefreshViewHeight && offset.y < 0){
            _topRefreshView.refreshState = PRStatePullToRefresh;
            _topRefreshView.progress = fabs(offset.y) / kPRRefreshViewHeight;
        }
        
        //3.bottomLoadView will appear
        
        float yMargin = self.contentOffset.y + size.height - contentSize.height;
        if (yMargin > 10 && (_prType == PRTypeBottomLoad || _prType == PRTypeTopRefreshBottomLoad) && !_reachedEnd) {
            
            _loadMoreView.loadState = LoadStateLoading;
            if (_loadBlock) {
                _loadBlock();
            }
            
            [UIView animateWithDuration:kPRAnimationDuration animations:^{
                self.contentInset = UIEdgeInsetsMake(orignContentInsetTop, 0, kPRLoadViewHeight, 0);
            }];
        }
        
    }
}

- (void)tableViewDidEndDragging{
    if (_topRefreshView.refreshState != PRStateReleaseToRefresh) {
        return;
    }
    _isRefreshing = YES;
    _reachedEnd = NO;
    _topRefreshView.refreshState = PRStateRefreshing;
    
    if (_refreshBlock) {
        _refreshBlock();
    }
    
    [UIView animateWithDuration:kPRAnimationDuration animations:^{
        self.contentInset = UIEdgeInsetsMake(kPRRefreshViewHeight + orignContentInsetTop, 0, 0, 0);
    } completion:nil];
    
}

- (void)finishLoading{
    _isRefreshing = NO;
    
    if (_loadMoreView.loadState == LoadStateLoading) {
        _loadMoreView.loadState = LoadStateNormal;

    }else if (_loadMoreView.loadState == LoadStateReachEnd){
        self.contentInset = UIEdgeInsetsMake(orignContentInsetTop, 0, 0, 0);
    }
    
    if (_topRefreshView.refreshState == PRStateRefreshing) {
        _topRefreshView.refreshState = PRStatePullToRefresh;

        [UIView animateWithDuration:kPRAnimationDuration animations:^{
            self.contentInset = UIEdgeInsetsMake(orignContentInsetTop, 0, 0, 0);
        } completion:nil];
    }
}

#pragma mark KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object != self) {
        return;
    }
    if ([keyPath isEqual:kContentOffset]) {

        //tableview一被加载,就会自动调整ContentOffset,会自动触发tableViewDidScroll,所以要判断一下
        if (needDetectTopRefreshViewFrame) {
            if (self.isDragging) {
                [self tableViewDidScroll];
            }
        }else{
            //如果未达到刷新的offset,会自动回滚,也需要将progress传出
            [self tableViewDidScroll];
        }
        if (!self.isDragging && _topRefreshView.refreshState == PRStateReleaseToRefresh) {
            [self tableViewDidEndDragging];
        }
    }else if ([keyPath isEqual:kContentInset]) {

        UIEdgeInsets new = [change[@"new"] UIEdgeInsetsValue];
        UIEdgeInsets old = [change[@"old"] UIEdgeInsetsValue];
        if (new.top != old.top) {
            if (needDetectTopRefreshViewFrame) {
                orignContentInsetTop = self.contentInset.top;
                orignContentOffsetY = self.contentOffset.y;
                _topRefreshView.frame = CGRectMake(0, orignContentInsetTop, _topRefreshView.frame.size.width, _topRefreshView.frame.size.height);
            }
        }
    }else if ([keyPath isEqual:kContentSize]) {

        CGRect frame = _loadMoreView.frame;
        if (_prType == PRTypeTopRefreshBottomLoad || _prType == PRTypeBottomLoad) {
            CGSize contentSize = self.contentSize;
            frame.origin.y = contentSize.height < self.frame.size.height ? self.frame.size.height : contentSize.height;
        }
        _loadMoreView.frame = frame;
    }
}

- (void)dealloc{
    [self removeObserver:self forKeyPath:kContentOffset];
    [self removeObserver:self forKeyPath:kContentInset];
}

@end
