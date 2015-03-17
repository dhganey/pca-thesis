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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 When the view appears, rotate the view, update the title, and create the scatterplot
 */
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.title = [[PCADefinitions determineSymptomName:(int)self.curSymptom] capitalizedString];
    
    //change device orientation to landscape:
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];

    [self constructPlot];
}

/**
 Creates the scatterplot
 */
-(void) constructPlot
{
    dispatch_async(dispatch_get_main_queue(), ^{
        //hack to force auto-layout
        CPTGraphHostingView *hostView = [[CPTGraphHostingView alloc] initWithFrame:self.NewGraphingView.frame];
        
        //create graph object and add to hostview
        CPTGraph *graph = [[CPTXYGraph alloc] initWithFrame:CGRectMake(0, 0, 100, 100)]; //part of new hack
        hostView.hostedGraph = graph;
        
        hostView.allowPinchScaling = YES;
        
        graph.paddingBottom = 70;
        graph.paddingLeft = 25;
        graph.paddingRight = 0;
        graph.paddingTop = 10;
        
        graph.plotAreaFrame.paddingBottom = 0;
        graph.plotAreaFrame.paddingLeft = 0;
        graph.plotAreaFrame.paddingRight = 0;
        graph.plotAreaFrame.paddingTop = 0;
        
        graph.plotAreaFrame.masksToBorder = NO;
        
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
        
        CPTMutableTextStyle* textStyle = [CPTMutableTextStyle textStyle];
        textStyle.fontSize = 12.0f;
        textStyle.color = [CPTColor colorWithCGColor:[[UIColor blackColor] CGColor]];
        
        CPTXYAxis *x = axisSet.xAxis;
        x.majorIntervalLength = CPTDecimalFromString(@"2");
        x.majorTickLength = 7.0f;
        x.minorTickLineStyle = nil;
        x.Title = @"Date of Input";
        x.TitleOffset = 50.0f;
        x.labelingPolicy = CPTAxisLabelingPolicyNone; //do the labels manually
        x.labelRotation = M_PI/4;
        [x setAxisLabels:[NSSet setWithArray:[self getDatesArray]]];
        x.labelTextStyle = textStyle;
        x.LabelOffset = 0.0f;
        
        CPTXYAxis *y = axisSet.yAxis;
        y.majorIntervalLength = CPTDecimalFromString(@"1");
        y.majorTickLength = 7.0f;
        y.minorTickLineStyle = nil;
        y.Title = @"Number input";
        y.TitleOffset = 20.0f;
        y.labelingPolicy = CPTAxisLabelingPolicyFixedInterval;
        y.labelTextStyle = textStyle;
        y.LabelOffset = 0.0f;
        
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

/**
 Creates an array of the entry dates
 */
-(NSArray*) getDatesArray
{
    NSMutableArray* tempArr = [[NSMutableArray alloc] init];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yy"];
    
    CPTMutableTextStyle* textStyle = [CPTMutableTextStyle textStyle];
    textStyle.fontSize = 12.0f;
    textStyle.color = [CPTColor colorWithCGColor:[[UIColor blackColor] CGColor]];
    
    for (int i = 0; i < self.userEntries.count; i++)
    {
        CatalyzeEntry* entry = [self.userEntries objectAtIndex:i];
        CPTAxisLabel* label = [[CPTAxisLabel alloc] initWithText:[formatter stringFromDate:entry.createdAt] textStyle:textStyle];
        [label setTickLocation:CPTDecimalFromInt(i)];
        [label setRotation:M_PI/4];
        [label setOffset:0.1];
        [tempArr addObject:label];
    }
        
    return [NSArray arrayWithArray:tempArr];
}

/**
 Datasource delegate method. Determines how many records there are
 @param plot CPTPlot
 */
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    return [self.userEntries count];
}

/**
 Datasource delegate method. Like cellForRowAtIndexPath, fills a unique plot point
 @param plot CPT plot
 @param fieldEnum tells whether we're on X or Y axis
 @param idx which index we're at
 */
-(NSNumber*)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)idx
{
    CatalyzeEntry* temp = [self.userEntries objectAtIndex:idx];
    if (fieldEnum == CPTScatterPlotFieldX)
    {
        return [NSNumber numberWithUnsignedInteger:idx];
    }
    else
    {
        NSString* key = [PCADefinitions determineSymptomName:self.curSymptom];
        if (self.curSymptom == SHORTNESS_OF_BREATH) //special case since underscores
        {
            key = @"shortness_of_breath";
        }
        NSNumber* painScore = [temp.content objectForKey:key];
        return painScore;
    }
}

@end
