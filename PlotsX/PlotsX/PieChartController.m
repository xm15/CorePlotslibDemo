
#import "PieChartController.h"

@implementation PieChartController

@synthesize dataForChart;
@synthesize timer;

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    CGFloat margin = pieChart.plotAreaFrame.borderLineStyle.lineWidth + 5.0;

    CPTPieChart *piePlot = (CPTPieChart *)[pieChart plotWithIdentifier:@"Pie Chart 1"];
    CGRect plotBounds    = pieChart.plotAreaFrame.bounds;
    CGFloat newRadius    = MIN(plotBounds.size.width, plotBounds.size.height) / 2.0 - margin;

    CGFloat y = 0.0;

    if ( plotBounds.size.width > plotBounds.size.height ) {
        y = 0.5;
    }
    else {
        y = (newRadius + margin) / plotBounds.size.height;
    }
    CGPoint newAnchor = CGPointMake(0.5, y);

    // Animate the change
    [CATransaction begin];
    {
        [CATransaction setAnimationDuration:1.0];
        [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];

        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"pieRadius"];
        animation.toValue  = [NSNumber numberWithDouble:newRadius];
        animation.fillMode = kCAFillModeForwards;
        animation.delegate = self;
        [piePlot addAnimation:animation forKey:@"pieRadius"];

        animation          = [CABasicAnimation animationWithKeyPath:@"centerAnchor"];
        animation.toValue  = [NSValue valueWithBytes:&newAnchor objCType:@encode(CGPoint)];
        animation.fillMode = kCAFillModeForwards;
        animation.delegate = self;
        [piePlot addAnimation:animation forKey:@"centerAnchor"];
    }
    [CATransaction commit];
}

#pragma mark -
#pragma mark Initialization and teardown

-(void)dealloc
{
    [dataForChart release];
    [timer release];
    [super dealloc];
}

-(void)viewDidAppear:(BOOL)animated
{
    // Add some initial data
    NSMutableArray *contentArray = [NSMutableArray arrayWithObjects:[NSNumber numberWithDouble:100.0],[NSNumber numberWithDouble:100.0],[NSNumber numberWithDouble:100.0],[NSNumber numberWithDouble:100.0],[NSNumber numberWithDouble:100.0],[NSNumber numberWithDouble:100.0],[NSNumber numberWithDouble:100.0],[NSNumber numberWithDouble:100.0],[NSNumber numberWithDouble:100.0],[NSNumber numberWithDouble:100.0],[NSNumber numberWithDouble:100.0],[NSNumber numberWithDouble:100.0],[NSNumber numberWithDouble:100.0],[NSNumber numberWithDouble:100.0],[NSNumber numberWithDouble:100.0], [NSNumber numberWithDouble:200.0], [NSNumber numberWithDouble:400.0], nil];

    self.dataForChart = contentArray;

    [self timerFired];
#ifdef MEMORY_TEST
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self
                                                selector:@selector(timerFired) userInfo:nil repeats:YES];
#endif
}

-(void)timerFired
{
#ifdef MEMORY_TEST
    static NSUInteger counter = 0;

    NSLog(@"\n----------------------------\ntimerFired: %lu", counter++);
#endif

    [pieChart release];

    // Create pieChart from theme
    pieChart = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
    // 紧接的两行设置主题，如果注释掉，将不显示主题
    CPTTheme *theme = [CPTTheme themeNamed:kCPTSlateTheme];
    [pieChart applyTheme:theme];
    CPTGraphHostingView *hostingView = (CPTGraphHostingView *)self.view;
    hostingView.hostedGraph = pieChart;

    pieChart.paddingLeft   = 20.0;
    pieChart.paddingTop    = 120.0;
    pieChart.paddingRight  = 20.0;
    pieChart.paddingBottom = 20.0;

    pieChart.axisSet = nil;

    CPTMutableTextStyle *whiteText = [CPTMutableTextStyle textStyle];
    whiteText.color = [CPTColor whiteColor];

    pieChart.titleTextStyle = whiteText;
    pieChart.title          = @"Graph Title";

    // Add pie chart
    CPTPieChart *piePlot = [[CPTPieChart alloc] init];
    piePlot.dataSource      = self;
    piePlot.pieRadius       = 100;    //半径
    piePlot.identifier      = @"Pie Chart 1";
    piePlot.startAngle      = M_PI_4;   //开始画的位置
    piePlot.sliceDirection  = CPTPieDirectionCounterClockwise; //顺时针
    piePlot.centerAnchor    = CGPointMake(0.5, 0.5); // 圆心除以总长度
    piePlot.borderLineStyle = [CPTLineStyle lineStyle];
    piePlot.delegate        = self;
    [pieChart addPlot:piePlot];
    
    piePlot.borderLineStyle = nil;
    [piePlot release];

#ifdef PERFORMANCE_TEST
    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(changePlotRange) userInfo:nil repeats:YES];
#endif
}

-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

#pragma mark -
#pragma mark Plot Data Source Methods

//个数
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    return [self.dataForChart count];
}

//
-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    if ( index >= [self.dataForChart count] ) {
        return nil;
    }

    if ( fieldEnum == CPTPieChartFieldSliceWidth ) {
        return [self.dataForChart objectAtIndex:index];
    }
    else {
        return [NSNumber numberWithInt:index];
    }
}

// 扇形描述数据
-(CPTLayer *)dataLabelForPlot:(CPTPlot *)plot recordIndex:(NSUInteger)index
{
    CPTTextLayer *label            = [[CPTTextLayer alloc] initWithText:@"3G\n60%"];
    CPTMutableTextStyle *textStyle = [label.textStyle mutableCopy];

    textStyle.color = [CPTColor blackColor];
    label.textStyle = textStyle;
    [textStyle release];
    return [label autorelease];
}


// 突出该扇形区域
-(CGFloat)radialOffsetForPieChart:(CPTPieChart *)piePlot recordIndex:(NSUInteger)index
{
    CGFloat offset = 0.0;

//    if ( index == 0 ) {
//        offset = piePlot.pieRadius / 8.0;
//    }

    return offset;
}

// 绘制某一扇形颜色
/*-(CPTFill *)sliceFillForPieChart:(CPTPieChart *)pieChart recordIndex:(NSUInteger)index;
 * {
 *  return nil;
 * }*/

#pragma mark -
#pragma mark Delegate Methods

-(void)pieChart:(CPTPieChart *)plot sliceWasSelectedAtRecordIndex:(NSUInteger)index
{
    pieChart.title = [NSString stringWithFormat:@"Selected index: %lu", (unsigned long)index];
}

-(void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
    CPTPieChart *piePlot             = (CPTPieChart *)[pieChart plotWithIdentifier:@"Pie Chart 1"];
    CABasicAnimation *basicAnimation = (CABasicAnimation *)theAnimation;

    [piePlot removeAnimationForKey:basicAnimation.keyPath];
    [piePlot setValue:basicAnimation.toValue forKey:basicAnimation.keyPath];
    [piePlot repositionAllLabelAnnotations];
}

@end
