//
//  PCAPatientTableViewController.h
//  PCA-Thesis
//
//  Created by David Ganey on 8/27/14.
//  Copyright (c) 2014 dhganey. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PCAAppDelegate.h"

@interface PCAPatientTableViewController : UITableViewController

@property NSArray* recentEntries;

@property CatalyzeEntry* selectedEntry;

@property NSDictionary* userTranslation;

-(void) executeQuery;
-(void) queryUserTranslations;

@end
