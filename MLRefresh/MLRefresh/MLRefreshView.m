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
#define STROKE_END_RADIAN 180/RADIANS_TO_DEGREES(M_PI)
#define STROKE_PROCESS_RADIAN(angle) angle/RADIANS_TO_DEGREES(M_PI)
#define DRAW_LINE_RATE 7.5 // 画线速率
#define RECURRENT 4 // 周期
#define RADIUS_NONE 20
#define RADIUS_LOGO 32.5

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
        self.lineWidth = RING_LINE_WIDTH;
        self.fillColor = [UIColor clearColor].CGColor;
        self.strokeColor = RING_COLOR;
        self.lineCap = kCALineCapRound;
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
@property(nonatomic, strong)CALayer *container; // 容器
@property(nonatomic, strong)MLSpinnerRing *layerLeft; // 左圆弧
@property(nonatomic, strong)MLSpinnerRing *layerRight; // 右圆弧
@property(nonatomic, strong)UIImageView *logoImage; // logo图
@property(nonatomic, strong)CABasicAnimation *strokeEndAnimation;
@property(nonatomic, strong)CABasicAnimation *rotateAnimation;
@end
@implementation MLRefreshView

#pragma mark - publicMethod

+ (instancetype)refreshViewWithFrame:(CGRect)frame logoStyle:(RefreshLogo)style{
    MLRefreshView *view = [[self alloc]initWithFrame:frame logoStyle:style];
    return view;
}
- (instancetype)initWithFrame:(CGRect)frame logoStyle:(RefreshLogo)style {
    self = [super initWithFrame:frame];
    if (self) {
        CGPoint center = CGPointMake(frame.size.width/2.0f, frame.size.height/2.0f);
//        CGFloat radius = (MIN(frame.size.width, frame.size.height))/2.0f;
        CGFloat radius = RADIUS_NONE;
        
        if (style == RefreshLogoCommon || style == RefreshLogoAlbum) {
            [self createLogo:style];
//            radius = (MAX(self.logoImage.bounds.size.width, self.logoImage.bounds.size.height))/2.0f + 10;
            radius = RADIUS_LOGO;
        }
//        UIBezierPath *lineLeft = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:DEGREES_TO_RADIANS(110) endAngle:DEGREES_TO_RADIANS(-80) clockwise:YES];
//       self.layerLeft.path = lineLeft.CGPath;
// 
//        UIBezierPath *lineRight = [UIBezierPath bezierPathWithArcCenter:center radius:radius  startAngle:DEGREES_TO_RADIANS(-70) endAngle:DEGREES_TO_RADIANS(100) clockwise:YES];
//        self.layerRight.path = lineRight.CGPath;
        
        UIBezierPath *lineLeft = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:DEGREES_TO_RADIANS(30) endAngle:DEGREES_TO_RADIANS(-160) clockwise:YES];
        self.layerLeft.path = lineLeft.CGPath;
        
        UIBezierPath *lineRight = [UIBezierPath bezierPathWithArcCenter:center radius:radius  startAngle:DEGREES_TO_RADIANS(-150) endAngle:DEGREES_TO_RADIANS(20) clockwise:YES];
        self.layerRight.path = lineRight.CGPath;
    }
    return self;
}
- (void)startAnimation {
    [self clearAllAnimation];
    [self checkSeting];
    [self.layerLeft addAnimation:self.strokeEndAnimation forKey:self.strokeEndAnimation.keyPath];
    [self.layerRight addAnimation:self.strokeEndAnimation forKey:self.strokeEndAnimation.keyPath];
    [self.container addAnimation:self.rotateAnimation forKey:self.rotateAnimation.keyPath];
}
- (void)stopAnimation {
    [self clearAllAnimation];
}
- (void)drawLineWithPercent:(CGFloat)percent {
        [self checkSeting];
    [UIView animateWithDuration:0.1 animations:^{
        [self.layerLeft setStrokeEnd:percent];
        [self.layerRight setStrokeEnd:percent];
        self.container.transform = CATransform3DMakeRotation(M_PI_4 * percent, 0, 0, 1);
    }];

}
#pragma mark - privateMethod
- (void)clearAllAnimation {
    [self.layer removeAllAnimations];
    [self.layerLeft removeAllAnimations];
    [self.layerRight removeAllAnimations];
    self.container.transform = CATransform3DIdentity;
}
- (void)checkSeting {
    if (self.lineColor && self.lineColor.CGColor != self.layerLeft.strokeColor) {
        [self changeLineColor:self.lineColor];
    }
}
- (void)createLogo:(RefreshLogo)style {
    self.logoImage.frame = self.bounds;
    [self addSubview:self.logoImage];
    if (style == RefreshLogoCommon) {
        self.logoImage.image = [UIImage imageNamed:@"Applogo_opacity20_light"];
        [self changeLineColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2]];
        self.layerLeft.lineWidth = 1;
        self.layerRight.lineWidth = 1;
    }else if (style == RefreshLogoAlbum) {
        self.logoImage.image = [UIImage imageNamed:@"Applogo_opacity20_dark"];
        [self changeLineColor:[UIColor colorWithRed:255 green:255 blue:255 alpha:0.2]];
        self.layerLeft.lineWidth = 1;
        self.layerRight.lineWidth = 1;
    }
    
}
- (void)changeLineColor:(UIColor *)color {
    self.layerLeft.strokeColor = color.CGColor;
    self.layerRight.strokeColor = color.CGColor;

}

#pragma mark - lazy
- (CALayer *)container {
    if (!_container) {
        _container = [CALayer layer];
        _container.frame = self.bounds;
        [self.layer addSublayer:_container];
    }
    return _container;
}

- (MLSpinnerRing *)layerLeft {
    if (!_layerLeft) {
        _layerLeft = [MLSpinnerRing layerWithFrame:self.bounds];
        [self.container addSublayer:_layerLeft];
    }
    return _layerLeft;
}
- (MLSpinnerRing *)layerRight {
    if (!_layerRight) {
        _layerRight = [MLSpinnerRing layerWithFrame:self.bounds];
        [self.container addSublayer:_layerRight];
    }
    return _layerRight;
}
- (CABasicAnimation *)strokeEndAnimation {
    if (!_strokeEndAnimation) {
        _strokeEndAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        _strokeEndAnimation.fromValue = @(1 - STROKE_END_RADIAN);
        _strokeEndAnimation.toValue = @(STROKE_PROCESS_RADIAN(160));
        _strokeEndAnimation.duration = DRAW_LINE_RATE / SPEED;
        _strokeEndAnimation.repeatCount = HUGE_VAL;
        _strokeEndAnimation.removedOnCompletion = NO;
        _strokeEndAnimation.autoreverses = YES;
    }
    return _strokeEndAnimation;
}
- (CABasicAnimation *)rotateAnimation {
    if (!_rotateAnimation) {
        _rotateAnimation =[CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        _rotateAnimation.duration = self.strokeEndAnimation.duration / RECURRENT;
        _rotateAnimation.fromValue = @(0);
        _rotateAnimation.toValue = @(M_PI);
        _rotateAnimation.repeatCount = HUGE_VAL;
        _rotateAnimation.autoreverses = NO;
        _rotateAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    }
    return _rotateAnimation;
}
- (UIImageView *)logoImage {
    if (!_logoImage) {
        _logoImage = [[UIImageView alloc]init];
    }
    return _logoImage;
}
@end
