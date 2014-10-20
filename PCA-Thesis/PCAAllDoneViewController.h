//
//  PCAAllDoneViewController.h
//  PCA-Thesis
//
//  Created by David Ganey on 9/21/14.
//  Copyright (c) 2014 dhganey. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PCADefinitions.h"
#import "PCAAppDelegate.h"

@interface PCAAllDoneViewController : UIViewController

/**
 Represents what type of "done" we have--what information to show to user
 */
@property ALL_DONE_TYPE doneType;

/**
 Represents the symptoms which were urgent to give feedback to the user
 */
@property NSMutableDictionary* urgentDictionary;

/**
 AppDelegate object used to reference defObj for static functions
 */
@property PCAAppDelegate* appDel;

/**
 Called when logout button pressed
 */
- (IBAction)logoutPressed:(id)sender;

@end
