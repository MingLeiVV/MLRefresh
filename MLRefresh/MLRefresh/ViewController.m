//
//  ViewController.m
//  MLRefresh
//
//  Created by 磊 on 16/4/14.
//  Copyright © 2016年 磊. All rights reserved.
//

#import "ViewController.h"
#import "MLRefreshView.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property(nonatomic, strong)MLRefreshView *refreshView;
@property(nonatomic, assign)BOOL click;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.refreshView;
    self.click = YES;
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)sliderChanger:(id)sender {
    [self.refreshView drawLineWithPercent:self.slider.value];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (_click) {
    [self.refreshView startAnimation];
        _click = NO;
    }else {
        [self.refreshView stopAnimation];
        _click = YES;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (MLRefreshView *)refreshView {
    if (!_refreshView) {
        _refreshView = [MLRefreshView refreshViewWithFrame:CGRectMake(100, 100, 200, 200) logoStyle:RefreshLogoNone];
        [self.view addSubview:_refreshView];
        _refreshView.lineColor = [UIColor blueColor];
    }
    return _refreshView;
}
@end
