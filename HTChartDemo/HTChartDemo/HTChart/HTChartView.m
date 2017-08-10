//
//  HTChartView.m
//  HTChartDemo
//
//  Created by chenghong on 2017/8/10.
//  Copyright © 2017年 HT. All rights reserved.
//

#import "HTChartView.h"

#define VIEW_WIDTH  self.frame.size.width
#define VIEW_HEIGHT self.frame.size.height

@implementation HTChartView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        
        
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Draw the X axis
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextMoveToPoint(context, 30, VIEW_HEIGHT - 20);
    CGContextAddLineToPoint(context, VIEW_WIDTH - 10, VIEW_HEIGHT - 20);
    CGContextStrokePath(context);
    
}


@end
