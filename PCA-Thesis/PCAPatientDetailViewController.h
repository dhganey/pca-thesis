//
//  PCAPatientDetailViewController.h
//  PCA-Thesis
//
//  Created by David Ganey on 9/26/14.
//  Copyright (c) 2014 dhganey. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Catalyze.h"

@interface PCAPatientDetailViewController : UIViewController


@property (weak, nonatomic) IBOutlet UITextView *informationView;

@property NSDictionary* userTranslation;

@property CatalyzeEntry* selectedEntry;

@property NSMutableArray* userEntries;

@end
