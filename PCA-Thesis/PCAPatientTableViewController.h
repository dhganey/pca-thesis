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

/**
 AppDelegate object used to reference defObj for static functions
 */
@property PCAAppDelegate* appDel;

@property CatalyzeEntry* selectedEntry;

@end
