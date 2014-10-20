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
        //todo
    }
    
    //Set up app delegate object for use of shared functions
    self.appDel = [[UIApplication sharedApplication] delegate];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
    feedLabel.lineBreakMode = NSLineBreakByCharWrapping;
    [feedLabel setNumberOfLines:count*2];
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

-(void) showNoNeed
{
    UILabel *feedLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 65, CGRectGetWidth(self.view.bounds), 500)]; //todo adjust magic nums
    
    [feedLabel setText:@"No need to enter symptoms right now! Please enter symptoms once on Tuesdays, Thursdays, and Saturdays"];
    [feedLabel sizeToFit];
    //feedLabel.lineBreakMode = NSLineBreakByCharWrapping; //TODO fix this
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
        [self.appDel.defObj showAlert:LOGOUT_ERROR];
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
