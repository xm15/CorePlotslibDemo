//
//  CPTTestAppBarChartController.m
//  CPTTestApp-iPhone
//

#import "BarChartController.h"
#define DF_number 5

@implementation BarChartController

@synthesize timer;

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

#pragma mark -
#pragma mark Initialization and teardown

-(void)viewDidAppear:(BOOL)animated
{
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

    [barChart release];

    // Create barChart from theme   创建barchart
    barChart = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
    CPTTheme *theme = [CPTTheme themeNamed:kCPTPlainWhiteTheme];
    [barChart applyTheme:theme];
    CPTGraphHostingView *hostingView = (CPTGraphHostingView *)self.view;
    hostingView.hostedGraph = barChart;

    // Border  边界
    barChart.plotAreaFrame.borderLineStyle = nil;
    barChart.plotAreaFrame.cornerRadius    = 0.0f;

    // Paddings 填充
    barChart.paddingLeft   = 0.0f;
    barChart.paddingRight  = 0.0f;
    barChart.paddingTop    = 120.0f;
    barChart.paddingBottom = 0.0f;

    barChart.plotAreaFrame.paddingLeft   = 50.0;
    barChart.plotAreaFrame.paddingTop    = 50.0;
    barChart.plotAreaFrame.paddingRight  = 20.0;
    barChart.plotAreaFrame.paddingBottom = 80.0;

    // Graph title 标题
    barChart.title = @"Graph Title\nLine 2";
    CPTMutableTextStyle *textStyle = [CPTTextStyle textStyle];
    textStyle.color                   = [CPTColor redColor];
    textStyle.fontSize                = 16.0f;
    textStyle.textAlignment           = CPTTextAlignmentCenter;
    barChart.titleTextStyle           = textStyle;
    barChart.titleDisplacement        = CGPointMake(0.0f, -64.0f);
    barChart.titlePlotAreaFrameAnchor = CPTRectAnchorTop;

    // Add plot space for horizontal bar charts
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)barChart.defaultPlotSpace;
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f) length:CPTDecimalFromFloat(300.0f)]; // Y坐标区间
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f) length:CPTDecimalFromFloat(5*2.0f)];    // X坐标区间

    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)barChart.axisSet;
    CPTXYAxis *x          = axisSet.xAxis;
    x.axisLineStyle               = [CPTLineStyle lineStyle];
    x.majorTickLineStyle          = [CPTLineStyle lineStyle];
    x.minorTickLineStyle          = nil;
    x.majorIntervalLength         = CPTDecimalFromString(@"5"); // 大刻度线间隔单位： 5 个单位
    x.orthogonalCoordinateDecimal = CPTDecimalFromString(@"0"); // 直角坐标： 0
    x.title                       = @"X Axis";
    x.titleLocation               = CPTDecimalFromFloat(7.5f);      //标题位置： 7.5 单位
    x.titleOffset                 = 55.0f;                          // 向下偏移： 55.0

    // Define some custom labels for the data elements 自定义X 坐标的标题
    x.labelRotation  = M_PI / 4;
    x.labelingPolicy = CPTAxisLabelingPolicyNone;
    NSArray *customTickLocations = [NSArray arrayWithObjects:[NSDecimalNumber numberWithInt:1*2], [NSDecimalNumber numberWithInt:2*2],[NSDecimalNumber numberWithInt:3*2],[NSDecimalNumber numberWithInt:4*2], nil];  //X 坐标标注 所在位置
    NSArray *xAxisLabels         = [NSArray arrayWithObjects:@"Label A", @"Label B", @"Label C", @"Label D",nil];
    NSUInteger labelLocation     = 0;
    NSMutableArray *customLabels = [NSMutableArray arrayWithCapacity:[xAxisLabels count]];
    for ( NSNumber *tickLocation in customTickLocations ) {
        CPTAxisLabel *newLabel = [[CPTAxisLabel alloc] initWithText:[xAxisLabels objectAtIndex:labelLocation++] textStyle:x.labelTextStyle];
        newLabel.tickLocation = [tickLocation decimalValue];
        newLabel.offset       = x.labelOffset + x.majorTickLength;
        newLabel.rotation     = M_PI_4;
        [customLabels addObject:newLabel];
        [newLabel release];
    }

    x.axisLabels = [NSSet setWithArray:customLabels];

    CPTXYAxis *y = axisSet.yAxis;
    y.axisLineStyle               = [CPTLineStyle lineStyle];
    y.majorTickLineStyle          = [CPTLineStyle lineStyle];
    y.minorTickLineStyle          = nil;
    y.majorIntervalLength         = CPTDecimalFromString(@"50");    //刻度间隔
    y.orthogonalCoordinateDecimal = CPTDecimalFromString(@"0");     // 坐标原点： 0
    y.title                       = @"Y Axis";
    y.titleOffset                 = 45.0f;
    y.titleLocation               = CPTDecimalFromFloat(150.0f);

    // First bar plot
    CPTBarPlot *barPlot = [CPTBarPlot tubularBarPlotWithColor:[CPTColor yellowColor] horizontalBars:NO];
    barPlot.fill = [CPTFill fillWithColor:[ CPTColor colorWithComponentRed:75.0/255 green:193.0/255 blue:210.0/255 alpha:1.0 ]];//不写填充颜色柱子是立体效果的，加上填充颜色是扁平化的
    
//    barPlot.barWidth =CPTDecimalFromFloat(1.0f);
    barPlot.baseValue  = CPTDecimalFromString(@"0");
    barPlot.dataSource = self;
    barPlot.barOffset  = CPTDecimalFromFloat(-0.25f);
    barPlot.barCornerRadius = 2.0f;
    barPlot.identifier = @"color0";
    barPlot.delegate = self;
    [barChart addPlot:barPlot toPlotSpace:plotSpace];

    //使用 for循坏新建多个barplot，不同颜色，id
    // Second bar plot
    barPlot                 = [CPTBarPlot tubularBarPlotWithColor:[CPTColor blueColor] horizontalBars:NO];
    barPlot.fill = [CPTFill fillWithColor:[ CPTColor colorWithComponentRed:0.0/255 green:0.0/255 blue:255.0/255 alpha:1.0 ]];//不写填充颜色柱子是立体效果的，加上填充颜色是扁平化的
    barPlot.dataSource      = self;
    barPlot.baseValue       = CPTDecimalFromString(@"0");
    barPlot.barOffset       = CPTDecimalFromFloat(-0.25f);
    barPlot.barCornerRadius = 2.0f;
    barPlot.identifier      = @"color1";
    barPlot.delegate = self;
    [barChart addPlot:barPlot toPlotSpace:plotSpace];
}

-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

#pragma mark -
#pragma mark Plot Data Source Methods

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    return 5;
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    NSDecimalNumber *num = nil;
    //  使用index % number = index--> if indx she number,else 0;
    int colorIndex = index % 2;
    NSString *ColorIdentifier = [NSString stringWithFormat:@"color%d",colorIndex];
    if ( [plot isKindOfClass:[CPTBarPlot class]] ) {
        if ([plot.identifier isEqual:ColorIdentifier]) {
            switch ( fieldEnum ) {
                case CPTBarPlotFieldBarLocation: // X
                    num = (NSDecimalNumber *)[NSDecimalNumber numberWithUnsignedInteger:index*2];
                    break;
                    
                case CPTBarPlotFieldBarTip: // Y
                    num = (NSDecimalNumber *)[NSDecimalNumber numberWithUnsignedInteger:(index)*60];
                    break;
            }
        }else{
            return 0;
        }
        
    }

    return num;
}

-(void)barPlot:(CPTBarPlot *)plot barWasSelectedAtRecordIndex:(NSUInteger)index
{
    NSLog(@"%d",index);
}

@end
