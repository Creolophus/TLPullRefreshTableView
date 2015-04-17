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
@property (strong, nonatomic) UIActivityIndicatorView *indicatorView;

@end

@implementation BaseLoadMoreView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 20)];
        _label.font = [UIFont systemFontOfSize:14.0];
        _label.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        _label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_label];
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _indicatorView.color = [UIColor redColor];
        _indicatorView.frame = CGRectMake(self.frame.size.width/2, self.frame.size.height/2, 0, 0);
        [self addSubview:_indicatorView];
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
            [_indicatorView startAnimating];
            _label.hidden = YES;
            break;
        }
        case LoadStateLoading:{
            _label.hidden = YES;
            [_indicatorView startAnimating];
            break;
        }
        case LoadStateReachEnd:{
            [_indicatorView stopAnimating];
            _label.hidden = NO;
            _label.text = @"没有更多";
            break;
        }
            
        default:
            break;
    }
}

@end
