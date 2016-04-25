//
//  MLRefreshView.h
//  MLRefresh
//
//  Created by 磊 on 16/4/14.
//  Copyright © 2016年 磊. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SPEED 5       // 转动速度
#define RING_COLOR [UIColor colorWithRed:221 green:0 blue:0 alpha:1.0].CGColor // 默认圆环颜色
#define RING_LINE_WIDTH 2  // 圆环线的宽度

typedef NS_ENUM(NSInteger, RefreshLogo) {
    RefreshLogoNone,   // none
    RefreshLogoCommon, // 默认style
    RefreshLogoAlbum   // 图集style
};
@interface MLRefreshView : UIView
@property(nonatomic, strong)UIColor *lineColor; // 不设置为默认颜色
 /**
 *  根据是否有logo创建不同的刷新样式
 *
 *  @param frame  刷新view位置
 *  @param isLogo 是否有logo
 *
 */
+ (instancetype)refreshViewWithFrame:(CGRect)frame logoStyle:(RefreshLogo)style;
/**
 *  根据百分比进度去画线，应用在下拉操作
 *
 *  @param percent 百分比
 */
- (void)drawLineWithPercent:(CGFloat)percent;
// 开启动画
- (void)startAnimation;
// 停止动画
- (void)stopAnimation;
@end
