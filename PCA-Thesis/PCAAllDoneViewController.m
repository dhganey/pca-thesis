//
//  PCAAllDoneViewController.m
//  PCA-Thesis
//
//  Created by David Ganey on 9/21/14.
//  Copyright (c) 2014 dhganey. All rights reserved.
//

#import "PCAAllDoneViewController.h"
#import "Catalyze.h"
#import "PCADefinitions.h"

@interface PCAAllDoneViewController ()

@end

@implementation PCAAllDoneViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //[self.view setBackgroundColor:[UIColor clearColor]];
    
    if (self.doneType == NO_NEED)
    {
        [self showNoNeed];
    }
    else if (self.doneType == DONE_ENTERING)
    {
        [self showUrgentSymptoms];
    }
    else
    {
        //TODO
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 Gives the user feedback on the symtoms which are urgent
 Tells the user their symptom is "a little" high when urgency is 1
 Tells the user their symptom is "very high" when urgency is 2
 */
-(void) showUrgentSymptoms
{
    NSString* feedback = @"";
    int count = 0;
    
    for (NSString* key in self.urgentDictionary)
    {
        if ([[self.urgentDictionary valueForKey:key] intValue] > 0)
        {
            count++;
        }
    }
    
    UILabel *feedLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 65, CGRectGetWidth(self.view.bounds), 500)]; //todo adjust magic nums
    feedLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [feedLabel setNumberOfLines:0]; //this should force wrapping
    feedLabel.font = [feedLabel.font fontWithSize:14];

    NSString* tempString;
    
    for (NSString* key in self.urgentDictionary)
    {
        if ([[self.urgentDictionary valueForKey:key] intValue] > 0)
        {
            if ([[self.urgentDictionary valueForKey:key] intValue] == 1)
            {
                tempString = [NSString stringWithFormat:@"Your %@ is a little high\n", [key stringByReplacingOccurrencesOfString:@"_" withString:@" "]]; //removes underscores from shortness_of_breath
                feedback = [feedback stringByAppendingString:tempString];
            }
            else if ([[self.urgentDictionary valueForKey:key] intValue] == 2)
            {
                tempString = [NSString stringWithFormat:@"Your %@ is very high\n", [key stringByReplacingOccurrencesOfString:@"_" withString:@" "]];
                feedback = [feedback stringByAppendingString:tempString];
            }
        }
    }
    tempString = @"Your physician has been notified";
    feedback = [feedback stringByAppendingString:tempString];
    
    [feedLabel setText:feedback];
    [feedLabel sizeToFit];
    [self.view addSubview:feedLabel];
}

/**
 Tells the user if they do not need to currently enter symptoms
 Used when app skips from login straight to this view controller
 */
-(void) showNoNeed
{
    UILabel *feedLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 65, CGRectGetWidth(self.view.bounds), 500)]; //todo adjust magic nums
    
    [feedLabel setText:@"No need to enter symptoms right now! Please enter symptoms once on Tuesdays, Thursdays, and Saturdays"];
    feedLabel.numberOfLines = 0;
    [feedLabel sizeToFit];
    [self.view addSubview:feedLabel];
}

/**
 Called when the user presses the logout button. Sends the user back to the login screen and disengages Catalyze
 @param sender id of the pressed button
 @return IBAction
 */
- (IBAction)logoutPressed:(id)sender
{
    [[CatalyzeUser currentUser] logoutWithSuccess:^(id result)
    {
        //we're in alldoneVC behind mainVC, so dismiss the presenting's presenting VC
        [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
    failure:^(NSDictionary *result, int status, NSError *error)
    {
        NSLog(@"Error while logging out");
        [PCADefinitions showAlert:LOGOUT_ERROR];
    }];
}

@end
