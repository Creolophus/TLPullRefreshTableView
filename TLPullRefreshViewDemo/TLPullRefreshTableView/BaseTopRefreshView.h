//
//  BaseTopRefreshView.h
//  TLPullRefreshViewDemo
//
//  Created by Creolophus on 4/16/15.
//  Copyright (c) 2015 Creolophus. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    PRStatePullToRefresh,
    PRStateReleaseToRefresh,
    PRStateRefreshing,
    PRStateReachEnd
} PRState;

@interface BaseTopRefreshView : UIView
@property (strong, nonatomic) UIColor *tintColor;
@property (assign, nonatomic) PRState refreshState;
@property (assign, nonatomic) CGFloat progress;


- (void)setup;


@end
