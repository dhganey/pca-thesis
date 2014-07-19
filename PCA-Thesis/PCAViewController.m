//
//  PCAViewController.m
//  PCA-Thesis
//
//  Created by David Ganey on 4/13/14.
//  Copyright (c) 2014 dhganey. All rights reserved.
//

#import "PCAViewController.h"

#import "PCALoginViewController.h"
#import "PCASignupViewController.h"

@interface PCAViewController ()

@property PCALoginViewController *logInViewController;

@end

@implementation PCAViewController

@synthesize logInViewController;

//Called before viewDidLoad, used to present login/signup VC
-(void)viewWillLayoutSubviews
{
    //determine which VC to present initially
    if (![PFUser currentUser]) //nobody logged in
    {
        // Create the log in view controller
        logInViewController = [[PCALoginViewController alloc] init];
        [logInViewController setDelegate:self]; // Set ourselves as the delegate
        [logInViewController setFields:PFLogInFieldsDefault];
        
        // Create the sign up view controller
        PCASignupViewController *signUpViewController = [[PCASignupViewController alloc] init];
        [signUpViewController setDelegate:self]; // Set ourselves as the delegate
        [signUpViewController setFields:PFSignUpFieldsDefault | PFSignUpFieldsAdditional];
        
        // Assign our sign up controller to be displayed from the login controller
        [logInViewController setSignUpController:signUpViewController];
        
        // Present the log in view controller
        [self presentViewController:logInViewController animated:YES completion:nil];
    }
    else
    {
        //allow the view to load
    }

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated
{
    [self.view setNeedsDisplay];
    
    if ([PFUser currentUser]) //if logged in
    {
        [self runMostRecentQuery];
    }
}

-(void) viewDidAppear:(BOOL)animated
{
    if ([PFUser currentUser]) //if logged in
    {
        [self runMostRecentQuery];
    }
}

-(void) runMostRecentQuery
{
    //Query the database to find all pain scores for current user
    PFQuery *query = [PFQuery queryWithClassName:@"ESASEntry"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    
    //[query whereKey:@"symptom" equalTo:@"pain"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         if (!error)
         {
             NSString* labelText = @"No Entry"; //default value
             PFObject *mostRecent; //most recent pain score
             if ( [objects count] == 0)
             {
                 //do nothing
             }
             else //loop through to find the most recent entry
             {
                 mostRecent = [objects objectAtIndex:0]; //grab first object
                 for (PFObject *object in objects)
                 {
                     if ( [object.createdAt timeIntervalSinceReferenceDate] > [mostRecent.createdAt timeIntervalSinceReferenceDate]) //if the current object is more recent than mostRecent, reset
                     {
                         mostRecent = object;
                     }
                 }
                 NSNumber* recentNum = mostRecent[@"value"];
                 labelText = [recentNum stringValue];
             }
             
             [self.previousValueLabel setText:labelText];
             [self.view setNeedsDisplay];
         }
         else
         {
             //TODO error case
         }
     }];

}

- (IBAction)logOutPressed:(id)sender
{
    [PFUser logOut];
    [self viewWillLayoutSubviews];
}


//Optional Login method
// Sent to the delegate to determine whether the log in request should be submitted to the server.
- (BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password
{
    // Check if both fields are completed
    if (username && password && username.length != 0 && password.length != 0)
    {
        return YES; // Begin login process
    }
    
    [[[UIAlertView alloc] initWithTitle:@"Missing Information"
                                message:@"Make sure you fill out all of the information!"
                               delegate:nil
                      cancelButtonTitle:@"ok"
                      otherButtonTitles:nil] show];
    return NO; // Interrupt login process
}

//Optional login method
// Sent to the delegate when a PFUser is logged in.
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user
{
    //[self performSegueWithIdentifier:@"loggedInSegue" sender:self];
    [self dismissViewControllerAnimated:YES completion:NULL];
}

//Optional login method
// Sent to the delegate when the log in attempt fails.
- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error
{
    NSLog(@"Failed to log in...");
    
    [[[UIAlertView alloc] initWithTitle:@"Error"
                                message:@"There was an error signing in. Please try again."
                               delegate:nil
                      cancelButtonTitle:@"ok"
                      otherButtonTitles:nil] show];
}

//Optional login method
// Sent to the delegate when the log in screen is dismissed.
- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController
{
    [self.navigationController popViewControllerAnimated:YES];
}


//Optional signup method
// Sent to the delegate to determine whether the sign up request should be submitted to the server.
- (BOOL)signUpViewController:(PFSignUpViewController *)signUpController shouldBeginSignUp:(NSDictionary *)info
{
    BOOL informationComplete = YES;
    
    // loop through all of the submitted data
    for (id key in info)
    {
        NSString *field = [info objectForKey:key];
        if (!field || field.length == 0) // check completion
        {
            informationComplete = NO;
            break;
        }
    }
    
    // Display an alert if a field wasn't completed
    if (!informationComplete) {
        [[[UIAlertView alloc] initWithTitle:@"Missing Information"
                                    message:@"Make sure you fill out all of the information!"
                                   delegate:nil
                          cancelButtonTitle:@"ok"
                          otherButtonTitles:nil] show];
    }
    
    return informationComplete;
}

//Optional signup method
// Sent to the delegate when a PFUser is signed up.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user
{
    [self dismissViewControllerAnimated:YES completion:^
    {
        if ([PFUser currentUser][@"symptomBitmask"] == NULL) //if the patient has not supplied additional information yet
        {
            [self performSegueWithIdentifier:@"additionalInfoSegue" sender:self];
        }
        else
        {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }]; // Dismiss the PFSignUpViewController
}

//Optional signup method
// Sent to the delegate when the sign up attempt fails.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didFailToSignUpWithError:(NSError *)error
{
    NSLog(@"Failed to sign up...");
}

//Optional signup method
// Sent to the delegate when the sign up screen is dismissed.
- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController
{
    NSLog(@"User dismissed the signUpViewController");
}

- (IBAction)submitPressed:(id)sender
{
    NSNumber *painEntered = [[NSNumber alloc] initWithDouble:[self.painField.text doubleValue]]; //grab the entered value
    
    PFObject *painObject = [PFObject objectWithClassName:@"ESASEntry"];
    painObject[@"symptom"] = @"pain";
    painObject[@"value"] = painEntered;
    painObject[@"user"] = [PFUser currentUser];
    
    [painObject saveInBackground];
    
    [self.view endEditing:YES];
    
    [self runMostRecentQuery];
}
@end
