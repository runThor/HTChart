# HTChart
## Show
![demoImg](https://github.com/runThor/HTChart/raw/master/Other/HTChartDemo.png)
## Usage
```Objective-C
// ViewController.m

#import "HTChartView.h"

@interface ViewController ()

@property (nonatomic, strong)HTChartView *chartView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.chartView = [[HTChartView alloc] initWithFrame:CGRectMake(0, 0, 320, 250)];
    self.chartView.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1];
    [self.chartView setCenter:CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2)];
    self.chartView.maxValue = 10;
    self.chartView.minValue = 0;
    [self.view addSubview:self.chartView];
    
    [self addlines];
}

- (void)addlines {
    HTLine *yellowLine = [[HTLine alloc] init];
    [yellowLine.dataArr addObjectsFromArray:@[@(1), @(3), @(5), @(7), @(9), @(5), @(6), @(4), @(2), @(8), @(1), @(6), @(4), @(5), @(9), @(8), @(2)]];
    yellowLine.lineColor = [UIColor yellowColor];
    
    HTLine *redLine = [[HTLine alloc] init];
    [redLine.dataArr addObjectsFromArray:@[@(2), @(4), @(5), @(8), @(6), @(1), @(7), @(5), @(3), @(4), @(6), @(2), @(8), @(7), @(9), @(5), @(2)]];
    redLine.lineColor = [UIColor redColor];
    
    NSArray *linesArr = @[yellowLine, redLine];
    [self.chartView addLines:linesArr];
}
```
