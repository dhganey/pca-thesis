//
//  PCAPatientDetailViewController.h
//  PCA-Thesis
//
//  Created by David Ganey on 9/26/14.
//  Copyright (c) 2014 dhganey. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Catalyze.h"
#import "PCADefinitions.h"
#import "PCAPatientStatsViewController.h"

@interface PCAPatientDetailViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>

/**
 UITextView for giving information about patient's recent entry
 */
@property (weak, nonatomic) IBOutlet UITextView *informationView;

/**
 Picker showing symptoms for stats button
 */
@property (weak, nonatomic) IBOutlet UIPickerView *symptomPicker;

/**
 Holds translation table -- maps from user IDs to names
 */
@property NSDictionary* userTranslation;

/**
 Current entry being shown
 */
@property CatalyzeEntry* selectedEntry;

/**
 Recent user entries
 */
@property NSMutableArray* userEntries;

/**
 Symptom array for picker
 */
@property NSMutableArray* symptomArray;

@end
