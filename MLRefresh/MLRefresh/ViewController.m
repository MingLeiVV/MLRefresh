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
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)sliderChanger:(id)sender {
    [self.refreshView drawLineWithPercent:self.slider.value];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.refreshView startAnimation];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (MLRefreshView *)refreshView {
    if (!_refreshView) {
        _refreshView = [MLRefreshView refreshViewWithFrame:CGRectMake(100, 100, 50, 50) logoStyle:RefreshLogoNone];
        [self.view addSubview:_refreshView];
    }
    return _refreshView;
}
@end
