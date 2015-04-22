//
//  BaseTopRefreshView.m
//  TLPullRefreshViewDemo
//
//  Created by Creolophus on 4/16/15.
//  Copyright (c) 2015 Creolophus. All rights reserved.
//

#import "BaseTopRefreshView.h"


NSString* kRotationAnimation = @"RotationAnimation";

@interface BaseTopRefreshView ()
@property (strong, nonatomic) CALayer *containerLayer;
@property (strong, nonatomic) NSMutableArray *componetLayers;
@property (assign, nonatomic) BOOL isRefreshingAnimation;

@end

@implementation BaseTopRefreshView

- (instancetype)init
{
    self = [self initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 60)];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 60)];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setup];
    }
    return self;
}

- (void)setup {
    _componetLayers = [NSMutableArray array];
    CGRect frame = self.frame;
    _containerLayer = [[CALayer alloc] init];
    _containerLayer.frame = CGRectMake(0, 0, 40, 40);

    _containerLayer.position = CGPointMake(frame.size.width/2, frame.size.height/2);
    [self.layer addSublayer:_containerLayer];
    
    for (int i=0; i<12; i++) {
        
        CALayer *layer = [self createComponentLayer];
        layer.transform = CATransform3DMakeRotation(M_PI / 6 * i, 0, 0, 1);
        [_containerLayer addSublayer:layer];
        [_componetLayers addObject:layer];
    }
}

- (UIColor *)tintColor{
    if (!_tintColor) {
        _tintColor = [UIColor redColor];
    }
    return _tintColor;
}

- (void)setProgress:(CGFloat)progress{
    _progress = progress;
    
    if (_isRefreshingAnimation) {
        return;
    }
    
    for (int i=0; i<12; i++) {
        CALayer *layer = _componetLayers[i];
        if (i < progress * 12.0) {
            layer.hidden = NO;
        }else{
            layer.hidden = YES;
        }
    }

}

- (void)setRefreshState:(PRState)refreshState{
    if (_refreshState == refreshState) {
        return;
    }
    _refreshState = refreshState;
    if ([NSStringFromClass([self class]) isEqual:@"BaseTopRefreshView"]) {
        switch (refreshState) {
            case PRStatePullToRefresh:{
                [self stopAnimation];
                break;
            }
                
            case PRStateReleaseToRefresh:{
                [self releaseToRefreshAnimation];
                break;
            }
                
            case PRStateRefreshing:{
                [_containerLayer removeAnimationForKey:kRotationAnimation];
                [self addOpacityAnimation];
                break;
            }
            default:
                break;

        return;
   
        }
        
    }
}

- (void)releaseToRefreshAnimation{
//    self.isRotating = YES;
    [self.containerLayer addAnimation:[self createRotatonAnimation] forKey:kRotationAnimation];
    
}


- (void)addOpacityAnimation{
    _isRefreshingAnimation = YES;
    [_componetLayers enumerateObjectsUsingBlock:^(CALayer *layer, NSUInteger idx, BOOL *stop) {
        CAAnimation *animation = [self createOpacityAnimationWithIndex:idx];
        [layer addAnimation:animation forKey:nil];
        
    }];
}

- (CAAnimation *)createRotatonAnimation{
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotationAnimation.fromValue = [NSNumber numberWithFloat:0];
    rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI];
    rotationAnimation.duration = 0.5f;
    rotationAnimation.repeatCount = INFINITY;
    rotationAnimation.speed = 0.5f;
    return rotationAnimation;
}


- (CAAnimation *)createOpacityAnimationWithIndex:(NSInteger)index {
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = @(1);
    opacityAnimation.toValue = @(0);
    opacityAnimation.duration = 1.0;
    opacityAnimation.repeatCount = INFINITY;
    opacityAnimation.timeOffset = 1.0 - index / 12.0;
    return opacityAnimation;
}

- (void)stopAnimation{
    _isRefreshingAnimation = NO;
    [_containerLayer removeAllAnimations];
    [_componetLayers enumerateObjectsUsingBlock:^(CALayer *layer, NSUInteger idx, BOOL *stop) {
        [layer removeAllAnimations];
    }];
}

- (CALayer *)createComponentLayer{
    CALayer *layer = [[CALayer alloc] init];
    layer.backgroundColor = self.tintColor.CGColor;
    layer.frame = CGRectMake(20-1, 20-4, 2, 8);
    layer.anchorPoint = CGPointMake(0.5, 2.0);
    layer.allowsEdgeAntialiasing = YES;

    layer.cornerRadius = 1.0f;
    [self.layer addSublayer:layer];
    
    return layer;
}

@end
