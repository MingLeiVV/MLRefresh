//
//  MLRefreshView.h
//  MLRefresh
//
//  Created by 磊 on 16/4/14.
//  Copyright © 2016年 磊. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SPEED 10       // 转动速度
#define RingColor [UIColor redColor].CGColor // 默认圆环颜色
#define RingLineWidth 3  // 圆环线的宽度
@interface MLRefreshView : UIView
+ (instancetype)refreshViewWithFrame:(CGRect)frame;
- (void)startAnimation;
- (void)stopAnimation;
@end
