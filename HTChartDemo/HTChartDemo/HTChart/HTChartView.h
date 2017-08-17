//
//  HTChartView.h
//  HTChartDemo
//
//  Created by chenghong on 2017/8/10.
//  Copyright © 2017年 HT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTLine.h"

@interface HTChartView : UIView

@property (nonatomic, assign) CGFloat maxValue;
@property (nonatomic, assign) CGFloat minValue;

- (void)addLines:(NSArray *)lines;

@end
