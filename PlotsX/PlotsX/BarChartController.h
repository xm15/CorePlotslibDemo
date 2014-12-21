//
//  CPTTestAppBarChartController.h
//  CPTTestApp-iPhone
//

#import "CorePlot-CocoaTouch.h"
#import <UIKit/UIKit.h>

@interface BarChartController : UIViewController<CPTPlotDataSource,CPTBarPlotDelegate>
{
    @private
    CPTXYGraph *barChart;
    NSTimer *timer;
}

@property (readwrite, retain, nonatomic) NSTimer *timer;

-(void)timerFired;

@end
