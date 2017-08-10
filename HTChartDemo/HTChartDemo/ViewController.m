//
//  ViewController.m
//  HTChartDemo
//
//  Created by chenghong on 2017/8/10.
//  Copyright © 2017年 HT. All rights reserved.
//

#import "ViewController.h"
#import "HTChartView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.view.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1];
    
    HTChartView *chartView = [[HTChartView alloc] initWithFrame:CGRectMake(0, 0, 320, 250)];
    chartView.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1];
    [chartView setCenter:CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2)];
    [self.view addSubview:chartView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
