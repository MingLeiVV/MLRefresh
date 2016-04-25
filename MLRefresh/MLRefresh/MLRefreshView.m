//
//  MLRefreshView.m
//  MLRefresh
//
//  Created by 磊 on 16/4/14.
//  Copyright © 2016年 磊. All rights reserved.
//

#import "MLRefreshView.h"
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)
#define RADIANS_TO_DEGREES(radians) ((radians) * (180.0 / M_PI))
#define ML_Step 170 // 线条总长度
#define everyChangeAngle 1*SPEED // 每次转动的角度
#define STROKE_END_RADIAN 160/RADIANS_TO_DEGREES(M_PI)
#define STROKE_PROCESS_RADIAN(angle) angle/RADIANS_TO_DEGREES(M_PI)

@interface MLSpinnerRing : CAShapeLayer
- (instancetype)initWithFrame:(CGRect)frame;
+ (instancetype)layerWithFrame:(CGRect)frame;
@end

@implementation MLSpinnerRing
+ (instancetype)layerWithFrame:(CGRect)frame {
    return [[self alloc]initWithFrame:frame];
}
- (instancetype)init {
    if (self = [super init]) {
        self.lineWidth = RingLineWidth;
        self.fillColor = [UIColor clearColor].CGColor;
        self.strokeColor = RingColor;
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if ([self init]) {
        self.frame = frame;
    }
    return self;
}
@end

@interface MLRefreshView ()
@property(nonatomic, strong)CADisplayLink *link;
@property(nonatomic, strong)MLSpinnerRing *layerLeft;
@property(nonatomic, strong)MLSpinnerRing *layerRight;
@property(nonatomic, strong)CABasicAnimation *strokeEndAnimation;
@end
@implementation MLRefreshView
+ (instancetype)refreshViewWithFrame:(CGRect)frame {
    MLRefreshView *view = [[self alloc]initWithFrame:frame];
    return view;
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        CGPoint center = CGPointMake(frame.size.width/2.0f, frame.size.height/2.0f);
        CGFloat radius = (MIN(frame.size.width, frame.size.height))/2.0f;
        
        UIBezierPath *lineLeft = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:DEGREES_TO_RADIANS(110) endAngle:DEGREES_TO_RADIANS(-80) clockwise:NO];
       self.layerLeft.path = lineLeft.CGPath;
 
        UIBezierPath *lineRight = [UIBezierPath bezierPathWithArcCenter:center radius:radius  startAngle:DEGREES_TO_RADIANS(-70) endAngle:DEGREES_TO_RADIANS(100) clockwise:NO];
        self.layerRight.path = lineRight.CGPath;
        
    }
    return self;
}
- (void)startAnimation {
    [self clearAllAnimation];
    [self.layerLeft addAnimation:self.strokeEndAnimation forKey:self.strokeEndAnimation.keyPath];
    [self.layerRight addAnimation:self.strokeEndAnimation forKey:self.strokeEndAnimation.keyPath];
    self.link.paused = NO;
}
- (void)stopAnimation {
    [self clearAllAnimation];
    self.link.paused = YES;
}
- (void)clearAllAnimation {
    [self.layer removeAllAnimations];
    [self.layerLeft removeAllAnimations];
    [self.layerRight removeAllAnimations];
}

- (void)linkAnimation {
    [UIView animateWithDuration:self.link.duration animations:^{
       self.transform = CGAffineTransformRotate(self.transform, DEGREES_TO_RADIANS(everyChangeAngle));
    } completion:^(BOOL finished) {
        
    }];
}


#pragma mark - lazy 
- (CADisplayLink *)link {
    if (!_link) {
        _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(linkAnimation)];
        _link.frameInterval = 0;
        ;
        [_link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    }
    return _link;
}
- (MLSpinnerRing *)layerLeft {
    if (!_layerLeft) {
        _layerLeft = [MLSpinnerRing layerWithFrame:self.bounds];
        [self.layer addSublayer:_layerLeft];
    }
    return _layerLeft;
}
- (MLSpinnerRing *)layerRight {
    if (!_layerRight) {
        _layerRight = [MLSpinnerRing layerWithFrame:self.bounds];
        [self.layer addSublayer:_layerRight];
    }
    return _layerRight;
}
- (CABasicAnimation *)strokeEndAnimation {
    if (!_strokeEndAnimation) {
        _strokeEndAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        _strokeEndAnimation.fromValue = @(1 - STROKE_END_RADIAN);
        _strokeEndAnimation.toValue = @(STROKE_END_RADIAN);
        _strokeEndAnimation.duration = 1.5;
        _strokeEndAnimation.repeatCount = HUGE_VAL;
        _strokeEndAnimation.removedOnCompletion = NO;
        _strokeEndAnimation.autoreverses = YES;
    }
    return _strokeEndAnimation;
}
@end
