//
//  PCAMainViewController.h
//  PCA-Thesis
//
//  Created by David Ganey on 7/21/14.
//  Copyright (c) 2014 dhganey. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Catalyze.h"

#import "PCAAppDelegate.h"

@interface PCAMainViewController : UIViewController <UIAlertViewDelegate>

- (IBAction)logoutPressed:(id)sender;

/**
 Reflects the current symptom during symptom iteration
 */
@property int currentSymptom;

/**
 Holds the value to be saved as the UILabel will be inaccessible during saving
 */
@property double valueToSave;

/**
 AppDelegate object used to reference defObj for static functions
 */
@property PCAAppDelegate* appDel;

//@property CatalyzeEntry* esasEntry;

/**
 The dictionary of new symptoms to be saved
 */
@property NSMutableDictionary* esasDictionary;

/**
 The most recent CatalyzeEntry
 */
@property CatalyzeEntry* mostRecent;

/**
 The NSArray of the last 60 results
 */
@property NSArray* last60Entries;

/**
 The type of "done" we have
 */
@property ALL_DONE_TYPE doneType;

@end
