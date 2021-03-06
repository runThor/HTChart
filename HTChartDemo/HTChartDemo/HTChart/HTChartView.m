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
#define MAX_POINT_INTERVAL  60
#define MIN_POINT_INTERVAL  5

@interface HTChartView ()

@property (nonatomic, assign) CGFloat topMargin;
@property (nonatomic, assign) CGFloat bottomMargin;
@property (nonatomic, assign) CGFloat leftMargin;
@property (nonatomic, assign) CGFloat rightMargin;
@property (nonatomic, assign) NSInteger horizontalValueLinesCount;
@property (nonatomic, assign) CGFloat contentOffset;
@property (nonatomic, assign) CGFloat pointInterval;
@property (nonatomic, strong) NSMutableArray *linesArr;
@property (nonatomic, strong) NSMutableArray *dataOriginArr;

@end

@implementation HTChartView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1];
        
        self.topMargin = 20.0;
        self.bottomMargin = 20.0;
        self.leftMargin = 30.0;
        self.rightMargin = 10.0;
        self.horizontalValueLinesCount = 5;
        self.pointInterval = 40;
        self.linesArr = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect {
    [self drawChartFrame];
    
    [self drawLines];
}

- (void)drawChartFrame {
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
}



- (void)drawLines {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    for (int lineIndex = 0; lineIndex < self.linesArr.count; lineIndex++) {
        HTLine *line = self.linesArr[lineIndex];
        
        // get data points origin
        NSMutableArray *originArr = [[NSMutableArray alloc] init];
        
        for (int dataIndex = 0; dataIndex < line.dataArr.count; dataIndex++) {
            CGFloat x = self.leftMargin + dataIndex * self.pointInterval - self.contentOffset;
            CGFloat y = VIEW_HEIGHT - ([line.dataArr[dataIndex] floatValue]/(self.maxValue - self.minValue) * (VIEW_HEIGHT - self.topMargin - self.bottomMargin) + self.bottomMargin);
            
            [originArr addObject:NSStringFromCGPoint(CGPointMake(x, y))];
        }
        
        [self.dataOriginArr addObject:originArr];
        
        // Draw data points
        CGContextSetFillColorWithColor(context, line.lineColor.CGColor);
        
        for (NSString *origin in originArr) {
            CGPoint dataOrigin = CGPointFromString(origin);
            
            if (dataOrigin.x >= self.leftMargin) {
                if (dataOrigin.x > VIEW_WIDTH - self.rightMargin) {
                    break;
                } else {
                    CGContextFillEllipseInRect(context, CGRectMake(dataOrigin.x - 2.5, dataOrigin.y - 2.5, 5, 5));
                }
            }
        }
        
        // Draw data lines
        CGContextSetStrokeColorWithColor(context, line.lineColor.CGColor);
        
        BOOL startDrawing = NO;
        
        for (int dataIndex = 0; dataIndex < originArr.count; dataIndex++) {
            CGPoint dataOrigin = CGPointFromString(originArr[dataIndex]);
            
            if (startDrawing == NO) {
                if (dataOrigin.x >= self.leftMargin) {
                    if (dataIndex == 0) {
                        CGContextMoveToPoint(context, dataOrigin.x, dataOrigin.y);
                    } else {
                        // Intersection with the Y axis
                        CGPoint lastDataOrigin = CGPointFromString(originArr[dataIndex - 1]);
                        CGFloat startPointY = dataOrigin.y - (dataOrigin.x - self.leftMargin)/self.pointInterval * (dataOrigin.y - lastDataOrigin.y);
                        
                        CGContextMoveToPoint(context, self.leftMargin, startPointY);
                        CGContextAddLineToPoint(context, dataOrigin.x, dataOrigin.y);
                    }
                    
                    startDrawing = YES;
                }
            } else {
                if (dataOrigin.x >= VIEW_WIDTH - self.rightMargin) {
                    // Intersection with the right border
                    CGPoint lastDataOrigin = CGPointFromString(originArr[dataIndex - 1]);
                    CGFloat endPointY = dataOrigin.y - (dataOrigin.x - (VIEW_WIDTH - self.rightMargin))/self.pointInterval * (dataOrigin.y - lastDataOrigin.y);
                    
                    CGContextAddLineToPoint(context, VIEW_WIDTH - self.rightMargin, endPointY);
                    
                    break;
                } else {
                    CGContextAddLineToPoint(context, dataOrigin.x, dataOrigin.y);
                }
            }
        }
        
        CGContextStrokePath(context);
    }
}


- (void)addLines:(NSArray *)lines {
    [self.linesArr addObjectsFromArray:lines];
    
    [self setNeedsDisplay];
}


- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGFloat lineLength = self.pointInterval * ([self.linesArr[0] dataArr].count - 1);

    NSArray *touchesArr = [event allTouches].allObjects;
    
    if (1 == touchesArr.count) {
        CGPoint currentTouchPoint = [[touches anyObject] locationInView:self];
        CGPoint previousTouchPoint = [[touches anyObject] previousLocationInView:self];
        
        self.contentOffset += previousTouchPoint.x - currentTouchPoint.x;
    } else if (2 == touchesArr.count) {
        CGPoint currentOnePoint = [touchesArr[0] locationInView:self];
        CGPoint currentAnotherPoint = [touchesArr[1] locationInView:self];
        CGPoint previousOnePoint = [touchesArr[0] previousLocationInView:self];
        CGPoint previousAnotherPoint = [touchesArr[1] previousLocationInView:self];
        
        CGFloat currentFingerSpacing = fabs(currentOnePoint.x - currentAnotherPoint.x);
        CGFloat previousFingerSpacing = fabs(previousOnePoint.x - previousAnotherPoint.x);
        CGFloat centerX = (currentOnePoint.x - currentAnotherPoint.x)/2 + currentAnotherPoint.x;
        
        if (currentFingerSpacing > previousFingerSpacing && self.pointInterval < MAX_POINT_INTERVAL) {
            self.pointInterval *= 1.05;
            self.contentOffset = self.contentOffset * 1.05 + (centerX - self.leftMargin) * 0.05;
        } else if (currentFingerSpacing < previousFingerSpacing && self.pointInterval > MIN_POINT_INTERVAL) {
            self.pointInterval *= 0.95;
            self.contentOffset = self.contentOffset * 0.95 - (centerX - self.leftMargin) * 0.05;
        }
    }
    
    if (self.contentOffset < 0) {
        self.contentOffset = 0;
    } else if (self.contentOffset > lineLength) {
        self.contentOffset = lineLength;
    }
    
    [self setNeedsDisplay];
}










@end
