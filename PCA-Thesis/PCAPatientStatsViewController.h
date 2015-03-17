//
//  PCAPatientStatsViewController.h
//  PCA-Thesis
//
//  Created by David Ganey on 2/24/15.
//  Copyright (c) 2015 dhganey. All rights reserved.
//

#pragma once

#import <UIKit/UIKit.h>
#import "Catalyze.h"
#import "CorePlot-CocoaTouch.h"

#include "PCADefinitions.h"
#include "PCAAppDelegate.h"

@interface PCAPatientStatsViewController : UIViewController <CPTPlotDataSource>

/**
 UIView holds the graph, tied to the storyboard
 */
@property (strong, nonatomic) IBOutlet UIView *NewGraphingView;

/**
 Array of user entries, passed from previous VC
 */
@property NSMutableArray* userEntries;

/*
 Enum for symptom selected in previous VC
 */
@property SYMPTOM curSymptom;

@end