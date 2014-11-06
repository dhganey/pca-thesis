//
//  PCAPatientDetailViewController.m
//  PCA-Thesis
//
//  Created by David Ganey on 9/26/14.
//  Copyright (c) 2014 dhganey. All rights reserved.
//

#import "PCAPatientDetailViewController.h"

@interface PCAPatientDetailViewController ()

@end

@implementation PCAPatientDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = self.selectedEntry.authorId;
    
    [self updateInformationArea];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

/**
 Updates the information text area with the user's urgent symptoms and the values entered
 @return void
 */
-(void) updateInformationArea
{
    NSString* labelText = @"";
    NSDictionary* urgentEntries = [self.selectedEntry.content objectForKey:@"urgent"];
    
    for (NSString* key in [urgentEntries allKeys])
    {
        NSNumber* curVal = [urgentEntries valueForKey:key];
        if ([curVal intValue] > 0) //if urgent symptom
        {
            labelText = [labelText stringByAppendingString:@"User's "];
            labelText = [labelText stringByAppendingString:key];
            labelText = [labelText stringByAppendingString:@" is urgent; user entered "];
            labelText = [labelText stringByAppendingString:[NSString stringWithFormat:@"%@", [self.selectedEntry.content objectForKey:key]]];
            labelText = [labelText stringByAppendingString:@"\n"];
        }
    }
    
    if ([labelText isEqualToString:@""]) //if still empty, nothing should be urgent
    {
        labelText = @"This user has no urgent symptoms";
    }
    
    self.informationView.text = labelText;
}

@end
