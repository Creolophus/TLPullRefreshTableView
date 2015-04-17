//
//  BaseLoadMoreView.m
//  TLPullRefreshViewDemo
//
//  Created by Creolophus on 4/16/15.
//  Copyright (c) 2015 Creolophus. All rights reserved.
//

#import "BaseLoadMoreView.h"

@interface BaseLoadMoreView ()
@property (strong, nonatomic) UILabel *label;
@end

@implementation BaseLoadMoreView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 20)];
        _label.font = [UIFont systemFontOfSize:14.0];
        _label.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        _label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_label];
    }
    return self;
}

- (void)setLoadState:(LoadState)loadState{
    if (_loadState == loadState) {
        return;
    }
    _loadState = loadState;
    switch (_loadState) {
        case LoadStateNormal:{
            _label.text = @"加载更多";
            break;
        }
        case LoadStateLoading:{
            _label.text = @"正在加载";
            break;
        }
        case LoadStateReachEnd:{
            _label.text = @"没有更多";
            break;
        }
            
        default:
            break;
    }
}

@end
