//
//  PCAPatientDetailViewController.m
//  PCA-Thesis
//
//  Created by David Ganey on 9/26/14.
//  Copyright (c) 2014 dhganey. All rights reserved.
//

#import "PCAPatientDetailViewController.h"
#include "PCAPatientStatsViewController.h"

@interface PCAPatientDetailViewController ()

@end

@implementation PCAPatientDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = [self.userTranslation valueForKey:self.selectedEntry.authorId];
    
    [self updateInformationArea];
    
    [self queryForSymptoms];
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
            NSNumber* enteredVal = [self.selectedEntry.content objectForKey:key];
            
            labelText = [labelText stringByAppendingString:@"User's "];
            labelText = [labelText stringByAppendingString:key];
            labelText = [labelText stringByAppendingString:@" is urgent; user entered "];
            labelText = [labelText stringByAppendingString:[NSString stringWithFormat:@"%.2f", [enteredVal doubleValue]]];
            labelText = [labelText stringByAppendingString:@"\n"];
        }
    }
    
    if ([labelText isEqualToString:@""]) //if still empty, nothing should be urgent
    {
        labelText = @"This user has no urgent symptoms";
    }
    
    self.informationView.text = labelText;
}

/**
 Grabs the previous 60 entries for the selected user
 */
-(void)queryForSymptoms
{
    CatalyzeQuery* query = [CatalyzeQuery queryWithClassName:@"esasEntry"];
    [query setPageNumber:1];
    [query setPageSize:60];
    
    [query retrieveInBackgroundForUsersId:self.selectedEntry.authorId success:^(NSArray *result)
     {
         if ([result count] > 0)
         {
             self.userEntries = [NSMutableArray arrayWithArray:result];
             NSLog(@"query finished");
         }
         else //no recent entries--start cycle automatically as this is a new user
         {
             NSLog(@"No entries");
         }
     }
                                  failure:^(NSDictionary *result, int status, NSError *error)
     {
         NSLog(@"query failure in query for pain");
         NSLog(@"%@", error);
     }];
}

/**
 When we segue to the stats view, pass the result of the entries query
 */
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    PCAPatientStatsViewController* nextVC = segue.destinationViewController;
    nextVC.userEntries = self.userEntries;
}

@end
