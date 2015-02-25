//
//  PCAPatientStatsViewController.m
//  PCA-Thesis
//
//  Created by David Ganey on 2/24/15.
//  Copyright (c) 2015 dhganey. All rights reserved.
//

#import "PCAPatientStatsViewController.h"

#include "PCAPatientDetailViewController.h"

@interface PCAPatientStatsViewController ()

@end

@implementation PCAPatientStatsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Set up app delegate object for use of shared functions
    self.appDel = [[UIApplication sharedApplication] delegate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.title = [[self.appDel.defObj determineSymptomName:(int)self.curSymptom] capitalizedString];
    
    //change device orientation to landscape:
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];

    [self constructPlot];
}

-(void) constructPlot
{
    dispatch_async(dispatch_get_main_queue(), ^{
        //hack to force auto-layout
        CPTGraphHostingView *hostView = [[CPTGraphHostingView alloc] initWithFrame:self.NewGraphingView.frame];
        
        //create graph object and add to hostview
        CPTGraph *graph = [[CPTXYGraph alloc] initWithFrame:CGRectMake(0, 0, 100, 100)]; //part of new hack
        hostView.hostedGraph = graph;
        
        hostView.allowPinchScaling = YES;
        
        graph.paddingBottom = 0;
        graph.paddingLeft = 0;
        graph.paddingRight = 0;
        graph.paddingTop = 0;
        
        [graph applyTheme:[CPTTheme themeNamed:kCPTPlainWhiteTheme]];
        
        //get default plotspace
        CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) graph.defaultPlotSpace;
        
        //calculate ranges
        float xMin, xMax, yMin, yMax;
        xMin = 0;
        xMax = [self.userEntries count];
        yMin = 0;
        //yMax depends on the symptom
        if (self.curSymptom == ACTIVITY ||
            self.curSymptom == ANXIETY ||
            self.curSymptom == APPETITE)
        {
            yMax = 4;
        }
        else
        {
            yMax = 10;
        }
        
        //set ranges
        [plotSpace setXRange:[CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(xMin) length:CPTDecimalFromFloat(xMax)]];
        [plotSpace setYRange:[CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(yMin) length:CPTDecimalFromFloat(yMax)]];
        
        //configure axes
        CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
        CPTXYAxis *x = axisSet.xAxis;
        x.majorIntervalLength = CPTDecimalFromString(@"2");
        x.minorTicksPerInterval = 1;
        x.minorTickLength = 5.0f;
        x.majorTickLength = 7.0f;
        x.orthogonalCoordinateDecimal = CPTDecimalFromString(@"0");
        x.labelingPolicy = CPTAxisLabelingPolicyFixedInterval;
        x.Title = @"Date of Input";
        x.TitleOffset = 5.0f;
        //x.LabelOffset = 15.0f;
        
        CPTXYAxis *y = axisSet.yAxis;
        y.majorIntervalLength = CPTDecimalFromString(@"1");
        y.minorTicksPerInterval = 0;
        y.minorTickLength = 5.0f;
        y.majorTickLength = 7.0f;
        y.orthogonalCoordinateDecimal = CPTDecimalFromString(@"0");
        y.labelingPolicy = CPTAxisLabelingPolicyFixedInterval;
        y.Title = @"Number input";
        y.TitleOffset = 0;
        //y.LabelOffset = 15.0f;
        
        //create the plot
        CPTScatterPlot *plot = [[CPTScatterPlot alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        
        plot.dataSource = self; //this uses datasource protocol
        
        //line color stuff
        CPTMutableLineStyle *lineStyle = [[CPTMutableLineStyle alloc] init];
        lineStyle.lineColor = [CPTColor blueColor];
        lineStyle.lineWidth = 1.5f;
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
        return [NSNumber numberWithUnsignedInteger:idx];
    }
    else
    {
        NSString* key = [self.appDel.defObj determineSymptomName:self.curSymptom];
        if (self.curSymptom == SHORTNESS_OF_BREATH) //special case since underscores
        {
            key = @"shortness_of_breath";
        }
        NSNumber* painScore = [temp.content objectForKey:key];
        return painScore;
    }
}

@end
