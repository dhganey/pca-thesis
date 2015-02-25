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

@property NSMutableArray* userEntries;

@property SYMPTOM curSymptom;

/**
 AppDelegate object used to reference defObj for static functions
 */
@property PCAAppDelegate* appDel;

@end