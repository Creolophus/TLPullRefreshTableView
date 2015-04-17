//
//  CustomTopRefreshView.m
//  TLPullRefreshViewDemo
//
//  Created by Creolophus on 4/17/15.
//  Copyright (c) 2015 Creolophus. All rights reserved.
//

#import "CustomTopRefreshView.h"

@interface CustomTopRefreshView ()
@property (strong, nonatomic) CALayer *redLayer;
@property (strong, nonatomic) CALayer *blueLayer;

@end

@implementation CustomTopRefreshView


- (void)setup{
    _redLayer = [[CALayer alloc] init];
    _redLayer.backgroundColor = [UIColor redColor].CGColor;
    _redLayer.frame = CGRectMake(0, 0, 30, 30);
    _redLayer.anchorPoint = CGPointMake(-0.5, 0.5);
    _redLayer.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    
    
    _blueLayer = [[CALayer alloc] init];
    _blueLayer.backgroundColor = [UIColor colorWithRed:0.110 green:0.494 blue:1.000 alpha:1.000].CGColor;
    _blueLayer.frame = CGRectMake(0, 0, 30, 30);
    _blueLayer.anchorPoint = CGPointMake(1.5, 0.5);
    _blueLayer.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    
    CATransform3D tran = CATransform3DIdentity;
    tran.m34 = 1/300;
    _redLayer.transform = tran;
    tran.m34 = -1/300;
    _blueLayer.transform = tran;

    [self.layer addSublayer:_redLayer];
    
    [self.layer addSublayer:_blueLayer];
    
}

- (void)setProgress:(CGFloat)progress{
    _redLayer.cornerRadius = progress * _redLayer.bounds.size.width / 2;
    _blueLayer.cornerRadius = progress * _blueLayer.bounds.size.width / 2;
}

- (void)setRefreshState:(PRState)refreshState{
    [super setRefreshState:refreshState];
    switch (refreshState) {
        case PRStatePullToRefresh:{
            [_blueLayer removeAllAnimations];
            [_redLayer removeAllAnimations];
            break;
        }
            
        case PRStateReleaseToRefresh:{

            break;
        }
            
        case PRStateRefreshing:{
            [_blueLayer addAnimation:[self addRotateAnimation] forKey:nil];
            [_redLayer addAnimation:[self addRotateAnimation] forKey:nil];
            break;
        }
        default:
            break;
    }

}


- (CABasicAnimation *)addRotateAnimation{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    animation.fromValue = @(0);
    animation.toValue = @(360 * M_PI / 180);
    animation.duration = 1;
    animation.repeatCount = INFINITY;
//    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    return animation;
}

@end
