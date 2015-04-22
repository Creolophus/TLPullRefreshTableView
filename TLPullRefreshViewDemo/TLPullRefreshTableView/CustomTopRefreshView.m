//
//  CustomTopRefreshView.m
//  TLPullRefreshViewDemo
//
//  Created by Creolophus on 4/17/15.
//  Copyright (c) 2015 Creolophus. All rights reserved.
//

#import "CustomTopRefreshView.h"

@interface CustomTopRefreshView ()

@property (strong, nonatomic) CAShapeLayer *ovalShapeLayer;

@end

@implementation CustomTopRefreshView


- (void)setup{
    
    _ovalShapeLayer = [[CAShapeLayer alloc] init];
//    _ovalShapeLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(self.frame.size.width/2 - 20, self.frame.size.height/2 - 20, 40, 40)].CGPath;
    _ovalShapeLayer.strokeColor = [UIColor grayColor].CGColor;
    _ovalShapeLayer.fillColor = [UIColor clearColor].CGColor;
    _ovalShapeLayer.lineWidth = 2.0;

//    _ovalShapeLayer.lineDashPattern = @[@(2), @(2)];
    [self.layer addSublayer:_ovalShapeLayer];
    
}

- (void)setProgress:(CGFloat)progress{
    _ovalShapeLayer.strokeEnd = progress;
    _ovalShapeLayer.opacity = progress;
    NSLog(@"%@", NSStringFromCGRect(_ovalShapeLayer.frame));
    _ovalShapeLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(self.frame.size.width/2 - 20, self.frame.size.height/2 - 20 - (60 - progress*60), 40, 40)].CGPath;


}

- (void)setRefreshState:(PRState)refreshState{
    [super setRefreshState:refreshState];
    switch (refreshState) {
        case PRStatePullToRefresh:{
            _ovalShapeLayer.opacity = 0;
            [_ovalShapeLayer removeAllAnimations];
            break;
        }
            
        case PRStateReleaseToRefresh:{
            break;
        }
            
        case PRStateRefreshing:{
            [_ovalShapeLayer addAnimation:[self addRotateAnimation] forKey:@"1"];
            break;
        }
        default:
            break;
    }

}


- (CAAnimation *)addRotateAnimation{
    CABasicAnimation *a1 = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    a1.fromValue = @(-.5);
    a1.toValue = @(1);
    CABasicAnimation *a2 = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    a2.fromValue = @(0);
    a2.toValue = @(1);
    
    CAAnimationGroup *group = [CAAnimationGroup new];
    group.animations = @[a1, a2];
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    group.repeatCount = INFINITY;
    group.duration = 1;
    return group;
}

@end
