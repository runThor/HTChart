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

@interface HTChartView ()

@property (nonatomic, assign) CGFloat topMargin;
@property (nonatomic, assign) CGFloat bottomMargin;
@property (nonatomic, assign) CGFloat leftMargin;
@property (nonatomic, assign) CGFloat rightMargin;
@property (nonatomic, assign) NSInteger horizontalValueLinesCount;
@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation HTChartView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.topMargin = 20.0;
        self.bottomMargin = 20.0;
        self.leftMargin = 30.0;
        self.rightMargin = 10.0;
        self.horizontalValueLinesCount = 5;
        
        self.dataArr = [[NSMutableArray alloc] initWithObjects:@1, @2, @3, @4, @5, nil];
        
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    
    // Draw the Y axis
    CGContextMoveToPoint(context, self.leftMargin, self.topMargin);
    CGContextAddLineToPoint(context, self.leftMargin, VIEW_HEIGHT - self.bottomMargin);
    
    // Draw the X axis
    CGContextAddLineToPoint(context, VIEW_WIDTH - self.rightMargin, VIEW_HEIGHT - self.bottomMargin);

    // Draw the right border
    CGContextAddLineToPoint(context, VIEW_WIDTH - self.rightMargin, self.topMargin);
    
    CGContextStrokePath(context);
    
    // Draw horizontal value lines
    CGContextSetRGBStrokeColor(context, 1, 1, 1, 0.3);
    
    CGFloat eachHeight = (VIEW_HEIGHT - self.topMargin - self.bottomMargin)/(self.horizontalValueLinesCount + 1);
    
    for (int i = 1 ; i <= self.horizontalValueLinesCount; i++) {
        
        CGContextMoveToPoint(context, self.leftMargin, self.topMargin + eachHeight * i);
        CGContextAddLineToPoint(context, VIEW_WIDTH - self.rightMargin, self.topMargin + eachHeight * i);
        
    }
    
    CGContextStrokePath(context);
    
    // Draw data points
    CGContextSetFillColorWithColor(context, [UIColor yellowColor].CGColor);
    
    for (int i = 0; i < self.dataArr.count; i++) {
        
        CGFloat originX = self.leftMargin + i * 40;
        CGFloat originY = 100;
        
        CGContextFillEllipseInRect(context, CGRectMake(originX - 2.5, originY - 2.5, 5, 5));
        
    }
    
    // Draw data lines
    CGContextSetStrokeColorWithColor(context, [UIColor yellowColor].CGColor);
    
    for (int i = 0; i < self.dataArr.count; i++) {
        
        CGFloat originX = self.leftMargin + i * 40;
        CGFloat originY = 100;
        
        if (0 == i) {
            CGContextMoveToPoint(context, self.leftMargin, 100);
        }
        
        CGContextAddLineToPoint(context, originX, originY);
        
    }
    
    CGContextStrokePath(context);
}
















@end
