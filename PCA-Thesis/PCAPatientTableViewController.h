//
//  PCAPatientTableViewController.h
//  PCA-Thesis
//
//  Created by David Ganey on 8/27/14.
//  Copyright (c) 2014 dhganey. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Catalyze.h"
#import "PCADefinitions.h"
#import "PCAPatientDetailViewController.h"

@interface PCAPatientTableViewController : UITableViewController

/**
 Array of one recent entry per user
 */
@property NSArray* recentEntries;

/**
 Holds the entry when tapped by doctor
 */
@property CatalyzeEntry* selectedEntry;

/**
 Holds user translation table -- maps from user ids to names
 */
@property NSDictionary* userTranslation;

/**
 Holds state to deal with query failure -- allows query to try twice
 */
@property BOOL secondTry;

-(void) executeQuery;
-(void) queryUserTranslations;

@end
