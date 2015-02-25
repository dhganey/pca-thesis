//
//  PCAPatientDetailViewController.h
//  PCA-Thesis
//
//  Created by David Ganey on 9/26/14.
//  Copyright (c) 2014 dhganey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Catalyze.h"

#include "PCAAppDelegate.h"

@interface PCAPatientDetailViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>


@property (weak, nonatomic) IBOutlet UITextView *informationView;

@property (weak, nonatomic) IBOutlet UIPickerView *symptomPicker;

@property NSDictionary* userTranslation;

@property CatalyzeEntry* selectedEntry;

@property NSMutableArray* userEntries;

@property NSMutableArray* symptomArray;

/**
 AppDelegate object used to reference defObj for static functions
 */
@property PCAAppDelegate* appDel;

@end
