//
//  PCAPatientStatsViewController.m
//  PCA-Thesis
//
//  Created by David Ganey on 2/24/15.
//  Copyright (c) 2015 dhganey. All rights reserved.
//

#import "PCAPatientStatsViewController.h"

@interface PCAPatientStatsViewController ()

@property (strong, nonatomic) IBOutlet UIView *NewGraphingView;

@end

@implementation PCAPatientStatsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //dispatch_queue_t graphQueue = dispatch_queue_create("graph view create", NULL);
    dispatch_async(dispatch_get_main_queue(), ^{
        //hack to force auto-layout
        CPTGraphHostingView *hostView = [[CPTGraphHostingView alloc] initWithFrame:self.NewGraphingView.frame];
        
        //create graph object and add to hostview
        //CPTGraph *graph = [[CPTXYGraph alloc] initWithFrame:hostView.bounds];
        CPTGraph *graph = [[CPTXYGraph alloc] initWithFrame:CGRectMake(0, 0, 100, 100)]; //part of new hack
        hostView.hostedGraph = graph;
        
        
        //new stuff for formatting
        hostView.allowPinchScaling = YES;
        
        graph.paddingBottom = 0; //30.0f;
        graph.paddingLeft = 0; //30.0f;
        graph.paddingRight = 0; //-5.0f;
        graph.paddingTop = 0; //-1.0f;
        
        //[graph applyTheme:[CPTTheme themeNamed:kCPTSlateTheme]];
        [graph applyTheme:[CPTTheme themeNamed:kCPTPlainWhiteTheme]];
        
        //graph title stuff
        NSString *title = @"User Pain";
        CPTMutableTextStyle *titleStyle = [CPTMutableTextStyle textStyle];
        titleStyle.fontName = @"Helvetica Bold";
        titleStyle.fontSize = 20.0f;
        graph.titleTextStyle = titleStyle;
        graph.title = title;
        
        //get default plotspace
        CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) graph.defaultPlotSpace;
        
        //calculate ranges
        float xMin, xMax, yMin, yMax;
        xMin = 0;
        xMax = [self.userEntries count];
        
        yMin = 0;
        //yMax = [self maxSleepEntry];
        yMax = 20 * 1.2; //so title is visible
        
        //set ranges
        [plotSpace setXRange:[CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(xMin) length:CPTDecimalFromFloat(xMax)]];
        [plotSpace setYRange:[CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(yMin) length:CPTDecimalFromFloat(yMax)]];
        
        //create the plot
        CPTScatterPlot *plot = [[CPTScatterPlot alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        
        plot.dataSource = self; //this uses protocol in .h file
        
        //line color stuff
        CPTMutableLineStyle *lineStyle = [[CPTMutableLineStyle alloc] init];
        lineStyle.lineColor = [CPTColor blueColor];
        lineStyle.lineWidth = 2.0f;
        plot.dataLineStyle = lineStyle;
        
        [graph addPlot:plot toPlotSpace:graph.defaultPlotSpace];
        //[graph.defaultPlotSpace scaleToFitPlots:[graph allPlots]];
        
        [self.view addSubview:hostView];
        [self.view setNeedsDisplay];
    });
}

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    return [self.userEntries count];
}

//also for datasource protocol
-(NSNumber*)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)idx
{
    CatalyzeEntry* temp = [self.userEntries objectAtIndex:idx];
    if (fieldEnum == CPTScatterPlotFieldX)
    {
        NSLog(@"index :%lu", (unsigned long)idx);
        return [NSNumber numberWithInt:idx];
    }
    else
    {
        NSNumber* painScore = [temp.content objectForKey:@"pain"];
        NSLog(@"value: %f", painScore);
        return painScore;
    }
}

@end
